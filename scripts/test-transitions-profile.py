#!/usr/bin/env python3
"""Assert profile rejections by field, including base OKF validation errors."""
import json
import os
import subprocess
from pathlib import Path

okf = os.environ.get("OKF_BIN", "okf")
profile = os.environ.get("PROFILE", "profiles/coordination/transitions.dhall")
subprocess.run([okf, "validate", "fixtures/transitions", "--strict", "--profile", profile,
                "--profile-enforce", "--log-enforce"], check=True)
cases = json.loads(Path("fixtures/transitions-invalid/expected.json").read_text())
for name, field in cases.items():
    command = [okf, "validate", "fixtures/transitions-invalid/" + name, "--profile", profile]
    result = subprocess.run(command, text=True, capture_output=True)
    diagnostics = result.stdout + result.stderr
    assert any(field in line for line in diagnostics.splitlines()
               if line.startswith(("profile:", "transition:"))), (name, field, diagnostics)
    enforced = subprocess.run(command + ["--profile-enforce"], text=True, capture_output=True)
    assert enforced.returncode != 0, (name, enforced.stdout, enforced.stderr)
print(f"OK: transition profile accepts 4 concepts and rejects {len(cases)} focused cases")
