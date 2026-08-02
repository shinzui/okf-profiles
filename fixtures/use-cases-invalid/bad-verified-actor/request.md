---
type: Use Case
title: A confirmation from an unnamed actor
description: This use case carries valid provenance and a malformed verified entry.
generated:
  by: human:nadeem
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
verified:
  - by: example-agent
    at: "2026-07-30T00:01:00Z"
---

# A confirmation from an unnamed actor

`verified` is optional, but whenever it is present each entry's `by` member is
checked against the same OKF v0.2 §7 actor format as `generated.by`. A bare
`example-agent` is neither `process:example-agent` nor a
`<producer>/<version>` pair.
