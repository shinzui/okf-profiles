# okf-profiles

> Authoritative, versioned [OKF](https://github.com/shinzui/okf) house profiles, authored in Dhall and importable from any project.

An **OKF profile** is a declarative description of how a team uses the Open
Knowledge Format: which `type:` strings are allowed, which frontmatter keys are
required, what `resource:` URI scheme each type needs, where each type's files
must live, and what columns a `# Schema` table must have. The `okf` CLI checks a
bundle against a profile with:

```bash
okf validate <bundle> --profile <descriptor>.dhall
```

This repository is the single source of truth for those profiles. Projects do not
copy them — they **import** a pinned version from here, so a convention is defined
once and consumed everywhere.

> **Profiles are not part of the OKF standard.** The OKF spec deliberately defines
> no taxonomy of concept types. A bundle that deviates from a profile is still
> fully OKF-conformant. Profiles are house conventions layered on top, and
> `okf validate --profile` reports deviations as **advisory** by default
> (`--profile-enforce` makes them fail).


## Where this sits

Three repositories, three responsibilities — keep them distinct:

| Repository | Owns |
|---|---|
| [`okf`](https://github.com/shinzui/okf) | The format engine and CLI: parsing, validation, the `--profile` mechanism, exit codes. Ships a *self-contained sample* profile at `docs/profiles/postgresql.dhall` for its own tests and docs. |
| **`okf-profiles`** (this repo) | The *authoritative* profiles and the conventions they encode. The thing every project imports. |
| `mori` | Discovery and addressing: registers OKF bundles, indexes their concepts, and resolves project-and-bundle-scoped stable document handles. |

The sample inside `okf` and the profiles here intentionally start identical for
PostgreSQL; this repo is where they evolve and get versioned.


## Layout

```text
package.dhall                 # entry point: re-exports the schema records and all profiles
Profile/
  okf.dhall                   # pinned remote import of okf's canonical schema (the only URL+hash)
  Type.dhall                  # re-export of okf's profile completion module
  TypeRule.dhall              # re-export of okf's per-type completion module
  FrontmatterRules.dhall      # re-export of okf's frontmatter completion module
  ReviewRule.dhall            # shared nested review-provenance contract
profiles/
  documentation/
    package.dhall             # namespaced documentation-profile exports
    architecture-decisions.dhall
                              # flat ADR corpus with stable ADR-N handles
    pattern-catalog.dhall     # implementation-pattern catalog conventions
    research-documents.dhall  # nested research corpus with stable RES-N handles
  coordination/
    package.dhall             # namespaced coordination-profile exports
    improvement-requests.dhall
                              # cross-repository improvement-request conventions
  postgresql.dhall            # stable flat PostgreSQL export
  tan-postgresql.dhall        # stable flat tan PostgreSQL export
fixtures/
  architecture-decisions/    # valid stable-ID ADR fixture
  architecture-decisions-invalid/
                              # rejection fixtures for the ADR contract
  documentation-pattern-catalog/
                              # three-concept end-to-end profile fixture
  research-documents/         # research records and model-review provenance fixture
blueprints/
  adopt-architecture-decisions/
                              # adaptive Seihou migration for existing ADR corpora
```

The pinned okf schema exports each authoring record as a `{ Type, default }`
completion module, and this package re-exports those modules directly so local
defaults cannot drift from okf's decoder. Values are built with
Dhall's **record completion** operator `::` — `Profile::{ name = … }` fills every
field that has a default. This is what makes the schema safe to grow (see
[Schema evolution](#schema-evolution)) and lets a project's profile be
**type-checked against the schema** instead of failing later at decode time.


## Consuming a profile

### Pinned remote import (recommended for CI)

Import a tagged, hash-pinned version. The hash makes the import reproducible and
locally cached; the tag makes it stable so editing this repo never silently
changes a consumer's conventions.

```dhall
-- your-project/okf-profile.dhall
let okf =
      https://raw.githubusercontent.com/shinzui/okf-profiles/v0.1.0/package.dhall
        sha256:04a684786df59fde0216e5f1a0ed62753d5d0ea41ea1b9480616144282ad13e9

in  okf.postgresql
```

Namespaced profile families are available from the same package. For example,
an implementation-pattern corpus consumes the documentation catalog profile as:

```dhall
let okf =
      https://raw.githubusercontent.com/shinzui/okf-profiles/v0.2.0/package.dhall

in  okf.documentation.patternCatalog
```

Run `dhall freeze --inplace` in the consuming repository to add the release's
semantic hash before committing the import.

Override an existing profile without copying — `//` replaces fields on the value:

```dhall
let okf =
      https://raw.githubusercontent.com/shinzui/okf-profiles/v0.1.0/package.dhall
        sha256:04a684786df59fde0216e5f1a0ed62753d5d0ea41ea1b9480616144282ad13e9

in  okf.postgresql
    //  { name = "acme-warehouse" }
    //  { allowUnknownTypes = True }
```

Or build a fresh profile against the imported schema with completion — only the
fields you set; everything else takes the schema default:

```dhall
let okf =
      https://raw.githubusercontent.com/shinzui/okf-profiles/v0.1.0/package.dhall
        sha256:04a684786df59fde0216e5f1a0ed62753d5d0ea41ea1b9480616144282ad13e9

in  okf.Profile::{
    , name = "acme-warehouse"
    , types =
      [ okf.TypeRule::{ type = "PostgreSQL Table", pathPattern = Some "schemas/*/tables/*" } ]
    }
```

Then point the tool at your file:

```bash
okf validate knowledge/warehouse --profile okf-profile.dhall
```

### Generating the hash

After this repo is pushed and tagged, generate the pinned form automatically:

```bash
dhall freeze --inplace your-project/okf-profile.dhall
```

`dhall freeze` fetches each remote import and writes its `sha256:` hash next to it.
Re-run it whenever you bump to a new tag.

### Local / offline use

`okf validate --profile` accepts **any** path. The `okf` tool never requires this
repo or network access — remote import is a convenience this repo enables, not a
dependency the tool imposes. For an offline build, vendor a frozen copy of the
profile into your project and import it by relative path.


## Compatibility

A profile's Dhall record type and okf-core's `FromDhall` decoder
(`okf-core/src/Okf/Profile.hs`) are **two halves of one contract**. If they drift,
decoding breaks at load time. Two rules keep them aligned:

- The `okfVersion` field declares the OKF **spec** version a profile targets
  (currently `"0.1"`).
- This repo's **tag** (`v0.1.0`, …) is what consumers pin. Treat any change to the
  schema types under `Profile/` as a breaking change: bump the major/minor tag and
  note the minimum `okf` version it requires in the release notes.

The schema is pinned to the `okf` 0.3.0.0 release commit. Every profile in this
checkout uses 0.3 rules—descriptions, field cardinality and formats at minimum—so
the catalog must be decoded with okf-core 0.3.0.0 or later. The existing
`postgresql` and `tanPostgresql` fields remain stable flat exports; new profile
families should use a namespaced directory and package field.

> **Single source of truth.** The schema *types* here are a pinned remote import of
> okf's canonical schema, in [`Profile/okf.dhall`](./Profile/okf.dhall) (the only
> URL + integrity hash in this repo); the sibling files re-export okf's own
> completion modules, and `profiles/` holds the values. okf owns the shape and
> defaults, while okf-profiles owns
> the conventions. The import is one-way: okf depends on nothing here. To track a
> newer okf, bump the commit ref in `Profile/okf.dhall` and re-run `dhall freeze`.


## Schema evolution

In Dhall, **record fields are always required** — adding even an `Optional` field
to a record type breaks every existing value that omitted it. That is why each
schema here is a `{ Type, default }` record consumed through the completion operator
`::`. `Profile::{ name = "x" }` desugars to `(Profile.default // { name = "x" }) :
Profile.Type`, so a value only ever names the fields it cares about.

When okf adds a defaulted field, existing `Profile::{ … }` / `TypeRule::{ … }`
values keep compiling unchanged. Upgrade `Profile/okf.dhall` by commit and hash
together; do not duplicate or override the upstream defaults here.

This is the idiomatic Dhall form of the Input/Type/default/mk pattern; completion
is preferred over a fixed minimal-input constructor because profile authors
routinely override the "optional" fields.

**Caveat — the Haskell boundary.** Completion protects *consumer source* from field
additions, but the value still **decodes against okf-core's exact record**: Dhall
record decoding rejects unknown fields. So adding a field is a *coordinated* change
— okf-core's `ProfileSpec` decoder, okf's published `Profile.dhall`, and this repo's
`{ Type, default }` must move together, gated by okf's drift-guard test and released
with a tag bump plus an updated `okfVersion` / minimum-`okf` note. Completion buys
backward compatibility for *authors*, not a license to diverge from the decoder.


## Validating this repo

Type-check every Dhall file (requires the `dhall` CLI, ≥ 1.42):

```bash
dhall type --file package.dhall
dhall type --file profiles/postgresql.dhall
dhall type --file profiles/documentation/pattern-catalog.dhall
dhall type --file profiles/documentation/research-documents.dhall
```

All should print the inferred type and exit `0`. To prove a profile actually
works end-to-end, run it against the `okf` sample bundle from a checkout of the
`okf` repo:

```bash
okf validate examples/postgresql-sample --profile /path/to/okf-profiles/profiles/postgresql.dhall
```

Expected: `OK: <n> concepts` with no `profile:` lines.

The documentation pattern-catalog fixture is self-contained:

```bash
okf validate fixtures/documentation-pattern-catalog \
  --profile profiles/documentation/pattern-catalog.dhall \
  --profile-enforce \
  --log-enforce
```

Expected: `OK: 3 concepts` with no `profile:` lines.

The cross-repository improvement-request fixture exercises stable IDs, typed
fields, lifecycle values, Mori URIs, and structured reviews:

```bash
okf validate fixtures/improvement-requests \
  --profile profiles/coordination/improvement-requests.dhall \
  --profile-enforce
```

Expected: `OK: 2 concepts`. Run
`scripts/test-improvement-requests-profile.sh` with an `okf` 0.3.0.0 binary to
also prove that missing IDs, wrong prefixes, duplicate IDs, missing required
metadata, unknown types, nested paths, malformed timestamps and URIs, invalid
lifecycle values, and malformed nested reviews are rejected.

These acceptance commands intentionally omit `--strict`. In okf 0.3, strict mode
enforces every `recommended` profile rule; catalog recommendations such as
`reviews`, `sources`, and supersession links are genuinely optional. All fields
the catalog requires for authored documents—including `description` and
`timestamp` where applicable—are explicit `required` rules.

`coordination.improvementRequests` requires the frontmatter fields `type`,
`title`, `description`, `timestamp`, `requestId`, `status`, and `origin`.
`reviews` is recommended but optional.
`requestId` is a stable `IR-N` handle and is unique only within one bundle; the
concept path remains OKF's canonical identity. The profile permits unknown
producer fields so consumers may add `originPlan`, `targetPlan`, `contracts`,
or tags. It validates the request lifecycle vocabulary, requires a Mori-scheme
URI for `origin`, and constrains `targetPlan` to a scalar while retaining both
repository-relative paths and Mori URIs. Mori still owns artifact-kind
semantics, project ownership, and external registry resolution.

`reviews` is an optional chronological list of timestamp-bound review records.
It may be absent or empty when no review has occurred; do not invent a
placeholder review for a draft. Preserve old records after a material update
and change the document's `timestamp`; a record is current only when its
`document_timestamp` equals that timestamp. Append a new record only after an
actual review. Review approval approves the request document for the named
scope; it does not change the request's lifecycle `status`.

Use the review shape established by the documentation-pattern governance
convention:

```yaml
reviews:
  - kind: human | model
    reviewer: stable-human-or-agent-identity
    reviewed_at: 2026-07-28T02:32:33Z
    document_timestamp: 2026-07-28T00:11:06Z
    scope: content | technical-accuracy | editorial | catalog-metadata | content-and-metadata
    outcome: approved | changes-requested | commented
    context: >-
      Concise description of the repository, evidence, and architectural basis used.
```

A model review additionally records the serving provider, the most specific
model identifier actually available, and the provider-reported reasoning or
thinking effort:

```yaml
    provider: openai
    model: gpt-5.6-sol
    effort: xhigh
```

Do not infer an undisclosed deployment identifier or effort. Use `unspecified`
when the serving environment does not expose one. okf validates the nested
record shape, vocabularies, cardinalities, and UTC timestamp formats, and makes
`provider`, `model`, and `effort` conditionally required for model reviews.
Freshness—the equality of `document_timestamp` and the document's top-level
`timestamp`—still needs a repository-specific review-status check.

A tagged consumer imports it as:

```dhall
let profiles =
      https://raw.githubusercontent.com/shinzui/okf-profiles/v0.5.0/package.dhall
        sha256:a3e1e6823ec6b31f97a80055e215fa1c95ae7669eac60c3d316d821eb901fb80

in  profiles.coordination.improvementRequests
```

Freeze the import in the consumer with `dhall freeze --inplace` before
committing it.

The research-document profile reuses the review contract above for technical
research, audits, surveys, evaluations, and design explorations. It requires
`type`, `title`, `description`, `timestamp`, `researchId`, `status`, and
`scope`; recommends `reviews`, `sources`, `relatedPlans`, `relatedDecisions`,
and `supersedes`; requires `supersededBy` only when `status: superseded`;
permits nested paths such as `notes/*`; and allocates stable `RES-N` handles.
A review remains optional until a human or
model actually reviews the document, and model reviews record `provider`,
`model`, and `effort` exactly as above.

Run its acceptance and rejection suite with:

```bash
scripts/test-research-documents-profile.sh
```

Run `scripts/test-pattern-catalog-profile.sh` for the corresponding catalog
acceptance fixture and its malformed format/cardinality/vocabulary rejection.
Run `scripts/test-tan-postgresql-profile.sh` to exercise its type-specific table
role vocabularies and the conditional `sourceStreams` requirement.

The fixture proves nested research documents and model-review provenance. The
rejection cases cover missing IDs, wrong prefixes, duplicate IDs, missing
required metadata, unknown types, invalid vocabularies and timestamps, and
incomplete model reviews, plus a missing conditionally required successor. A
tagged consumer imports the profile as
`profiles.documentation.researchDocuments`.

The architecture-decision fixture exercises the same stable-ID machinery for
repository-owned ADRs:

```bash
scripts/test-architecture-decisions-profile.sh
```

The script proves that a valid flat corpus passes and that missing IDs, wrong
prefixes, duplicate IDs, missing required metadata, unknown types, nested paths,
and dangling ADR references fail. A tagged consumer installs the descriptor as
`docs/adr/profile.dhall`:

```dhall
let profiles =
      https://raw.githubusercontent.com/shinzui/okf-profiles/v0.4.0/package.dhall
        sha256:39e79b65672439cde9c1271e3d92abf68ba1e2427541598e0d04de23e741f0cb

in  profiles.documentation.architectureDecisions
```

Existing ADR corpora should be migrated with the adaptive Seihou blueprint in
`blueprints/adopt-architecture-decisions`. Its prompt inventories each repository's
legacy metadata and numbering before it adds frontmatter, resolves collisions,
registers the Mori bundle, and integrates enforced validation. This belongs here—next
to the profile contract—rather than in Mori or in each repository as a one-off
rewriter.


## Profile catalog

| Export | Purpose | Minimum `okf` |
|---|---|---|
| `coordination.improvementRequests` | Flat cross-repository improvement requests with bundle-scoped `IR-N` handles and structured review provenance | 0.3.0.0 |
| `documentation.architectureDecisions` | Flat architecture-decision records with bundle-scoped `ADR-N` handles and checked supersession references | 0.3.0.0 |
| `documentation.patternCatalog` | Mori-addressable catalogs with typed status, URI, timestamp, and tag fields | 0.3.0.0 |
| `documentation.researchDocuments` | Nested research corpora with `RES-N` handles, structured reviews, and conditional supersession | 0.3.0.0 |
| `postgresql` | PostgreSQL schemas, tables, and views with typed timestamps and resource URIs | 0.3.0.0 |
| `tanPostgresql` | PostgreSQL plus per-table role vocabularies and conditional source streams | 0.3.0.0 |


## Adding a profile

1. Add `profiles/<family>/<name>.dhall`, built with `Profile::{ … }` /
   `TypeRule::{ … }` against `../../Profile/Type.dhall`.
2. Re-export it from the family `package.dhall`, then export that package from
   the root `package.dhall`. Keep existing flat exports stable.
3. `dhall type --file profiles/<name>.dhall` must pass.
4. Add a row describing it to this README and bump the tag on release.


## License

[BSD-3-Clause](./LICENSE) — (c) 2026 Nadeem Bitar.
