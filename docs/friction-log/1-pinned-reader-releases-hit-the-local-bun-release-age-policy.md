---
type: Friction Entry
title: "Pinned reader releases hit the local Bun release-age policy"
description: "The recipe dependency installation rejects qualified releases younger than the local seven-day minimum and requires an explicit install override."
generated:
  by: "codex-cli/gpt-6.1-sol"
  at: "2026-11-09T15:57:20Z"
frictionId: FRIC-1
status: logged
impact: detour
kind: environment
origin: "mori://shinzui/okf-profiles"
affects: "mori://shinzui/seihou-modules/templates/docs-microapp"
plan: "docs/plans/14-serve-generated-profile-documentation-with-the-seihou-labs-microapp.md"
workaround: "Verify exact releases in npm and upstream tags, retain recipe versions, then install with --minimum-release-age 0."
---
# Pinned reader releases hit the local Bun release-age policy

## Attempted

nix develop -c bun install in web/

## Encountered

Nine recipe-pinned packages were rejected by minimum release age 604800 seconds.

```text
Version @playwright/test@1.65.0 was published within minimum release age of 604800 seconds
```

## Workaround

Verify exact releases in npm and upstream tags, retain recipe versions, then install with --minimum-release-age 0.
