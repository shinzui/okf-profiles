#!/usr/bin/env bash

set -euo pipefail

okf_bin="${OKF_BIN:-okf}"
profile="profiles/coordination/pattern-applications.dhall"

"${okf_bin}" validate fixtures/pattern-applications \
  --strict \
  --profile "${profile}" \
  --profile-enforce \
  --log-enforce

# Each fixture must fail, and for its own reason. The expected diagnostic
# fragment guards against a fixture that fails for an unrelated defect (ADR-9).
while IFS='|' read -r fixture expected; do
  if output="$("${okf_bin}" validate "fixtures/pattern-applications-invalid/${fixture}" \
    --profile "${profile}" \
    --profile-enforce 2>&1)"; then
    echo "expected profile enforcement to reject ${fixture}" >&2
    exit 1
  fi
  if ! grep -qF -- "${expected}" <<<"${output}"; then
    echo "${fixture} failed without the expected diagnostic: ${expected}" >&2
    echo "${output}" >&2
    exit 1
  fi
done <<'FIXTURES'
missing-id|Pattern Application requires a document ID with prefix PA
wrong-prefix|document ID must look like PA-<number>
duplicate-id|duplicate document ID PA-1
non-mori-service|external reference at service uses scheme https
service-not-a-project|external reference at service does not match whole-value pattern
local-pattern|local document reference at pattern is not allowed
pattern-not-assessable|external reference at pattern does not match whole-value pattern
invalid-decision|frontmatter value at decision must be one of
missing-rationale|missing profile-required field: rationale
missing-exception|missing profile-required field: exception (when decision is exception)
incomplete-exception|missing profile-required field: exception.reviewCondition
exception-authority-not-human|exception.authority must match format human-actor
malformed-check|missing profile-required field: checks[0].target
duplicate-check-criterion|duplicate value "separate-live-and-ready" for checks.criterion
FIXTURES

echo "OK: pattern-applications profile acceptance and rejection fixtures"
