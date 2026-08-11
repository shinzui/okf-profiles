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
  V02.dhall                   # the six OKF v0.2 field families, defined once for the catalog
profiles/
  documentation/
    package.dhall             # namespaced documentation-profile exports
    architecture-decisions.dhall
                              # flat ADR corpus with stable ADR-N handles
    pattern-catalog.dhall     # implementation-pattern catalog conventions
    research-documents.dhall  # nested research corpus with stable RES-N handles
  coordination/
    package.dhall             # namespaced coordination-profile exports
    bug-reports.dhall         # defects in behavior a repository already provides
    capabilities.dhall        # what a repository provides today, with evidence
    improvement-requests.dhall
                              # cross-repository improvement-request conventions
    use-cases.dhall           # JTBD use cases and feature-delivery tracking
  okf-v0-2.dhall              # format-level v0.2 reference profile, no house conventions
  postgresql.dhall            # stable flat PostgreSQL export
  tan-postgresql.dhall        # stable flat tan PostgreSQL export
fixtures/                     # one acceptance bundle and one -invalid/ tree per profile
scripts/                      # one test-*.sh per profile, plus the ADR bundle check
docs/
  adr/                        # this repository's own decisions, governed by its own profile
  masterplans/, plans/        # the initiative that produced this release
blueprints/
  adopt-architecture-decisions/
                              # adaptive Seihou migration for existing ADR corpora
  migrate-okf-bundles-to-v0-2/
                              # detects and migrates every profiled bundle in a repository
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
      https://raw.githubusercontent.com/shinzui/okf-profiles/v0.8.0/package.dhall
        sha256:… -- run `dhall freeze` to fill this in

in  okf.postgresql
```

Namespaced profile families are available from the same package. For example,
an implementation-pattern corpus consumes the documentation catalog profile as:

```dhall
let okf =
      https://raw.githubusercontent.com/shinzui/okf-profiles/v0.8.0/package.dhall

in  okf.documentation.patternCatalog
```

Run `dhall freeze` in the consuming repository to add the release's
semantic hash before committing the import.

Override an existing profile without copying — `//` replaces fields on the value:

```dhall
let okf =
      https://raw.githubusercontent.com/shinzui/okf-profiles/v0.8.0/package.dhall
        sha256:… -- run `dhall freeze` to fill this in

in  okf.postgresql
    //  { name = "acme-warehouse" }
    //  { allowUnknownTypes = True }
```

Or build a fresh profile against the imported schema with completion — only the
fields you set; everything else takes the schema default:

