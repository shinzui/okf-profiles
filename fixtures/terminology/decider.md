---
type: Term
title: decider
description: A pure pair of functions that decides which events a command produces and evolves state from events.
generated:
  by: anthropic-claude-code/claude-opus-5
  at: "2026-09-18T22:30:00Z"
termId: TERM-4
status: current
aliases:
  - decision function
discouraged:
  - handler
  - command handler
---

# decider

A decider takes the current state and a command and returns the events to append, and folds
events back into state. It performs no input or output.

Do not call it a "handler" or a "command handler": those words suggest effectful code that
writes to storage, which is exactly what a decider is not.
