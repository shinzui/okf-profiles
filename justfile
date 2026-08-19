# Development tasks for okf-profiles.
#
# Everything here is a thin front door onto the checks documented in README.md;
# nothing is only runnable through `just`. `just check` is what a release needs
# to be green.

# List available recipes
default:
    @just --list

# Regenerate the profile documentation bundles under docs/profiles/
docs:
    @bash scripts/test-profile-docs.sh --regenerate

# Type-check every Dhall file
types:
    #!/usr/bin/env bash
    # Not sufficient on its own: the okfVersion consistency check runs when okf
    # loads a profile, not when Dhall type-checks it. `just test` is the gate.
    set -euo pipefail
    status=0
    for f in package.dhall mori.dhall seihou-registry.dhall docs/adr/profile.dhall \
             Profile/*.dhall profiles/*.dhall profiles/*/*.dhall \
             blueprints/*/blueprint.dhall; do
      dhall type --file "$f" > /dev/null || { echo "FAILED: $f" >&2; status=1; }
    done
    exit "$status"

# Run every check under scripts/, including the documentation staleness gate
test:
    #!/usr/bin/env bash
    set -euo pipefail
    for s in scripts/*.sh; do bash "$s"; done

# Everything a release has to pass
check: types test
