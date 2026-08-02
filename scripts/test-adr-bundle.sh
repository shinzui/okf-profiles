#!/usr/bin/env bash

# Unlike its siblings, this script validates the repository's OWN corpus rather
# than a fixture. docs/adr/profile.dhall imports ../../package.dhall by relative
# path, so this bundle is checked against the profile under development -- which
# makes the script a regression test on
# profiles/documentation/architecture-decisions.dhall, not merely a
# documentation check. A profile change that would break a real ADR corpus fails
# here before it reaches a consumer.
#
# The command is the one agents/skills/exec-plan/ADR.md mandates after creating
# or changing any decision record.

set -euo pipefail

okf_bin="${OKF_BIN:-okf}"
profile="docs/adr/profile.dhall"

"${okf_bin}" validate docs/adr \
  --strict \
  --profile "${profile}" \
  --profile-enforce \
  --log-enforce

echo "OK: architecture decision bundle"
