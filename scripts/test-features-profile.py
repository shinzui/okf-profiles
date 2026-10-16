#!/usr/bin/env python3
"""Accept the features fixture bundle and reject each focused features-invalid case."""
from profile_fixture_cases import run

run("features", "profiles/coordination/features.dhall", "fixtures/features", "fixtures/features-invalid")
