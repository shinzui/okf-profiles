#!/usr/bin/env bash

set -euo pipefail

okf_bin="${OKF_BIN:-okf}"
profile="profiles/documentation/research-documents.dhall"

"${okf_bin}" validate fixtures/research-documents \
  --strict \
  --profile "${profile}" \
  --profile-enforce \
  --log-enforce

for fixture in \
  missing-id \
  wrong-prefix \
  duplicate-id \
  missing-required \
  unknown-type; do
  if "${okf_bin}" validate "fixtures/research-documents-invalid/${fixture}" \
    --strict \
    --profile "${profile}" \
    --profile-enforce >/dev/null 2>&1; then
    echo "expected profile enforcement to reject ${fixture}" >&2
    exit 1
  fi
done

echo "OK: research-document profile acceptance and rejection fixtures"
