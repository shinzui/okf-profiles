#!/usr/bin/env python3
"""Check the relationships between product-discovery OKF bundles.

This is an interim, opt-in consumer gate in the sense of ADR-14, not part of
any profile. Profile validation checks each concept's own shape; this checks
what profile validation cannot express today. Every check is a named rule in
RULES with the project intended to own it long term:

  * `okf` owns a rule that reads one concept's own frontmatter. It is a gap in
    okf's descriptor language, to be closed under okf ADR-11.
  * `mori` owns a rule that follows a reference to another concept. That is
    registry-backed resolution, which okf ADR-1 assigns to Mori.

When an owner ships equivalent support, delete the rule here.

Usage:

    python3 scripts/check-product-discovery.py --list-rules
    python3 scripts/check-product-discovery.py --manifest PATH

The manifest is JSON: {"bundles": [{"uri", "path", "profile"}, ...]}. `uri` is
the canonical Mori bundle URI (mori://<namespace>/<project>/okf/<bundle>);
`path` and `profile` are resolved relative to the manifest file. Each bundle is
validated strictly with its profile and read through `okf concepts --json`,
using the executable named by OKF_BIN. Nothing is fetched from the network:
a reference to a bundle the manifest does not map is an error, not a success.

Exit status: 0 when every check passes, 1 on validation errors, 2 on bad usage
or an unreadable or invalid manifest.
"""
import argparse
import json
import math
import os
import re
import subprocess
import sys
from datetime import datetime
from pathlib import Path

RULES = [
    ("finite-number", "okf",
     "A job outcome's baseline and target, and a measurement's value, are finite numbers."),
    ("measurement-complete", "okf",
     "A job outcome with any measurement member has metric, unit, direction, and method."),
    ("baseline-context", "okf",
     "A job outcome with a baseline states its population and period, and the job has sources."),
    ("period-order", "okf",
     "A measurement's periodStart precedes its periodEnd."),
    ("outcome-ref-job-listed", "okf",
     "A feature's outcomeRefs[].jobRef also appears in its jobRefs."),
    ("inline-name-unique", "okf",
     "Inline job names, and inline feature names, are unique within a use case."),
    ("inline-feature-job", "okf",
     "An inline feature's jobs name inline jobs of the same use case."),
    ("outcome-names-need-jobref", "okf",
     "An inline job with outcomeNames also has a jobRef."),
    ("feature-ref-unique", "okf",
     "A use case references each canonical feature once, across featureRefs and features[].featureRef."),
    ("delivery-stage-features", "okf",
     "A planned, in-progress, or delivered use case has inline features or featureRefs."),
    ("reference-target", "mori",
     "A JOB, PR, FEAT, CAP, or SPEC reference resolves to a concept of an allowed type."),
    ("outcome-exists", "mori",
     "A use-case, feature, or finding outcome name exists on the referenced job."),
    ("measurement-matches-outcome", "mori",
     "A measurement names a measured job outcome and uses that outcome's unit."),
    ("assessment-evidence", "mori",
     "Every finding a job's assessment cites assesses that job in jobAssessments."),
    ("cited-finding-current", "mori",
     "A finding cited by a job's assessment has status current."),
    ("supersession-acyclic", "mori",
     "Following findings' supersededBy never returns to the starting finding."),
]
RULE_IDS = {rule for rule, _, _ in RULES}

ID_FIELDS = {
    "Job": "jobId",
    "Product Research Study": "productResearchId",
    "Product Research Finding": "productResearchId",
    "Feature": "featureId",
    "Use Case": "useCaseId",
    "Capability": "capabilityId",
    "Specification": "specId",
    "Specification Pointer": "specId",
}
UNINDEXED_TYPES = {"Use Case Theme"}

BUNDLE_URI = re.compile(r"mori://[^/]+/[^/]+/okf/[^/]+")
CONCEPT_URI = re.compile(r"(mori://[^/]+/[^/]+/okf/[^/]+)/concepts/([A-Z]+-[1-9][0-9]*)")
LOCAL_HANDLE = re.compile(r"[A-Z]+-[1-9][0-9]*")

