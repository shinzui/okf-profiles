#!/usr/bin/env bash
set -euo pipefail
okf_bin="${OKF_BIN:-okf}"
profile="${PROFILE:-profiles/documentation/runbooks.dhall}"
source_hash="$(dhall hash --file "$profile")"
snapshot_hash="$(dhall hash --file blueprints/adopt-runbooks/files/runbooks-profile.dhall)"
if [[ "$source_hash" != "$snapshot_hash" ]]; then
  echo "Runbook adoption snapshot differs from the source profile" >&2
  exit 1
fi
"$okf_bin" validate fixtures/runbooks --strict --profile "$profile" --profile-enforce --log-enforce
for fixture in fixtures/runbooks-invalid/*; do
  output="$(mktemp)"
  trap 'rm -f "$output"' EXIT
  "$okf_bin" validate "$fixture" --profile "$profile" >"$output" 2>&1
  case "${fixture##*/}" in
    unknown-type) field="type" ;;
    missing-owner) field="owner" ;;
    missing-id|bad-id|duplicate-id) field="docId|RB" ;;
    missing-trigger) field="trigger" ;;
    *environments) field="environments" ;;
    bad-project|empty-projects) field="projects" ;;
    *effects) field="effects" ;;
    *status) field="status" ;;
    bad-generated) field="generated" ;;
    *supersedes) field="supersedes" ;;
    bad-related) field="related" ;;
    bad-verified) field="verified" ;;
    bad-stale-after) field="stale_after" ;;
    *) echo "Unmapped rejection fixture: $fixture" >&2; exit 1 ;;
  esac
  if ! rg -q "^profile: .*($field)" "$output"; then
    cat "$output" >&2
    echo "Missing focused $field diagnostic: $fixture" >&2
    exit 1
  fi
  if "$okf_bin" validate "$fixture" --profile "$profile" --profile-enforce > /dev/null 2>&1; then
    echo "Expected runbook profile to reject $fixture" >&2
    exit 1
  fi
  rm -f "$output"
  trap - EXIT
done
echo "OK: runbook profile acceptance and rejection fixtures"
