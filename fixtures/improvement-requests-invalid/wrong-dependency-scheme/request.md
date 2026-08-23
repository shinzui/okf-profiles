---
type: Improvement Request
title: Wrong dependency scheme
description: This request is otherwise valid but uses an HTTPS dependency reference.
generated:
  by: human:nadeem
  at: "2026-08-23T00:00:00Z"
requestId: IR-1
status: proposed
origin: mori://example/origin
dependencies:
  - ref: https://example.test/improvement-requests/IR-2
    kind: hard
    reason: The target request supplies the required contract.
---

# Wrong dependency scheme

An HTTPS URL is not a canonical cross-repository improvement-request reference.
