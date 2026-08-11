#!/usr/bin/env bash

set -euo pipefail

okf_bin="${OKF_BIN:-okf}"
profile="profiles/coordination/bug-reports.dhall"

"${okf_bin}" validate fixtures/bug-reports \
  --strict \
  --profile "${profile}" \
  --profile-enforce \
  --log-enforce

for fixture in \
  missing-id \
  wrong-prefix \
  duplicate-id \
  missing-bundle-version \
  missing-type \
  missing-title \
  missing-description \
  missing-observed \
  missing-expected \
  missing-affected-version \
  missing-reproduction \
  scalar-reproduction \
  unknown-type \
  nested-path \
  invalid-status \
  invalid-severity \
  invalid-origin-uri \
  invalid-affects-uri \
  invalid-capability-uri \
  missing-fixed-version \
  missing-duplicate-of \
  unresolvable-duplicate-of \
  missing-generated \
  bad-actor \
  bad-verified-actor \
  bad-review-timestamp; do
  if "${okf_bin}" validate "fixtures/bug-reports-invalid/${fixture}" \
    --profile "${profile}" \
    --profile-enforce >/dev/null 2>&1; then
    echo "expected profile enforcement to reject ${fixture}" >&2
    exit 1
  fi
done

echo "OK: bug-report profile acceptance and rejection fixtures"
