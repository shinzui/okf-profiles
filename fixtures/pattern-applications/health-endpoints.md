---
type: Pattern Application
title: Health endpoints apply to billing
description: Billing adopts the health-endpoint standard and binds each criterion to a local probe check.
generated:
  by: human:alice
  at: 2026-09-19T00:00:00Z
tags: [health]
applicationId: PA-1
service: mori://acme/billing
pattern: mori://acme/patterns/okf/patterns/concepts/PAT-1
decision: applicable
rationale: Billing is a long-running HTTP service that the orchestrator probes before routing traffic.
checks:
  - criterion: separate-live-and-ready
    target: pattern-health-probes
  - criterion: dependency-sensitive-readiness
    target: pattern-health-probes
---

# Health endpoints apply to billing

Both deterministic criteria run through the service-owned `pattern-health-probes`
target. `probe-contract-tested` has no binding yet, so it reports as unassessed.
