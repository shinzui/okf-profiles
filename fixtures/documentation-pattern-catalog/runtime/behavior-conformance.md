---
type: Assessable Pattern
title: Behavior conformance reports
description: Publish a generated conformance report that separates failed, missing, stale, and unverified behavior keys
generated:
  by: okf-authoring-agent/1.4
  at: 2026-09-19T00:00:00Z
resource: mori://example/patterns/docs/behavior-conformance
tags: [runtime, conformance]
status: current
patternId: PAT-2
applicability:
  scope: Services whose documented behaviors are proven by generated conformance tests.
criteria:
  - id: report-generated
    statement: Every build produces a machine-readable behavior conformance report.
    evidenceKind: report
    severity: required
  - id: unverified-keys-distinct
    statement: The report lists honestly unverified keys separately from failed, missing, or stale keys.
    evidenceKind: report
    severity: required
  - id: behavior-descriptions-reviewed
    statement: Behavior descriptions read as observable outcomes rather than implementation steps.
    evidenceKind: review
    severity: advisory
---

# Behavior conformance reports

Generate the report from the conformance run itself, and never count an
unverified key as passing. Return to the [runtime overview](overview.md).
