---
type: Review
title: Rejection fixture
description: This record writes its dimensions as a single value.
generated:
  by: human:nadeem
  at: "2026-08-13T00:00:00Z"
reviewId: REV-1
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
dimensions: correctness
---

# Rejection fixture

`dimensions` is a list even when a review examined one concern. A scalar here
reads as one dimension to a human and as a different shape to every consumer
that iterates the key.
