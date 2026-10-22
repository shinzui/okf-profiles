---
type: Friction Entry
title: Release checklist asks for the changelog entry twice
description: The release skill prompts for a changelog entry and the release gate then asks for the same entry again.
generated:
  by: process:example-agent
  at: "2026-10-13T11:00:00Z"
frictionId: FRIC-4
status: accepted
resolution: The second prompt is the CI gate restating the first on purpose, so a skipped prompt is still caught; the house keeps both.
impact: nuisance
kind: process
origin: mori://example/warehouse
affects: mori://example/warehouse
plan: docs/plans/6-release-the-lakehouse-exporter.md
amended:
  - by: human:fixture-triager
    at: "2026-10-20T09:10:00Z"
    change: Accepted at triage with the gate's reason recorded.
---

# Release checklist asks for the changelog entry twice

This fixture proves the `accepted` status, the `process` kind, and an entry
whose `affects` is its own `origin`: the surface that cost the effort is the
recording repository's own release process. The friction is a `nuisance`
because nothing was delayed; it is recorded because it will recur on every
release.

## Attempted

Run the release skill end to end.

## Encountered

The skill asked for a changelog entry, wrote it, and the release gate then
asked for a changelog entry again before accepting the one already written.
