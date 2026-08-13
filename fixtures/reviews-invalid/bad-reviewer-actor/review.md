---
type: Review
title: Rejection fixture
description: This record names its reviewer with a bare identifier.
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
reviewer: example-agent
provider: example-provider
model: example-model-5
effort: high
outcome: approved
dimensions:
  - correctness
---

# Rejection fixture

`reviewer` must be a §7 actor. Recording it in the actor form is what makes
mirroring into `verified.by` a copy rather than a translation somebody has to
get right by hand.
