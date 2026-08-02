---
type: Use Case
title: A malformed legacy timestamp
description: This use case carries v0.2 provenance and a legacy timestamp that is not RFC3339 UTC.
generated:
  by: human:nadeem
  at: "2026-07-30T00:00:00Z"
timestamp: "2026-07-30"
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

# A malformed legacy timestamp

Demoting `timestamp` to the `optional` list stops its *absence* being reported
but does not stop its *format* being checked. A date alone is not an RFC3339 UTC
instant, so this use case is rejected even though the key is optional.
