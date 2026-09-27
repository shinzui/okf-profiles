---
type: Architecture Decision Record
title: A verification run is an immutable event that links to its data
description: Verification runs and attestations are path-addressed events, while VC-N definitions describe computations and data stays outside the OKF bundle.
docId: ADR-15
status: Accepted
date: 2026-09-27
generated:
  by: openai-codex/gpt-6-sol
  at: "2026-09-27T14:27:08Z"
originatingPlan: mori://shinzui/keiro-runtime-kenshou/plans/19-publish-the-verification-evidence-profile-in-okf-profiles
---

# A verification run is an immutable event that links to its data

## Context

ADR-10 made a review an event artifact in the assurance family. OKF's
`mori://shinzui/okf/okf/adrs/concepts/ADR-14` says computations are recorded
but not run by okf: receipts and verdicts belong to a runtime. The observed
bundle at `mori://shinzui/keiro-runtime-kenshou/okf/verification` records
executions and checks around those computations. Its owner decided that a
record must never contain measurements. These facts call for house concept
types rather than a reading of OKF section 10 as a run store.

## Decision

Publish one `assurance.verificationEvidence` profile for one bundle with three
types. An `Attested Computation` is a definition with a stable, bundle-scoped
VC-N handle. A `Verification Run` is one immutable execution or comparison
event; an `Attestation` is a separate immutable event describing an independent
verifier's checks and conclusion. Runs and attestations are addressed by path
and carry UUIDv7 identities, because concurrent writers cannot safely allocate
the next sequential handle from separate working trees.

Each run links to data as `{kind, uri, digest, mediaType, bytes}`. Its OKF
`verified` list may gain the attestation's machine confirmation; that append is
the one sanctioned mutation of a run. A human sign-off uses a `human:` actor
only when a person actually supplies it. Event types take neither `status` nor
`stale_after`, because they are not redrafted and do not decay. Baselines and
trends are derived by readers and never stored as mutable records. The profile
leaves runtime-specific `layer` and `tier` vocabularies open for a consumer's
local overlay.

## Rationale

Keeping definitions, runs and attestations together lets run references resolve
local VC-N handles. Storing data outside the bundle keeps the historic record
small and makes byte integrity explicit. A separate attestation preserves the
verifier's full result even when a run later gains a terse `verified` entry.
Path addressing lets two independent recorders publish events without racing
for the same sequence number.

## Consequences

The profile checks shape, vocabularies, paths and local references. It cannot
check digest or revision hex lengths, UUIDv7 identity, object reachability,
measurement semantics, or Git immutability; a consumer must check those
locally. Markdown files under `references/` are OKF concepts and need a
declared type, so executable references in the observed bundle are non-Markdown
files. Once immutable records exist, an upstream profile change may relax a
vocabulary or presence class, but must not rename a field or accepted value.
