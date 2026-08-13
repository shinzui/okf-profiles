---
type: Review
title: Rejection fixture
description: This record's provenance actor is a bare name.
generated:
  by: nadeem
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
---

# Rejection fixture

`generated.by` is `nadeem`, which is none of the three §7 actor forms. The
`human:` prefix is what §5.3 reads to separate the trust tiers, so a bare name
is not a weaker spelling of it — it is unreadable.
