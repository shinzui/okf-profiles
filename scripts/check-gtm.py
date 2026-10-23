#!/usr/bin/env python3
"""Validate campaign, claim-check and audience relationships from a local manifest.

Interim opt-in checks: concept-local conditions belong to
mori://shinzui/okf/okf/improvement-requests/concepts/IR-9; resolution belongs to
mori://shinzui/mori/okf/improvement-requests/concepts/IR-38. Remove equivalent
rules when those owners ship them. Descriptors remain the shape authority.

Manifest: {"bundles": [{"uri", "path", "profile"}, ...]}, with paths relative
to the manifest. Repository paths resolve from the containing Git root, or the
manifest directory outside Git. No network/registry lookup is treated as proof.
"""
import argparse
import json
import math
import os
from pathlib import Path
import re
import subprocess
import sys
from datetime import datetime

RULES = {
    "secondary-purpose-block": "okf: each declared secondary purpose has its block",
    "hypothesis-study": "okf/mori: a measuring/read-out hypothesis has an experiment Study",
    "claim-evidence": "okf: measured verdicts have query or computation evidence",
    "reference-target": "mori: typed references resolve to allowed concept types",
    "query-path": "mori: repository artifact paths exist inside the repository",
    "metric-context": "okf: metric baselines and audience sizes are finite and windows ordered",
    "owner-format": "okf: campaign owners are actor strings or canonical Mori URIs",
}
IDS = {
    "Campaign": "campaignId", "Campaign Email": "campaignId",
    "Claim Check": "claimId", "Segment": "audienceId", "Persona": "audienceId",
    "Job": "jobId", "Feature": "featureId",
    "Product Research Study": "productResearchId",
    "Product Research Finding": "productResearchId", "Term": "termId",
    "Attested Computation": "computationId",
    # These target types become authorable through the launch/strategy exports.
    "Launch": "launchId", "Landing Page": "launchId",
}
BUNDLE = re.compile(r"mori://[^/]+/[^/]+/okf/[^/]+")
CONCEPT = re.compile(r"(mori://[^/]+/[^/]+/okf/[^/]+)/concepts/([A-Z]+-[1-9][0-9]*)")
HANDLE = re.compile(r"[A-Z]+-[1-9][0-9]*")
ACTOR = re.compile(r"(?:human:[^\s]+|process:[^\s]+|[^\s/]+/[^\s]+)")


def values(value):
    return value if isinstance(value, list) else []


def records(value):
    return [v for v in values(value) if isinstance(v, dict)]


def finite(value):
    return isinstance(value, (int, float)) and not isinstance(value, bool) and math.isfinite(value)


def time(value):
    try:
        return datetime.fromisoformat(value.replace("Z", "+00:00"))
    except (AttributeError, ValueError):
        return None


