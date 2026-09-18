---
type: Improvement Request
title: Add a shared terminology profile
description: >-
  Publish documentation.terminology, a profile for controlled project vocabularies with
  stable TERM-N handles, preferred and discouraged wording, typed term relations,
  cross-project equivalence, succession, and code anchors, plus an adopt-terminology blueprint.
timestamp: "2026-09-18T22:18:37Z"
generated:
  by: anthropic-claude-code/claude-opus-5
  at: "2026-09-18T22:18:37Z"
requestId: IR-6
status: proposed
origin: mori://shinzui/mori/plans/268-specify-the-shared-terminology-contract-and-request-it-upstream
acceptanceCriteria:
  - id: AC-1
    statement: The package exports documentation.terminology for OKF type Term with a TERM-N handle in termId.
    verification: Run okf profile show on the export and inspect the type rule, idField, idPrefix, and pathPattern.
  - id: AC-2
    statement: A valid fixture bundle exercises every required, conditional, and optional field of the contract.
    verification: Run the focused terminology fixture script with --strict, --profile-enforce, and --log-enforce.
  - id: AC-3
    statement: One rejection fixture per load-bearing rule fails for exactly one reason.
    verification: Run each fixtures/terminology-invalid case without --profile-enforce and confirm a single advisory.
  - id: AC-4
    statement: Generated profile documentation describes every field and its purpose.
    verification: Run just docs and read the generated terminology page.
  - id: AC-5
    statement: The export is listed in mori.dhall profiles and in the house-status list of Profile/V02.dhall.
    verification: Inspect mori.dhall and the Profile/V02.dhall header after just check.
  - id: AC-6
    statement: An adopt-terminology blueprint adopts the profile without fabricating vocabulary.
    verification: Run the blueprint on a repository with no settled vocabulary and confirm it makes no change, then rerun it on an adopted repository and confirm no handle changes.
  - id: AC-7
    statement: The profile ships in a tagged release after v0.16.0 with a CHANGELOG entry and a pinnable hash.
    verification: Run just check and compare the released remote import hash with the local hash.
reviews:
  - kind: model
    reviewer: process:anthropic-claude-code
    reviewed_at: "2026-09-18T22:18:57Z"
    document_timestamp: "2026-09-18T22:18:37Z"
    scope: content-and-metadata
    outcome: commented
    provider: anthropic
    model: claude-opus-5
    effort: unspecified
    context: >-
      Author self-check, not an independent review: profile conformance under strict
      enforcement, internal consistency with the requesting Mori plan, and the shape of
      every cited mori:// URI. The okf-profiles ADR handles are cited in intended handle
      form; the global registry snapshot of the adrs bundle predated their docId fields.
---

# Improvement Request: Add a Shared Terminology Profile

## Status

**Proposed.** Requested by
`mori://shinzui/mori/plans/268-specify-the-shared-terminology-contract-and-request-it-upstream`
as the source contract for
`mori://shinzui/mori/masterplans/36-publish-project-terminology-as-a-first-class-okf-catalog`.

## Problem

A project's precise vocabulary is currently unqueryable prose. `mori://shinzui/keiro`
distinguishes stream, decider, projection, process manager, durable workflow, and slot
ledger, but those meanings are spread across user guides and ADRs. Its ADR-22 renamed
generated "sidecars" to "slot ledgers", yet its guides still say "sidecar", and nothing
tells an author or an agent which wording to use.

The only structured vocabulary the fleet has is the Mori DDD extension's glossary. That is
Domain-Driven Design vocabulary: a term, a definition, a bounded context, aliases, and
replaced wording. It cannot say which wording is discouraged, how terms relate, which code
embodies a term, or that a term in one project means the same thing as a term in another.
Infrastructure libraries have no domain model to hang a glossary on.

No existing profile fits. A term is not a decision (architecture decisions), an obligation
(specifications), a reusable solution (pattern catalog), a provision claim (capabilities),
or a page for readers (user documentation). Each of those profiles describes behavior or
judgment; a term defines a word and points to where its behavior is described.

## Requested Change

Publish `documentation.terminology`, canonically addressed as
`mori://shinzui/okf-profiles/profiles/terminology`, and an `adopt-terminology` blueprint.

### Proposed contract

