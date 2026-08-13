---
type: Review
title: Rejection fixture
description: This record continues from a review that does not exist.
generated:
  by: human:nadeem
  at: "2026-08-13T00:00:00Z"
reviewId: REV-1
subject: mori://example/orders
subjectKind: component
component: orders-core
reviewedSha: 4c1f9b2e7a30d5c8e1b64f0a92d7c3518ae6b0d4
coverage: incremental
baseSha: e93b7c0142fd8a65be3097c4d15a8f2b6047ce39
previousReview: REV-9
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

`REV-9` resolves to nothing in this bundle. A broken predecessor link is worse
than none: it claims the range before `baseSha` was covered by a review a reader
cannot open.
