#!/usr/bin/env bash

set -euo pipefail

okf_bin="${OKF_BIN:-okf}"
profile="profiles/documentation/pattern-catalog.dhall"

"${okf_bin}" validate fixtures/documentation-pattern-catalog \
  --strict \
  --profile "${profile}" \
  --profile-enforce \
  --log-enforce

for fixture in \
  invalid-policy \
  bad-actor \
  missing-generated \
  bad-source-shape \
  bad-verified-actor \
  bad-legacy-timestamp; do
  if "${okf_bin}" validate "fixtures/documentation-pattern-catalog-invalid/${fixture}" \
    --profile "${profile}" \
    --profile-enforce >/dev/null 2>&1; then
    echo "expected profile enforcement to reject ${fixture}" >&2
    exit 1
  fi
done

echo "OK: pattern-catalog profile acceptance and rejection fixtures"
