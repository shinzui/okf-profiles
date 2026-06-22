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
package.dhall                 # entry point: re-exports the schema types and all profiles
Profile/
  Type.dhall                  # the ProfileSpec record type
  TypeRule.dhall              # the per-type rule record type
  FrontmatterRules.dhall      # the frontmatter-rules record type
profiles/
  postgresql.dhall            # the PostgreSQL profile value (annotated against Profile/Type.dhall)
```

The schema types are published deliberately. Importing `Profile` lets a project's
override be **type-checked against the schema** instead of failing later at decode
time.


## Consuming a profile

### Pinned remote import (recommended for CI)

Import a tagged, hash-pinned version. The hash makes the import reproducible and
locally cached; the tag makes it stable so editing this repo never silently
changes a consumer's conventions.

```dhall
-- your-project/okf-profile.dhall
let okf =
      https://raw.githubusercontent.com/shinzui/okf-profiles/v0.1.0/package.dhall
        sha256:<filled-in-by-dhall-freeze>

in  okf.postgresql
```

Override or extend without copying — this is the whole point of shipping the type:

```dhall
let okf =
      https://raw.githubusercontent.com/shinzui/okf-profiles/v0.1.0/package.dhall
        sha256:<...>

in  okf.postgresql
    //  { name = "acme-warehouse" }
    //  { allowUnknownTypes = True }
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

The schema currently matches `okf` with profile support (okf-core ≥ the version
that introduced `Okf.Profile`). When in doubt, run the validation below against the
`okf` you have.


## Validating this repo

Type-check every Dhall file (requires the `dhall` CLI, ≥ 1.42):

```bash
dhall type --file package.dhall
dhall type --file profiles/postgresql.dhall
```

Both should print the inferred type and exit `0`. To prove a profile actually
works end-to-end, run it against the `okf` sample bundle from a checkout of the
`okf` repo:

```bash
okf validate examples/postgresql-sample --profile /path/to/okf-profiles/profiles/postgresql.dhall
```

Expected: `OK: <n> concepts` with no `profile:` lines.


## Adding a profile

1. Add `profiles/<name>.dhall`, annotated `: ../Profile/Type.dhall`.
2. Re-export it from `package.dhall`.
3. `dhall type --file profiles/<name>.dhall` must pass.
4. Add a row describing it to this README and bump the tag on release.


## License

[BSD-3-Clause](./LICENSE) — (c) 2026 Nadeem Bitar.
