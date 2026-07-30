#!/usr/bin/env bash

set -euo pipefail

okf_bin="${OKF_BIN:-okf}"
profile="profiles/coordination/improvement-requests.dhall"

"${okf_bin}" validate fixtures/improvement-requests \
  --profile "${profile}" \
  --profile-enforce

for fixture in \
  missing-id \
  wrong-prefix \
  duplicate-id \
  missing-required \
  unknown-type \
  nested-path \
  invalid-policy; do
  if "${okf_bin}" validate "fixtures/improvement-requests-invalid/${fixture}" \
    --profile "${profile}" \
    --profile-enforce >/dev/null 2>&1; then
    echo "expected profile enforcement to reject ${fixture}" >&2
    exit 1
  fi
done

echo "OK: improvement-request profile acceptance and rejection fixtures"