JOB = {"Job"}
STUDY = {"Product Research Study"}
FINDING = {"Product Research Finding"}
FEATURE = {"Feature"}
CAPABILITY = {"Capability"}
SPECIFICATION = {"Specification", "Specification Pointer"}

MEASUREMENT_MEMBERS = ("metric", "unit", "direction", "method", "baseline", "target",
                       "population", "period")


class ManifestError(Exception):
    pass


class Concept:
    def __init__(self, bundle, data):
        self.bundle = bundle
        self.data = data
        self.type = data.get("type")
        field = ID_FIELDS.get(self.type)
        self.handle = data.get(field) if field else None

    @property
    def uri(self):
        if self.handle:
            return f"{self.bundle}/concepts/{self.handle}"
        return f"{self.bundle} ({self.data.get('title', 'untitled')})"


class Checker:
    def __init__(self):
        self.index = {}
        self.concepts = []
        self.errors = []
        self.resolved = 0
        self.unchecked = {"owner": 0, "improvement-request": 0}

    def error(self, concept, path, rule, message):
        assert rule in RULE_IDS, rule
        self.errors.append(f"{concept.uri} {path}: [{rule}] {message}")

    # -- reference resolution --------------------------------------------

    def resolve(self, concept, path, value, allowed, local=False):
        """Return the target concept, or None after reporting why not."""
        if not isinstance(value, str):
            return None
        match = CONCEPT_URI.fullmatch(value)
        if match:
            key = (match.group(1), match.group(2))
        elif local and LOCAL_HANDLE.fullmatch(value):
            key = (concept.bundle, value)
        else:
            # Malformed references are the profile's to report.
            return None
        if not any(bundle == key[0] for bundle, _ in self.index):
            self.error(concept, path, "reference-target",
                       f"{value} is in a bundle the manifest does not map")
            return None
        target = self.index.get(key)
        if target is None:
            self.error(concept, path, "reference-target", f"{value} does not exist")
            return None
        if target.type not in allowed:
            wanted = " or ".join(sorted(allowed))
            self.error(concept, path, "reference-target",
                       f"{value} is a {target.type}, expected {wanted}")
            return None
        self.resolved += 1
        return target

    def resolve_all(self, concept, field, allowed, local=False):
        targets = []
        for i, value in enumerate(as_list(concept.data.get(field))):
            target = self.resolve(concept, f"{field}[{i}]", value, allowed, local)
            if target is not None:
                targets.append(target)
        return targets

    def outcome_exists(self, concept, path, job, name):
        names = [o.get("name") for o in records(job.data.get("outcomes"))]
        if name not in names:
            self.error(concept, path, "outcome-exists",
                       f"unknown outcome {name} on {job.uri}")
            return None
        return records(job.data.get("outcomes"))[names.index(name)]

    # -- per-type checks -------------------------------------------------

    def check_job(self, job):
        for i, outcome in enumerate(records(job.data.get("outcomes"))):
            path = f"outcomes[{i}]"
            present = [m for m in MEASUREMENT_MEMBERS if m in outcome]
            if present:
                missing = [m for m in ("metric", "unit", "direction", "method") if m not in outcome]
                if missing:
                    self.error(job, path, "measurement-complete",
                               f"measured outcome lacks {', '.join(missing)}")
            for member in ("baseline", "target"):
                if member in outcome and not finite(outcome[member]):
                    self.error(job, f"{path}.{member}", "finite-number",
                               f"{outcome[member]!r} is not a finite number")
            if "baseline" in outcome:
                missing = [m for m in ("population", "period") if m not in outcome]
                if missing:
                    self.error(job, f"{path}.baseline", "baseline-context",
                               f"baseline lacks {', '.join(missing)}")
                if not as_list(job.data.get("sources")):
                    self.error(job, f"{path}.baseline", "baseline-context",
                               "baseline is stated but the job has no sources")
        self.resolve_all(job, "relatedJobs", JOB, local=True)
        assessment = job.data.get("assessment")
        if not isinstance(assessment, dict):
            return
        for i, ref in enumerate(as_list(assessment.get("findingRefs"))):
            path = f"assessment.findingRefs[{i}]"
            finding = self.resolve(job, path, ref, FINDING)
            if finding is None:
                continue
            if finding.data.get("status") != "current":
                self.error(job, path, "cited-finding-current",
                           f"{finding.uri} is {finding.data.get('status')}; re-assess or cite its replacement")
            assessed = [a for a in records(finding.data.get("jobAssessments"))
                        if self.points_at(finding, a.get("jobRef"), job)]
            if not assessed:
                self.error(job, path, "assessment-evidence",
                           f"{finding.uri} has no jobAssessments entry for {job.uri}")

    def points_at(self, source, value, target):
        match = CONCEPT_URI.fullmatch(value) if isinstance(value, str) else None
        return bool(match) and (match.group(1), match.group(2)) == (target.bundle, target.handle)

    def check_study(self, study):
        self.resolve_all(study, "jobRefs", JOB)

    def check_finding(self, finding):
        self.resolve(finding, "studyRef", finding.data.get("studyRef"), STUDY, local=True)
        if "supersededBy" in finding.data:
            self.resolve(finding, "supersededBy", finding.data["supersededBy"], FINDING, local=True)
        for i, entry in enumerate(records(finding.data.get("jobAssessments"))):
            path = f"jobAssessments[{i}]"
            job = self.resolve(finding, f"{path}.jobRef", entry.get("jobRef"), JOB)
            if job is not None and "outcomeName" in entry:
                self.outcome_exists(finding, f"{path}.outcomeName", job, entry["outcomeName"])
        for i, entry in enumerate(records(finding.data.get("measurements"))):
            path = f"measurements[{i}]"
            if "value" in entry and not finite(entry["value"]):
                self.error(finding, f"{path}.value", "finite-number",
                           f"{entry['value']!r} is not a finite number")
            start, end = timestamp(entry.get("periodStart")), timestamp(entry.get("periodEnd"))
            if start and end and not start < end:
                self.error(finding, f"{path}.periodEnd", "period-order",
                           f"{entry['periodEnd']} does not follow {entry['periodStart']}")
            job = self.resolve(finding, f"{path}.jobRef", entry.get("jobRef"), JOB)
            if job is None or "outcomeName" not in entry:
                continue
            outcome = self.outcome_exists(finding, f"{path}.outcomeName", job, entry["outcomeName"])
            if outcome is None:
                continue
            if "metric" not in outcome:
                self.error(finding, f"{path}.outcomeName", "measurement-matches-outcome",
                           f"outcome {entry['outcomeName']} on {job.uri} declares no metric")
            elif outcome.get("unit") != entry.get("unit"):
                self.error(finding, f"{path}.unit", "measurement-matches-outcome",
                           f"unit {entry.get('unit')} differs from {outcome.get('unit')} on {job.uri}")

    def check_feature(self, feature):
        self.resolve_all(feature, "jobRefs", JOB)
        listed = as_list(feature.data.get("jobRefs"))
        for i, entry in enumerate(records(feature.data.get("outcomeRefs"))):
            path = f"outcomeRefs[{i}]"
            ref = entry.get("jobRef")
            if ref not in listed:
                self.error(feature, f"{path}.jobRef", "outcome-ref-job-listed",
                           f"{ref} is not listed in jobRefs")
            job = self.resolve(feature, f"{path}.jobRef", ref, JOB)
            if job is not None and "outcomeName" in entry:
                self.outcome_exists(feature, f"{path}.outcomeName", job, entry["outcomeName"])
        self.resolve_all(feature, "capabilityRefs", CAPABILITY)
        self.resolve_all(feature, "specificationRefs", SPECIFICATION)
        self.unchecked["owner"] += len(as_list(feature.data.get("owners")))
        self.unchecked["improvement-request"] += len(as_list(feature.data.get("improvementRequests")))

    def check_use_case(self, use_case):
        jobs = records(use_case.data.get("jobs"))
        features = records(use_case.data.get("features"))
        job_names = [j.get("name") for j in jobs]
        for label, items in (("jobs", jobs), ("features", features)):
            seen = set()
            for i, item in enumerate(items):
                name = item.get("name")
                if name in seen:
                    self.error(use_case, f"{label}[{i}].name", "inline-name-unique",
                               f"duplicate inline name {name}")
                seen.add(name)
        for i, job in enumerate(jobs):
            path = f"jobs[{i}]"
            names = as_list(job.get("outcomeNames"))
            if names and "jobRef" not in job:
                self.error(use_case, f"{path}.outcomeNames", "outcome-names-need-jobref",
                           "outcomeNames needs a jobRef naming the job that declares them")
            target = self.resolve(use_case, f"{path}.jobRef", job.get("jobRef"), JOB) \
                if "jobRef" in job else None
            if target is not None:
                for k, name in enumerate(names):
                    self.outcome_exists(use_case, f"{path}.outcomeNames[{k}]", target, name)
        seen_features = {}
        refs = [(f"featureRefs[{i}]", v) for i, v in enumerate(as_list(use_case.data.get("featureRefs")))]
        for i, feature in enumerate(features):
            for k, name in enumerate(as_list(feature.get("jobs"))):
                if name not in job_names:
                    self.error(use_case, f"features[{i}].jobs[{k}]", "inline-feature-job",
                               f"{name} is not an inline job of this use case")
            if "featureRef" in feature:
                refs.append((f"features[{i}].featureRef", feature["featureRef"]))
            self.unchecked["owner"] += len(as_list(feature.get("owners")))
            self.unchecked["improvement-request"] += len(as_list(feature.get("improvementRequests")))
        for path, value in refs:
            if value in seen_features:
                self.error(use_case, path, "feature-ref-unique",
                           f"{value} is already referenced at {seen_features[value]}")
                continue
            seen_features[value] = path
            self.resolve(use_case, path, value, FEATURE)
        if use_case.data.get("status") in ("planned", "in-progress", "delivered") and not refs \
                and not features:
            self.error(use_case, "featureRefs", "delivery-stage-features",
                       f"a {use_case.data.get('status')} use case needs inline features or featureRefs")
        self.unchecked["improvement-request"] += len(as_list(use_case.data.get("improvementRequests")))

    def check_supersession(self):
        for start in self.concepts:
            if start.type not in FINDING:
                continue
            seen, current = {(start.bundle, start.handle)}, start
            while "supersededBy" in current.data:
                key = reference_key(current, current.data["supersededBy"])
                if key is None or key not in self.index:
                    break
                if key == (start.bundle, start.handle):
                    self.error(start, "supersededBy", "supersession-acyclic",
                               "supersededBy leads back to this finding")
                    break
                if key in seen:
                    break
                seen.add(key)
                current = self.index[key]

    def run(self):
        dispatch = {
            "Job": self.check_job,
            "Product Research Study": self.check_study,
            "Product Research Finding": self.check_finding,
            "Feature": self.check_feature,
            "Use Case": self.check_use_case,
        }
        for concept in self.concepts:
            check = dispatch.get(concept.type)
            if check:
                check(concept)
        self.check_supersession()


