#!/usr/bin/env python3
"""Accept the designs fixture bundle and reject each focused designs-invalid case.

A second run closes the viewer-axis names through `designsFor`, using the house
descriptor `fixtures/designs-house.dhall`, and rejects a misspelled axis. The
same brief must validate strictly under the default profile, whose names are
open.
"""
import os
import subprocess
import sys

from profile_fixture_cases import run

run("designs", "profiles/coordination/designs.dhall", "fixtures/designs", "fixtures/designs-invalid")
run("designs house", "fixtures/designs-house.dhall", "fixtures/designs", "fixtures/designs-house-invalid")

open_names = subprocess.run(
    [os.environ.get("OKF_BIN", "okf"), "validate", "fixtures/designs-house-invalid/misspelled-viewer-axis",
     "--strict", "--profile", "profiles/coordination/designs.dhall", "--profile-enforce"],
    text=True, capture_output=True)
if open_names.returncode != 0:
    sys.exit(f"the default designs profile must leave viewer-axis names open:\n{open_names.stdout}{open_names.stderr}")
print("OK: designs profile leaves viewer-axis names open")
