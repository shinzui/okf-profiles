---
type: Term
title: stream
description: An ordered, append-only sequence of events that records the history of one entity.
generated:
  by: anthropic-claude-code/claude-opus-5
  at: "2026-09-18T22:30:00Z"
termId: TERM-1
status: current
aliases:
  - event stream
tags:
  - storage
anchors:
  - kind: module
    resource: Fixture.Stream
    note: Defines the stream name and append operations.
  - kind: file
    resource: valid-src/Fixture/Stream.hs
---

# stream

A stream is the unit of consistency in the fictional event-sourcing library these fixtures
describe. Every event belongs to exactly one stream, and events in a stream are totally ordered
by their position.

Readers and writers address a stream by name. An "event stream" means the same thing.
