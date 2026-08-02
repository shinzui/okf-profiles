---
type: Architecture Decision Record
title: The house status key diverges from OKF v0.2
description: Five profiles keep their own status vocabulary; only the two PostgreSQL profiles adopt OKF's.
docId: ADR-1
status: Accepted
date: 2026-08-01
generated:
  by: human:nadeem
  at: "2026-08-01T00:00:00Z"
---

# The house status key diverges from OKF v0.2

## Context

OKF v0.2 §5.4 defines a `status` frontmatter key with the closed vocabulary
`draft` / `stable` / `deprecated`, and §5.5 adds `stale_after`. Five profiles in
this catalog already use the key name `status` for lifecycle vocabularies that
predate v0.2 and mean something else entirely:

| Profile | House `status` values |
|---------|----------------------|
| `documentation.architectureDecisions` | repository-native, e.g. `Accepted` |
| `documentation.patternCatalog` | `current`, `deprecated` |
| `documentation.researchDocuments` | `active`, `complete`, `superseded` |
| `coordination.improvementRequests` | `proposed`, `accepted`, `in-progress`, `completed`, `rejected`, `withdrawn`, `superseded` |
| `coordination.useCases` | `draft`, `validated`, `planned`, `in-progress`, `delivered`, `retired` |

Adopting OKF's vocabulary on those five would require rewriting the key's values
across every consumer corpus. Every one of these profiles is imported by pinned
URL from repositories this one does not control.

## Decision

**The five colliding profiles keep their house vocabulary and do not declare
OKF's `status` or `stale_after`.** The two PostgreSQL profiles — `postgresql`
and `tanPostgresql` — declare neither key today, so they have no collision, and
they adopt both in full.

## Rationale

A profile key name does not imply the OKF core key of that name. okf sanctions
this reading explicitly: its own profile guide gives
`field.enum "status" [ "proposed", "accepted", "superseded" ]` as meaning an ADR
lifecycle rather than OKF v0.2's `status`, and specification §11 requires nothing
of the key. What okf checks instead is value *formats*, because a format has no
house-convention reading.

Renaming was considered and rejected. It would break every consumer corpus,
every cross-repository citation, and every downstream query, for no conformance
gain — the format does not demand the key, so conforming to it buys nothing a
consumer can observe.

Adopting the OKF family somewhere in the catalog still mattered, so that this
repository ships something that demonstrably follows §5.4 and §5.5 rather than
only documenting a divergence. The PostgreSQL profiles are the right home: a
database description is exactly the content whose accuracy decays on a schedule
whether or not anyone edits the document, which is the case `stale_after` was
designed for.

## Consequences

`okf trust` prints a house `status` value verbatim as a status it does not
recognise. This is accepted.

The catalog now has two branches, and the difference is load-bearing for anyone
writing a migration. Telling a consumer to rewrite an ADR's `status: Accepted`
to `status: stable` would destroy that corpus's lifecycle information. Both
Seihou blueprints therefore state the prohibition twice — once per profile and
once in a prohibition list — and
`blueprints/migrate-okf-bundles-to-v0-2/files/v0-2-migration-reference.md`
tabulates every house vocabulary in the catalog.

`coordination.useCases` already allows `draft`, overlapping OKF's vocabulary by
coincidence. That is not partial conformance and the vocabulary should not be
extended toward OKF's.

A future profile added to this catalog must choose a branch deliberately: if it
declares a house `status`, it does not get OKF's; if it does not, it should
declare OKF's. See [the atomic v0.2 flip](0002-a-profile-flips-to-okf-v0-2-atomically.md)
for the related compile-time constraint.
