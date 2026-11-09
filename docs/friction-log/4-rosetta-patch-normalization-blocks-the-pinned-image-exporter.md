---
type: Friction Entry
title: "Rosetta patch normalization blocks the pinned image exporter"
description: "The pinned nix2container exporter fails while normalizing its platform-independent Skopeo patch inside the AMD64 Rosetta builder."
generated:
  by: "codex-cli/gpt-6.1-sol"
  at: "2026-11-09T17:38:42Z"
frictionId: FRIC-4
status: "accepted"
impact: detour
kind: tooling
origin: "mori://shinzui/okf-profiles"
affects: "https://github.com/nlewo/nix2container"
affectedVersion: "e503eb81630a0c5d7ec244e08e0733650235d8f1"
plan: "docs/plans/14-serve-generated-profile-documentation-with-the-seihou-labs-microapp.md"
workaround: "Build the exact pinned fixed-output patch on native Apple Silicon, verify the unchanged expected SHA-256 through Nix, and transfer that artifact through a private local Nix binary cache into the AMD64 builder before resuming export."
resolution: "Build the exact pinned patch natively and transfer its fixed-output artifact through a private local binary cache; retain all dependency pins and hashes."
amended:
  - by: "codex-cli/gpt-6.1-sol"
    at: "2026-11-09T17:49:24Z"
    change: "Keep a tested native patch helper and record the successful image export workaround."
---
# Rosetta patch normalization blocks the pinned image exporter

## Attempted

Build docs-image.copyTo using the recipe-pinned nix2container revision in the AMD64 Apple Container.

## Encountered

fetchpatch2 produced an empty normalized patch on repeated attempts despite fetching the correct raw Git patch.

```text
Normalized patch is empty (while the fetched file was not).
```

## Workaround

Build the exact pinned fixed-output patch on native Apple Silicon, verify the unchanged expected SHA-256 through Nix, and transfer that artifact through a private local Nix binary cache into the AMD64 builder before resuming export.
