---
type: Friction Entry
title: Resume guide omits the acknowledgement step
description: The resume guide never says that a page must be acknowledged before the cursor advances, which cost an afternoon of re-reading.
generated:
  by: process:example-agent
  at: "2026-10-12T15:30:00Z"
frictionId: FRIC-3
status: resolved
resolution: Platform 1.3.0 added the acknowledgement step to the resume guide, and the plan's second milestone followed it without re-reading.
impact: slowdown
kind: documentation
origin: mori://example/warehouse
affects: mori://example/platform
affectedVersion: "1.2.0"
plan: docs/plans/5-stream-closed-periods-to-the-lakehouse.md
amended:
  - by: human:fixture-triager
    at: "2026-10-20T09:00:00Z"
    change: Marked resolved after platform 1.3.0 shipped the corrected guide.
verified:
  - by: human:fixture-triager
    at: "2026-10-20T09:00:00Z"
---

# Resume guide omits the acknowledgement step

This fixture proves the `resolved` status and its demanded `resolution`, and
the list spelling of `verified`. The friction was a `slowdown`: the intended
path worked once the implementer found the acknowledgement call in the
platform's source, but the guide that should have said so did not. Nothing was
promoted because the owning repository fixed the guide before triage.

## Attempted

Follow the platform's resume guide to continue an interrupted export from its
last page.

## Encountered

The cursor returned the same page on every resume until the implementer read
the platform source and found that a page has to be acknowledged before the
cursor advances. The guide does not mention acknowledgement.
