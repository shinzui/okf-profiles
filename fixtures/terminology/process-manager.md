---
type: Term
title: process manager
description: A long-running coordinator that reacts to events by issuing commands, possibly to several streams.
generated:
  by: anthropic-claude-code/claude-opus-5
  at: "2026-09-18T22:30:00Z"
termId: TERM-7
status: current
abbreviation: PM
sameAs:
  - mori://example/other-lib/okf/terminology/concepts/TERM-1
anchors:
  - kind: uri
    resource: https://example.org/patterns/process-manager
    note: External description of the pattern.
---

# process manager

A process manager listens to events, keeps its own state, and sends commands so that a
multi-step business process completes. It is usually abbreviated "PM".

Another project publishes the same concept; the `sameAs` link records that equivalence.
