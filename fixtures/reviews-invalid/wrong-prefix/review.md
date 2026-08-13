---
type: Review
title: Rejection fixture
description: This record's handle uses a prefix the profile does not declare.
generated:
  by: human:nadeem
  at: "2026-08-13T00:00:00Z"
reviewId: RVW-1
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

`RVW-1` is not a `REV-N` handle. The prefix is what ties a handle to the type
that declares it, so a near-miss resolves to nothing at all.
