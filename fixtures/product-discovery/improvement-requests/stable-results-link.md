---
type: Improvement Request
title: Serve published results behind a stable link
description: The export service needs a stable, unauthenticated read endpoint for published result snapshots.
generated:
  by: human:fixture-author
  at: "2026-10-16T09:00:00Z"
requestId: IR-1
status: accepted
origin: mori://example/product/okf/features/concepts/FEAT-1
acceptanceCriteria:
  - id: AC-1
    statement: A GET on the published snapshot endpoint returns the latest snapshot for a period without credentials.
    verification: Integration test against a running export service with authentication disabled for the endpoint only.
reviews:
  - kind: human
    reviewer: human:fixture-author
    reviewed_at: "2026-10-16T09:30:00Z"
    document_timestamp: "2026-10-16T09:00:00Z"
    scope: content
    outcome: approved
    context: Fixture review against the linked feature.
---

# Serve published results behind a stable link

Raised by FEAT-1 through `origin`. Its `AC-1` is a repository-work condition
and is unrelated to FEAT-1's `AC-1`, which is a product acceptance condition.
