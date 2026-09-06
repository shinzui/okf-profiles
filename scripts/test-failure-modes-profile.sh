#!/usr/bin/env bash

set -euo pipefail

okf_bin="${OKF_BIN:-okf}"
profile="profiles/assurance/failure-modes.dhall"

"${okf_bin}" validate fixtures/failure-modes \
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
  missing-signature \
  missing-occurrences \
  missing-diagnosis \
  scalar-occurrences \
  scalar-diagnosis \
  missing-root-cause \
  missing-control \
  invalid-status \
  invalid-scope \
  invalid-bug-report-uri \
  unresolvable-superseded-by \
  unknown-type \
  nested-path \
  missing-generated \
  bad-actor \
  bad-review-timestamp; do
  if "${okf_bin}" validate "fixtures/failure-modes-invalid/${fixture}" \
    --profile "${profile}" \
    --profile-enforce >/dev/null 2>&1; then
    echo "expected profile enforcement to reject ${fixture}" >&2
    exit 1
  fi
done

echo "OK: failure-mode profile acceptance and rejection fixtures"
