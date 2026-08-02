---
type: Use Case
title: A use case with no provenance
description: This use case records everything except who produced it.
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

# A use case with no provenance

OKF v0.2 makes `generated` a required family on this profile, at profile scope
rather than inside the `Use Case` type rule, so it applies to themes too. A use
case that records no producer is rejected.
