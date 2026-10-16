---
type: Use Case
title: Close the month and share results
description: A finance lead closes the month and gets results to stakeholders the same morning.
generated:
  by: human:fixture-author
  at: "2026-10-16T09:00:00Z"
useCaseId: UC-1
status: in-progress
origin: mori://example/product
themes:
  - month-end
jobs:
  - name: share-after-close
    actor: finance lead at a pilot account
    situation: the July close finished overnight and the CFO asks for numbers at nine
    motivation: send figures the CFO can trust before the morning meeting
    outcome: the CFO opens current results before the meeting starts
    jobRef: mori://example/product/okf/jobs/concepts/JOB-1
    outcomeNames:
      - time-to-share
      - confidence-in-numbers
featureRefs:
  - mori://example/product/okf/features/concepts/FEAT-1
  - mori://example/product/okf/features/concepts/FEAT-2
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

# Close the month and share results

A canonical use case: it links its inline job to JOB-1 and names features only
through `featureRefs`, so their delivery state is read from the features
themselves.