def reference_key(concept, value):
    if not isinstance(value, str):
        return None
    match = CONCEPT_URI.fullmatch(value)
    if match:
        return (match.group(1), match.group(2))
    if LOCAL_HANDLE.fullmatch(value):
        return (concept.bundle, value)
    return None


def as_list(value):
    return value if isinstance(value, list) else []


def records(value):
    return [v for v in as_list(value) if isinstance(v, dict)]


def finite(value):
    return isinstance(value, (int, float)) and not isinstance(value, bool) and math.isfinite(value)


def timestamp(value):
    if not isinstance(value, str):
        return None
    try:
        return datetime.fromisoformat(value.replace("Z", "+00:00"))
    except ValueError:
        return None


def load_manifest(path):
    try:
        manifest = json.loads(Path(path).read_text())
    except (OSError, ValueError) as exc:
        raise ManifestError(f"cannot read manifest {path}: {exc}")
    bundles = manifest.get("bundles") if isinstance(manifest, dict) else None
    if not isinstance(bundles, list) or not bundles:
        raise ManifestError("manifest must be an object with a non-empty `bundles` list")
    base = Path(path).resolve().parent
    seen, result = set(), []
    for i, entry in enumerate(bundles):
        if not isinstance(entry, dict) or set(entry) != {"uri", "path", "profile"}:
            raise ManifestError(f"bundles[{i}] must have exactly `uri`, `path`, and `profile`")
        if not all(isinstance(entry[k], str) for k in entry):
            raise ManifestError(f"bundles[{i}] values must be strings")
        if not BUNDLE_URI.fullmatch(entry["uri"]):
            raise ManifestError(f"bundles[{i}].uri is not a canonical Mori bundle URI: {entry['uri']}")
        if entry["uri"] in seen:
            raise ManifestError(f"bundles[{i}].uri is mapped twice: {entry['uri']}")
        seen.add(entry["uri"])
        bundle_path, profile = base / entry["path"], base / entry["profile"]
        if not bundle_path.is_dir():
            raise ManifestError(f"bundles[{i}].path is not a directory: {bundle_path}")
        if not profile.is_file():
            raise ManifestError(f"bundles[{i}].profile is not a file: {profile}")
        result.append((entry["uri"], bundle_path, profile))
    return result


