---
type: Feature
title: Results sharing link
description: Publish closed monthly results behind one stable link stakeholders can open.
generated:
  by: human:fixture-author
  at: "2026-10-16T09:00:00Z"
featureId: FEAT-1
status: in-progress
behavior: >-
  After the period closes, the finance lead publishes results once and
  stakeholders open a single stable link that always shows the latest
  published figures, streamed from the export service.
priority: high
owners:
  - mori://example/product
  - mori://example/export-service
jobRefs:
  - mori://example/product/okf/jobs/concepts/JOB-1
outcomeRefs:
  - jobRef: mori://example/product/okf/jobs/concepts/JOB-1
    outcomeName: time-to-share
capabilityRefs:
  - mori://example/export-service/okf/capabilities/concepts/CAP-1
specificationRefs:
  - mori://example/product/okf/specifications/concepts/SPEC-1
  - mori://example/product/okf/specifications/concepts/SPEC-2
improvementRequests:
  - mori://example/export-service/okf/improvement-requests/concepts/IR-1
acceptanceCriteria:
  - id: AC-1
    statement: A stakeholder opening the link sees the most recently published results without signing in to the finance tool.
    verification: Publish results for a test period, open the link in a fresh browser profile, and compare the figures with the published snapshot.
  - id: AC-2
    statement: Publishing results for a new period does not change the link.
    verification: Publish two consecutive periods and confirm the link text is identical and shows the second period.
---

# Results sharing link

`capabilityRefs` names the streaming export the link is built on; it does not
claim that capability delivers the whole feature, and the missing producer
behavior is tracked by IR-1. SPEC-1 is a proposed contract and SPEC-2 points at
the storage project's authoritative specification. Neither link promotes the
feature's status, and delivering the feature would not prove conformance.

This feature's `AC-1` is unrelated to IR-1's `AC-1`.
