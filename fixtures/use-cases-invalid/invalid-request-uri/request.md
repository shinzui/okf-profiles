---
type: Use Case
title: Invalid request URI
description: This fixture uses a non-Mori improvement-request reference.
generated:
  by: human:nadeem
  at: "2026-07-30T00:00:00Z"
useCaseId: UC-1
status: draft
origin: mori://example/platform
jobs:
  - name: example
    actor: operator
    situation: a feature is needed
    motivation: make progress
    outcome: the feature works
features:
  - name: example
    description: Example feature.
    status: planned
    owners: [mori://example/platform]
    acceptance: The example is observable.
improvementRequests:
  - https://example.com/requests/1
---

# Invalid request URI
