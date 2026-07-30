#!/usr/bin/env bash

set -euo pipefail

okf_bin="${OKF_BIN:-okf}"
profile="profiles/documentation/pattern-catalog.dhall"

"${okf_bin}" validate fixtures/documentation-pattern-catalog \
  --profile "${profile}" \
  --profile-enforce \
  --log-enforce

if "${okf_bin}" validate fixtures/documentation-pattern-catalog-invalid \
  --profile "${profile}" \
  --profile-enforce >/dev/null 2>&1; then
  echo "expected profile enforcement to reject invalid-policy" >&2
  exit 1
fi

echo "OK: pattern-catalog profile acceptance and rejection fixtures"
