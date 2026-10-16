#!/usr/bin/env python3
"""Accept the jobs fixture bundle and reject each focused jobs-invalid case."""
from profile_fixture_cases import run

run("jobs", "profiles/coordination/jobs.dhall", "fixtures/jobs", "fixtures/jobs-invalid")
