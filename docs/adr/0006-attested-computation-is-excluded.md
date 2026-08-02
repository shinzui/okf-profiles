---
type: Architecture Decision Record
title: OKF v0.2's Attested Computation concept type is excluded
description: No profile in this catalog documents computations, so any convention written now would be invented rather than observed.
docId: ADR-6
status: Accepted
date: 2026-08-01
generated:
  by: human:nadeem
  at: "2026-08-01T00:00:00Z"
---

# OKF v0.2's Attested Computation concept type is excluded

## Context

OKF v0.2 §10 defines an `Attested Computation` concept type with five contract
keys — `runtime`, `parameters`, `computation`, `executor`, `attester`. okf
0.5.0.0 reads all five and enforces §10.2 and §10.3 in strict mode. The
`objectFields` and `path` rules this repository gained in v0.8.0 are sufficient
to constrain them, so a profile for the type could be written today.

## Decision

**No profile in this catalog declares the `Attested Computation` type, and this
release does not add one.**

## Rationale

Not one of the seven profiles documents computations, and no consumer has asked
for one. A convention written now would be invented rather than observed — the
opposite of how every other profile in this catalog came to exist, each of which
codifies a shape some repository was already writing by hand.

The cost of waiting is low. The schema surface is already exported, so adding the
type when a consumer needs it is a small additive change to one profile, not a
structural one.

## Consequences

A reader who notices that okf supports §10 and that this catalog does not will
find this record rather than re-deriving the question. That is the entire point
of writing down a deliberate exclusion.

Adding the type later is additive and non-breaking: a new concept type in a
profile's `types` list does not change what an existing concept must carry. It
does not require a new major version of this catalog.

If a consumer does ask, the right first move is to look at what they are already
writing, not at §10.
