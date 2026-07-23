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
| `mori` | Discovery: registers this repo so profiles are findable, and (planned) attaches a profile to a registered bundle and validates it at observe time. |

The sample inside `okf` and the profiles here intentionally start identical for
PostgreSQL; this repo is where they evolve and get versioned.


## Layout

```text
package.dhall                 # entry point: re-exports the schema records and all profiles
Profile/
  okf.dhall                   # pinned remote import of okf's canonical schema (the only URL+hash)
  Type.dhall                  # Profile schema: okf's type + local default, as { Type, default }
  TypeRule.dhall              # per-type rule schema: okf's type + local default
  FrontmatterRules.dhall      # frontmatter-rules schema: okf's type + local default
profiles/
  documentation/
    package.dhall             # namespaced documentation-profile exports
    pattern-catalog.dhall     # implementation-pattern catalog conventions
  postgresql.dhall            # stable flat PostgreSQL export
  tan-postgresql.dhall        # stable flat tan PostgreSQL export
fixtures/
  documentation-pattern-catalog/
                              # three-concept end-to-end profile fixture
```

Each schema is exported as a `{ Type, default }` record so values are built with
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

The schema currently matches `okf` with profile support (okf-core ≥ 0.1.1.0).
The `documentation.patternCatalog` profile also requires profile support from
that release. When in doubt, run the validation below against the `okf` you
have. The existing `postgresql` and `tanPostgresql` fields remain stable flat
exports; new profile families should use a namespaced directory and package
field.

> **Single source of truth.** The schema *types* here are a pinned remote import of
> okf's canonical schema, in [`Profile/okf.dhall`](./Profile/okf.dhall) (the only
> URL + integrity hash in this repo); the sibling files add only the `default`
> records, and `profiles/` holds the values. okf owns the shape, okf-profiles owns
> the conventions. The import is one-way: okf depends on nothing here. To track a
> newer okf, bump the commit ref in `Profile/okf.dhall` and re-run `dhall freeze`.


## Schema evolution

In Dhall, **record fields are always required** — adding even an `Optional` field
to a record type breaks every existing value that omitted it. That is why each
schema here is a `{ Type, default }` record consumed through the completion operator
`::`. `Profile::{ name = "x" }` desugars to `(Profile.default // { name = "x" }) :
Profile.Type`, so a value only ever names the fields it cares about.

To add a field later:

1. Add it to the schema's type **and** to its `default`.
2. Existing `Profile::{ … }` / `TypeRule::{ … }` values keep compiling unchanged —
   the default supplies the new field.

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
```

Both should print the inferred type and exit `0`. To prove a profile actually
works end-to-end, run it against the `okf` sample bundle from a checkout of the
`okf` repo:

```bash
okf validate examples/postgresql-sample --profile /path/to/okf-profiles/profiles/postgresql.dhall
```

Expected: `OK: <n> concepts` with no `profile:` lines.

The documentation pattern-catalog fixture is self-contained:

```bash
okf validate fixtures/documentation-pattern-catalog \
  --strict \
  --profile profiles/documentation/pattern-catalog.dhall \
  --profile-enforce
```

Expected: `OK: 3 concepts` with no `profile:` lines.


## Profile catalog

| Export | Purpose | Minimum `okf` |
|---|---|---|
| `documentation.patternCatalog` | Mori-addressable catalogs of standards, guides, patterns, runbooks, references, and gotchas | 0.1.1.0 |
| `postgresql` | PostgreSQL schemas, tables, and views | 0.1.1.0 |
| `tanPostgresql` | The PostgreSQL profile plus logical event streams | 0.1.1.0 |


## Adding a profile

1. Add `profiles/<family>/<name>.dhall`, built with `Profile::{ … }` /
   `TypeRule::{ … }` against `../../Profile/Type.dhall`.
2. Re-export it from the family `package.dhall`, then export that package from
   the root `package.dhall`. Keep existing flat exports stable.
3. `dhall type --file profiles/<name>.dhall` must pass.
4. Add a row describing it to this README and bump the tag on release.


## License

[BSD-3-Clause](./LICENSE) — (c) 2026 Nadeem Bitar.
