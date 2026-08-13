---
type: Review
title: Rejection fixture
description: This record never says whether a person or a model reviewed it.
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
reviewer: process:example-agent
provider: example-provider
model: example-model-5
effort: high
outcome: approved
dimensions:
  - correctness
---

# Rejection fixture

`reviewerKind` is absent, so nothing gates the model keys and nothing tells a
reader which kind of review this was — the `human:` prefix on `reviewer` is a
convention okf cannot condition on.
