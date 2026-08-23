---
type: Improvement Request
title: Unknown dependency kind
description: This request is otherwise valid but invents a dependency kind.
generated:
  by: human:nadeem
  at: "2026-08-23T00:00:00Z"
requestId: IR-1
status: proposed
origin: mori://example/origin
dependencies:
  - ref: mori://example/target/okf/improvement-requests/concepts/IR-2
    kind: blocking
    reason: The target request supplies the required contract.
---

# Unknown dependency kind

`blocking` is not one of `hard`, `soft`, or `integration`.
