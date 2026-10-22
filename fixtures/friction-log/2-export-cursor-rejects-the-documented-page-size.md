---
type: Friction Entry
title: Export cursor rejects the documented page size
description: The export cursor refused the maximum page size its reference page documents, stopping the plan's first milestone.
generated:
  by: human:fixture-author
  at: "2026-10-15T08:00:00Z"
frictionId: FRIC-2
status: promoted
promotedTo: mori://example/warehouse/okf/bug-reports/concepts/BUG-4
impact: blocked
kind: interface
origin: mori://example/warehouse
affects: mori://example/platform
affectedVersion: "1.2.0"
plan: docs/plans/5-stream-closed-periods-to-the-lakehouse.md
amended:
  - by: human:fixture-author
    at: "2026-10-16T09:00:00Z"
    change: Promoted to BUG-4 once the reference page's claim and a reproduction were in hand.
reviews:
  - kind: human
    reviewer: human:fixture-author
    reviewed_at: "2026-10-16T09:00:00Z"
    document_timestamp: "2026-10-15T08:00:00Z"
    scope: content-and-metadata
    outcome: approved
    context: Confirmed the page size against the platform reference page before filing the bug report.
verified:
  by: human:fixture-author
  at: "2026-10-16T09:00:00Z"
---

# Export cursor rejects the documented page size

This fixture proves the `promoted` status and the field it demands. The entry
was `blocked`: the milestone needed the documented page size and no smaller
size met its acceptance, so a human had to decide what to do. At triage the
recording repository could name the published claim the behavior contradicts
and reproduce it, which is the line between friction and a bug report, so the
entry was promoted and `promotedTo` names the report that now tracks it. The
promotion is recorded in `amended` so `generated` keeps who felt the friction.

## Attempted

Open an export cursor with `pageSize: 5000`, the maximum the platform's
reference page documents.

## Encountered

The platform rejected the request with `pageSize must be at most 1000`. Every
smaller size succeeded, but the milestone's acceptance needs the documented
maximum.

```text
HTTP 400
{"error":"pageSize must be at most 1000"}
```
