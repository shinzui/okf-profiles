---
type: "Architecture Decision Record"
title: "Campaigns are coordinated work, claim checks are assurance, readouts are research"
description: "Campaigns and audiences join coordination, checked wording joins assurance, and experiment results reuse product research with an opt-in interim gate."
docId: "ADR-21"
status: "Accepted"
date: "2026-10-23"
generated: {"by": "openai/gpt-6.1-sol", "at": "2026-10-23T20:24:58Z"}
originatingPlan: "mori://tan/tan-product-management/plans/3-add-campaign-and-audience-profiles-to-okf-profiles"
---

# Campaigns are coordinated work, claim checks are assurance, readouts are research

## Context

The source consumer `mori://shinzui/tan-os/okf/campaigns` already records campaign purposes, claims, reviews and intended readouts. The catalog divides statement kinds rather than business domains. [ADR-17](0017-product-discovery-separates-jobs-research-features-and-scenarios.md) already separates product behavior from research and customer progress.

## Decision

Publish Campaign and Campaign Email in `coordination.campaigns`, Segment and Persona in `coordination.audiences`, and Claim Check in `assurance.claimChecks`. Use one profile-level id field with per-type prefixes, following designs. A campaign experiment links a Product Research Study with method experiment and its readout cites Findings; no parallel Readout exists. Reviews are the shared annotation, not a new review artifact type.

Personas use the jobs assessment shape and describe who holds jobs, not another job. Shared `Profile/Hypothesis.dhall` holds problem/belief/prediction/falsifiedIf for campaigns and initiatives. Unknown producer fields such as Notion identifiers remain accepted. Nothing is recommended under [ADR-8](0008-recommended-means-a-well-run-corpus-carries-it.md).

Campaigns and audiences keep house status vocabularies. Claim Checks are result records whose house verdict is the complete result vocabulary; they take neither OKF status nor staleAfter, following the event-assurance exception in [ADR-15](0015-a-verification-run-is-an-immutable-event-that-links-to-its-data.md). A measured claim is evidence for wording, not a job-outcome measurement. An existing Attested Computation may be cited but that type is not admitted here.

The opt-in portable `scripts/check-gtm.py` validates manifest bundles strictly and follows canonical concept references. Its named local conditions belong upstream to `mori://shinzui/okf/okf/improvement-requests/concepts/IR-9`; target resolution belongs to `mori://shinzui/mori/okf/improvement-requests/concepts/IR-38`. Descriptors cannot express conjunctions, alternatives or recursive nested fields. The gate checks these instead of broadening the engine. Guidance names only lifecycle meaning or delegated checks under ADR-18 and shrinks when the owning tool ships equivalent support.

## Consequences

Campaign approval and send status need actual evidence, not elapsed planned dates. Measured claims require query or computation provenance and replacement wording when inaccurate. The real campaign’s four distinct email keys survive even though two share sequence 2. Product research remains the home for competitive desk research and experiments; pricing/offer profiles wait for a real corpus.
