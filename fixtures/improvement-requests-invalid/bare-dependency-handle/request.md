---
type: Improvement Request
title: Bare dependency handle
description: This request is otherwise valid but uses an ambiguous local dependency handle.
generated:
  by: human:nadeem
  at: "2026-08-23T00:00:00Z"
requestId: IR-1
status: proposed
origin: mori://example/origin
dependencies:
  - ref: IR-2
    kind: hard
    reason: The target request supplies the required contract.
---

# Bare dependency handle

`IR-2` is ambiguous outside its own bundle and must be written as a canonical Mori URI.
