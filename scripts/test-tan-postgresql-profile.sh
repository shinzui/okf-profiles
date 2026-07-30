#!/usr/bin/env bash

set -euo pipefail

okf_bin="${OKF_BIN:-okf}"
profile="profiles/tan-postgresql.dhall"

"${okf_bin}" validate fixtures/tan-postgresql \
  --profile "${profile}" \
  --profile-enforce

for fixture in missing-source-streams invalid-role; do
  if "${okf_bin}" validate "fixtures/tan-postgresql-invalid/${fixture}" \
    --profile "${profile}" \
    --profile-enforce >/dev/null 2>&1; then
    echo "expected profile enforcement to reject ${fixture}" >&2
    exit 1
  fi
done

echo "OK: tan-postgresql profile acceptance and rejection fixtures"
