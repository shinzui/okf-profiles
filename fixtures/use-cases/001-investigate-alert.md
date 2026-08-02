---
type: Use Case
title: Investigate a production alert
description: Give a service steward enough context to begin safe incident diagnosis.
generated:
  by: human:nadeem
  at: "2026-07-30T00:00:00Z"
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
reviews:
  - kind: human
    reviewer: human:nadeem
    reviewed_at: "2026-07-30T00:10:00Z"
    document_timestamp: "2026-07-30T00:00:00Z"
    scope: content-and-metadata
    outcome: approved
    context: >-
      Read against the observability project's alert-handling runbooks.
verified:
  by: human:nadeem
  at: "2026-07-30T00:10:00Z"
---

# Investigate a production alert

This fixture links its job and feature to the [operations theme](themes/operations.md).
It retains the superseded v0.1 `timestamp` key alongside `generated`, proving
the demoted rule still accepts and format-checks the legacy key, and it mirrors
its approving `reviews` entry into the bare-mapping spelling of OKF `verified`.
