---
type: Review
title: Rejection fixture
description: This record's human sign-off drops the human prefix.
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
dimensions:
  - correctness
verified:
  - by: nadeem
    at: "2026-08-13T01:00:00Z"
---

# Rejection fixture

`verified.by` is `nadeem` rather than `human:nadeem`. §5.3 makes the prefix the
sole discriminator of the human-reviewed tier, so dropping it does not merely
abbreviate the actor — it loses the claim.
