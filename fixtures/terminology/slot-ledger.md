---
type: Term
title: slot ledger
description: A generated file that records which slots of a source file a code generator owns and at which version.
generated:
  by: anthropic-claude-code/claude-opus-5
  at: "2026-09-18T22:30:00Z"
termId: TERM-6
status: current
replaces:
  - TERM-5
related:
  - TERM-1
---

# slot ledger

A slot ledger lets the generator regenerate its own slots without touching code a person wrote.
It replaces the term [sidecar](sidecar.md). Its version history is kept per
[stream](stream.md) of generator runs.
