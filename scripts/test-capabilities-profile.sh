#!/usr/bin/env bash

set -euo pipefail

okf_bin="${OKF_BIN:-okf}"
profile="profiles/coordination/capabilities.dhall"

"${okf_bin}" validate fixtures/capabilities \
  --strict \
  --profile "${profile}" \
  --profile-enforce \
  --log-enforce

for fixture in \
  missing-evidence \
  missing-evidence-resource \
  invalid-evidence-kind \
  invalid-status \
  invalid-stability \
  invalid-provider-uri \
  bad-capability-handle \
  duplicate-id \
  missing-replaced-by \
  unresolvable-requires \
  missing-generated \
  bad-actor \
  bad-verified-actor; do
  if "${okf_bin}" validate "fixtures/capabilities-invalid/${fixture}" \
    --profile "${profile}" \
    --profile-enforce >/dev/null 2>&1; then
    echo "expected profile enforcement to reject ${fixture}" >&2
    exit 1
  fi
done

echo "OK: capability profile acceptance and rejection fixtures"
