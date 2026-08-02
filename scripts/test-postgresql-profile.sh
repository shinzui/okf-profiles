#!/usr/bin/env bash

set -euo pipefail

okf_bin="${OKF_BIN:-okf}"
profile="profiles/postgresql.dhall"

"${okf_bin}" validate fixtures/postgresql \
  --strict \
  --profile "${profile}" \
  --profile-enforce \
  --log-enforce

for fixture in \
  bad-resource-scheme \
  missing-schema-section; do
  if "${okf_bin}" validate "fixtures/postgresql-invalid/${fixture}" \
    --profile "${profile}" \
    --profile-enforce >/dev/null 2>&1; then
    echo "expected profile enforcement to reject ${fixture}" >&2
    exit 1
  fi
done

echo "OK: postgresql profile acceptance and rejection fixtures"
