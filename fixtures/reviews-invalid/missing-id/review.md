---
type: Review
title: Rejection fixture
description: This record carries no stable handle.
generated:
  by: human:nadeem
  at: "2026-08-13T00:00:00Z"
subject: mori://example/orders
subjectKind: component
component: orders-core
reviewedSha: 4c1f9b2e7a30d5c8e1b64f0a92d7c3518ae6b0d4
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

`reviewId` is absent, so nothing else can cite this review — including the next
review of the same subject, whose `previousReview` would name it.