class Checker:
    def __init__(self, root):
        self.root = root
        self.index = {}
        self.rows = []
        self.errors = []
        self.resolved = 0

    def error(self, row, field, rule, message):
        self.errors.append(f"{row['_uri']} {field} [{rule}]: {message}")

    def resolve(self, row, field, value, types, local=False, rule="reference-target"):
        match = CONCEPT.fullmatch(value) if isinstance(value, str) else None
        if match:
            key = (match[1], match[2])
        elif local and isinstance(value, str) and HANDLE.fullmatch(value):
            key = (row['_bundle'], value)
        else:
            self.error(row, field, rule, f"not a canonical concept reference: {value!r}")
            return None
        target = self.index.get(key)
        if target is None:
            self.error(row, field, rule, f"unresolved {value}")
            return None
        if types and target.get('type') not in types:
            self.error(row, field, rule, f"{value} is {target.get('type')}, expected {' or '.join(sorted(types))}")
            return None
        self.resolved += 1
        return target

    def many(self, row, field, refs, types, local=False):
        for i, value in enumerate(values(refs)):
            self.resolve(row, f"{field}[{i}]", value, types, local)

    def artifact(self, row, field, value):
        if not isinstance(value, str) or not value or "://" in value or Path(value).is_absolute():
            self.error(row, field, "query-path", "expected a repository-relative artifact path")
            return
        path = (self.root / value).resolve()
        if not path.is_relative_to(self.root) or not path.is_file():
            self.error(row, field, "query-path", f"missing or external repository file: {value}")

    def assessment(self, row):
        assessment = row.get('assessment')
        if not isinstance(assessment, dict):
            return
        for i, ref in enumerate(values(assessment.get('findingRefs'))):
            target = self.resolve(row, f"assessment.findingRefs[{i}]", ref, {'Product Research Finding'})
            if target and target.get('status') != 'current':
                self.error(row, f"assessment.findingRefs[{i}]", "reference-target", "assessment must cite a current Finding")

    def campaign(self, row):
        for purpose in values(row.get('secondaryPurposes')):
            if not isinstance(row.get(purpose), dict) or not row[purpose]:
                self.error(row, purpose, "secondary-purpose-block", "secondary purpose needs its block")
        purposes = {row.get('purpose'), *values(row.get('secondaryPurposes'))}
        required_study = 'hypothesis' in purposes and row.get('status') in {'measuring', 'read-out'}
        if required_study or 'studyRef' in row:
            study = self.resolve(row, 'studyRef', row.get('studyRef'), {'Product Research Study'},
                                 rule='hypothesis-study')
            if study and study.get('method') != 'experiment':
                self.error(row, 'studyRef', 'hypothesis-study', 'Study method must be experiment')
        announcement = row.get('announcement', {})
        self.many(row, 'announcement.featureRefs', announcement.get('featureRefs'), {'Feature'})
        readout = row.get('readout', {})
        self.many(row, 'readout.findingRefs', readout.get('findingRefs'), {'Product Research Finding'})
        metric = row.get('primaryMetric', {})
        if 'baseline' in metric and not finite(metric['baseline']):
            self.error(row, 'primaryMetric.baseline', 'metric-context', 'baseline must be a finite number')
        window = row.get('window', {})
        start, end = time(window.get('from')), time(window.get('to'))
        if start and end and start >= end:
            self.error(row, 'window', 'metric-context', 'from must precede to')
        for i, audience in enumerate(records(row.get('audience'))):
            if not finite(audience.get('size')) or audience['size'] < 0:
                self.error(row, f'audience[{i}].size', 'metric-context', 'size must be finite and nonnegative')
        for i, owner in enumerate(values(row.get('owners'))):
            if not isinstance(owner, str) or not (ACTOR.fullmatch(owner) or
                    (owner.startswith('mori://') and re.fullmatch(r'mori://[^\s/]+/[^\s]+', owner))):
                self.error(row, f'owners[{i}]', 'owner-format', 'expected an actor or canonical Mori URI')

    def claim(self, row):
        if row.get('verdict') in {'match', 'close', 'wrong'} and not (row.get('query') or row.get('computationRef')):
            self.error(row, 'query/computationRef', 'claim-evidence', 'measured verdict needs query or computation evidence')
        if 'computationRef' in row:
            self.resolve(row, 'computationRef', row['computationRef'], {'Attested Computation'})
        for i, ref in enumerate(values(row.get('usedIn'))):
            if isinstance(ref, str) and ref.startswith('mori:'):
                self.resolve(row, f'usedIn[{i}]', ref, None)
            else:
                self.artifact(row, f'usedIn[{i}]', ref)

    def run(self):
        for row in self.rows:
            typ = row.get('type')
            if typ == 'Campaign':
                self.campaign(row)
            if typ == 'Campaign Email':
                self.resolve(row, 'campaignRef', row.get('campaignRef'), {'Campaign'}, local=True)
            if typ == 'Claim Check':
                self.claim(row)
            if typ == 'Persona':
                self.assessment(row)
                self.many(row, 'segmentRefs', row.get('segmentRefs'), {'Segment'}, local=True)
            if typ == 'Segment':
                if 'parentSegmentRef' in row:
                    self.resolve(row, 'parentSegmentRef', row['parentSegmentRef'], {'Segment'}, local=True)
                size = row.get('size', {})
                if 'count' in size and (not finite(size['count']) or size['count'] < 0):
                    self.error(row, 'size.count', 'metric-context', 'count must be finite and nonnegative')
            # The gate follows typed GTM edges, not arbitrary discovery/source fields.
            if typ in {'Campaign', 'Campaign Email', 'Segment', 'Persona'}:
                self.many(row, 'audienceRefs', row.get('audienceRefs'), {'Segment'})
                self.many(row, 'jobRefs', row.get('jobRefs'), {'Job'})
                self.many(row, 'termRefs', row.get('termRefs'), {'Term'})
                for field, target in [('launchRef', 'Launch'), ('landingPageRef', 'Landing Page')]:
                    if field in row:
                        self.resolve(row, field, row[field], {target})
                for i, outcome in enumerate(records(row.get('outcomeRefs'))):
                    job = self.resolve(row, f'outcomeRefs[{i}].jobRef', outcome.get('jobRef'), {'Job'})
                    if job and outcome.get('outcomeName') not in {o.get('name') for o in records(job.get('outcomes'))}:
                        self.error(row, f'outcomeRefs[{i}].outcomeName', 'reference-target', 'unknown job outcome')
            if typ in {'Claim Check', 'Segment'} and 'query' in row:
                self.artifact(row, 'query', row['query'])


