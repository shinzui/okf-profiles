#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
export DOCS_CONTENT_ROOT="$PWD"
export DOCS_CONTENT_CONFIG=publication.json
python3 scripts/profile-docs-publication.py --check
cd web
case "${1:?Expected dev, build, check or e2e}" in
  dev) exec nix develop -c bun run dev ;;
  build) exec nix develop -c bun run build ;;
  check) exec nix develop -c bash -c 'bun run build && bun run check && bun run test' ;;
  e2e) exec nix develop -c bun run test:e2e ;;
  *) exit 2 ;;
esac
