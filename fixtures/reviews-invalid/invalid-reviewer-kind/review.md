---
type: Review
title: Rejection fixture
description: This record invents a third kind of reviewer.
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
reviewerKind: agent
reviewer: process:example-agent
provider: example-provider
model: example-model-5
effort: high
outcome: approved
dimensions:
  - correctness
---

# Rejection fixture

`agent` is neither `human` nor `model`. An agent is a harness running a model,
which `reviewer` already records; a third value would leave `provider`, `model`,
and `effort` demanded by nothing.
