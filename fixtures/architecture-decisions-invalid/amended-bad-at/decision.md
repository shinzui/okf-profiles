---
type: Architecture Decision Record
title: Amendment time without a zone
description: This record is otherwise complete but its amended.at has no UTC designator.
generated:
  by: human:nadeem
  at: 2026-07-26T00:00:00Z
amended:
  - by: human:nadeem
    at: 2026-07-27T00:00:00
    change: Corrected a broken link.
docId: ADR-1
status: Accepted
date: 2026-07-26
---

# Amendment time without a zone

`amended.at` must be a UTC RFC3339 timestamp ending in `Z`.
