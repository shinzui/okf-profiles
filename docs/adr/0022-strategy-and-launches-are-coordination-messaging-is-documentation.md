---
type: "Architecture Decision Record"
title: "Strategy and launches are coordination; messaging is documentation"
description: "Targets and coordinated go-live work stay separate from observations and evidence-backed customer explanations."
status: "Accepted"
date: "2026-10-23"
originatingPlan: "mori://tan/tan-product-management/plans/4-add-strategy-messaging-and-launch-profiles-to-okf-profiles"
docId: "ADR-22"
generated: {"by": "codex-cli/gpt-6.1-sol", "at": "2026-10-23T22:39:33Z"}
---

# Strategy and launches are coordination; messaging is documentation

## Context

[ADR-17](0017-product-discovery-separates-jobs-research-features-and-scenarios.md) separates intended customer progress from observed evidence. [ADR-21](0021-campaigns-are-coordinated-work-claim-checks-are-assurance-readouts-are-research.md) places campaigns and audiences by statement kind, not business domain. The real source portfolio in `mori://shinzui/tan-os/okf/tan-product-dev` needs strategy, growth initiatives and landing-page identities; its messaging matrix needs audience-addressed explanations.

## Decision

Publish `coordination.strategy` for Strategic Theme (distinct from Use Case Theme), Objective and Initiative; `coordination.launches` for Launch and Landing Page; `documentation.messaging` for Positioning and Message. Growth projects are Initiatives of kind growth, with producer wave and size fields. No engineering-project, pricing/offer or competitor type is introduced.

Key results hold intended targets using the jobs measurement vocabulary; observations remain Findings or Claim Checks. Achieved/missed objectives require a reasoned evidence assessment. A projection is a scenario, never a committed objective or observed achievement. Objective period bounds carry the shared measurement period, and jobRef/outcomeName remain a flat optional pair because the descriptor supports only one record level.

Launch readiness uses feature-local AC-N acceptance elements; launchEvidence uses shared sources. Readiness is a condition and verification method, not a passed flag; launched records a go-live event, not customer outcome. Landing Pages reference design briefs or detailed designs rather than duplicating surface design.

Positioning and Messages require a Segment or Persona audience. Proof points cite a Claim Check or Product Research Finding, never a Study. Messages explain facts rather than creating new measurement records. Matrix coordinates remain flat scalar labels.

Cross-profile references are external-only canonical concept URIs; references between types of the same profile may use local handles. No recommended fields are introduced, and house statuses replace OKF status/staleAfter. Optional sources/reviews/verified use existing shared blocks without changing their policy.

The opt-in check-gtm.py retains its manifest API and existing rules, adding audience-any-of, key-result outcome pairs, typed proof-point evidence and strategy/launch/message targets. It also checks finite targets and ordered objective periods under metric-context. Concept-local rules belong to `mori://shinzui/okf/okf/improvement-requests/concepts/IR-9`; resolution belongs to `mori://shinzui/mori/okf/improvement-requests/concepts/IR-38`. No engine extension is bundled.

## Consequences

Delivery, validation and historical dates never promote objectives, messages or launches automatically. Guidance sentences are limited to lifecycle meaning and delegated checks under ADR-18. Real source samples are tested in disposable scratch bundles; reusable fixtures carry synthetic values and no private owner identities or financial figures.
