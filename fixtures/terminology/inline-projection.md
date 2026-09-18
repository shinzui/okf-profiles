---
type: Term
title: inline projection
description: A projection that is applied in the same transaction that appends the events it reads.
generated:
  by: anthropic-claude-code/claude-opus-5
  at: "2026-09-18T22:30:00Z"
termId: TERM-3
status: current
scope: read side
broader:
  - TERM-2
---

# inline projection

An inline projection is a [projection](projection.md) whose read model is updated atomically
with the append, so a reader that sees the events also sees their effect.
