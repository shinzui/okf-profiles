---
type: Use Case
title: Explore mid-period digests for leadership
description: Leadership hears about material changes from finance between closes.
generated:
  by: human:fixture-author
  at: "2026-10-16T09:00:00Z"
useCaseId: UC-3
status: draft
origin: mori://example/product
themes:
  - month-end
jobs:
  - name: inform-leadership
    actor: finance lead
    situation: revenue drops sharply in the second week of a month
    motivation: tell leadership before they hear it elsewhere
    outcome: leadership hears of the change from finance first
    jobRef: mori://example/product/okf/jobs/concepts/JOB-3
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

# Explore mid-period digests for leadership

An early scenario with no selected solution: it has neither inline
`features` nor `featureRefs`, which a `draft` use case may omit.
