#!/usr/bin/env bash

set -euo pipefail

okf_bin="${OKF_BIN:-okf}"
profile="profiles/documentation/pattern-catalog.dhall"

"${okf_bin}" validate fixtures/documentation-pattern-catalog \
  --strict \
  --profile "${profile}" \
  --profile-enforce \
  --log-enforce

for fixture in \
  invalid-policy \
  bad-actor \
  missing-generated \
  bad-source-shape \
  bad-verified-actor \
  bad-legacy-timestamp; do
  if "${okf_bin}" validate "fixtures/documentation-pattern-catalog-invalid/${fixture}" \
    --profile "${profile}" \
    --profile-enforce >/dev/null 2>&1; then
    echo "expected profile enforcement to reject ${fixture}" >&2
    exit 1
  fi
done

# Assessable types: each fixture must fail, and for its own reason. The
# expected diagnostic fragment guards against a fixture that fails for an
# unrelated defect (ADR-9).
while IFS='|' read -r fixture expected; do
  if output="$("${okf_bin}" validate "fixtures/documentation-pattern-catalog-invalid/${fixture}" \
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
assessable-missing-id|Assessable Standard requires a document ID with prefix PAT
assessable-wrong-prefix|document ID must look like PAT-<number>
assessable-duplicate-id|duplicate document ID PAT-1
assessable-empty-criteria|missing profile-required field: criteria
assessable-duplicate-criterion-id|duplicate value "separate-live-and-ready" for criteria.id
assessable-missing-applicability|missing profile-required field: applicability
assessable-missing-scope|missing profile-required field: applicability.scope
assessable-bad-evidence-kind|criteria[0].evidenceKind must be one of
assessable-missing-severity|missing profile-required field: criteria[0].severity
assessable-bad-dependency-uri|applicability.dependenciesAny must match format uri-with-scheme(mori)
FIXTURES

echo "OK: pattern-catalog profile acceptance and rejection fixtures"
