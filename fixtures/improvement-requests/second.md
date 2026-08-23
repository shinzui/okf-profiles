---
type: Improvement Request
title: Link requests to implementation plans
description: Record a target plan without deriving lifecycle from it.
generated:
  by: human:nadeem
  at: "2026-07-26T00:01:00Z"
requestId: IR-2
status: completed
origin: mori://example/origin/packages/example-library
completedAt: "2026-07-26T00:03:00Z"
targetPlan: mori://example/target/plans/1-implement-request
dependencies:
  - ref: mori://example/contracts/okf/improvement-requests/concepts/IR-1
    kind: hard
    reason: The target request supplies the contract this request implements.
  - ref: mori://example/research/okf/improvement-requests/concepts/IR-2
    kind: soft
    reason: The target request records research that de-risks this implementation.
  - ref: mori://example/integration/okf/improvement-requests/concepts/IR-3
    kind: integration
    reason: The two implementations require a named joint conformance check before fulfillment.
acceptanceCriteria:
  - id: AC-1
    statement: Strict profile validation accepts all three dependency kinds.
    verification: Run the improvement-request profile fixture script and observe a zero exit status.
  - id: AC-2
    statement: Each acceptance criterion has a unique request-local handle.
    verification: Validate this bundle and the duplicate-criterion rejection fixture.
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
verified:
  by: process:example-agent
  at: "2026-07-26T00:02:00Z"
---

# Link requests to implementation plans

This conforming fixture proves completion metadata, producer-defined plan metadata, all three
source-dependency meanings, and stable request-local acceptance criteria. It carries no
`timestamp` key at all, proving that the demoted v0.1 rule never reports its own absence —
`generated.at` supersedes it. Its approving model `reviews` entry is mirrored into the
bare-mapping spelling of OKF `verified`, so the derived trust tier reflects the machine
confirmation rather than reporting the concept as unverified.