One concept type, `Term`, one file per term at the bundle root (`pathPattern = "*"`).
The handle field is `termId` with prefix `TERM` (`TERM-1`, `TERM-2`, …), allocated with
`okf id next` and never reused, following the shared-handle convention of
`mori://shinzui/okf-profiles/okf/adrs/concepts/ADR-11`.

Required frontmatter:

- `type` — `Term`.
- `title` — the canonical term, spelled and cased exactly as it should be written.
- `description` — a one-sentence definition.
- `generated` — OKF v0.2 provenance, spliced from `Profile/V02.dhall`.
- `termId` — the stable `TERM-N` handle.
- `status` — a house vocabulary, `current` or `deprecated`. Per
  `mori://shinzui/okf-profiles/okf/adrs/concepts/ADR-1`, the profile deliberately uses a
  house `status` and must be added to the house-status list in `Profile/V02.dhall`. OKF's
  `draft`/`stable` distinction has no meaning for a word: a term is either the one to use or
  one that has been retired.

Conditionally required:

- `replacedBy` — a scalar reference (local `TERM-N` or canonical `mori://` concept URI),
  required when `status` is `deprecated`. A retired term must say what to say instead.

Optional scalars:

- `abbreviation` — an accepted short form, for example `PM`.
- `scope` — free text naming the subsystem or bounded context in which the meaning holds.

Optional text lists:

- `aliases` — accepted synonyms with identical meaning.
- `discouraged` — wording that must not be used for this concept; the body explains why.
- `tags`.

Optional reference lists, each entry a local `TERM-N` handle or a canonical
`mori://<namespace>/<project>/okf/<bundle>/concepts/TERM-N` URI:

- `broader` — more general terms this term specialises.
- `related` — associated terms that are neither broader nor equivalent.
- `replaces` — terms this term succeeds.
- `sameAs` — **external only**: the same concept published by another project. A local
  reference is rejected (`allowLocal = False`), because an equivalent inside one bundle is an
  alias, not a second term. External pattern:
  `mori://[^/]+/[^/]+/okf/[^/]+/concepts/TERM-[1-9][0-9]*`.

Optional `anchors`, a list of records `{ kind, resource, note? }` naming what embodies the
term, where `kind` is one of `module`, `type`, `function`, `file`, `doc`, or `uri` and
`resource` is the module name, qualified identifier, repository-relative path, or absolute URI.

Deliberately absent:

- `narrower` is not authored. Consumers derive it as the inverse of `broader`, so the two
  directions cannot disagree.
- No body/frontmatter mirror is required. The body should link related terms, but the
  typed fields already carry the edges, and a mirror rule is the most expensive part of the
  capabilities profile to author and validate.
- No `guidance`, per `mori://shinzui/okf-profiles/okf/adrs/concepts/ADR-12`.

Presence classes follow `mori://shinzui/okf-profiles/okf/adrs/concepts/ADR-8`: none of the
optional fields is `recommended`, because a well-formed term routinely has no abbreviation,
no alias, no discouraged wording, and no relation.

### Non-normative Dhall sketch

```dhall
let Profile = ../../Profile/package.dhall

let v02 = ../../Profile/V02.dhall

let termRef =
      Some Profile.HandleReferenceRule::{
      , localPrefix = "TERM"
      , externalUriSchemes = [ "mori" ]
      }

in  Profile.Profile::{
    , okfVersion = "0.2"
    , idField = Some "termId"
    , idPrefix = Some "TERM"
    , pathPattern = Some "*"
    , types =
      [ Profile.TypeRule::{
        , type = "Term"
        , frontmatter = Profile.FrontmatterRules::{
          , required =
            [ scalar "title" "The canonical term, exactly as it should be written."
            , scalar "description" "A one-sentence definition."
            , v02.generated
            , Profile.FieldRule::{
              , field = "termId"
              , format = Some (Profile.FieldFormat.DocumentHandle "TERM")
              }
            , Profile.FieldRule::{
              , field = "status"
              , allowedValues = [ "current", "deprecated" ]
              }
            , Profile.FieldRule::{
              , field = "replacedBy"
              , reference = termRef
              , when = Some { field = "status", hasValue = [ "deprecated" ] }
              }
            ]
          , optional =
            [ scalar "abbreviation" "An accepted short form."
            , scalar "scope" "Where this meaning holds."
            , textList "aliases" "Accepted synonyms with identical meaning."
            , textList "discouraged" "Wording that must not be used for this concept."
            , textList "tags" "Free classification tags."
            , refList "broader" termRef
            , refList "related" termRef
            , refList "replaces" termRef
            , refList
                "sameAs"
                ( Some
                    Profile.HandleReferenceRule::{
                    , allowLocal = False
                    , externalUriSchemes = [ "mori" ]
                    , externalUriPattern = Some
                        "mori://[^/]+/[^/]+/okf/[^/]+/concepts/TERM-[1-9][0-9]*"
                    }
                )
            , Profile.FieldRule::{
              , field = "anchors"
              , elementFields = Some Profile.NestedRules::{
                , required =
                  [ Profile.FieldRule::{
                    , field = "kind"
                    , allowedValues =
                      [ "module", "type", "function", "file", "doc", "uri" ]
                    }
                  , scalar "resource" "What embodies the term."
                  ]
                , optional = [ scalar "note" "Why this anchor matters." ]
                }
              }
            ]
          }
        }
      ]
    }
```

