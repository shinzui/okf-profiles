---
type: "Transition"
transitionId: "TR-4"
title: "Consolidate notification services"
description: "Hypothetical consolidation fixture with separately scoped retirement evidence."
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
kind: "consolidation"
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
    project: "mori://fixture/email-template-renderer"
    disposition: "retire"
  -
    project: "mori://fixture/email-notification-service"
    disposition: "retire"
  -
    project: "mori://fixture/alert-service"
    disposition: "retire"
  -
    project: "mori://fixture/mailer"
    disposition: "retire"
  -
    project: "mori://fixture/email-request-service"
    disposition: "retire"
  -
    project: "mori://fixture/email-coordinator"
    disposition: "retain"
successors:
  -
    key: "hub"
    project: "mori://fixture/notification-hub"
  -
    key: "renderer"
    pendingIdentity: "Intended renderer owner not identified"
  -
    key: "in-app"
    pendingIdentity: "In-app alert successor not identified"
responsibilities:
  -
    key: "templates"
    title: "Templates"
    from: "mori://fixture/email-template-renderer"
    disposition: "move"
    to: "renderer"
  -
    key: "registration-email"
    title: "Registration email"
    from: "mori://fixture/email-notification-service"
    disposition: "move"
    to: "hub"
  -
    key: "password-reset"
    title: "Password reset"
    from: "mori://fixture/email-notification-service"
    disposition: "move"
    to: "hub"
  -
    key: "other-notifications"
    title: "Other notifications"
    from: "mori://fixture/email-notification-service"
    disposition: "move"
    to: "hub"
  -
    key: "alert-email"
    title: "Alert email"
    from: "mori://fixture/alert-service"
    disposition: "move"
    to: "hub"
  -
    key: "alert-storage"
    title: "Alert storage"
    from: "mori://fixture/alert-service"
    disposition: "move"
    to: "in-app"
  -
    key: "alert-read"
    title: "Alert read"
    from: "mori://fixture/alert-service"
    disposition: "move"
    to: "in-app"
  -
    key: "alert-dismiss"
    title: "Alert dismiss"
    from: "mori://fixture/alert-service"
    disposition: "move"
    to: "in-app"
  -
    key: "alert-subscriptions"
    title: "Alert subscriptions"
    from: "mori://fixture/alert-service"
    disposition: "move"
    to: "in-app"
  -
    key: "provider-delivery"
    title: "Provider delivery"
    from: "mori://fixture/mailer"
    disposition: "move"
    to: "hub"
  -
    key: "email-intake"
    title: "Email intake"
    from: "mori://fixture/email-request-service"
    disposition: "move"
    to: "hub"
  -
    key: "obsolete-preview"
    title: "Obsolete preview"
    from: "mori://fixture/email-request-service"
    disposition: "discontinue"
  -
    key: "coordination"
    title: "Coordination"
    from: "mori://fixture/email-coordinator"
    disposition: "retain"
