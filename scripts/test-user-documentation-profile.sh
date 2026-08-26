#!/usr/bin/env bash

set -euo pipefail

okf_bin="${OKF_BIN:-okf}"
profile="${PROFILE:-profiles/documentation/user-documentation.dhall}"

"${okf_bin}" validate fixtures/user-documentation \
  --strict \
  --profile "${profile}" \
  --profile-enforce \
  --log-enforce

fixtures=(
  unknown-type
  missing-title
  missing-description
  missing-doc-id
  bad-doc-id
  missing-tags
  missing-generated
  bad-generated-actor
  bad-generated-at
  bad-status
  bad-stale-after
  bad-source-shape
  bad-usage-window
  bad-verified-actor
  dangling-supersedes
  bad-superseded-by
  self-supersedes
  bad-external-supersedes
  bad-legacy-timestamp
  duplicate-doc-id
)

for fixture in "${fixtures[@]}"; do
  output="$(mktemp)"
  trap 'rm -f "${output}"' EXIT

  "${okf_bin}" validate "fixtures/user-documentation-invalid/${fixture}" \
    --profile "${profile}" >"${output}" 2>&1

  expected=1
  case "${fixture}" in
    missing-doc-id|bad-doc-id)
      # The required profile-wide DOC format and per-type ID ownership are two
      # independent diagnostics for the same composite stable-identity policy.
      expected=2
      ;;
  esac

  actual="$(grep -c '^profile: ' "${output}" || true)"
  # Exclude the final advisory summary line from the diagnostic count.
  actual=$((actual - 1))
  if [ "${actual}" -ne "${expected}" ]; then
    echo "expected ${fixture} to report ${expected} focused profile diagnostic(s), found ${actual}" >&2
    cat "${output}" >&2
    exit 1
  fi

  if "${okf_bin}" validate "fixtures/user-documentation-invalid/${fixture}" \
    --profile "${profile}" \
    --profile-enforce >/dev/null 2>&1; then
    echo "expected profile enforcement to reject ${fixture}" >&2
    exit 1
  fi

  rm -f "${output}"
  trap - EXIT
done

echo "OK: user-documentation profile acceptance and rejection fixtures"
