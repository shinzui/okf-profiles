---
type: Use Case
title: Investigate a production alert
description: Give a service steward enough context to begin safe incident diagnosis.
timestamp: "2026-07-30T00:00:00Z"
useCaseId: UC-1
status: validated
origin: mori://example/platform
themes:
  - operations
jobs:
  - name: diagnose-incident
    actor: service steward
    situation: a production alert fires for a service they own
    motivation: identify the likely cause without first assembling context by hand
    outcome: a bounded investigation begins with attributable evidence
features:
  - name: alert-context
    description: Normalize the service target and attach recent changes to the alert.
    status: planned
    owners:
      - mori://example/observability
    acceptance: The steward opens one alert and sees the canonical target and recent changes.
    jobs:
      - diagnose-incident
    improvementRequests:
      - mori://example/observability/okf/improvement-requests/concepts/IR-3
improvementRequests:
  - mori://example/observability/okf/improvement-requests/concepts/IR-3
---

# Investigate a production alert

This fixture links its job and feature to the [operations theme](themes/operations.md).
