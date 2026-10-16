#!/usr/bin/env python3
"""Test the product-discovery relationship checker and the integration fixtures.

The valid graph in fixtures/product-discovery/manifest.json must pass. Each
mutation below is applied to a temporary copy and must fail with errors from
exactly its intended rule, including one at the intended source concept and
field; restoring the copy must then pass again. Every rule printed by
`--list-rules` must have an `okf` or `mori` owner and be exercised here.

The auxiliary improvement-request, bug-report, and technical-research bundles
are not in the manifest. They are validated strictly with their own, unchanged
profiles, and their links to the discovery concepts are asserted directly from
`okf concepts --json`, with one negative control per link.
"""
import json
import os
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

OKF = os.environ.get("OKF_BIN", "okf")
CHECKER = Path("scripts/check-product-discovery.py").resolve()
REPO = Path.cwd()
TREES = ["fixtures/jobs", "fixtures/product-research", "fixtures/features",
         "fixtures/product-discovery"]

P = "mori://example/product/okf"
JOB1, JOB3 = f"{P}/jobs/concepts/JOB-1", f"{P}/jobs/concepts/JOB-3"
PR2 = f"{P}/research/concepts/PR-2"
PR5 = f"{P}/research/concepts/PR-5"
FEAT1 = f"{P}/features/concepts/FEAT-1"
UC1, UC2, UC3 = (f"{P}/use-cases/concepts/UC-{n}" for n in (1, 2, 3))
CAP1 = "mori://example/export-service/okf/capabilities/concepts/CAP-1"

JOB_FILE = "fixtures/jobs/share-monthly-results.md"
JOB3_FILE = "fixtures/jobs/keep-leadership-informed.md"
PR2_FILE = "fixtures/product-research/time-to-share-dominates.md"
PR3_FILE = "fixtures/product-research/attachments-ignored.md"
PR5_FILE = "fixtures/product-research/early-pilot-timing.md"
FEAT_FILE = "fixtures/features/results-sharing-link.md"
UC1_FILE = "fixtures/product-discovery/use-cases/close-and-share-month.md"
UC2_FILE = "fixtures/product-discovery/use-cases/brief-the-board.md"
UC3_FILE = "fixtures/product-discovery/use-cases/explore-digests.md"

PR6 = """---
type: Product Research Finding
title: Second pilot timing estimate
description: Another early estimate, superseded in a cycle by mistake.
generated:
  by: human:fixture-author
  at: "2026-10-16T09:00:00Z"
productResearchId: PR-6
studyRef: PR-1
observation: One lead estimated two hours.
interpretation: Time to share is several hours.
context: The third interview.
observedAt: "2026-08-04T16:00:00Z"
limitations: One self-reported estimate.
status: superseded
supersededBy: PR-5
sources:
  - id: notes
    resource: Interview notes, PR-1 session 3
---

# Second pilot timing estimate
"""

