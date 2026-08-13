---
type: Review
title: Rejection fixture
description: This record links what it produced by web address.
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
produced:
  - https://example.com/bugs/4
---

# Rejection fixture

`produced` entries are `mori://` URIs. The records a review causes to exist live
in other bundles, and only the canonical URI addresses them from here.
