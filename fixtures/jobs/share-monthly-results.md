---
type: Job
title: Share monthly results with stakeholders
description: A finance lead wants stakeholders to see trustworthy monthly results soon after the period closes.
generated:
  by: human:fixture-author
  at: "2026-10-16T09:00:00Z"
jobId: JOB-1
actor: finance lead at a mid-sized company
situation: the accounting period has just closed and stakeholders are waiting for the numbers
motivation: get trustworthy results in front of stakeholders without a day of manual assembly
status: active
validationStatus: mixed
functionalContext: Results come from several systems that close on different days.
emotionalContext: Wants to avoid the anxiety of sending numbers that might be wrong.
socialContext: Wants to be seen by leadership as the dependable source of results.
outcomes:
  - name: time-to-share
    description: Stakeholders receive the monthly results shortly after close.
    metric: minutes from period close to results shared
    unit: minutes
    direction: decrease
    method: product analytics event timestamps
    baseline: 95
    target: 30
    population: finance leads at the nine pilot accounts
    period: July 2026 close
  - name: confidence-in-numbers
    description: The finance lead shares results without re-checking every figure by hand.
assessment:
  rationale: >-
    PR-2 supports the claim that time to share is the dominant pain. PR-3
    challenges the narrower claim that stakeholders want a file attachment.
    The job holds, but the expected delivery form is contested.
  assessedAt: "2026-10-16T09:00:00Z"
  findingRefs:
    - mori://example/product/okf/research/concepts/PR-2
    - mori://example/product/okf/research/concepts/PR-3
sources:
  - id: july-baseline
    resource: mori://example/product/okf/research/concepts/PR-2
    title: Median time-to-share measured during the July 2026 close
---

# Share monthly results with stakeholders

The job is stated without naming a report format, a screen, or a channel. The
`time-to-share` baseline is the July measurement recorded in the finding cited
as `july-baseline`[^july-baseline]; the target is an aspiration, not an
observation. `confidence-in-numbers` is deliberately qualitative.

[^july-baseline]: Median time-to-share measured during the July 2026 close.
