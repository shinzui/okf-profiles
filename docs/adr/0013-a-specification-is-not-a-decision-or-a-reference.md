---
type: Architecture Decision Record
title: A specification is not a decision, research, or a reference page
description: Normative specifications get their own profile and SPEC-N handles, distinguished from three documentation siblings by a ratified version and an explicit normative scope.
docId: ADR-13
status: Accepted
date: 2026-09-17
generated:
  by: anthropic/claude-opus-5
  at: 2026-09-17T00:00:00Z
---

# A specification is not a decision, research, or a reference page

## Context

Projects across the fleet keep a `docs/specs/` directory or a `docs/initial-spec.md`
holding the contract a service is obliged to satisfy. Fifteen first-party
repositories carry an initial specification today, and they agree on nothing:
some declare `type: initial-spec`, some `type: service-spec`, some carry no
frontmatter at all, and the ratification state — which version was ratified, and
which parts of the prose bind — is written as free-running English inside
`status:`, where no tool can read it.

The catalog already has three documentation profiles whose subject matter
overlaps. None of them answers the question a specification answers:

- `documentation.architectureDecisions` records a choice and its rationale. A
  decision is complete the moment it is made. A specification is a standing
  obligation that keeps being true until superseded.
- `documentation.researchDocuments` records evidence and alternatives within a
  bounded question. Research describes what is; a specification prescribes what
  must be, often for an implementation that does not exist yet.
- `documentation.userDocumentation` classifies pages by reader intent. Its
  `Reference` type describes an interface as built, for a reader looking
  something up.

A fourth option was to treat "specs" as a directory rather than a genus and
accept everything filed there. Inspecting one such directory showed why that
fails: twelve documents carrying five `type:` values, of which only eight stated
required behavior at all. The rest were investigations, a delivery tracking
brief, and a traceability matrix. A profile accepting all twelve would encode a
filing habit, not a contract.

## Decision

Publish `documentation.specifications`, canonically addressed as
`mori://shinzui/okf-profiles/profiles/specifications`, for documents that state
what an owning boundary must do.

Demand on every document: `type`, `title`, `description`, a bundle-scoped
`specId` (`SPEC-N`), a house `status` from `draft` / `proposed` / `ratified` /
`superseded` / `withdrawn`, `owner` as one or more canonical URIs naming the
boundaries obliged to satisfy the contract, and OKF v0.2 `generated`.

Demand two further fields on a `Specification` once `status` is `ratified`:

- `specVersion` — the version of the contract that was ratified, spelled as
  implementations cite it; and
- `normativeScope` — the parts of the document that bind. Anything not named
  there is informative.

Both are declared on the type rather than profile-wide, because they describe
the specification text. A ratified `Specification Pointer` carries neither: it
holds no text to version or scope, and states both through the authoritative
document it names.

These two are what justify a new profile rather than an override on a sibling.
They are also the practical test for whether a document belongs here at all: a
document that cannot say which of its parts bind, at which version, is a
decision, a piece of research, or a draft.

`normativeScope` has no companion list of non-binding sections. A complement is
derivable, and two lists can disagree.

Provide two types, `Specification` and `Specification Pointer`, sharing the one
`SPEC-N` prefix. A pointer records a boundary accepted in this repository whose
authoritative text is owned by another, and carries `authoritativeSpec` naming
it. One prefix means a specification keeps its handle, and every durable
reference to it, when its text is promoted out of a repository or absorbed back
into one — the identity-versus-classification rule of
[ADR-11](0011-user-documentation-shares-reader-intent-types-and-doc-handles.md).

Keep `conformance`, `supersedes`, `reviews`, `sources`, `verified`, and the
legacy `timestamp` optional. Demand `supersededBy` once `status` is
`superseded`.

Recommend nothing.

## Rationale

Ratification is the event OKF v0.2 §5.4 has no word for. `draft` / `stable` /
`deprecated` cannot express that a named version of a contract was accepted and
that two thirds of the prose around it is commentary. That is why this profile
takes the house `status` branch of
[ADR-1](0001-house-status-diverges-from-okf-v0-2.md) rather than OKF's.

Conditioning `specVersion` and `normativeScope` on ratification rather than
demanding them unconditionally follows
[ADR-8](0008-recommended-means-a-well-run-corpus-carries-it.md): a draft
specification that has neither is complete and correct for what it is. The same
test moves `reviews` to `optional`, against the precedent of
`documentation.researchDocuments` where it is recommended. A corpus adopting
this profile retroactively cannot truthfully supply review records it never
kept, and a rule that can only be satisfied by inventing data is worse than no
rule.

`owner` takes `Uri` rather than `UriWithScheme "mori"`, unlike
`coordination.useCases`'s `origin`. The documentation family is consumed by
projects that may not run a Mori registry; `mori://` satisfies the rule without
the profile mandating a particular one.

## Consequences

A repository adopting this profile must sort its `docs/specs/` directory before
it can validate, because the profile deliberately cannot accept everything filed
there. That sorting is the point, and the catalog has a home for each of the
other kinds.

`SPEC-N` is unique only inside one bundle, and a specification addressed as a
Mori document keeps that address alongside its handle. A project that registers
its specifications both ways should decide which address is canonical for
citation rather than letting the two accumulate independently.

No Seihou blueprint ships with this release. `adopt-user-documentation` was
published alongside ADR-11 as a first-adoption playbook; the equivalent for
specifications waits until a second repository adopts the profile and the
migration shape is observed rather than guessed.
