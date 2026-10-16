---
type: Feature
title: Results sharing link
description: Publish closed monthly results behind one stable link stakeholders can open.
generated:
  by: human:fixture-author
  at: "2026-10-16T09:00:00Z"
featureId: FEAT-1
status: delivered
behavior: Stakeholders open a single stable link showing the latest published results.
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
improvementRequests:
  - mori://example/export-service/okf/improvement-requests/concepts/IR-1
acceptanceCriteria:
  - id: AC-1
    statement: A stakeholder opening the link sees the latest published results.
    verification: Open the link in a fresh browser profile and compare with the snapshot.
  - id: AC-2
    statement: Publishing a new period does not change the link.
    verification: Publish two periods and compare the link text.
deliveredAt: "2026-10-01T12:00:00Z"
---

# Results sharing link

Violates exactly one rule: a delivered feature has no `deliveryEvidence`.
