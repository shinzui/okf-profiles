#!/usr/bin/env bash

set -euo pipefail

okf_bin="${OKF_BIN:-okf}"
profile="profiles/documentation/specifications.dhall"

"${okf_bin}" validate fixtures/specifications \
  --strict \
  --profile "${profile}" \
  --profile-enforce \
  --log-enforce

for fixture in \
  missing-id \
  wrong-prefix \
  duplicate-id \
  missing-required \
  unknown-type \
  invalid-status \
  missing-spec-version \
  missing-normative-scope \
  missing-superseded-by \
  missing-authoritative-spec \
  bad-owner-uri \
  bad-conformance-uri \
  bad-superseded-by-handle \
  unresolved-supersedes \
  bad-actor \
  missing-generated \
  bad-verified-actor \
  bad-legacy-timestamp \
  bad-source-shape; do
  if "${okf_bin}" validate "fixtures/specifications-invalid/${fixture}" \
    --profile "${profile}" \
    --profile-enforce >/dev/null 2>&1; then
    echo "expected profile enforcement to reject ${fixture}" >&2
    exit 1
  fi
done

echo "OK: specification profile acceptance and rejection fixtures"
