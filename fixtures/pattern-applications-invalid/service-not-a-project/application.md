---
type: Pattern Application
title: Example application
description: Exercise one pattern-application defect.
generated:
  by: human:alice
  at: 2026-09-19T00:00:00Z
applicationId: PA-1
service: mori://acme/billing/okf/docs/concepts/DOC-1
pattern: mori://acme/patterns/okf/patterns/concepts/PAT-1
decision: applicable
rationale: Billing is a probed HTTP service.
checks:
  - criterion: separate-live-and-ready
    target: pattern-health-probes
---

# Example application

This fixture must fail for exactly one reason.