```dhall
let okf =
      https://raw.githubusercontent.com/shinzui/okf-profiles/v0.8.0/package.dhall
        sha256:… -- run `dhall freeze` to fill this in

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
dhall freeze your-project/okf-profile.dhall
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

- The `okfVersion` field declares the OKF **spec** version a profile targets.
  Every profile in this catalog declares `"0.2"`.
- This repo's **tag** (`v0.8.0`, …) is what consumers pin. Treat any change to the
  schema types under `Profile/` as a breaking change: bump the major/minor tag and
  note the minimum `okf` version it requires in the release notes.

**This catalog targets OKF v0.2 and requires okf-core 0.5.0.0 or later.** The
schema is pinned to the `okf` 0.5.0.0 release commit, and the package exports the
full v0.2 descriptor vocabulary — `Profile.requireBundleVersion`,
`FieldRule.objectFields`, `FieldRule.path` with its `PathReferenceRule` record,
and the `actor`, `human-actor`, `integer`, `non-negative-integer`, and `boolean`
field formats — so a downstream author can write a v0.2 rule by importing this
package alone. The existing `postgresql` and `tanPostgresql` fields remain stable
flat exports; new profile families should use a namespaced directory and package
field.

> **`okfVersion` is compile-checked against the rules a profile declares, in both
> directions.** This is the thing most likely to surprise someone forking a
> profile. okf 0.5.0.0 rejects a profile that declares `okfVersion = "0.2"` while
> keeping the superseded `timestamp` key in its `required` or `recommended` list,
> *and* rejects one that uses the `actor` format while declaring `"0.1"`:
>
> ```text
> Failed to load profile probe.dhall: invalid profile definition:
>   - profile frontmatter: declared okfVersion 0.2 supersedes the frontmatter key timestamp
>     (OKF 0.2); move it to the optional list or replace it with generated
> ```
>
> A profile therefore adopts v0.2 atomically — there is no half-migrated state
> that loads. A `dhall type` pass will not catch this; okf enforces it when it
> *loads* the profile, so verify a profile edit with `okf profile show` or
> `okf validate`. See
> [ADR-2](./docs/adr/0002-a-profile-flips-to-okf-v0-2-atomically.md).

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

**The v0.2 vocabulary is the worked example.** Moving `Profile/okf.dhall` from okf
0.4.0.0 to 0.5.0.0 added `Profile.requireBundleVersion`, `FieldRule.objectFields`,
`FieldRule.path`, the `PathReferenceRule` record, and five field formats. Because
every value here is built with `::`, not one of the seven existing profiles needed
an edit to keep compiling — the pin bump was verified behaviour-preserving before
any profile adopted the new vocabulary. That is the property completion buys, and
it is why the schema pin moves in its own change, separately from anything that
uses what the pin delivers.


## Validating this repo

Every check lives under `scripts/`. Run them all:

```bash
for s in scripts/*.sh; do bash "$s"; done
```

There is a `justfile` front door onto the same checks — `just check` is what a
release has to pass, and `just --list` shows the rest. Nothing is only runnable
through `just`.

```bash
just check    # types + every script under scripts/
just types    # dhall type sweep only
just test     # every script under scripts/
just docs     # regenerate docs/profiles/ (see below)
```

Each prints one `OK:` line per bundle it validates plus a summary line. A passing
run looks like this — note the `(okf_version 0.2)` suffix, which is how you know
the bundle's root `index.md` declares the dialect the profile requires:

```text
OK: 9 concepts (okf_version 0.2)
OK: architecture decision bundle
OK: 2 concepts (okf_version 0.2)
OK: architecture-decision profile acceptance and rejection fixtures
…
```

| Script | Validates |
|---|---|
| `test-adr-bundle.sh` | **This repository's own `docs/adr` corpus** — see below |
| `test-profile-docs.sh` | **`docs/profiles/` is current** — see below; `--regenerate` rewrites it |
| `test-architecture-decisions-profile.sh` | `documentation.architectureDecisions` |
| `test-bug-reports-profile.sh` | `coordination.bugReports` |
| `test-capabilities-profile.sh` | `coordination.capabilities` |
| `test-improvement-requests-profile.sh` | `coordination.improvementRequests` |
| `test-okf-v0-2-profile.sh` | `okfV02`, the format-level reference profile |
| `test-pattern-catalog-profile.sh` | `documentation.patternCatalog` |
| `test-postgresql-profile.sh` | `postgresql` |
| `test-research-documents-profile.sh` | `documentation.researchDocuments` |
| `test-tan-postgresql-profile.sh` | `tanPostgresql` |
| `test-use-cases-profile.sh` | `coordination.useCases` |

Each profile script validates one acceptance fixture under
`--strict --profile-enforce`, then asserts that every bundle in the matching
`fixtures/<name>-invalid/` tree is rejected. The rejection fixtures are not
decorative: each one is written to fail for exactly one reason, and every rule a
profile splices from `Profile/V02.dhall` has a fixture that goes green if the rule
is deleted. See
[ADR-9](./docs/adr/0009-a-rejection-fixture-must-fail-for-exactly-one-reason.md)
for the two checks that keep them honest.

Type-check every Dhall file (requires the `dhall` CLI, ≥ 1.42):

```bash
for f in package.dhall mori.dhall seihou-registry.dhall docs/adr/profile.dhall \
         Profile/*.dhall profiles/*.dhall profiles/*/*.dhall; do
  dhall type --file "$f" > /dev/null || echo "FAILED: $f"
done
```

No output means everything type-checks. Note that a clean `dhall type` sweep is
**not** sufficient on its own — okf enforces the `okfVersion` consistency check
when it loads a profile, not when Dhall type-checks it, which is why the scripts
above are the real gate.

### This repository uses its own profile

`docs/adr/` is a profile-governed OKF bundle holding the decisions behind this
catalog. Its descriptor imports `../../package.dhall` by **relative path** — the
one place in the world that form is correct, since a remote pin here would be
circular and would govern these decisions with the *previous* release.

The consequence is deliberate: `scripts/test-adr-bundle.sh` validates a real
corpus against the profile under development, so it is a regression test on
`profiles/documentation/architecture-decisions.dhall` rather than a documentation
check. A profile change that would break a real ADR corpus fails here before it
reaches a consumer.

```bash
okf validate docs/adr --strict --profile docs/adr/profile.dhall \
  --profile-enforce --log-enforce
