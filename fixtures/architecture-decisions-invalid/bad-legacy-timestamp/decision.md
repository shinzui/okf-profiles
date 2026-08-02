---
type: Architecture Decision Record
title: A malformed legacy timestamp
description: This record carries v0.2 provenance and a legacy timestamp that is not RFC3339 UTC.
generated:
  by: human:nadeem
  at: 2026-07-26T00:00:00Z
timestamp: 2026-07-26
docId: ADR-1
status: Accepted
date: 2026-07-26
---

# A malformed legacy timestamp

Demoting `timestamp` to the `optional` list stops its *absence* being reported
but does not stop its *format* being checked. A date alone is not an RFC3339 UTC
instant, so this record is rejected even though the key is optional.
