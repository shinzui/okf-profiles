---
type: Product Research Finding
title: Time to share dominates month-end pain
description: Most interviewed finance leads named the hours between close and sharing as their main pain.
generated:
  by: human:fixture-author
  at: "2026-10-16T09:00:00Z"
productResearchId: PR-2
studyRef: PR-1
observation: Seven of nine leads described assembling a spreadsheet by hand after close; the median time to share in July was 95 minutes.
interpretation: Reducing assembly time is the progress leads most want from month-end tooling.
context: Leads at accounts with at least three source systems.
observedAt: "2026-08-07T18:00:00Z"
limitations: Self-reported pain; the timing comes from product analytics for the same nine accounts only.
status: current
sources:
  - id: notes
    resource: Synthesised interview notes, PR-1 sessions 1 to 9
  - id: analytics
    resource: Product analytics export of share events, July 2026
jobAssessments:
  - jobRef: mori://example/product/okf/jobs/concepts/JOB-1
    claim: Finance leads want monthly results in front of stakeholders sooner.
    stance: supports
    rationale: Seven of nine leads named time to share unprompted.
    outcomeName: time-to-share
  - jobRef: mori://example/product/okf/jobs/concepts/JOB-3
    claim: Leads need to inform leadership between closes.
    stance: supports
    rationale: Four leads already send informal mid-month notes.
measurements:
  - name: median-time-to-share-july
    jobRef: mori://example/product/okf/jobs/concepts/JOB-1
    outcomeName: time-to-share
    value: 95
    unit: minutes
    method: product analytics event timestamps
    population: finance leads at the nine pilot accounts
    periodStart: "2026-07-01T00:00:00Z"
    periodEnd: "2026-07-31T23:59:59Z"
---

# Time to share dominates month-end pain

The `observation` is what was heard and measured; the `interpretation` is the
conclusion drawn from it, which a reader may dispute separately.
