---
type: Feature
title: Export audit trail
description: Record who exported which results and when, so later questions about a figure can be traced.
generated:
  by: human:fixture-author
  at: "2026-10-16T09:00:00Z"
featureId: FEAT-2
status: delivered
behavior: Every export records the actor, the period, and the snapshot it was taken from, and the record can be listed per period.
priority: medium
owners:
  - mori://example/export-service
acceptanceCriteria:
  - id: AC-1
    statement: Each export of a closed period appears once in that period's audit listing with its actor and snapshot.
    verification: Run three exports for one period as two actors and list the period's audit entries.
deliveredAt: "2026-09-30T12:00:00Z"
deliveryEvidence:
  - id: audit-test
    resource: mori://example/export-service
    title: Export audit integration test suite in the export service
reviews:
  - kind: human
    reviewer: human:fixture-author
    reviewed_at: "2026-10-16T09:30:00Z"
    document_timestamp: "2026-10-16T09:00:00Z"
    scope: content-and-metadata
    outcome: approved
    context: Checked the delivery evidence against the export service's test suite.
verified:
  by: human:fixture-author
  at: "2026-10-16T09:30:00Z"
---

# Export audit trail

A technical enabling feature: it names no customer job because none was
invented to fill `jobRefs`. Its delivery evidence shows the behavior was
implemented and accepted, not that any customer outcome improved.
