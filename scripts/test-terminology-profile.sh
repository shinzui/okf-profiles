#!/usr/bin/env bash

set -euo pipefail

okf_bin="${OKF_BIN:-okf}"
profile="profiles/documentation/terminology.dhall"

"${okf_bin}" validate fixtures/terminology \
  --strict \
  --profile "${profile}" \
  --profile-enforce \
  --log-enforce

for fixture in \
  missing-id \
  wrong-prefix \
  duplicate-id \
  missing-required \
  missing-generated \
  unknown-type \
  invalid-status \
  missing-replaced-by \
  local-same-as \
  bad-same-as-uri \
  bad-broader-reference \
  unresolved-broader \
  bad-anchor-kind \
  missing-anchor-resource; do
  if "${okf_bin}" validate "fixtures/terminology-invalid/${fixture}" \
    --profile "${profile}" \
    --profile-enforce >/dev/null 2>&1; then
    echo "expected profile enforcement to reject ${fixture}" >&2
    exit 1
  fi
done

echo "OK: terminology profile acceptance and rejection fixtures"
