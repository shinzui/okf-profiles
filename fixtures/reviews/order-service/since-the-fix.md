---
type: Review
title: Order aggregate since the concurrency fix
description: Only the range since REV-1 was read, and the concurrency finding it raised is now covered by a test.
generated:
  by: process:example-agent
  at: "2026-08-13T08:15:00Z"
reviewId: REV-2
subject: mori://example/orders
subjectKind: aggregate
component: Orders.Domain.Order
repository: mori://example/orders/repos/orders
reviewedSha: b7d0a54c93e21f6480ac7d3e5b91f28c0e4a6d17
coverage: incremental
baseSha: 4c1f9b2e7a30d5c8e1b64f0a92d7c3518ae6b0d4
previousReview: REV-1
reviewedAt: "2026-08-13T08:12:00Z"
reviewerKind: model
reviewer: process:example-agent
provider: example-provider
model: example-model-5
effort: high
outcome: approved
dimensions:
  - correctness
  - test-coverage
context: >-
  Read only the commits between the two recorded shas, plus the tests they touch.
---

# Order aggregate since the concurrency fix

This conforming fixture proves the chain REV-1 exists to start. `coverage:
incremental` demands `baseSha`, and `baseSha` is REV-1's `reviewedSha` exactly —
which is what `previousReview` records, so a reader following the corpus backwards
never has to guess whether an arbitrary commit was somebody's stopping point.

The pair `subject` + `component` is byte-identical to REV-1's. That is the whole
mechanism: identity is matched, not inferred, and a second spelling of the
component would silently start a second history.

Everything before `baseSha` rests on REV-1 rather than on this record, and the
narrower `dimensions` list says so from the other direction: nobody re-examined
security here, so an approving outcome makes no claim about it.