# (name, rule, source URI, field path, [(file, old, new)], {new file: text})
MUTATIONS = [
    ("baseline-not-number", "finite-number", JOB1, "outcomes[0].baseline",
     [(JOB_FILE, "baseline: 95", 'baseline: "ninety-five"')], {}),
    ("measurement-value-not-number", "finite-number", PR2, "measurements[0].value",
     [(PR2_FILE, "    value: 95", "    value: .nan")], {}),
    ("partial-measurement", "measurement-complete", JOB1, "outcomes[0]",
     [(JOB_FILE, "    method: product analytics event timestamps\n", "")], {}),
    ("baseline-without-period", "baseline-context", JOB1, "outcomes[0].baseline",
     [(JOB_FILE, "    period: July 2026 close\n", "")], {}),
    ("reversed-period", "period-order", PR2, "measurements[0].periodEnd",
     [(PR2_FILE, 'periodEnd: "2026-07-31T23:59:59Z"', 'periodEnd: "2026-06-30T00:00:00Z"')], {}),
    ("outcome-ref-job-unlisted", "outcome-ref-job-listed", FEAT1, "outcomeRefs[0].jobRef",
     [(FEAT_FILE, f"  - jobRef: {JOB1}\n    outcomeName: time-to-share",
       f"  - jobRef: {JOB3}\n    outcomeName: heard-from-finance-first")], {}),
    ("duplicate-inline-job", "inline-name-unique", UC3, "jobs[1].name",
     [(UC3_FILE, f"    jobRef: {JOB3}\n",
       f"    jobRef: {JOB3}\n  - name: inform-leadership\n    actor: controller\n"
       "    situation: a large invoice is disputed\n    motivation: warn leadership early\n"
       "    outcome: leadership is warned by finance\n")], {}),
    ("inline-feature-unknown-job", "inline-feature-job", UC2, "features[0].jobs[0]",
     [(UC2_FILE, "      - brief-board", "      - brief-the-board")], {}),
    ("outcome-names-without-jobref", "outcome-names-need-jobref", UC1, "jobs[0].outcomeNames",
     [(UC1_FILE, f"    jobRef: {JOB1}\n", "")], {}),
    ("duplicate-feature-reference", "feature-ref-unique", UC2, "features[0].featureRef",
     [(UC2_FILE, f"  - {P}/features/concepts/FEAT-3", f"  - {FEAT1}")], {}),
    ("delivery-stage-without-features", "delivery-stage-features", UC3, "featureRefs",
     [(UC3_FILE, "status: draft", "status: planned")], {}),
    ("missing-imported-feature", "reference-target", UC1, "featureRefs[1]",
     [(UC1_FILE, f"  - {P}/features/concepts/FEAT-2", f"  - {P}/features/concepts/FEAT-9")], {}),
    ("study-ref-to-finding", "reference-target", PR2, "studyRef",
     [(PR2_FILE, "studyRef: PR-1", "studyRef: PR-3")], {}),
    ("finding-ref-to-study", "reference-target", JOB1, "assessment.findingRefs[0]",
     [(JOB_FILE, f"    - {PR2}\n    - ", f"    - {P}/research/concepts/PR-1\n    - ")], {}),
    ("missing-capability", "reference-target", FEAT1, "capabilityRefs[0]",
     [(FEAT_FILE, f"  - {CAP1}", "  - mori://example/export-service/okf/capabilities/concepts/CAP-2")], {}),
    ("unmapped-capability-bundle", "reference-target", FEAT1, "capabilityRefs[0]",
     [(FEAT_FILE, f"  - {CAP1}", "  - mori://example/other-service/okf/capabilities/concepts/CAP-1")], {}),
    ("missing-specification", "reference-target", FEAT1, "specificationRefs[1]",
     [(FEAT_FILE, f"  - {P}/specifications/concepts/SPEC-2", f"  - {P}/specifications/concepts/SPEC-7")], {}),
    ("unknown-outcome", "outcome-exists", UC1, "jobs[0].outcomeNames[0]",
     [(UC1_FILE, "      - time-to-share", "      - missing-outcome")], {}),
    ("measurement-unit-mismatch", "measurement-matches-outcome", PR2, "measurements[0].unit",
     [(PR2_FILE, "    unit: minutes", "    unit: hours")], {}),
    ("unrelated-assessment-evidence", "assessment-evidence", JOB3, "assessment.findingRefs[0]",
     [(JOB3_FILE, f"    - {PR2}", f"    - {P}/research/concepts/PR-3")], {}),
    ("cited-finding-withdrawn", "cited-finding-current", JOB1, "assessment.findingRefs[1]",
     [(PR3_FILE, "status: current", "status: withdrawn\nwithdrawalReason: Notes were misattributed.")], {}),
    ("supersession-cycle", "supersession-acyclic", PR5, "supersededBy",
     [(PR5_FILE, "supersededBy: PR-2", "supersededBy: PR-6")],
     {"fixtures/product-research/second-pilot-timing.md": PR6}),
]


def checker(manifest):
    return subprocess.run([sys.executable, str(CHECKER), "--manifest", str(manifest)],
                          text=True, capture_output=True)


def copy_tree(root):
    for tree in TREES:
        shutil.copytree(REPO / tree, root / tree)
    manifest = json.loads((REPO / "fixtures/product-discovery/manifest.json").read_text())
    for entry in manifest["bundles"]:
        entry["profile"] = str((REPO / "fixtures/product-discovery" / entry["profile"]).resolve())
    path = root / "fixtures/product-discovery/manifest.json"
    path.write_text(json.dumps(manifest, indent=2))
    return path


