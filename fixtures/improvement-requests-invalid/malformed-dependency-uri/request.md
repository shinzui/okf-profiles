---
type: Improvement Request
title: Malformed dependency URI
description: This request is otherwise valid but pads the target request number.
generated:
  by: human:nadeem
  at: "2026-08-23T00:00:00Z"
requestId: IR-1
status: proposed
origin: mori://example/origin
dependencies:
  - ref: mori://example/target/okf/improvement-requests/concepts/IR-02
    kind: hard
    reason: The target request supplies the required contract.
---

# Malformed dependency URI

`IR-02` is not the canonical unpadded spelling of a request handle.
