---
type: Job
title: Share monthly results with stakeholders
description: A finance lead wants stakeholders to see trustworthy monthly results soon after the period closes.
generated:
  by: human:fixture-author
  at: "2026-10-16T09:00:00Z"
jobId: JOB-1
actor: finance lead
situation: the accounting period has just closed
motivation: get trustworthy results to stakeholders quickly
status: active
validationStatus: supported
outcomes: []
assessment:
  rationale: The cited finding supports the claim.
  assessedAt: "2026-10-16T09:00:00Z"
  findingRefs:
    - mori://example/product/okf/research/concepts/PR-2
relatedJobs:
  - mori://example/product/okf/jobs/concepts/JOB-2
sources:
  - id: july-baseline
    resource: mori://example/product/okf/research/concepts/PR-2
reviews:
  - kind: human
    reviewer: human:fixture-author
    reviewed_at: "2026-10-16T09:30:00Z"
    document_timestamp: "2026-10-16T09:00:00Z"
    scope: content
    outcome: approved
    context: Fixture review.
verified:
  by: human:fixture-author
  at: "2026-10-16T09:30:00Z"
---

# Share monthly results with stakeholders

Violates exactly one rule: `outcomes` is an empty list, which counts as absent.