def check_rules():
    listed = subprocess.run([sys.executable, str(CHECKER), "--list-rules"],
                            text=True, capture_output=True, check=True).stdout.splitlines()
    rules = {}
    for line in listed:
        rule, owner, _ = line.split("  ", 2)
        assert owner in ("okf", "mori"), line
        rules[rule] = owner
    untested = set(rules) - {m[1] for m in MUTATIONS}
    assert not untested, f"rules without a mutation: {sorted(untested)}"
    return rules


def check_mutations(root, manifest):
    failures = []
    for name, rule, source, field, edits, new_files in MUTATIONS:
        originals = {}
        for file, old, new in edits:
            path = root / file
            text = originals.setdefault(path, path.read_text())
            current = path.read_text()
            assert current.count(old) == 1, (name, file, old)
            path.write_text(current.replace(old, new))
        for file, text in new_files.items():
            (root / file).write_text(text)
        result = checker(manifest)
        errors = [l for l in result.stderr.splitlines() if " [" in l and "]" in l]
        expected = f"{source} {field}: [{rule}] "
        if result.returncode != 1:
            failures.append(f"{name}: exit {result.returncode}\n{result.stdout}{result.stderr}")
        elif not any(l.startswith(expected) for l in errors):
            failures.append(f"{name}: no error starting {expected!r}\n{result.stderr}")
        elif any(f"[{rule}]" not in l for l in errors):
            failures.append(f"{name}: unrelated errors\n{result.stderr}")
        for path, text in originals.items():
            path.write_text(text)
        for file in new_files:
            (root / file).unlink()
    restored = checker(manifest)
    if restored.returncode != 0:
        failures.append(f"restored tree no longer passes:\n{restored.stderr}")
    return failures


def check_boundary(root, manifest):
    """Profile validation accepts a missing target that the checker rejects."""
    path = root / UC1_FILE
    original = path.read_text()
    path.write_text(original.replace(f"{P}/features/concepts/FEAT-2", f"{P}/features/concepts/FEAT-9"))
    profile = REPO / "profiles/coordination/use-cases.dhall"
    validated = subprocess.run([OKF, "validate", str(path.parent), "--strict", "--profile",
                                str(profile), "--profile-enforce", "--log-enforce"],
                               text=True, capture_output=True)
    checked = checker(manifest)
    path.write_text(original)
    assert validated.returncode == 0, validated.stdout + validated.stderr
    assert checked.returncode == 1, checked.stdout + checked.stderr


def check_manifest_errors(root):
    cases = {
        "not-json": "{",
        "no-bundles": '{"bundles": []}',
        "bad-uri": '{"bundles": [{"uri": "mori://example/product", "path": "use-cases", '
                   '"profile": "manifest.json"}]}',
        "missing-path": '{"bundles": [{"uri": "mori://example/product/okf/x", '
                        '"path": "nowhere", "profile": "manifest.json"}]}',
    }
    for name, text in cases.items():
        path = root / "fixtures/product-discovery" / f"{name}.json"
        path.write_text(text)
        result = checker(path)
        assert result.returncode == 2, (name, result.stdout, result.stderr)
    usage = subprocess.run([sys.executable, str(CHECKER)], text=True, capture_output=True)
    assert usage.returncode == 2, usage.stderr


def check_profile_failure(root, manifest):
    """A bundle failing strict profile validation fails the checker with exit 1."""
    path = root / UC3_FILE
    original = path.read_text()
    path.write_text(original.replace("status: draft", "status: dreaming"))
    result = checker(manifest)
    path.write_text(original)
    assert result.returncode == 1 and "strict profile validation failed" in result.stderr, \
        result.stdout + result.stderr


AUXILIARY = [
    ("improvement-requests", "profiles/coordination/improvement-requests.dhall"),
    ("bug-reports", "profiles/coordination/bug-reports.dhall"),
    ("technical-research", "profiles/documentation/research-documents.dhall"),
]


def concepts(bundle):
    listed = subprocess.run([OKF, "concepts", str(bundle), "--json"],
                            text=True, capture_output=True, check=True)
    return {c.get("title"): c for c in json.loads(listed.stdout)}


