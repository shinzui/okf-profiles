---
type: Improvement Request
title: Add a shared verification evidence profile
description: >-
  Publish assurance.verificationEvidence for immutable verification-run and attestation
  records with digest-pinned data links and the computations that define their verdicts.
generated:
  by: openai-codex/gpt-6-sol
  at: "2026-09-27T14:28:16Z"
requestId: IR-7
status: in-progress
origin: mori://shinzui/keiro-runtime-kenshou/masterplans/1-build-an-extensive-verification-suite-for-the-keiro-runtime
targetPlan: mori://shinzui/keiro-runtime-kenshou/plans/19-publish-the-verification-evidence-profile-in-okf-profiles
acceptanceCriteria:
  - id: AC-1
    statement: The package exports assurance.verificationEvidence with Attested Computation, Verification Run and Attestation; only computations have VC-N handles.
    verification: Run okf profile show on the export and inspect the three type rules, idField, idPrefix and pathPattern.
  - id: AC-2
    statement: A valid fixture bundle exercises every required, conditional and optional field of every type.
    verification: Run the focused fixture script with strict profile and log enforcement.
  - id: AC-3
    statement: A rejection fixture per load-bearing rule fails for its own expected diagnostic.
    verification: Run the focused fixture script and sweep rules individually.
  - id: AC-4
    statement: Generated profile documentation describes every field and its purpose.
    verification: Run just docs and inspect docs/profiles/verification-evidence.
  - id: AC-5
    statement: ADR-6 admits the observed computation type and a new ADR explains immutable run events.
    verification: Run scripts/test-adr-bundle.sh and read both records.
  - id: AC-6
    statement: The requesting corpus validates without a recorded concept being edited.
    verification: Strictly validate mori://shinzui/keiro-runtime-kenshou/okf/verification against the working-tree export.
  - id: AC-7
    statement: The contract ships in a tagged release with a Mori entry and a pinnable package hash.
    verification: Run just check and compare the release import hash with the local hash.
reviews:
  - kind: model
    reviewer: process:codex-cli
    reviewed_at: "2026-09-27T14:11:40Z"
    document_timestamp: "2026-09-27T14:11:40Z"
    scope: content-and-metadata
    outcome: commented
    provider: openai
    model: gpt-6-sol
    effort: unspecified
    context: >-
      Author self-check, not an independent review: checked the request against
      the existing corpus, its local descriptor, and the publication plan.
---

# Add a shared verification evidence profile

## Status

In progress. The working-tree profile, fixtures, generated documentation, and
decision records are complete; release preparation and publication remain.

## Problem

The verification bundle at `mori://shinzui/keiro-runtime-kenshou/okf/verification`
already contains seven recorded runs (including a comparison), seven attestations,
and three computation definitions. Its local Dhall descriptor checks their shape,
but another repository cannot import a released house contract for the same kind
of evidence. The condition in ADR-6 is now met: a consumer has written real
`Attested Computation` concepts before this catalog declared that type.

## Requested Change

Publish `assurance.verificationEvidence` as a single OKF v0.2 profile. Its
`Attested Computation` definitions carry VC-N handles and describe an executor
and deterministic attester. Path-addressed `Verification Run` events record one
scenario execution or comparison, exact revisions and outcomes, and links
`{kind, uri, digest, mediaType, bytes}` to external data. Path-addressed
`Attestation` events say which checks an independent verifier performed and its
verdict. A run's `verified` list may gain a matching confirmation.

The published rules are lifted from the consumer's descriptor. Only `layer` and
`tier` vocabularies and the `gs` URI scheme are opened for other consumers;
the consumer retains its own layer and tier overlay and checks storage URIs in
its local evidence checker. Optional fields such as `previousRun`, `produced`,
`knownDefects`, `computation`, and `exception` remain optional. No key or value
is renamed, and no presence requirement is strengthened. Run and attestation
events have no `status` or `stale_after`; computation definitions take OKF's
v0.2 lifecycle fields. The profile has no free-form `guidance` and stores no
measurements. An adoption blueprint waits for a second adopter.

## Fixtures

Ship a valid bundle that exercises the three types, four run kinds, comparison,
conditional fields, attestations and optional fields. Ship isolated rejection
bundles with asserted diagnostics and verify that each load-bearing rule has a
fixture, following `mori://shinzui/okf-profiles/okf/adrs/concepts/ADR-9`.

## What the profile is not

It is not a results store or a benchmark database. It does not replace the
consumer's byte-level digest verification, exact-revision lookup, URI reachability
checks, UUIDv7 checks, or Git immutability check. The descriptor language cannot
express those rules.

## Consumer contract

The consumer bundle remains `docs/verification/`; its descriptor becomes a
hash-pinned import of the released profile plus a local vocabulary overlay.
`mori.dhall` binds it as `Published`. Strict acceptance is:

```bash
okf validate docs/verification --strict --profile docs/verification/profile.dhall --profile-enforce --log-enforce
```
