---
type: Architecture Decision Record
title: Provenance actor in the wrong shape
description: This record is otherwise complete but its generated.by is a bare name.
generated:
  by: nadeem
  at: 2026-07-26T00:00:00Z
docId: ADR-1
status: Accepted
date: 2026-07-26
---

# Provenance actor in the wrong shape

`nadeem` is none of `human:nadeem`, `process:nadeem`, or a
`<producer>/<version>` pair, so the OKF v0.2 §7 actor format rejects it.
