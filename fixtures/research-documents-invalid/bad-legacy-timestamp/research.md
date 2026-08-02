---
type: Research Document
title: A malformed legacy timestamp
description: This record carries v0.2 provenance and a legacy timestamp that is not RFC3339 UTC.
researchId: RES-1
status: active
scope: One bounded question and the evidence relevant to it.
reviews:
  - kind: human
    reviewer: human:nadeem
    reviewed_at: "2026-07-28T17:15:00Z"
    document_timestamp: "2026-07-28T17:10:00Z"
    scope: content
    outcome: approved
    context: Read in repository.
generated:
  by: human:nadeem
  at: "2026-07-28T17:10:00Z"
timestamp: 2026-07-28
---

# A malformed legacy timestamp

Demoting `timestamp` stops its absence being reported, not its format being checked.
