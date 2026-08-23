---
type: Improvement Request
title: Add a shared Observability Contract profile
description: >-
  Define service-owned observability contracts that distinguish instrumentation,
  export, propagation, dashboards, alerts, ownership, runbooks, lifecycle, and
  executable evidence.
timestamp: "2026-08-19T18:04:00Z"
generated:
  by: openai-codex/gpt-5
  at: "2026-08-19T18:04:00Z"
requestId: IR-5
status: proposed
origin: mori://tan/tan-platform/plans/4-define-platform-architecture-assets-and-upstream-gaps
reviews:
  - kind: model
    reviewer: process:openai-codex
    reviewed_at: "2026-08-23T21:20:05Z"
    document_timestamp: "2026-08-19T18:04:00Z"
    scope: content-and-metadata
    outcome: approved
    provider: openai
    model: gpt-5
    effort: unspecified
    context: >-
      Reviewed for profile conformance, internal consistency, and canonical
      cross-repository references; every concrete Mori URI resolved in the
      registry during the v0.12.0 release audit.
verified:
  by: process:openai-codex
  at: "2026-08-23T21:20:05Z"
---

# Improvement Request: Add a Shared Observability Contract Profile

## Status

**Proposed.** The TAN architecture experiment preserved complete OTel/Grafana evidence
in an owner document, but no shared profile can validate or query its independent gates.

## Problem

An OpenTelemetry dependency proves neither instrumentation nor export. A collector URL
proves neither propagation nor delivery. A Grafana dashboard proves neither actionable
alerts nor an owner and runbook. These are independently verifiable facts with separate
lifecycles, and a service may be complete on some while missing others.

Architecture Standard concepts requested by
`mori://shinzui/okf-profiles/okf/improvement-requests/concepts/IR-1` can state the policy,
and Mori DocRefs can expose a runbook. They cannot declare a service-scoped contract
whose fields a fleet report can validate and query. Encoding boundaries, collector
routes, dashboard identities, or alert ownership in prose leaves no stable identity or
typed relationship and encourages false conformance from dependency or URL detection.

This gap was proven by
`mori://tan/tan-platform/docs/architecture-upstream-capability-gaps`, raised while
implementing
`mori://tan/tan-platform/plans/4-define-platform-architecture-assets-and-upstream-gaps`.

## Requested Change

Publish an additive Observability Contract profile that supports:

- canonical service/project owner, lifecycle, environments, and service/resource
  identity;
- traces, metrics, and logs as separate signal declarations with instrumentation and
  executable evidence;
- OTLP exporter and collector route, plus observed-delivery evidence;
- a list of W3C propagation boundaries covering relevant HTTP, outbox, broker, inbox,
  consumer, and workflow paths;
- log/trace correlation behavior where logs are used;
- stable Grafana dashboard and alert identities, definitions, lifecycle, and evidence;
- alert owner, notification route, failure-mode rationale, runbook reference, and
  exercise/review evidence; and
- explicit partial or conflicting claims without converting a missing field into a
  negative implementation claim.

The profile should reuse Mori document references for runbooks and compose with the
ownership, lifecycle, evidence, supersession, and conflict conventions requested by
`mori://shinzui/okf-profiles/okf/improvement-requests/concepts/IR-1`.

## Acceptance

1. A valid service fixture declares OTel trace/metric instrumentation, one collector
   path, HTTP and messaging propagation boundaries, log correlation, two dashboards,
   actionable alerts, owner, notification route, runbook, lifecycle, and executable
   evidence; strict validation passes.
2. Queries can distinguish instrumentation, export, propagation, dashboards, alerts,
   ownership, and runbooks rather than returning one observability boolean.
3. Invalid fixtures fail for a dashboard-only contract presented as complete, an alert
   without owner/runbook, an export claim without collector/evidence, duplicate asset
   identity, and malformed cross-project references.
4. Dependency declarations remain separate evidence and cannot satisfy operational
   gates by themselves.
5. The package export, documentation, fixtures, tests, changelog, and tagged release
   ship together with a pinnable semantic hash.

## Non-goals

This request does not install collectors, create dashboards or alerts, choose a vendor,
query live Grafana, or make the profile authoritative for telemetry emitted at runtime.
