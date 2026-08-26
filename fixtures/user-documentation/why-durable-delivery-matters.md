---
type: Explanation
title: Why durable delivery matters
description: Explain the failure model that makes durable delivery necessary.
docId: DOC-4
tags: [explanation, delivery, failures]
generated:
  by: human:nadeem
  at: 2026-08-26T00:00:00Z
sources:
  - id: delivery-contract
    resource: mori://example/delivery/docs/contract
    title: Delivery contract
usage_window:
  from: 2026-01-01
  to: 2026-08-26
verified:
  by: process:delivery-contract-check
  at: 2026-08-26T00:00:00Z
---

# Why durable delivery matters

A durable handoff keeps accepted work recoverable when the worker or its dependency fails[^delivery-contract].

[^delivery-contract]: The example delivery contract defines accepted work as durable before acknowledgement.
