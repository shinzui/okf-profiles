---
type: Term
title: projection
description: A function that folds events from one or more streams into a queryable read model.
generated:
  by: anthropic-claude-code/claude-opus-5
  at: "2026-09-18T22:30:00Z"
termId: TERM-2
status: current
scope: read side
---

# projection

A projection consumes events and maintains derived state for queries. It never decides
anything; it only reflects what the write side has already recorded in a [stream](stream.md).

More specific kinds of projection include the [inline projection](inline-projection.md).
