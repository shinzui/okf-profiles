---
type: "Transition"
transitionId: "TR-3"
title: "Absorb user profiles"
description: "Hypothetical absorption fixture with separately scoped retirement evidence."
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
kind: "absorption"
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
    project: "mori://fixture/user-service"
    disposition: "retire"
successors:
  -
    key: "accounts"
    project: "mori://fixture/account-service-v2"
responsibilities:
  -
    key: "profile"
    title: "Profile"
    from: "mori://fixture/user-service"
    disposition: "move"
    to: "accounts"
    capabilityRefs:
      - "mori://fixture/user-service/okf/capabilities/concepts/CAP-1"
      - "mori://fixture/account-service-v2/okf/capabilities/concepts/CAP-1"
requirements:
  -
    key: "duties"
    predecessor: "mori://fixture/user-service"
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
    predecessor: "mori://fixture/user-service"
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
    predecessor: "mori://fixture/user-service"
    kind: "routing-cutover"
    statement: "Resolve all scoped cutover obligations."
    owner:
      role: "service-owner"
      party: "fixture-owner"
    minimumBasis: "runtime-observed"
    itemized: false
    requiresAcceptance: true
  -
    key: "drain"
    predecessor: "mori://fixture/user-service"
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
    predecessor: "mori://fixture/user-service"
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
    predecessor: "mori://fixture/user-service"
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
    predecessor: "mori://fixture/user-service"
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
    predecessor: "mori://fixture/user-service"
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
    predecessor: "mori://fixture/user-service"
    kind: "ownership"
    statement: "Resolve all scoped ownership obligations."
    owner:
      role: "service-owner"
      party: "fixture-owner"
    minimumBasis: "runtime-observed"
    itemized: false
    requiresAcceptance: true
---

# Absorb user profiles

Fixture derived from `mori://tan/tan-platform/docs/transformation-register` and its retirement scenarios. Never production evidence.
