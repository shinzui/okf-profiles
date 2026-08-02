---
type: Architecture Decision Record
title: A profile flips to OKF v0.2 atomically
description: okf compile-checks okfVersion against the rules a profile declares, in both directions, so partial adoption is impossible.
docId: ADR-2
status: Accepted
date: 2026-08-01
generated:
  by: human:nadeem
  at: "2026-08-01T00:00:00Z"
---

# A profile flips to OKF v0.2 atomically

## Context

As of okf 0.5.0.0 — new in that release, not true of 0.4.0.0 — a profile's
declared `okfVersion` is checked against the rules the profile declares, at
profile *load* time, in **both** directions. Probing the installed binary
confirms each:

```text
$ okf validate ./bundle --profile probe.dhall
Failed to load profile probe.dhall: invalid profile definition:
  - profile frontmatter: declared okfVersion 0.2 supersedes the frontmatter key timestamp
    (OKF 0.2); move it to the optional list or replace it with generated
```

```text
$ okf validate ./bundle --profile probe2.dhall
Failed to load profile probe2.dhall: invalid profile definition:
  - profile frontmatter: declared okfVersion 0.1 does not support the format actor at
    generated.by, which OKF 0.2 introduced
```

A Dhall type-check cannot catch either. `dhall type` succeeds on both probes;
okf enforces the constraint when it loads the profile.

## Decision

**Every change that moves a profile to OKF v0.2 lands as one edit, and no profile
is left in an intermediate state across a commit.** Verification of such a change
uses `okf profile show` or `okf validate`, never `dhall type` alone.

## Rationale

The constraint is not a style preference; it is arithmetic. A profile cannot
declare `okfVersion = "0.2"` while `timestamp` sits in `required` or
`recommended`, and it cannot use the `actor` format — which the `generated`
family requires — while declaring `"0.1"`. There is no ordering of the two halves
that leaves a loadable profile in between. Attempting a staged migration produces
a hard load failure, which presents to a consumer as a broken profile rather than
a partial one.

This shaped how the migration was decomposed: per-profile, never per-feature. A
plan that tried to "add `generated` everywhere" and then "declare 0.2 everywhere"
would have been unimplementable.

## Consequences

Any future profile added to this catalog, and any future change to the OKF
version a profile targets, is a single atomic edit to that profile.

A profile's presence lists and its `okfVersion` are coupled, so the presence
class of a superseded key is not a free choice — see
[the timestamp demotion](0003-timestamp-is-demoted-not-deleted.md).

Because the check is at load time, a Dhall-only CI gate is insufficient for this
catalog. Every profile is exercised by a `scripts/test-*.sh` that runs `okf
validate` against a fixture, which is what actually catches an inconsistent
`okfVersion`.