def load(path, checker):
    manifest = json.loads(path.read_text())
    entries = manifest.get('bundles') if isinstance(manifest, dict) else None
    if not isinstance(entries, list) or not entries:
        raise ValueError('manifest needs a nonempty bundles list')
    seen = set()
    okf = os.environ.get('OKF_BIN', 'okf')
    for entry in entries:
        if not isinstance(entry, dict) or set(entry) != {'uri', 'path', 'profile'} or not all(isinstance(v, str) for v in entry.values()):
            raise ValueError('bundle entries need exactly uri, path, profile strings')
        uri = entry['uri']
        if not BUNDLE.fullmatch(uri) or uri in seen:
            raise ValueError(f'invalid or duplicate bundle URI: {uri}')
        seen.add(uri)
        bundle, profile = (path.parent / entry['path']).resolve(), (path.parent / entry['profile']).resolve()
        checked = subprocess.run([okf, 'validate', str(bundle), '--strict', '--profile', str(profile),
                                  '--profile-enforce', '--log-enforce'], text=True, capture_output=True)
        if checked.returncode:
            raise ValueError(f'{uri}: strict validation failed\n{checked.stdout}{checked.stderr}')
        listed = subprocess.run([okf, 'concepts', str(bundle), '--json'], check=True, text=True, capture_output=True)
        for row in json.loads(listed.stdout):
            field = IDS.get(row.get('type'))
            # Discovery themes and verification events are supporting unaddressed rows.
            if field is None:
                continue
            handle = row.get(field)
            if not isinstance(handle, str) or not HANDLE.fullmatch(handle):
                raise ValueError(f'{uri}: missing concept handle for {row.get("type")}')
            key = (uri, handle)
            if key in checker.index:
                raise ValueError(f'duplicate concept URI: {uri}/concepts/{handle}')
            row = dict(row, _bundle=uri, _uri=uri+'/concepts/'+handle)
            checker.index[key] = row
            checker.rows.append(row)
    return len(entries)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--manifest', type=Path)
    parser.add_argument('--list-rules', action='store_true')
    args = parser.parse_args()
    if args.list_rules:
        for rule, owner in RULES.items():
            print(rule, owner)
        return 0
    if args.manifest is None:
        parser.error('--manifest is required')
    path = args.manifest.resolve()
    git = subprocess.run(['git', '-C', str(path.parent), 'rev-parse', '--show-toplevel'],
                         text=True, capture_output=True)
    root = Path(git.stdout.strip()).resolve() if git.returncode == 0 else path.parent
    checker = Checker(root)
    try:
        bundles = load(path, checker)
        checker.run()
    except (OSError, ValueError, subprocess.CalledProcessError) as exc:
        print(f'error: {exc}', file=sys.stderr)
        return 2
    if checker.errors:
        print('\n'.join(checker.errors), file=sys.stderr)
        return 1
    print(f'OK: {bundles} bundles, {len(checker.rows)} concepts, {checker.resolved} GTM references resolved')
    print('untraversed: generic sources, owner existence, and supporting discovery relationships')
    return 0


if __name__ == '__main__':
    sys.exit(main())