def integration_failures(root):
    """Return the fields whose intended integration link is missing."""
    base = root / "fixtures/product-discovery"
    for bundle, profile in AUXILIARY:
        subprocess.run([OKF, "validate", str(base / bundle), "--strict", "--profile",
                        str(REPO / profile), "--profile-enforce", "--log-enforce"],
                       text=True, capture_output=True, check=True)
    request = concepts(base / "improvement-requests")["Serve published results behind a stable link"]
    bug = concepts(base / "bug-reports")["Sharing link shows the previous period after publishing"]
    research = concepts(base / "technical-research")["Caching options for the results sharing link"]
    feature = concepts(root / "fixtures/features")["Results sharing link"]
    spec = concepts(base / "specifications")["Results sharing link contract"]
    ir1 = "mori://example/export-service/okf/improvement-requests/concepts/IR-1"
    failures = []
    if request.get("origin") != FEAT1:
        failures.append("origin")
    if ir1 not in feature.get("improvementRequests", []):
        failures.append("improvementRequests")
    request_ac = {c["id"]: c for c in request.get("acceptanceCriteria", [])}
    feature_ac = {c["id"]: c for c in feature.get("acceptanceCriteria", [])}
    if "AC-1" not in request_ac or "AC-1" not in feature_ac or \
            request_ac["AC-1"]["statement"] == feature_ac["AC-1"]["statement"] or \
            request_ac["AC-1"]["verification"] == feature_ac["AC-1"]["verification"]:
        failures.append("acceptanceCriteria")
    if bug.get("affects") != FEAT1:
        failures.append("affects")
    if bug.get("capability") != CAP1:
        failures.append("capability")
    if FEAT1 not in [s.get("resource") for s in research.get("sources", [])]:
        failures.append("sources (technical research)")
    spec_sources = [s.get("resource") for s in spec.get("sources", [])]
    if not {JOB1, f"{P}/research/concepts/PR-3", FEAT1} <= set(spec_sources):
        failures.append("sources (specification)")
    return failures


# (field the integration check must name, file, old, new)
INTEGRATION_CONTROLS = [
    ("origin", "fixtures/product-discovery/improvement-requests/stable-results-link.md",
     f"origin: {FEAT1}", "origin: mori://example/product"),
    ("improvementRequests", FEAT_FILE,
     "  - mori://example/export-service/okf/improvement-requests/concepts/IR-1",
     "  - mori://example/export-service/okf/improvement-requests/concepts/IR-2"),
    ("acceptanceCriteria", "fixtures/product-discovery/improvement-requests/stable-results-link.md",
     "  - id: AC-1", "  - id: AC-2"),
    ("affects", "fixtures/product-discovery/bug-reports/stale-link-snapshot.md",
     f"affects: {FEAT1}", "affects: mori://example/product"),
    ("capability", "fixtures/product-discovery/bug-reports/stale-link-snapshot.md",
     f"capability: {CAP1}", "capability: mori://example/export-service/okf/capabilities/concepts/CAP-2"),
    ("sources (technical research)", "fixtures/product-discovery/technical-research/link-caching-options.md",
     f"resource: {FEAT1}", "resource: mori://example/product"),
    ("sources (specification)", "fixtures/product-discovery/specifications/sharing-link-contract.md",
     f"resource: {FEAT1}", "resource: mori://example/product"),
]


def check_integration(root):
    found = integration_failures(root)
    assert not found, f"integration links missing: {found}"
    for field, file, old, new in INTEGRATION_CONTROLS:
        path = root / file
        original = path.read_text()
        assert original.count(old) == 1, (field, old)
        path.write_text(original.replace(old, new))
        found = integration_failures(root)
        path.write_text(original)
        assert found == [field], (field, found)


def main():
    passed = checker(REPO / "fixtures/product-discovery/manifest.json")
    if passed.returncode != 0:
        sys.exit(f"valid graph must pass:\n{passed.stdout}{passed.stderr}")
    rules = check_rules()
    with tempfile.TemporaryDirectory() as scratch:
        root = Path(scratch)
        manifest = copy_tree(root)
        failures = check_mutations(root, manifest)
        if failures:
            sys.exit("\n\n".join(failures))
        check_boundary(root, manifest)
        check_manifest_errors(root)
        check_profile_failure(root, manifest)
        check_integration(root)
    print(f"OK: product-discovery graph passes; {len(MUTATIONS)} single-rule mutations fail "
          f"at their intended field across {len(rules)} owned rules; "
          f"{len(INTEGRATION_CONTROLS)} integration links and their negative controls hold")


if __name__ == "__main__":
    main()
