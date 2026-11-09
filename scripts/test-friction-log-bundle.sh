#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
"${OKF_BIN:-okf}" validate docs/friction-log --strict --profile docs/friction-log/profile.dhall --profile-enforce --log-enforce
