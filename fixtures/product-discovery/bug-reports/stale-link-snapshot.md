---
type: Bug Report
title: Sharing link shows the previous period after publishing
description: After publishing a new period, the sharing link keeps serving the previous period's snapshot.
generated:
  by: human:fixture-author
  at: "2026-10-16T09:00:00Z"
bugId: BUG-1
status: confirmed
severity: degraded
origin: mori://example/product
affects: mori://example/product/okf/features/concepts/FEAT-1
affectedVersion: unreleased
workaround: Copy the link again after publishing; the copied link shows the new period.
capability: mori://example/export-service/okf/capabilities/concepts/CAP-1
observed: The link shows July figures after August results were published.
expected: The link shows the most recently published period, as FEAT-1 AC-2 states.
reproduction:
  - Publish results for July and open the link.
  - Publish results for August.
  - Reload the link and observe July figures.
reviews:
  - kind: human
    reviewer: human:fixture-author
    reviewed_at: "2026-10-16T09:30:00Z"
    document_timestamp: "2026-10-16T09:00:00Z"
    scope: content
    outcome: approved
    context: Fixture review against the linked feature.
---

# Sharing link shows the previous period after publishing

`affects` names the feature whose behavior is wrong; `capability` names the
provision claim the defect contradicts. Neither profile changed to allow this.
