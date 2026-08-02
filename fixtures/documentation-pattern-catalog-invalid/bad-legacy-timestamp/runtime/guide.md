---
type: Guide
title: A malformed legacy timestamp
description: This document carries v0.2 provenance and a legacy timestamp that is not RFC3339 UTC.
generated:
  by: human:nadeem
  at: 2026-07-22T00:00:00Z
timestamp: sometime-soon
resource: mori://example/patterns/docs/bad-legacy-timestamp
tags: [runtime]
status: current
---

# A malformed legacy timestamp

Demoting `timestamp` to the `optional` list stops its absence being reported but
does not stop its format being checked whenever it is present.