```

### Generated profile documentation

`docs/profiles/<name>/` holds one OKF bundle per published profile, generated
from the profile itself by `okf profile document`. Each has a `profile.md` with
the settings and the profile-wide frontmatter rules, and a `types/<type>.md` per
concept type showing that type's rules **merged** with the profile-wide ones —
the form that actually applies to a concept. The directory names match
`profiles/<family>/<name>.dhall`, `fixtures/<name>/`, and
`scripts/test-<name>-profile.sh`.

**Do not edit these by hand.** Every field description in them comes from the
`description` on the rule, so the way to reword one is to reword the profile and
regenerate:

```bash
just docs                                  # or: bash scripts/test-profile-docs.sh --regenerate
```

`scripts/test-profile-docs.sh` with no arguments regenerates into a temporary
directory and diffs, so a profile change that lands without regenerated
documentation fails in the same loop as everything else. That gate works only
because generation is reproducible: it reads no clock, `generated.at` is omitted
by design, and `generated.by` is the tool's stable `process:` actor rather than a
version that would churn every page on an okf bump.


## Migrating an existing corpus

v0.8.0 is **breaking for a consumer corpus**: `generated` is now required on five
profiles, `sources` changed shape on two, and every bundle is expected to declare
`okf_version: "0.2"` in its root `index.md`. A repository that pins one of these
profiles will start reporting deviations it never reported before, and under
`--profile-enforce` its build goes red with lines like:

```text
profile: bundle does not declare okf_version; this profile requires 0.2 or later
profile: 0001-use-stable-identifiers: missing profile-required field: generated (§5.2. Who produced this decision record's current content, and when.)
```

Two Seihou blueprints do the migration for you. Both are agent-driven: a Markdown
prompt plus reference files, run inside your repository by a tool-capable model
that reads the actual corpus and repairs it.

| Blueprint | Command | Covers |
|---|---|---|
| [`adopt-architecture-decisions`](./blueprints/adopt-architecture-decisions/) | `seihou agent migrate adopt-architecture-decisions --from 0.7.0 --to 0.8.0` | One adopted `docs/adr` bundle: moves the pin to v0.8.0, adds provenance, retires the presence override this blueprint used to install |
| [`migrate-okf-bundles-to-v0-2`](./blueprints/migrate-okf-bundles-to-v0-2/) | `seihou agent run migrate-okf-bundles-to-v0-2` | **Every** profiled bundle it can find — improvement requests, use cases, a pattern catalog, research documents, a PostgreSQL description — detected from `mori.dhall`, a local `profile.dhall`, or a check target |

Preview either without touching your repository:

```bash
seihou agent --debug run migrate-okf-bundles-to-v0-2
```

Doing it by hand is four changes per bundle:

1. **Add `generated`** to every concept — `by` is an OKF §7 actor (`human:<id>`,
   `process:<id>`, or `<producer>/<version>`), and `at` reuses the document's
   existing `timestamp` rather than being restamped to now.
2. **Keep `timestamp`.** It is demoted to `optional`, not removed: its format is
   still checked, its absence is never reported. See
   [ADR-3](./docs/adr/0003-timestamp-is-demoted-not-deleted.md).
3. **Declare the dialect**: `okf index <bundle> --write --okf-version 0.2`.
4. **Optionally adopt `verified`**, which is new and demanded nowhere.

`documentation.patternCatalog` and `documentation.researchDocuments` additionally
reshape `sources` from a list of strings into the v0.2 list of records:
`sources: [X]` becomes `sources: [{resource: X}]`.

> **Do not rewrite `status`.** Five profiles keep their own lifecycle vocabulary
> on that key and deliberately do not adopt OKF v0.2 §5.4's
> `draft`/`stable`/`deprecated`. Rewriting an ADR's `status: Accepted` to
> `status: stable` destroys your corpus's lifecycle information. Only `postgresql`
> and `tanPostgresql` take OKF's vocabulary. See
> [ADR-1](./docs/adr/0001-house-status-diverges-from-okf-v0-2.md).


## Profile catalog

Every profile targets OKF v0.2, declares `okfVersion = "0.2"`, sets
`requireBundleVersion = Some "0.2"`, and requires **okf 0.5.0.0 or later**.

| Export | Purpose | `generated` | Also demands |
|---|---|---|---|
| `coordination.bugReports` | Defects in behavior a repository already provides, with `BUG-N` handles, a severity scale graded by observable consequence, and a reproduction a reader can follow | required | `reviews`; `resolution` once a report reaches a terminal status; `workaround` once severity is `degraded` |
| `coordination.capabilities` | What a repository provides today, with `CAP-N` handles, a compatibility promise separate from availability, and required evidence | required | `reviews`; `interface`; `replacedBy` once a capability is deprecated or withdrawn |
| `coordination.improvementRequests` | Flat cross-repository improvement requests with bundle-scoped `IR-N` handles, completion state, and structured review provenance | required | `reviews`; `resolution` once a request reaches a terminal state |
| `coordination.useCases` | JTBD use cases with `UC-N` handles, typed feature delivery, and repository-owned request references | required (profile-wide, so themes too) | `reviews`; `themes` on a use case |
| `documentation.architectureDecisions` | Flat architecture-decision records with bundle-scoped `ADR-N` handles and checked supersession references | required | nothing recommended |
| `documentation.patternCatalog` | Mori-addressable catalogs with typed status, URI, and tag fields | required | nothing recommended; `sources` is the v0.2 record shape |
| `documentation.researchDocuments` | Nested research corpora with `RES-N` handles, structured reviews, and conditional supersession | required | `reviews`; `sources` is the v0.2 record shape |
| `okfV02` | Format-level reference profile: the six v0.2 families and no house conventions, for a team with no established profile of its own | recommended | OKF `status` and `stale_after` |
| `postgresql` | PostgreSQL schemas, tables, and views with typed resource URIs and `# Schema` column contracts | recommended | OKF `status` and `stale_after` |
| `tanPostgresql` | `postgresql` plus per-table role vocabularies and conditional source streams | recommended | OKF `status` and `stale_after` |

`verified` is `optional` on every profile above and demanded by none.

The package also exports building blocks a profile *author* imports, which are
not profiles a consumer selects:

| Export | What it is |
|---|---|
| `v02` | The six OKF v0.2 field families, defined once. Splice `v02.generated`, `v02.verified`, `v02.legacyTimestamp`, `v02.status`, `v02.staleAfter`, `v02.sources`, `v02.usageWindow` into your own presence lists. See [ADR-5](./docs/adr/0005-v0-2-field-families-are-defined-once.md) |
| `reviewRule` | The house `reviews` family: reviewer identity, scope, outcome, and model metadata |
| `Profile`, `TypeRule`, `FrontmatterRules`, `FieldRule`, `NestedRules`, `NestedFieldRule`, `HandleReferenceRule`, `PathReferenceRule`, `FieldCondition`, `Cardinality`, `FieldFormat`, `mk` | okf's schema records and constructors, re-exported so a profile never imports okf directly |


## Adding a profile

1. Add `profiles/<family>/<name>.dhall`, built with `Profile::{ … }` /
   `TypeRule::{ … }` against `../../Profile/Type.dhall`. Set
   `okfVersion = "0.2"` and `requireBundleVersion = Some "0.2"`, and splice the
   v0.2 families from `../../Profile/V02.dhall` rather than re-authoring them.
2. Decide the `status` branch deliberately: if the profile declares a house
   lifecycle vocabulary on `status`, it does **not** also take OKF's `status` or
   `stale_after`; if it declares no house `status`, it should take both. See
   [ADR-1](./docs/adr/0001-house-status-diverges-from-okf-v0-2.md).
3. Classify every field by whether a complete, correct document would still lack
   it — if so it is `optional`, not `recommended`. See
   [ADR-8](./docs/adr/0008-recommended-means-a-well-run-corpus-carries-it.md).
4. Re-export it from the family `package.dhall`, then export that package from
   the root `package.dhall`. Keep existing flat exports stable — a downstream
   project pins this package by URL, and renaming an export breaks it silently.
5. Add `fixtures/<name>/` and `fixtures/<name>-invalid/`, then
   `scripts/test-<name>-profile.sh` matching the shape of its siblings. Every
   rejection fixture must fail for exactly one reason, and every rule must be
   load-bearing. See
   [ADR-9](./docs/adr/0009-a-rejection-fixture-must-fail-for-exactly-one-reason.md).
6. `dhall type --file profiles/<name>.dhall` must pass, **and**
   `okf profile show --registry ./package.dhall <export>` must load without a
   `Failed to load profile` line — the `okfVersion` check runs at load time, not
   type-check time.
7. Add a row describing it to this README and bump the tag on release.


## License

[BSD-3-Clause](./LICENSE) — (c) 2026 Nadeem Bitar.
