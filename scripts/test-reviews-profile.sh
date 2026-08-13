#!/usr/bin/env bash

set -euo pipefail

okf_bin="${OKF_BIN:-okf}"
profile="profiles/assurance/reviews.dhall"

"${okf_bin}" validate fixtures/reviews \
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
  unknown-type \
  missing-title \
  missing-description \
  missing-generated \
  bad-actor \
  bad-verified-actor \
  missing-subject \
  invalid-subject-uri \
  missing-subject-kind \
  invalid-subject-kind \
  list-component \
  invalid-repository-uri \
  missing-reviewed-sha \
  missing-coverage \
  invalid-coverage \
  missing-base-sha \
  unresolvable-previous-review \
  missing-reviewed-at \
  bad-reviewed-at \
  missing-reviewer-kind \
  invalid-reviewer-kind \
  missing-reviewer \
  bad-reviewer-actor \
  missing-outcome \
  invalid-outcome \
  missing-dimensions \
  invalid-dimension \
  scalar-dimensions \
  missing-provider \
  missing-model \
  missing-effort \
  invalid-effort \
  invalid-produced-uri \
  list-context; do
  if "${okf_bin}" validate "fixtures/reviews-invalid/${fixture}" \
    --profile "${profile}" \
    --profile-enforce >/dev/null 2>&1; then
    echo "expected profile enforcement to reject ${fixture}" >&2
    exit 1
  fi
done

echo "OK: review profile acceptance and rejection fixtures"
