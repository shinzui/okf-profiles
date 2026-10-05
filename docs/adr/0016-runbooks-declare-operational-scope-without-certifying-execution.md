---
type: Architecture Decision Record
title: Runbooks declare operational scope without certifying execution
description: Dedicated runbook metadata makes procedures discoverable while execution correctness remains grounded in review and exercise evidence.
docId: ADR-16
status: Accepted
date: 2026-10-05
originatingPlan: mori://tan/tan-platform/plans/14-adopt-a-shared-operational-runbook-profile
generated:
  by: codex/gpt-6.1-sol
  at: 2026-10-05T14:35:00Z
---

# Runbooks declare operational scope without certifying execution

## Context

The general user-documentation profile recognizes Runbook but does not distinguish
operational applicability, accountability or effects. `mori://tan/tan-platform`
needs stable architecture operating procedures. `mori://shinzui/shibuya`, with
project-relative `docs/operations/RUNBOOKS.md` and `docs/operations/DEPLOYMENT.md`
(artifact-level URI pending), shows independent restart, scaling, stuck-processor
and dead-letter procedures alongside deployment reference material. Force termination
and replay branches need recovery boundaries that cannot be inferred from a title.

## Decision

Export `documentation.runbooks` with a single Runbook type and stable bundle-scoped
RB handles. Require owner, canonical project scope, environments, trigger, effects,
lifecycle and general discovery/provenance metadata. Keep commands and branching
procedures in Markdown. Authoring references require prerequisites, ordered steps,
expected observations, verification, stop/recovery conditions and escalation.

These body requirements are reviewed rather than validated by the current schema.
A successful structural check is not operational exercise evidence. `verified`
remains optional independent provenance; documentation lifecycle and effect metadata
grant no authority to execute commands.

Operations references remain general documentation. A mixed corpus is classified by
content; independently usable procedures can become separate runbooks while reference
pages retain their role. Existing Runbook documents under user-documentation remain
valid and are not forced to migrate.

## Consequences

A shared catalog can discover who owns a procedure and where it applies, while each
repository supplies its own environment and owner vocabulary. Adoption uses explicit
source evidence, preserves existing identities and navigation, and reports unresolved
operational details rather than inventing them. New consumers can vendor a normalized
snapshot before release; frozen remote imports follow publication. No release number
is claimed by a prerelease profile or adoption blueprint.
