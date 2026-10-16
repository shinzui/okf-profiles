#!/usr/bin/env python3
"""Accept legacy and canonical use-case bundles and reject each focused invalid case.

fixtures/use-cases is the legacy inline-only corpus; it must keep validating
unchanged. fixtures/product-discovery/use-cases exercises the canonical
`jobRef`, `outcomeNames`, `featureRefs`, and `features[].featureRef` links and
a draft use case with no features. Relationship checks between them live in
scripts/test-product-discovery.sh.
"""
import os
import subprocess
import sys

from profile_fixture_cases import run

profile = os.environ.get("PROFILE", "profiles/coordination/use-cases.dhall")
canonical = subprocess.run(
    [os.environ.get("OKF_BIN", "okf"), "validate", "fixtures/product-discovery/use-cases",
     "--strict", "--profile", profile, "--profile-enforce", "--log-enforce"],
    text=True, capture_output=True)
if canonical.returncode != 0:
    sys.exit("fixtures/product-discovery/use-cases must validate strictly:\n"
             + canonical.stdout + canonical.stderr)
run("use-case", "profiles/coordination/use-cases.dhall", "fixtures/use-cases", "fixtures/use-cases-invalid")
