#!/usr/bin/env bash
set -euo pipefail

for blueprint in blueprints/*/blueprint.dhall; do
  seihou validate-blueprint "$(dirname "$blueprint")" --lint
done

seihou registry validate

echo "OK: Seihou blueprints are valid"
