#!/usr/bin/env bash

# The bundles under docs/profiles/ are generated from the profiles themselves by
# `okf profile document`, so they cannot drift from the rules they describe by
# being edited — only by not being regenerated. With no arguments this asserts
# the committed bundles are current, which is why it belongs in the scripts/
# loop; `--regenerate` rewrites them, which is what `just docs` runs.
#
# Generation reads no clock and is byte-for-byte reproducible: `generated.at` is
# deliberately omitted, so re-running produces no diff when nothing changed.

set -euo pipefail

okf_bin="${OKF_BIN:-okf}"
registry="./package.dhall"
out_root="docs/profiles"

# The export as `okf profile list` prints it, then the directory it is
# documented in. Directory names match `profiles/<family>/<name>.dhall`,
# `fixtures/<name>/`, and `scripts/test-<name>-profile.sh`.
profiles=(
  "assurance.reviews:reviews"
  "coordination.bugReports:bug-reports"
  "coordination.capabilities:capabilities"
  "coordination.improvementRequests:improvement-requests"
  "coordination.useCases:use-cases"
  "documentation.architectureDecisions:architecture-decisions"
  "documentation.patternCatalog:pattern-catalog"
  "documentation.researchDocuments:research-documents"
  "okfV02:okf-v0-2"
  "postgresql:postgresql"
  "tanPostgresql:tan-postgresql"
)

generate_into () {
  local root="${1:?}"
  local pair export_path dir

  for pair in "${profiles[@]}"; do
    export_path="${pair%%:*}"
    dir="${pair##*:}"
    # Removed rather than overwritten, so a type dropped from a profile takes
    # its generated page with it instead of lingering as a stale concept.
    rm -rf "${root}/${dir}"
    "${okf_bin}" profile document \
      --no-local \
      --registry "${registry}" \
      "${export_path}" \
      --out "${root}/${dir}" \
      --write \
      --okf-version 0.2 > /dev/null
  done
}

case "${1:---check}" in
  --regenerate)
    generate_into "${out_root}"
    echo "OK: regenerated ${#profiles[@]} profile documentation bundles in ${out_root}"
    ;;
  --check)
    scratch="$(mktemp -d)"
    trap 'rm -rf "${scratch}"' EXIT
    generate_into "${scratch}"

    if ! diff -r "${out_root}" "${scratch}" > /dev/null 2>&1; then
      echo "profile documentation in ${out_root} is stale; run: just docs" >&2
      diff -r "${out_root}" "${scratch}" >&2 || true
      exit 1
    fi

    for dir in "${out_root}"/*/; do
      "${okf_bin}" validate "${dir}" --strict > /dev/null
    done

    echo "OK: profile documentation is current and validates"
    ;;
  *)
    echo "usage: $0 [--check|--regenerate]" >&2
    exit 2
    ;;
esac
