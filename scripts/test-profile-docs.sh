#!/usr/bin/env bash
# The shared inventory drives staged generation, drift checks and publication.
set -euo pipefail
cd "$(dirname "$0")/.."
case "${1:---check}" in
  --check) mode=check ;;
  --regenerate) mode=regenerate ;;
  *) echo "usage: $0 [--check|--regenerate]" >&2; exit 2 ;;
esac
exec python3 scripts/profile-docs-generate.py "$mode"
