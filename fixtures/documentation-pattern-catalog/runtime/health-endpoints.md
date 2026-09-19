---
type: Assessable Standard
title: Health endpoints
description: Expose separate liveness and readiness probes whose readiness reflects critical dependencies
generated:
  by: okf-authoring-agent/1.4
  at: 2026-09-19T00:00:00Z
resource: mori://example/patterns/docs/health-endpoints
tags: [runtime, health]
status: current
patternId: PAT-1
applicability:
  scope: Long-running HTTP services that an orchestrator probes before routing traffic.
  projectTypes: [service]
  languages: [haskell]
  dependenciesAny:
    - mori://example/http-server
criteria:
  - id: separate-live-and-ready
    statement: The service exposes distinct liveness and readiness endpoints.
    evidenceKind: test
    severity: required
  - id: dependency-sensitive-readiness
    statement: Readiness fails while a critical dependency is unavailable.
    evidenceKind: test
    severity: required
  - id: probe-contract-tested
    statement: A test exercises both probes against the documented contract.
    evidenceKind: test
    severity: advisory
---

# Health endpoints

Expose liveness and readiness separately. Readiness reports a critical
dependency's unavailability; liveness does not. See
[runtime startup](startup.md) for when readiness may first succeed.
