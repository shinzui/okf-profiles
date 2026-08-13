---
type: Review
title: Rejection fixture
description: This record identifies its subject with a web address.
generated:
  by: human:nadeem
  at: "2026-08-13T00:00:00Z"
reviewId: REV-1
subject: https://example.com/orders
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

`subject` must be a `mori://` URI. An `https://` link names a page that can
move; the Mori URI names the project itself, which is what makes the identity
stable across repositories.
