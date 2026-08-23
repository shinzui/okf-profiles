---
type: Improvement Request
title: Model improvement-request dependencies and acceptance criteria
description: >-
  Add typed, canonical IR-to-IR dependencies and stable structured acceptance
  criteria to the shared improvement-request profile so cross-repository
  fulfillment graphs can be validated and traversed instead of reconstructed from prose.
timestamp: "2026-08-23T21:20:05Z"
generated:
  by: openai-codex/gpt-5
  at: "2026-08-23T21:20:05Z"
requestId: IR-2
status: in-progress
origin: mori://shinzui/kikan
targetPlan: docs/plans/8-model-improvement-request-dependencies-and-acceptance-criteria.md
dependencies:
  - ref: mori://shinzui/mori/okf/improvement-requests/concepts/IR-18
    kind: soft
    reason: Mori projects profile-declared nested references as typed concept edges.
  - ref: mori://shinzui/kikan/okf/improvement-requests/concepts/IR-11
    kind: integration
    reason: Kikan owns the joint fulfillment-graph semantics and conformance proof.
acceptanceCriteria:
  - id: AC-1
    statement: Existing valid improvement-request fixtures remain valid without either new field.
    verification: Run the focused improvement-request fixture script and inspect the first fixture.
  - id: AC-2
    statement: The rich valid fixture covers all three dependency kinds and two stable criteria.
    verification: Inspect the second fixture and run the focused improvement-request fixture script.
  - id: AC-3
    statement: Eight invalid fixtures each reject one load-bearing contract violation.
    verification: Run the advisory loop, negative controls, and focused fixture script.
  - id: AC-4
    statement: Generated documentation defines dependency semantics and distinguishes live blockers.
    verification: Run just docs and compare the generated improvement-request profile documentation.
  - id: AC-5
    statement: Compiled profile metadata exposes dependencies.ref as a typed reference field.
    verification: Inspect the profile JSON from okf profile show and query the nested reference rule.
  - id: AC-6
    statement: The package, docs, fixtures, changelog, tag, and pinnable hash ship together.
    verification: Run just check and compare the released remote import hash with the local hash.
reviews:
  - kind: model
    reviewer: process:openai-codex
    reviewed_at: "2026-08-23T21:20:05Z"
    document_timestamp: "2026-08-23T21:20:05Z"
    scope: content-and-metadata
    outcome: approved
    provider: openai
    model: gpt-5
    effort: unspecified
    context: >-
      Reviewed against the implemented profile contract, compiled rule metadata,
      generated documentation, focused fixtures, and resolved dependency targets;
      final tag and remote-hash evidence remain release-stage work.
verified:
  by: process:openai-codex
  at: "2026-08-23T21:20:05Z"
---

# Improvement Request: Model Improvement-Request Dependencies and Acceptance Criteria

## Status

**In progress.** This is the shared-vocabulary request for
`mori://shinzui/kikan/okf/use-cases/concepts/UC-23`. It is deliberately additive: existing request
bundles remain valid, while repositories that declare fulfillment structure receive strict
validation and typed reference metadata.

## Problem

The shared improvement-request profile gives each request a stable `IR-N` handle, canonical origin,
lifecycle, optional plan, and terminal resolution. It cannot declare that one request depends on an
IR in another repository, distinguish a completion gate from an advisory or integration
relationship, or give acceptance criteria stable identities that evidence can address.

Authors therefore use prose “Dependencies” and “Acceptance” sections. Mori preserves the Markdown,
but the relationships are not profile-declared data and cannot reliably drive validation, graph
queries, readiness, or UI. Bare `IR-1` is especially unsafe across repositories because many bundles
legitimately contain that same local handle.

## Requested Change

Extend `coordination.improvementRequests` with two optional fields.

### `dependencies`

A list of records with:

- `ref` — a canonical `mori://<namespace>/<project>/okf/improvement-requests/concepts/IR-N` URI;
- `kind` — exactly `hard`, `soft`, or `integration`; and
- `reason` — a concise non-empty explanation of why the relationship exists.

The meanings are:

- **hard**: the target must be fulfilled before the source can be fulfilled;
- **soft**: the target informs or de-risks the source but never blocks by itself; and
- **integration**: implementations may proceed independently, but a named joint verification is
  required before fulfillment.

### `acceptanceCriteria`

A list of records with:

- `id` — a request-local stable handle such as `AC-1`;
- `statement` — the observable condition that must hold; and
- `verification` — the expected evidence or procedure, stated without claiming the evidence already
  exists.

Criteria describe the completion contract. They are not tasks, dependencies, or evidence. A future
evidence field may cite their stable identifiers without changing the criterion when the proof is
renewed.

Export compiled rule metadata for the nested reference at `dependencies.ref`, so Mori can project
typed edges with relation and surrounding dependency metadata. Document how consuming profiles may
add stricter policies without changing the shared meanings.

## Acceptance

1. Existing valid improvement-request fixtures remain valid without either new field.
2. A valid fixture declares all three dependency kinds to canonical IR URIs and at least two stable
   acceptance criteria; strict profile validation passes.
3. Invalid fixtures fail for a bare cross-repository `IR-N`, a non-`mori` URI, a malformed IR URI,
   an unknown dependency kind, a missing reason, a duplicate criterion id, and a criterion missing
   its statement or verification.
4. Generated profile documentation describes the exact readiness semantics of each dependency kind
   and explicitly distinguishes live operational blockers from source dependencies.
5. Compiled profile inspection identifies `dependencies.ref` as a reference field so
   `mori://shinzui/mori/okf/improvement-requests/concepts/IR-18` can project it as a typed edge.
6. The package export, valid and invalid fixtures, generated documentation, changelog, and profile
   tests ship together under a tagged release with a pinnable semantic hash.

## Dependencies

### Soft

- `mori://shinzui/mori/okf/improvement-requests/concepts/IR-18` is the registry consumer that turns
  profile-declared nested references into cross-project typed concept edges. The profile can ship
  first, but graph traversal depends on that request.

### Integration

- `mori://shinzui/kikan/okf/improvement-requests/concepts/IR-11` owns the system-level semantics and
  conformance fixture this profile must encode. This relationship gates final cross-service proof,
  not profile implementation.

## Non-goals

This request does not compute a transitive graph, validate cross-project existence, reject graph
cycles, store live blockers, or decide readiness. Profile validation checks document shape and URI
syntax; Mori and Rei own graph and operational behavior respectively.
