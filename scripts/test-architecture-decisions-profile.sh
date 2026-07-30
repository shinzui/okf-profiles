#!/usr/bin/env bash

set -euo pipefail

okf_bin="${OKF_BIN:-okf}"
profile="profiles/documentation/architecture-decisions.dhall"

"${okf_bin}" validate fixtures/architecture-decisions \
  --profile "${profile}" \
  --profile-enforce \
  --log-enforce

for fixture in \
  missing-id \
  wrong-prefix \
  duplicate-id \
  missing-required \
  unknown-type \
  nested-path \
  dangling-reference; do
  if "${okf_bin}" validate "fixtures/architecture-decisions-invalid/${fixture}" \
    --profile "${profile}" \
    --profile-enforce >/dev/null 2>&1; then
    echo "expected profile enforcement to reject ${fixture}" >&2
    exit 1
  fi
done

echo "OK: architecture-decision profile acceptance and rejection fixtures"
