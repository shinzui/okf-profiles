---
type: Improvement Request
title: Provenance actor in the wrong shape
description: This request is otherwise complete but its generated.by is a bare name.
generated:
  by: nadeem
  at: "2026-07-26T00:00:00Z"
requestId: IR-1
status: proposed
origin: mori://example/origin
---

# Provenance actor in the wrong shape

`nadeem` is none of `human:nadeem`, `process:nadeem`, or a
`<producer>/<version>` pair, so the OKF v0.2 §7 actor format rejects it.
