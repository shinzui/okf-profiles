---
type: Friction Entry
title: Descriptor freeze needs a published tag
description: Freezing the catalog descriptor failed for a day because the profile it imports was merged but not yet tagged.
generated:
  by: claude-code/example-model
  at: "2026-10-14T10:20:00Z"
frictionId: FRIC-1
status: logged
impact: detour
kind: tooling
origin: mori://example/warehouse
affects: mori://example/catalog
affectedVersion: "0.22.0"
plan: docs/plans/4-adopt-the-catalog-profile.md
workaround: Imported the catalog checkout by relative path and replaced it with the pinned remote import once the tag existed.
tags:
  - catalog
  - dhall
---

# Descriptor freeze needs a published tag

This conforming fixture proves the first stable friction handle and the shape of
an entry as it is written: first-person, graded by what happened to the work,
and pointed at the surface that cost the effort rather than at a cause. It is a
`detour` because the work proceeded only through the workaround it names, and
`logged` because nobody has yet decided whether the catalog should publish a
pre-release import path, document the wait, or do nothing.

## Attempted

Run `dhall freeze` on the warehouse's `docs/adr/profile.dhall` after switching
its import to the catalog release that exports the profile the plan adopts.

## Encountered

The import resolved to a 404 because the catalog commit was merged but the tag
named in the import did not exist yet.

```text
Error: Remote file not found
URL: https://example.invalid/catalog/v0.22.0/package.dhall
```

## Workaround

A relative import of the local catalog checkout validated the bundle for the
rest of the day. The pinned remote import replaced it the next morning.