The helper names (`scalar`, `textList`, `refList`) are illustrative; use whatever the
catalog's `Profile/` helpers provide.

### Fixtures

The valid fixture should cover every field at least once: a term with module and file
anchors, a scoped term, a term with `broader`, a term with `discouraged` and `aliases`, a
deprecated term with `replacedBy`, its successor with `replaces` and `related`, and a term
with an `abbreviation`, an external `sameAs`, and a `uri` anchor. Mori's fixture corpus at
`mori://shinzui/mori` path `mori-core/test/fixtures/okf/terminology/valid/` (artifact-level
URI pending) follows exactly this shape and may be copied.

Per `mori://shinzui/okf-profiles/okf/adrs/concepts/ADR-9`, each rejection fixture fails for
exactly one reason. At least: missing `termId`; a handle with the wrong prefix; `status`
outside the vocabulary; `deprecated` without `replacedBy`; a local `sameAs`; an anchor with
an unknown `kind`; and a malformed reference in `broader`.

### What the profile is not

In the spirit of `mori://shinzui/okf-profiles/okf/adrs/concepts/ADR-13`, generated
documentation should say plainly that a terminology catalog is a controlled vocabulary, not
a general ontology or knowledge graph. It does not record decisions, obligations, patterns,
capabilities, or reader-facing guides; those keep their own profiles and a term links to
them from its body or through a `doc` anchor.

### Consumer contract

- Bundle name `terminology`, path `docs/terminology`, OKF v0.2, with `index.md` and `log.md`.
- Local profile selector `mori/terminology-profile.dhall` selecting
  `Profiles.documentation.terminology` from the pinned release.
- A `Schema.ProfileBinding.Published` binding on the bundle in `mori.dhall`.
- A verify recipe running
  `okf validate docs/terminology --strict --profile mori/terminology-profile.dhall --profile-enforce --log-enforce`
  followed by Mori's semantic gate `mori terms validate --path .`.

### Blueprint

`adopt-terminology` should treat fabrication as the central risk. It inventories terms that
the repository's own documentation, ADRs, and module names already define, writes only
those, and makes no change when a repository has no settled vocabulary. It reconciles
idempotently: rerunning it on an adopted repository keeps every existing handle and edits
only what the sources changed. It records discouraged wording only when a source says the
wording is wrong (a rename ADR, a deprecation note), never from taste.

## Release Precondition

On 2026-09-18 `master` already referred to `v0.16.0` in every blueprint, `mori.dhall`, and
the README, but no `v0.16.0` tag existed locally or on origin, and `master` was one commit
ahead of origin. The newest published tag was `v0.15.0`. Release v0.16.0 first; this profile
ships in v0.17.0 or later.

## How Mori Consumes It

`mori://shinzui/mori/masterplans/36-publish-project-terminology-as-a-first-class-okf-catalog`
adds a typed read layer over stored `Term` frontmatter (`mori terms list`, `show`, `search`),
a repository-local semantic gate (`mori terms validate`: anchor existence, relation
resolution, `broader` cycles, the `replaces`/`replacedBy` mirror, and discouraged-wording
conflicts), and a terminology section in `mori agent context`. The decision is recorded in
`mori://shinzui/mori/okf/adrs/concepts/ADR-52`. The profile owns document shape; Mori owns the
checks that need the repository or the registry. Mori's decoder completes only once this
profile is released, so the release is an external gate on that plan.
