---
type: Use Case
title: Provenance actor in the wrong shape
description: This use case is otherwise complete but its generated.by is a bare name.
generated:
  by: nadeem
  at: "2026-07-30T00:00:00Z"
useCaseId: UC-1
status: draft
origin: mori://example/platform
themes:
  - operations
jobs:
  - name: example-job
    actor: service steward
    situation: a production alert fires
    motivation: identify the likely cause
    outcome: a bounded investigation begins
features:
  - name: example
    description: Example feature.
    status: discovered
    owners: [mori://example/platform]
    acceptance: The example is observable.
---

# Provenance actor in the wrong shape

`nadeem` is none of `human:nadeem`, `process:nadeem`, or a
`<producer>/<version>` pair, so the OKF v0.2 §7 actor format rejects it.
