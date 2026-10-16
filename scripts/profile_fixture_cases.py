"""Shared harness for profile tests that map each rejection fixture to a field.

A profile test validates its acceptance bundle strictly, then reads
`<invalid-dir>/expected.json`, which maps each rejection fixture to the field
its diagnostic must name. Per ADR-9 a rejection fixture must fail for exactly
one reason, so the advisory run must report exactly one deviation, and that
deviation must name the field. A value may instead be
`{"field": ..., "diagnostics": N}` when okf reports one defect through N
overlapping core diagnostics, such as a malformed handle that fails both the
field format and the document ID shape.

`OKF_BIN` selects the okf executable and `PROFILE` overrides the descriptor, so
a negative control can point the same test at a temporarily relaxed copy.
"""
import json
import os
import subprocess
import sys
from pathlib import Path

SUMMARY = "advisory deviation(s)"


def deviations(output):
    return [line for line in output.splitlines()
            if line.startswith("profile: ") and SUMMARY not in line]


def run(label, default_profile, accept, invalid):
    okf = os.environ.get("OKF_BIN", "okf")
    profile = os.environ.get("PROFILE", default_profile)
    accepted = subprocess.run(
        [okf, "validate", accept, "--strict", "--profile", profile,
         "--profile-enforce", "--log-enforce"],
        text=True, capture_output=True)
    if accepted.returncode != 0:
        sys.exit(f"{accept} must validate strictly:\n{accepted.stdout}{accepted.stderr}")
    concepts = accepted.stdout.split("OK: ", 1)[-1].split(" ", 1)[0]

    cases = json.loads(Path(invalid, "expected.json").read_text())
    failures = []
    for name, spec in cases.items():
        field = spec if isinstance(spec, str) else spec["field"]
        count = 1 if isinstance(spec, str) else spec["diagnostics"]
        command = [okf, "validate", str(Path(invalid, name)), "--profile", profile]
        advisory = subprocess.run(command, text=True, capture_output=True)
        found = deviations(advisory.stdout + advisory.stderr)
        if len(found) != count or not any(field in line for line in found):
            failures.append(f"{name}: expected {count} deviation(s) naming {field!r}, got {found}")
            continue
        enforced = subprocess.run(command + ["--profile-enforce"], text=True, capture_output=True)
        if enforced.returncode == 0:
            failures.append(f"{name}: --profile-enforce accepted the fixture")
    if failures:
        sys.exit("\n".join(failures))
    print(f"OK: {label} profile accepts {concepts} concepts and rejects {len(cases)} focused cases")
