---
type: Architecture Decision Record
title: User documentation shares reader-intent types and DOC handles
description: One fleet-wide profile classifies user-facing pages by reader intent while preserving identity with bundle-scoped DOC-N handles.
docId: ADR-11
status: Accepted
date: 2026-08-26
originatingPlan: docs/plans/9-publish-a-shared-user-documentation-profile-and-migrate-keiro.md
generated:
  by: openai-codex/gpt-5
  at: 2026-08-26T12:42:51Z
---

# User documentation shares reader-intent types and DOC handles

## Context

Projects commonly keep product documentation in `docs/user/` and `docs/guides/`, but path names
do not state what kind of help a page provides. The same subject may have a tutorial, conceptual
explanation, API reference, and production runbook. Treating every page as an undifferentiated
`Guide` makes search results ambiguous and gives an authoring agent no contract for deciding what
a page should contain.

A profile per repository would permit local validation, but it would fragment the vocabulary and
make fleet-wide queries dependent on each project's spelling. Deriving identity from a path or
type would create a second problem: reorganizing a documentation tree or correcting a page's
classification would break durable references.

## Decision

Publish one shared profile as `documentation.userDocumentation`, canonically addressed as
`mori://shinzui/okf-profiles/profiles/user-documentation`.

Classify each page by its primary reader intent:

- `Navigation` routes a reader to the right documentation;
- `Tutorial` teaches by leading a reader through an initial working experience;
- `Guide` helps a reader complete a specific goal;
- `Explanation` develops conceptual understanding and decision-making judgment;
- `Reference` is authoritative lookup material; and
- `Runbook` is an operational procedure whose ordering, safety conditions, and recovery matter.

Every type uses the same bundle-scoped `DOC-N` handle stored in `docId`. Paths remain
unconstrained, so both flat public manuals and nested documentation sites can consume the same
profile. A page keeps its handle when its path or primary intent changes.

Require the metadata every complete page can truthfully provide: `type`, `title`, `description`,
`docId`, `tags`, and OKF v0.2 `generated`. Keep `sources`, `verified`, `status`, `stale_after`,
`supersedes`, `supersededBy`, and legacy `timestamp` optional. Local supersession references use
`DOC-N`; cross-project supersession uses canonical `mori://` URIs.

## Rationale

Reader intent is more stable and useful than directory names. It distinguishes learning from
lookup and routine task completion from operational recovery without encoding a project's
particular information architecture. Six types are enough to guide authors while remaining small
enough for consistent fleet-wide queries.

One prefix deliberately decouples identity from classification. Type-specific prefixes such as
`TUTORIAL-N` or `RUNBOOK-N` would make a corrected classification look like a new document and
would force every durable reference to change.

Required search tags make the indexed corpus useful even when titles use project-specific terms.
The optional fields follow the rule in [ADR-8](0008-recommended-means-a-well-run-corpus-carries-it.md):
a current page may have no external source, independent verifier, expiry date, or predecessor and
is not deficient for omitting them.

## Consequences

Consumers import a tagged, hash-pinned catalog release rather than copying the descriptor. Mori
can then report which projects consume the profile and which pins are stale.

`DOC-N` is unique only inside one bundle. A project with separate `user-documentation` and
`guides` bundles may legitimately have `DOC-1` in both; canonical URIs remain unambiguous because
they include the bundle name.

The profile does not prove prose matches code. Producers must record meaningful sources and
verification when those exist, and project-specific checks may layer code-to-document drift rules
on top of this shared structural contract.

Keiro at `mori://shinzui/keiro` is the first consumer and keeps its two existing directories as
separate bundles. Its curated `README.md` pages remain `Navigation` concepts; generated
`index.md` files provide inventory without replacing those reading routes.
