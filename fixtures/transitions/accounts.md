---
type: "Transition"
transitionId: "TR-2"
title: "Split account-service"
description: "Hypothetical split fixture with separately scoped retirement evidence."
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
kind: "split"
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
    project: "mori://fixture/account-service"
    disposition: "retire"
successors:
  -
    key: "accounts"
    project: "mori://fixture/account-service-v2"
  -
    key: "billing"
    pendingIdentity: "Subscription/Stripe successor not identified"
responsibilities:
  -
    key: "accounts"
    title: "Accounts"
    from: "mori://fixture/account-service"
    disposition: "move"
    to: "accounts"
  -
    key: "billing"
    title: "Billing"
    from: "mori://fixture/account-service"
    disposition: "move"
    to: "billing"
requirements:
  -
    key: "duties"
    predecessor: "mori://fixture/account-service"
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
    predecessor: "mori://fixture/account-service"
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
    predecessor: "mori://fixture/account-service"
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
    predecessor: "mori://fixture/account-service"
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
    predecessor: "mori://fixture/account-service"
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
    predecessor: "mori://fixture/account-service"
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
    predecessor: "mori://fixture/account-service"
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
    predecessor: "mori://fixture/account-service"
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
    predecessor: "mori://fixture/account-service"
    kind: "ownership"
    statement: "Resolve all scoped ownership obligations."
    owner:
      role: "service-owner"
      party: "fixture-owner"
    minimumBasis: "runtime-observed"
    itemized: false
    requiresAcceptance: true
---

# Split account-service

Fixture derived from `mori://tan/tan-platform/docs/transformation-register` and its retirement scenarios. Never production evidence.