requirements:
  -
    key: "duties-1"
    predecessor: "mori://fixture/email-template-renderer"
    kind: "responsibility-transfer"
    statement: "Resolve all scoped duties 1 obligations."
    owner:
      role: "service-owner"
      party: "fixture-owner"
    minimumBasis: "runtime-observed"
    itemized: true
    requiresAcceptance: true
  -
    key: "callers-1"
    predecessor: "mori://fixture/email-template-renderer"
    kind: "consumer-migration"
    statement: "Resolve all scoped callers 1 obligations."
    owner:
      role: "service-owner"
      party: "fixture-owner"
    minimumBasis: "runtime-observed"
    itemized: true
    requiresAcceptance: true
  -
    key: "cutover-1"
    predecessor: "mori://fixture/email-template-renderer"
    kind: "routing-cutover"
    statement: "Resolve all scoped cutover 1 obligations."
    owner:
      role: "service-owner"
      party: "fixture-owner"
    minimumBasis: "runtime-observed"
    itemized: false
    requiresAcceptance: true
  -
    key: "drain-1"
    predecessor: "mori://fixture/email-template-renderer"
    kind: "in-flight-drain"
    statement: "Resolve all scoped drain 1 obligations."
    owner:
      role: "service-owner"
      party: "fixture-owner"
    minimumBasis: "runtime-observed"
    itemized: false
    requiresAcceptance: true
  -
    key: "data-1"
    predecessor: "mori://fixture/email-template-renderer"
    kind: "data-obligation"
    statement: "Resolve all scoped data 1 obligations."
    owner:
      role: "service-owner"
      party: "fixture-owner"
    minimumBasis: "runtime-observed"
    itemized: false
    requiresAcceptance: true
  -
    key: "events-1"
    predecessor: "mori://fixture/email-template-renderer"
    kind: "event-obligation"
    statement: "Resolve all scoped events 1 obligations."
    owner:
      role: "service-owner"
      party: "fixture-owner"
    minimumBasis: "runtime-observed"
    itemized: true
    requiresAcceptance: true
  -
    key: "rollback-1"
    predecessor: "mori://fixture/email-template-renderer"
    kind: "rollback"
    statement: "Resolve all scoped rollback 1 obligations."
    owner:
      role: "service-owner"
      party: "fixture-owner"
    minimumBasis: "runtime-observed"
    itemized: false
    requiresAcceptance: true
  -
    key: "operations-1"
    predecessor: "mori://fixture/email-template-renderer"
    kind: "operational-continuity"
    statement: "Resolve all scoped operations 1 obligations."
    owner:
      role: "service-owner"
      party: "fixture-owner"
    minimumBasis: "runtime-observed"
    itemized: false
    requiresAcceptance: true
  -
    key: "ownership-1"
    predecessor: "mori://fixture/email-template-renderer"
    kind: "ownership"
    statement: "Resolve all scoped ownership 1 obligations."
    owner:
      role: "service-owner"
      party: "fixture-owner"
    minimumBasis: "runtime-observed"
    itemized: false
    requiresAcceptance: true
  -
    key: "duties-2"
    predecessor: "mori://fixture/email-notification-service"
    kind: "responsibility-transfer"
    statement: "Resolve all scoped duties 2 obligations."
    owner:
      role: "service-owner"
      party: "fixture-owner"
    minimumBasis: "runtime-observed"
    itemized: true
    requiresAcceptance: true
  -
    key: "callers-2"
    predecessor: "mori://fixture/email-notification-service"
    kind: "consumer-migration"
    statement: "Resolve all scoped callers 2 obligations."
    owner:
      role: "service-owner"
      party: "fixture-owner"
    minimumBasis: "runtime-observed"
    itemized: true
    requiresAcceptance: true
  -
    key: "cutover-2"
    predecessor: "mori://fixture/email-notification-service"
    kind: "routing-cutover"
    statement: "Resolve all scoped cutover 2 obligations."
    owner:
      role: "service-owner"
      party: "fixture-owner"
    minimumBasis: "runtime-observed"
    itemized: false
    requiresAcceptance: true
  -
    key: "drain-2"
    predecessor: "mori://fixture/email-notification-service"
    kind: "in-flight-drain"
    statement: "Resolve all scoped drain 2 obligations."
    owner:
      role: "service-owner"
      party: "fixture-owner"
    minimumBasis: "runtime-observed"
    itemized: false
    requiresAcceptance: true
  -
    key: "data-2"
    predecessor: "mori://fixture/email-notification-service"
    kind: "data-obligation"
    statement: "Resolve all scoped data 2 obligations."
    owner:
      role: "service-owner"
      party: "fixture-owner"
    minimumBasis: "runtime-observed"
    itemized: false
    requiresAcceptance: true
  -
    key: "events-2"
    predecessor: "mori://fixture/email-notification-service"
    kind: "event-obligation"
    statement: "Resolve all scoped events 2 obligations."
    owner:
      role: "service-owner"
      party: "fixture-owner"
    minimumBasis: "runtime-observed"
    itemized: true
    requiresAcceptance: true
  -
    key: "rollback-2"
    predecessor: "mori://fixture/email-notification-service"
    kind: "rollback"
    statement: "Resolve all scoped rollback 2 obligations."
    owner:
      role: "service-owner"
      party: "fixture-owner"
    minimumBasis: "runtime-observed"
    itemized: false
    requiresAcceptance: true
  -
    key: "operations-2"
    predecessor: "mori://fixture/email-notification-service"
    kind: "operational-continuity"
    statement: "Resolve all scoped operations 2 obligations."
    owner:
      role: "service-owner"
      party: "fixture-owner"
    minimumBasis: "runtime-observed"
    itemized: false
    requiresAcceptance: true
  -
    key: "ownership-2"
    predecessor: "mori://fixture/email-notification-service"
    kind: "ownership"
    statement: "Resolve all scoped ownership 2 obligations."
    owner:
      role: "service-owner"
      party: "fixture-owner"
    minimumBasis: "runtime-observed"
    itemized: false
    requiresAcceptance: true
  -
    key: "duties-3"
    predecessor: "mori://fixture/alert-service"
    kind: "responsibility-transfer"
    statement: "Resolve all scoped duties 3 obligations."
    owner:
      role: "service-owner"
      party: "fixture-owner"
    minimumBasis: "runtime-observed"
    itemized: true
    requiresAcceptance: true
  -
    key: "callers-3"
    predecessor: "mori://fixture/alert-service"
    kind: "consumer-migration"
    statement: "Resolve all scoped callers 3 obligations."
    owner:
      role: "service-owner"
      party: "fixture-owner"
    minimumBasis: "runtime-observed"
    itemized: true
    requiresAcceptance: true
  -
    key: "cutover-3"
    predecessor: "mori://fixture/alert-service"
    kind: "routing-cutover"
    statement: "Resolve all scoped cutover 3 obligations."
    owner:
      role: "service-owner"
      party: "fixture-owner"
    minimumBasis: "runtime-observed"
    itemized: false
    requiresAcceptance: true
  -
    key: "drain-3"
    predecessor: "mori://fixture/alert-service"
    kind: "in-flight-drain"
    statement: "Resolve all scoped drain 3 obligations."
    owner:
      role: "service-owner"
      party: "fixture-owner"
    minimumBasis: "runtime-observed"
    itemized: false
    requiresAcceptance: true
  -
    key: "data-3"
    predecessor: "mori://fixture/alert-service"
    kind: "data-obligation"
    statement: "Resolve all scoped data 3 obligations."
    owner:
      role: "service-owner"
      party: "fixture-owner"
    minimumBasis: "runtime-observed"
    itemized: false
    requiresAcceptance: true
  -
    key: "events-3"
    predecessor: "mori://fixture/alert-service"
    kind: "event-obligation"
    statement: "Resolve all scoped events 3 obligations."
    owner:
      role: "service-owner"
      party: "fixture-owner"
    minimumBasis: "runtime-observed"
    itemized: true
    requiresAcceptance: true
  -
    key: "rollback-3"
    predecessor: "mori://fixture/alert-service"
    kind: "rollback"
    statement: "Resolve all scoped rollback 3 obligations."
    owner:
      role: "service-owner"
      party: "fixture-owner"
    minimumBasis: "runtime-observed"
    itemized: false
    requiresAcceptance: true
  -
    key: "operations-3"
    predecessor: "mori://fixture/alert-service"
    kind: "operational-continuity"
    statement: "Resolve all scoped operations 3 obligations."
    owner:
      role: "service-owner"
      party: "fixture-owner"
    minimumBasis: "runtime-observed"
    itemized: false
    requiresAcceptance: true
  -
    key: "ownership-3"
    predecessor: "mori://fixture/alert-service"
    kind: "ownership"
    statement: "Resolve all scoped ownership 3 obligations."
    owner:
      role: "service-owner"
      party: "fixture-owner"
    minimumBasis: "runtime-observed"
    itemized: false
    requiresAcceptance: true
  -
    key: "duties-4"
    predecessor: "mori://fixture/mailer"
    kind: "responsibility-transfer"
    statement: "Resolve all scoped duties 4 obligations."
    owner:
      role: "service-owner"
      party: "fixture-owner"
    minimumBasis: "runtime-observed"
    itemized: true
    requiresAcceptance: true
  -
    key: "callers-4"
    predecessor: "mori://fixture/mailer"
    kind: "consumer-migration"
    statement: "Resolve all scoped callers 4 obligations."
    owner:
      role: "service-owner"
      party: "fixture-owner"
    minimumBasis: "runtime-observed"
    itemized: true
    requiresAcceptance: true
  -
    key: "cutover-4"
    predecessor: "mori://fixture/mailer"
    kind: "routing-cutover"
    statement: "Resolve all scoped cutover 4 obligations."
    owner:
      role: "service-owner"
      party: "fixture-owner"
    minimumBasis: "runtime-observed"
    itemized: false
    requiresAcceptance: true
  -
    key: "drain-4"
    predecessor: "mori://fixture/mailer"
    kind: "in-flight-drain"
    statement: "Resolve all scoped drain 4 obligations."
    owner:
      role: "service-owner"
      party: "fixture-owner"
    minimumBasis: "runtime-observed"
    itemized: false
    requiresAcceptance: true
  -
    key: "data-4"
    predecessor: "mori://fixture/mailer"
    kind: "data-obligation"
    statement: "Resolve all scoped data 4 obligations."
    owner:
      role: "service-owner"
      party: "fixture-owner"
    minimumBasis: "runtime-observed"
    itemized: false
    requiresAcceptance: true
  -
    key: "events-4"
    predecessor: "mori://fixture/mailer"
    kind: "event-obligation"
    statement: "Resolve all scoped events 4 obligations."
    owner:
      role: "service-owner"
      party: "fixture-owner"
    minimumBasis: "runtime-observed"
    itemized: true
    requiresAcceptance: true
  -
    key: "rollback-4"
    predecessor: "mori://fixture/mailer"
    kind: "rollback"
    statement: "Resolve all scoped rollback 4 obligations."
    owner:
      role: "service-owner"
      party: "fixture-owner"
    minimumBasis: "runtime-observed"
    itemized: false
    requiresAcceptance: true
  -
    key: "operations-4"
    predecessor: "mori://fixture/mailer"
    kind: "operational-continuity"
    statement: "Resolve all scoped operations 4 obligations."
    owner:
      role: "service-owner"
      party: "fixture-owner"
    minimumBasis: "runtime-observed"
    itemized: false
    requiresAcceptance: true
  -
    key: "ownership-4"
    predecessor: "mori://fixture/mailer"
    kind: "ownership"
    statement: "Resolve all scoped ownership 4 obligations."
    owner:
      role: "service-owner"
      party: "fixture-owner"
    minimumBasis: "runtime-observed"
    itemized: false
    requiresAcceptance: true
  -
    key: "duties-5"
    predecessor: "mori://fixture/email-request-service"
    kind: "responsibility-transfer"
    statement: "Resolve all scoped duties 5 obligations."
    owner:
      role: "service-owner"
      party: "fixture-owner"
    minimumBasis: "runtime-observed"
    itemized: true
    requiresAcceptance: true
  -
    key: "callers-5"
    predecessor: "mori://fixture/email-request-service"
    kind: "consumer-migration"
    statement: "Resolve all scoped callers 5 obligations."
    owner:
      role: "service-owner"
      party: "fixture-owner"
    minimumBasis: "runtime-observed"
    itemized: true
    requiresAcceptance: true
  -
    key: "cutover-5"
    predecessor: "mori://fixture/email-request-service"
    kind: "routing-cutover"
    statement: "Resolve all scoped cutover 5 obligations."
    owner:
      role: "service-owner"
      party: "fixture-owner"
    minimumBasis: "runtime-observed"
    itemized: false
    requiresAcceptance: true
  -
    key: "drain-5"
    predecessor: "mori://fixture/email-request-service"
    kind: "in-flight-drain"
    statement: "Resolve all scoped drain 5 obligations."
    owner:
      role: "service-owner"
      party: "fixture-owner"
    minimumBasis: "runtime-observed"
    itemized: false
    requiresAcceptance: true
  -
    key: "data-5"
    predecessor: "mori://fixture/email-request-service"
    kind: "data-obligation"
    statement: "Resolve all scoped data 5 obligations."
    owner:
      role: "service-owner"
      party: "fixture-owner"
    minimumBasis: "runtime-observed"
    itemized: false
    requiresAcceptance: true
  -
    key: "events-5"
    predecessor: "mori://fixture/email-request-service"
    kind: "event-obligation"
    statement: "Resolve all scoped events 5 obligations."
    owner:
      role: "service-owner"
      party: "fixture-owner"
    minimumBasis: "runtime-observed"
    itemized: true
    requiresAcceptance: true
  -
    key: "rollback-5"
    predecessor: "mori://fixture/email-request-service"
    kind: "rollback"
    statement: "Resolve all scoped rollback 5 obligations."
    owner:
      role: "service-owner"
      party: "fixture-owner"
    minimumBasis: "runtime-observed"
    itemized: false
    requiresAcceptance: true
  -
    key: "operations-5"
    predecessor: "mori://fixture/email-request-service"
    kind: "operational-continuity"
    statement: "Resolve all scoped operations 5 obligations."
    owner:
      role: "service-owner"
      party: "fixture-owner"
    minimumBasis: "runtime-observed"
    itemized: false
    requiresAcceptance: true
  -
    key: "ownership-5"
    predecessor: "mori://fixture/email-request-service"
    kind: "ownership"
    statement: "Resolve all scoped ownership 5 obligations."
    owner:
      role: "service-owner"
      party: "fixture-owner"
    minimumBasis: "runtime-observed"
    itemized: false
    requiresAcceptance: true
---

# Consolidate notification services

Fixture derived from `mori://tan/tan-platform/docs/transformation-register` and its retirement scenarios. Never production evidence.
