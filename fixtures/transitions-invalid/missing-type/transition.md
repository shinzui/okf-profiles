---
transitionId: "TR-1"
title: "Replace registration-service"
description: "Hypothetical replacement fixture with separately scoped retirement evidence."
timestamp: "2026-10-07T04:32:00Z"
generated:
  by: "codex/gpt-6.1-sol"
  at: "2026-10-07T04:32:00Z"
reviews:
  -
    kind: "model"
    reviewer: "process:openai-codex"
    reviewed_at: "2026-10-07T04:32:00Z"
    document_timestamp: "2026-10-07T04:32:00Z"
    scope: "content-and-metadata"
    outcome: "commented"
    provider: "openai"
    model: "gpt-6.1-sol"
    effort: "unspecified"
    context: "Author self-check of fixture metadata and contract coverage, not an independent review or production evidence."
coordinator: "mori://fixture/platform"
kind: "replacement"
phase: "in-progress"
environments:
  - "staging"
  - "production"
accountable:
  -
    role: "coordinator"
    party: "fixture-coordinator"
predecessors:
  -
    project: "mori://fixture/registration-service"
    disposition: "retire"
successors:
  -
    key: "registration-v2"
    project: "mori://fixture/registration-service-v2"
responsibilities:
  -
    key: "member-registration"
    title: "Member registration"
    from: "mori://fixture/registration-service"
    disposition: "move"
    to: "registration-v2"
    owner: "fixture-owner"
    contextRefs:
      - "mori://fixture/registration-service-v2/ddd/contexts/registration"
    flowRefs:
      - "mori://fixture/platform/ddd/flows/member-registration"
    useCaseRefs:
      - "mori://fixture/platform/okf/business-use-cases/concepts/UC-1"
requirements:
  -
    key: "duties"
    predecessor: "mori://fixture/registration-service"
    kind: "responsibility-transfer"
    statement: "Resolve all scoped duties obligations."
    owner:
      role: "service-owner"
      party: "fixture-owner"
    minimumBasis: "runtime-observed"
    itemized: true
    requiresAcceptance: true
  -
    key: "callers"
    predecessor: "mori://fixture/registration-service"
    kind: "consumer-migration"
    statement: "Resolve all scoped callers obligations."
    owner:
      role: "service-owner"
      party: "fixture-owner"
    minimumBasis: "runtime-observed"
    itemized: true
    requiresAcceptance: true
  -
    key: "cutover"
    predecessor: "mori://fixture/registration-service"
    kind: "routing-cutover"
    statement: "Resolve all scoped cutover obligations."
    owner:
      role: "service-owner"
      party: "fixture-owner"
    minimumBasis: "runtime-observed"
    itemized: false
    requiresAcceptance: true
    environments:
      - "production"
    responsibility: "member-registration"
    maxAge: "P30D"
  -
    key: "drain"
    predecessor: "mori://fixture/registration-service"
    kind: "in-flight-drain"
    statement: "Resolve all scoped drain obligations."
    owner:
      role: "service-owner"
      party: "fixture-owner"
    minimumBasis: "runtime-observed"
    itemized: false
    requiresAcceptance: true
  -
    key: "data"
    predecessor: "mori://fixture/registration-service"
    kind: "data-obligation"
    statement: "Resolve all scoped data obligations."
    owner:
      role: "service-owner"
      party: "fixture-owner"
    minimumBasis: "runtime-observed"
    itemized: false
    requiresAcceptance: true
  -
    key: "events"
    predecessor: "mori://fixture/registration-service"
    kind: "event-obligation"
    statement: "Resolve all scoped events obligations."
    owner:
      role: "service-owner"
      party: "fixture-owner"
    minimumBasis: "runtime-observed"
    itemized: true
    requiresAcceptance: true
  -
    key: "rollback"
    predecessor: "mori://fixture/registration-service"
    kind: "rollback"
    statement: "Resolve all scoped rollback obligations."
    owner:
      role: "service-owner"
      party: "fixture-owner"
    minimumBasis: "runtime-observed"
    itemized: false
    requiresAcceptance: true
  -
    key: "operations"
    predecessor: "mori://fixture/registration-service"
    kind: "operational-continuity"
    statement: "Resolve all scoped operations obligations."
    owner:
      role: "service-owner"
      party: "fixture-owner"
    minimumBasis: "runtime-observed"
    itemized: false
    requiresAcceptance: true
  -
    key: "ownership"
    predecessor: "mori://fixture/registration-service"
    kind: "ownership"
    statement: "Resolve all scoped ownership obligations."
    owner:
      role: "service-owner"
      party: "fixture-owner"
    minimumBasis: "runtime-observed"
    itemized: false
    requiresAcceptance: true
phaseSource: "Hypothetical fixture intent, not a deployed route observation"
---

# Invalid fixture

Violates exactly `missing-field` (missing-type) relative to TR-1 in valid/. Resolve fixture references before checking semantic rules.
