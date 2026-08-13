---
type: Review
title: Rejection fixture
description: This record says when the review happened but not against what.
generated:
  by: human:nadeem
  at: "2026-08-13T00:00:00Z"
reviewId: REV-1
subject: mori://example/orders
subjectKind: component
component: orders-core
coverage: full
reviewedAt: "2026-08-13T00:00:00Z"
reviewerKind: model
reviewer: process:example-agent
provider: example-provider
model: example-model-5
effort: high
outcome: approved
dimensions:
  - correctness
---

# Rejection fixture

`reviewedSha` is absent. The date says someone looked; only the commit says what
they looked at, and only the commit lets the next review start from here instead
of from nothing.
