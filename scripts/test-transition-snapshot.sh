#!/usr/bin/env bash
set -euo pipefail
source_hash="$(dhall hash --file profiles/coordination/transitions.dhall)"
snapshot_hash="$(dhall hash --file blueprints/adopt-transitions/files/transitions-profile.dhall)"
test "$source_hash" = "$snapshot_hash"
dhall type --file blueprints/adopt-transitions/blueprint.dhall >/dev/null
echo 'OK: transition blueprint and standalone profile snapshot'
