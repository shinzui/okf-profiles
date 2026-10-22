---
type: Friction Entry
title: Descriptor freeze needs a published tag
description: Freezing the catalog descriptor failed because the profile it imports was merged but not yet tagged.
generated:
  by: human:fixture-author
  at: "2026-10-14T10:20:00Z"
frictionId: FRIC-1
status: logged
impact: slowdown
kind: tooling
origin: mori://example/warehouse
affects: mori://example/catalog
plan: docs/plans/4-adopt-the-catalog-profile.md
---

# Descriptor freeze needs a published tag

Violates exactly one rule: the entry lives in a subdirectory, which `pathPattern = "*"` forbids.
