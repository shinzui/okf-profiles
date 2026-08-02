#!/usr/bin/env bash

set -euo pipefail

okf_bin="${OKF_BIN:-okf}"
profile="profiles/coordination/use-cases.dhall"

"${okf_bin}" validate fixtures/use-cases \
  --strict \
  --profile "${profile}" \
  --profile-enforce \
  --log-enforce

for fixture in \
  missing-jobs \
  invalid-feature-status \
  invalid-owner-uri \
  invalid-request-uri \
  duplicate-id \
  bad-actor \
  missing-generated \
  bad-verified-actor \
  bad-legacy-timestamp; do
  if "${okf_bin}" validate "fixtures/use-cases-invalid/${fixture}" \
    --profile "${profile}" \
    --profile-enforce >/dev/null 2>&1; then
    echo "expected profile enforcement to reject ${fixture}" >&2
    exit 1
  fi
done

echo "OK: use-case profile acceptance and rejection fixtures"
