---
type: Product Research Finding
title: Time to share dominates month-end pain
description: Most interviewed finance leads named the hours between close and sharing as their main pain.
generated:
  by: human:fixture-author
  at: "2026-10-16T09:00:00Z"
productResearchId: PR-2
studyRef: mori://example/product/okf/research/concepts/PR-1
observation: Seven of nine leads assembled a spreadsheet by hand after close.
interpretation: Reducing assembly time is the progress leads most want.
context: Leads at accounts with at least three source systems.
observedAt: "2026-08-07T18:00:00Z"
limitations: Self-reported pain.
status: current
sources:
  - id: notes
    resource: Synthesised interview notes
jobAssessments:
  - jobRef: mori://example/product/okf/jobs/concepts/JOB-1
    claim: Finance leads want results in front of stakeholders sooner.
    stance: supports
    rationale: Seven of nine leads named time to share unprompted.
    outcomeName: time-to-share
measurements:
  - name: median-time-to-share-july
    jobRef: mori://example/product/okf/jobs/concepts/JOB-1
    outcomeName: time-to-share
    value: 95
    unit: minutes
    method: product analytics event timestamps
    population: finance leads at the pilot accounts
    periodStart: "2026-07-01T00:00:00Z"
    periodEnd: "2026-07-31"
  - name: median-time-to-share-august
    jobRef: mori://example/product/okf/jobs/concepts/JOB-1
    outcomeName: time-to-share
    value: 90
    unit: minutes
    method: product analytics event timestamps
    population: finance leads at the pilot accounts
    periodStart: "2026-08-01T00:00:00Z"
    periodEnd: "2026-08-31T23:59:59Z"
---

# Time to share dominates month-end pain

Violates exactly one rule: a measurement's `periodEnd` is not RFC3339 UTC.
