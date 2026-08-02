#!/usr/bin/env bash

set -euo pipefail

okf_bin="${OKF_BIN:-okf}"
profile="profiles/okf-v0-2.dhall"

"${okf_bin}" validate fixtures/okf-v0-2 \
  --strict \
  --profile "${profile}" \
  --profile-enforce \
  --log-enforce

for fixture in \
  bad-actor \
  missing-generated \
  bad-status \
  bad-stale-after \
  missing-source-resource \
  quoted-usage-count \
  bad-verified-actor \
  bad-usage-window-date; do
  if "${okf_bin}" validate "fixtures/okf-v0-2-invalid/${fixture}" \
    --profile "${profile}" \
    --profile-enforce >/dev/null 2>&1; then
    echo "expected profile enforcement to reject ${fixture}" >&2
    exit 1
  fi
done

echo "OK: okf-v0-2 reference profile acceptance and rejection fixtures"
