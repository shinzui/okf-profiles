---
type: Use Case
title: Brief the board each quarter
description: A finance lead prepares the quarterly board briefing from the monthly results already shared.
generated:
  by: human:fixture-author
  at: "2026-10-16T09:00:00Z"
useCaseId: UC-2
status: planned
origin: mori://example/product
themes:
  - month-end
jobs:
  - name: brief-board
    actor: finance lead preparing a board pack
    situation: the quarter has closed and board members want to review results before the meeting
    motivation: give board members one place to read results ahead of time
    outcome: board members arrive having read the quarter's results
    jobRef: mori://example/product/okf/jobs/concepts/JOB-1
    outcomeNames:
      - confidence-in-numbers
features:
  - name: board-results-link
    description: Share the quarter's results with the board through the results sharing link.
    status: planned
    owners:
      - mori://example/product
    acceptance: A board member opens the link before the meeting and sees the quarter's results.
    jobs:
      - brief-board
    featureRef: mori://example/product/okf/features/concepts/FEAT-1
featureRefs:
  - mori://example/product/okf/features/concepts/FEAT-3
reviews:
  - kind: human
    reviewer: human:fixture-author
    reviewed_at: "2026-10-16T09:30:00Z"
    document_timestamp: "2026-10-16T09:00:00Z"
    scope: content-and-metadata
    outcome: approved
    context: Read against the linked jobs and features.
verified:
  by: human:fixture-author
  at: "2026-10-16T09:30:00Z"
---

# Brief the board each quarter

A use case mid-migration: its retained inline feature record is a snapshot
linked to FEAT-1 through `featureRef`, while FEAT-3 is referenced canonically.
FEAT-1 is the same feature UC-1 relies on, so its current status lives in one
place.
