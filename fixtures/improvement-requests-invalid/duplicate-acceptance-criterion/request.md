---
type: Improvement Request
title: Duplicate acceptance criterion
description: This request is otherwise valid but reuses a criterion handle.
generated:
  by: human:nadeem
  at: "2026-08-23T00:00:00Z"
requestId: IR-1
status: proposed
origin: mori://example/origin
acceptanceCriteria:
  - id: AC-1
    statement: The profile loads successfully.
    verification: Type-check the profile descriptor.
  - id: AC-1
    statement: The valid fixture passes validation.
    verification: Run the focused fixture script.
---

# Duplicate acceptance criterion

Both conditions use `AC-1`, so later evidence could not name one unambiguously.
