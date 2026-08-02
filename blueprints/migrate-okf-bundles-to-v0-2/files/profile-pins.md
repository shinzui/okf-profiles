# okf-profiles v0.8.0 pinned imports

Copy the descriptor for the bundle you are repinning rather than composing the import by hand.
Every profile below targets Open Knowledge Format v0.2.

## Freezing

> **The `sha256:` hashes below are deliberately absent.** They are added by
> `dhall freeze` against the real v0.8.0 tag; this file ships with the import line only so that
> nobody hand-writes a hash. After copying a descriptor into a repository, always run:
>
> ```bash
> dhall freeze <bundle>/profile.dhall
> ```
>
> That fetches the pinned URL once and writes the integrity hash beneath it. A frozen import is
> then verified on every subsequent evaluation and never refetched.
>
> Never hand-write a `sha256:` value, and never delete a hash from a frozen import to make it
> resolve. An import that will not resolve is a problem to report, not to work around.
> (`--inplace` is deprecated as of dhall 1.42.3; freezing is in-place by default.)

## The seven profile exports

The package root is:

```text
https://raw.githubusercontent.com/shinzui/okf-profiles/v0.8.0/package.dhall
```

A descriptor is that import plus the export the bundle uses:

| Bundle kind | Export |
|-------------|--------|
| Architecture decision records | `documentation.architectureDecisions` |
| Documentation pattern catalog | `documentation.patternCatalog` |
| Research documents | `documentation.researchDocuments` |
| Cross-repository improvement requests | `coordination.improvementRequests` |
| JTBD use cases | `coordination.useCases` |
| PostgreSQL database description | `postgresql` |
| Tan PostgreSQL database description | `tanPostgresql` |

There is also `okfV02`, a format-level reference profile carrying the v0.2 families and no house
conventions, for a bundle with no established profile of its own.

## Descriptor template

```dhall
--| <Bundle kind> profile. Bump the tag and semantic hash together when upgrading.
let Profiles =
      https://raw.githubusercontent.com/shinzui/okf-profiles/v0.8.0/package.dhall

in  Profiles.documentation.architectureDecisions
```

Replace the export on the last line with the one from the table above, then run `dhall freeze`.

## Repinning an existing descriptor

Change only the tag in the URL and delete the old hash line, then re-freeze — the hash must be
regenerated, never edited:

```diff
 let Profiles =
-      https://raw.githubusercontent.com/shinzui/okf-profiles/v0.7.0/package.dhall
-        sha256:3a785b2ee66301e2bcd6466352e9480e71b7fafdca62256b4a2038cace5d0bb8
+      https://raw.githubusercontent.com/shinzui/okf-profiles/v0.8.0/package.dhall
```

```bash
dhall freeze <bundle>/profile.dhall
```

Preserve every customization the project layered on top of the import. Only the tag and its hash
are yours to change — with one exception, below.

## The one override you may now delete

A descriptor installed by the `adopt-architecture-decisions` blueprint at v0.7.0 carries an
override reclassifying `supersedes`, `supersededBy`, and `originatingPlan` from `recommended` to
`optional`:

```dhall
in  base
    //  { frontmatter =
            base.frontmatter
        //  { recommended = [] : List Profiles.FieldRule.Type
            , optional = base.frontmatter.recommended
            }
        }
```

v0.8.0 folds that reclassification into the upstream profile, so the override is a no-op. Delete
it, leaving a plain import. Deleting it changes nothing about which documents pass. Keep any
*other* customization.

## Verifying a repinned descriptor

```bash
dhall type --file <bundle>/profile.dhall
okf validate <bundle> --strict --profile <bundle>/profile.dhall \
  --profile-enforce --log-enforce
```

In a sandboxed agent session outbound network access may be unavailable even though the descriptor
is correct. If `dhall type` fails solely because the sandbox cannot reach the pinned remote import,
confirm the descriptor is byte-for-byte what you intended, use `v0-2-migration-reference.md` as the
authoritative field contract, and continue. Do not delete the import to work around it.
