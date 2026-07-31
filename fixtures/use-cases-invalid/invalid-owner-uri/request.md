---
type: Use Case
title: Invalid owner URI
description: This fixture uses a non-Mori owner.
timestamp: "2026-07-30T00:00:00Z"
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
    status: discovered
    owners: [https://example.com/platform]
    acceptance: The example is observable.
---

# Invalid owner URI
