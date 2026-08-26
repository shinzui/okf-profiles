# User-documentation migration reference for okf-profiles v0.13.1

The `documentation.userDocumentation` profile governs reader-facing product documentation. Its
canonical profile URI is
`mori://shinzui/okf-profiles/profiles/user-documentation`. It requires OKF v0.2 and `okf` 0.8.0.0
or later.

## Required page contract

Every concept is one Markdown file with YAML frontmatter shaped like this:

```yaml
---
type: Guide
title: Configure retries
description: Configure bounded retries and inspect exhausted work safely.
docId: DOC-7
tags: [retries, operations, workers]
generated:
  by: human:maintainer
  at: 2026-08-20T14:32:00Z
---

# Configure retries
```

All six keys are required. `tags` must be a list. `generated.by` is an OKF producer actor in one
of the forms `human:<id>`, `process:<id>`, or `<producer>/<version>`; `generated.at` is the last
meaningful content revision in RFC 3339 UTC form. Adoption metadata does not make the migration
agent the page's author and does not move an old content date to today.

The allowed `type` values describe the page's primary reader intent:

- `Navigation` routes readers to the right documentation.
- `Tutorial` leads readers through an initial working experience.
- `Guide` helps readers complete a bounded goal.
- `Explanation` develops conceptual understanding and judgment.
- `Reference` provides authoritative lookup material.
- `Runbook` gives an operational procedure whose order, safety, and recovery matter.

The optional profile fields are OKF v0.2 `status`, `stale_after`, `sources`, `usage_window`, and
`verified`; typed `supersedes` and `supersededBy` relationships; and legacy `timestamp`.
`supersedes` is a list and `supersededBy` is a scalar. Both accept a local `DOC-N` handle or a
canonical external `mori://` URI. Preserve valid producer-owned optional metadata.

## Stable identity

`docId` is `DOC-` followed by one positive unpadded integer. It is unique within one bundle and
stable across file moves, title changes, and reader-intent corrections. Separate bundles may each
own `DOC-1` because their canonical URIs include the bundle name.

Before allocation, preserve and list every existing handle:

```bash
okf id list <bundle> --profile mori/user-documentation-profile.dhall
okf id next <bundle> DOC --profile mori/user-documentation-profile.dhall
```

Never close a gap, recycle a retired number, or derive identity from type. A duplicate existing
handle requires human resolution. For a completely unnumbered bundle, assign `README.md` first
when it is a substantive navigation page, then remaining paths lexicographically.

## Shared descriptor

Install the shipped `user-documentation-profile.dhall` byte-for-byte at the project's established
shared-selector path, or at `mori/user-documentation-profile.dhall` when no convention exists. It
contains this frozen import:

```dhall
let Profiles =
      https://raw.githubusercontent.com/shinzui/okf-profiles/v0.13.1/package.dhall
        sha256:3be4c39d128ef8a21e39d7ae4eaef29097801b343ab5672caaf7e30186a8f91a

in  Profiles.documentation.userDocumentation
```

Both `docs/user/` and `docs/guides/` use the same selector but remain separate bundles. Never use
`docs/` as the bundle root merely to avoid two entries; that absorbs unrelated plans, ADRs,
research, and internal documentation.

## Bundle files and Mori declaration

`index.md` and `log.md` are reserved files, not concepts. Generate the inventory and bundle
dialect, then add one truthful migration log entry:

```bash
okf index <bundle> --write --okf-version 0.2
okf log add <bundle> --kind Migration \
  -m "Adopt the shared user-documentation profile and assign stable document handles."
```

When the project's pinned Mori schema supports typed profile bindings, an entry has this shape.
Use `user-documentation` for `docs/user` and `guides` for `docs/guides`, preserving an established
non-conflicting bundle name.

```dhall
Schema.OkfBundle::{
, name = "user-documentation"
, path = "docs/user"
, profile = Some "mori/user-documentation-profile.dhall"
, profileBinding = Some
    ( Schema.ProfileBinding.Published
        Schema.PinnedImport::{
        , publisher = "shinzui/okf-profiles"
        , publisherRef = Some
            Schema.MoriRef::{ namespace = "shinzui", name = "okf-profiles" }
        , export = Some "documentation.userDocumentation"
        , version = Some "v0.13.1"
        , pin = Some
            "sha256:3be4c39d128ef8a21e39d7ae4eaef29097801b343ab5672caaf7e30186a8f91a"
        }
    )
, okfVersion = "0.2"
, description = Some "Reader-facing product documentation"
}
```

Inspect the imported schema source before editing. If `profileBinding` is unavailable, keep the
legacy `profile` field and report the missing typed publisher metadata rather than guessing a
record shape or upgrading the entire project schema incidentally.

## Validation and body preservation

Run strict profile and log enforcement for each bundle, then graph its Markdown links:

```bash
dhall type --file mori/user-documentation-profile.dhall
dhall type --file mori.dhall
okf validate <bundle> --strict \
  --profile mori/user-documentation-profile.dhall \
  --profile-enforce --log-enforce
okf graph <bundle> --json
```

The final validation reports `OK: <count> concepts (okf_version 0.2)`. The original body below
frontmatter, including a curated `README.md`, must remain unchanged. Generate `index.md` a second
time and require no diff. A second complete blueprint pass must add no IDs, metadata, log entries,
bundle declarations, or validation targets.
