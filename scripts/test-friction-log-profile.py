#!/usr/bin/env python3
"""Accept the friction-log fixture bundle and reject each focused friction-log-invalid case."""
from profile_fixture_cases import run

run("friction-log", "profiles/coordination/friction-log.dhall", "fixtures/friction-log", "fixtures/friction-log-invalid")
