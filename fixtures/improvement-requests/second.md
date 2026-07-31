---
type: Improvement Request
title: Link requests to implementation plans
description: Record a target plan without deriving lifecycle from it.
timestamp: "2026-07-26T00:01:00Z"
requestId: IR-2
status: completed
origin: mori://example/origin/packages/example-library
completedAt: "2026-07-26T00:03:00Z"
targetPlan: mori://example/target/plans/1-implement-request
resolution: The target plan's acceptance checks passed.
reviews:
  - kind: model
    reviewer: example-agent
    reviewed_at: "2026-07-26T00:02:00Z"
    document_timestamp: "2026-07-26T00:01:00Z"
    scope: technical-accuracy
    outcome: approved
    provider: example-provider
    model: example-model
    effort: high
    context: >-
      In-repository review against the target project's source and architecture guidance.
---

# Link requests to implementation plans

This conforming fixture proves completion metadata and producer-defined plan metadata.
