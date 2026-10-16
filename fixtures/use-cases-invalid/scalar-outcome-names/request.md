---
type: Use Case
title: Linked use case
description: This fixture links inline records to canonical jobs and features.
generated:
  by: human:nadeem
  at: "2026-10-16T00:00:00Z"
useCaseId: UC-1
status: planned
origin: mori://example/platform
jobs:
  - name: example
    actor: operator
    situation: a feature is needed
    motivation: make progress
    outcome: the feature works
    jobRef: mori://example/product/okf/jobs/concepts/JOB-1
    outcomeNames: time-to-share
features:
  - name: example
    description: Example feature.
    status: planned
    owners: [mori://example/platform]
    acceptance: The example is observable.
    featureRef: mori://example/product/okf/features/concepts/FEAT-1
featureRefs:
  - mori://example/product/okf/features/concepts/FEAT-2
---

# Linked use case

Violates exactly one rule: `jobs[0].outcomeNames` is a scalar, not a list.