def load(okf, bundles, checker):
    """Validate and index every bundle; return error lines for failed bundles."""
    failures = []
    for uri, path, profile in bundles:
        validated = subprocess.run(
            [okf, "validate", str(path), "--strict", "--profile", str(profile),
             "--profile-enforce", "--log-enforce"],
            text=True, capture_output=True)
        if validated.returncode != 0:
            detail = (validated.stdout + validated.stderr).strip()
            failures.append(f"{uri}: strict profile validation failed\n{detail}")
            continue
        listed = subprocess.run([okf, "concepts", str(path), "--json"],
                                text=True, capture_output=True)
        if listed.returncode != 0:
            failures.append(f"{uri}: okf concepts failed\n{listed.stderr.strip()}")
            continue
        for row in json.loads(listed.stdout):
            concept = Concept(uri, row)
            if concept.type in UNINDEXED_TYPES:
                checker.concepts.append(concept)
                continue
            if concept.type not in ID_FIELDS:
                failures.append(f"{uri}: unsupported concept type {concept.type!r}")
                continue
            checker.concepts.append(concept)
            checker.index[(uri, concept.handle)] = concept
    return failures


def main():
    parser = argparse.ArgumentParser(description=__doc__.split("\n\n")[0])
    parser.add_argument("--manifest", help="JSON manifest mapping bundle URIs to paths and profiles")
    parser.add_argument("--list-rules", action="store_true", help="print each rule with its owner")
    args = parser.parse_args()
    if args.list_rules:
        for rule, owner, description in RULES:
            print(f"{rule}  {owner}  {description}")
        return 0
    if not args.manifest:
        parser.error("--manifest is required unless --list-rules is given")
    try:
        bundles = load_manifest(args.manifest)
    except ManifestError as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 2

    checker = Checker()
    failures = load(os.environ.get("OKF_BIN", "okf"), bundles, checker)
    if failures:
        print("\n".join(failures), file=sys.stderr)
        return 1
    checker.run()
    if checker.errors:
        print("\n".join(checker.errors), file=sys.stderr)
        print(f"FAILED: {len(checker.errors)} relationship error(s)", file=sys.stderr)
        return 1
    print(f"OK: {len(bundles)} bundles, {len(checker.concepts)} concepts, "
          f"{checker.resolved} references resolved across jobs, product research, "
          f"features, use cases, capabilities, and specifications")
    print(f"unchecked: {checker.unchecked['owner']} owner project URIs and "
          f"{checker.unchecked['improvement-request']} improvement-request URIs are outside "
          f"this checker's resolution domain")
    print("untraversed: generic sources, related use cases, capability requires, "
          "specification supersession, and pointer destinations")
    return 0


if __name__ == "__main__":
    sys.exit(main())
