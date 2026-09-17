---
type: Specification
title: Example runtime execution contract
description: What the example runtime must guarantee to a program it accepts for execution.
specId: SPEC-1
status: ratified
specVersion: "1.0"
normativeScope:
  - Program admission and rejection codes
  - Idempotent retry semantics under an operation key
  - The observable ordering guarantee between accepted and completed events
owner:
  - mori://example/runtime
conformance:
  - https://example.invalid/conformance/runtime-contract/v1
generated:
  by: human:nadeem
  at: "2026-09-16T10:00:00Z"
verified:
  - by: process:example-agent
    at: "2026-09-16T10:30:00Z"
supersedes:
  - SPEC-3
sources:
  - id: example-runtime
    resource: mori://example/runtime
    title: The example runtime project
    author: human:nadeem
    usage_count: 9
    last_modified: 2026-09-10
reviews:
  - kind: model
    reviewer: example-agent
    reviewed_at: "2026-09-16T10:30:00Z"
    document_timestamp: "2026-09-16T10:00:00Z"
    scope: technical-accuracy
    outcome: approved
    provider: example-provider
    model: example-model
    effort: high
    context: >-
      Reviewed against the runtime source and the published conformance package.
---

# Example runtime execution contract

The runtime MUST reject a program whose declared interface it cannot satisfy, and
MUST report the rejection with a stable code[^example-runtime]. Sections not named
in `normativeScope` describe intent and are informative.

[^example-runtime]: The example runtime project, read for this contract.
