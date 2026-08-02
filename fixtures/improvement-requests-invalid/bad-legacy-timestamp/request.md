---
type: Improvement Request
title: A malformed legacy timestamp
description: This request carries v0.2 provenance and a legacy timestamp that is not RFC3339 UTC.
generated:
  by: human:nadeem
  at: "2026-07-26T00:00:00Z"
timestamp: "2026-07-26"
requestId: IR-1
status: proposed
origin: mori://example/origin
---

# A malformed legacy timestamp

Demoting `timestamp` to the `optional` list stops its *absence* being reported
but does not stop its *format* being checked. A date alone is not an RFC3339 UTC
instant, so this request is rejected even though the key is optional.
