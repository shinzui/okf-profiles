# Adopt the shared OKF architecture-decision profile

Migrate the current repository's existing Architecture Decision Records (ADRs) into a
profile-governed OKF bundle at `docs/adr/`. Preserve their historical meaning and adapt to the
repository's actual conventions rather than applying a blind textual rewrite. Complete the
migration, strict validation, Mori registration, and repository-native check integration.

This run requires a tool-capable local CLI provider such as `claude-cli` or `codex-cli`.

Treat any additional prompt supplied to `seihou agent run` as repository-specific guidance—for
example, known legacy metadata, a preferred existing check target, or fields that must be preserved.
Apply it together with repository evidence, but do not let it weaken the shared profile, handle
uniqueness, or validation requirements below.

## Reference handling

Two references ship with this blueprint. If Seihou reports a readable reference directory, read
both before editing:

- `architecture-decisions-profile.dhall` is the version-pinned descriptor to install at
  `docs/adr/profile.dhall`.
- `migration-reference.md` defines the exact profile contract, accepted legacy shapes, collision
  policy, Mori declaration, and validation sequence.

If the references are unavailable, stop before editing and report that the blueprint cannot safely
install the authoritative profile. Do not recreate the profile from memory.

## Working rules

Read every repository-local instruction file before editing. Preserve unrelated changes and work on
the current branch. Follow the repository's commit conventions, but do not commit or push unless the
operator explicitly asks.

If `mori.dhall` exists, run `mori show --full` before planning changes. Use Mori before guessing any
dependency or tool API. Never search `/nix/store` or traverse `/`; scope searches to the current
repository and exact paths Mori returns.

Do not invent decision status, date, title, or provenance. Derive them from the ADR, its filename,
its links, and Git history. Ask one focused question only when the repository does not contain enough
evidence to make a safe choice.

## Phase 1: Inventory the corpus and its consumers

If `docs/adr/` does not exist or contains no decision records, report that ADR adoption is not
applicable and finish successfully without creating an empty bundle, profile, log, check, or Mori
entry. This no-op behavior is required because plan-module upgrades invoke this blueprint across
repositories whether or not they already use ADRs.

If the corpus already uses the shared profile, preserve every valid handle and treat the run as an
idempotent reconciliation: repair only missing registration/check integration, validate, and avoid
rewriting conforming documents.

Start with:

```bash
git status --short --branch
rg --files docs/adr
```

Scan every ADR's frontmatter, first heading, status, date, and links. Also find incoming references
from plans, documentation, source comments, and other ADRs. Distinguish decision records from
reserved or navigational files:

- `index.md` and `log.md` are reserved OKF files and are not concepts;
- a legacy `README.md` that only indexes ADRs should normally become `index.md`, with incoming links
  updated;
- a Markdown file that contains a real decision must become a profile-conforming concept even if its
  filename is unconventional.

Record duplicate legacy numbers, missing metadata, nested decision files, and existing YAML before
editing. The profile is intentionally flat, so nested ADRs must be moved to the bundle root with
links updated, not silently accepted.

## Phase 2: Install the profile and assign stable handles

Copy the shipped descriptor byte-for-byte to `docs/adr/profile.dhall`. Do not inline or fork the
profile. Type-check it before changing ADRs:

```bash
dhall type --file docs/adr/profile.dhall
```

Every decision concept must have YAML frontmatter with the profile-required ADR fields plus OKF's
strict authoring fields. Values are shaped like:

```yaml
---
type: Architecture Decision Record
title: Use stable identifiers
description: Give each ADR a rename-stable handle.
timestamp: 2026-07-26T00:00:00Z
docId: ADR-7
status: Accepted
date: 2026-07-26
---
```

`date` is the original decision date; `timestamp` is the last meaningful revision time. Derive the
one-sentence `description` from the record's actual decision. Preserve additional producer-owned
fields. `docId` is the rename-stable handle; it must be `ADR-N`
with a positive, unpadded number and must be unique within this bundle.

Preserve an existing valid `docId`. Otherwise preserve a legacy ADR number when it is unambiguous.
Before allocating any new number, list the profile-recognized handles:

```bash
okf id list docs/adr --profile docs/adr/profile.dhall
okf id next docs/adr --profile docs/adr/profile.dhall ADR
```

Legacy collisions require repository-specific judgment. Inspect incoming links and Git chronology,
keep the handle on the record already identified by that number, allocate a new unused handle to the
other record, and update its heading and incoming references when leaving the old number would make
human citations ambiguous. Never reuse a retired handle merely to close a gap.

Derive `title` from the decision's actual heading without the `ADR N` label. Preserve status text
such as `Accepted (amended …)` when it carries meaning. Prefer the original decision date; when it is
missing, use Git evidence for the file's introduction rather than the current date. Keep historical
body prose intact. Remove duplicated top-of-document status/date lines only when their exact values
are represented in frontmatter and no link or explanation depends on them.

## Phase 3: Register the bundle and add strict checking

If the repository has `mori.dhall`, add or update exactly one `Schema.OkfBundle` entry:

```dhall
Schema.OkfBundle::{
, name = "adrs"
, path = "docs/adr"
, profile = Some "docs/adr/profile.dhall"
, okfVersion = "0.1"
, description = Some "Durable architecture decisions"
}
```

Preserve every existing bundle and manifest field. If the pinned Mori schema does not expose
`Schema.OkfBundle`/`okfBundles`, upgrade it through the repository's established schema workflow;
do not hand-edit a downloaded schema. If no `mori.dhall` exists, do not invent project identity—finish
the local OKF migration and report that Mori registration needs an independently established project
manifest.

Add strict profile enforcement to the repository's existing check surface (CI, a check script,
Makefile, justfile, Nix check, or equivalent):

```bash
okf validate docs/adr \
  --strict \
  --profile docs/adr/profile.dhall \
  --profile-enforce \
  --log-enforce
```

Do not introduce a new build framework solely for this command. Document it near the repository's
other contributor checks when such documentation exists.

Preserve a valid existing `log.md` and append one migration entry. If the bundle has no log, create
one through OKF so the required timestamps do not leave permanent staleness advisories:

```bash
okf log add docs/adr \
  --kind Migration \
  --message "Adopt the shared architecture-decision profile."
```

## Phase 4: Validate and prove addressing

Run the strict validation command. Fix every missing field, malformed/duplicate ID, unknown type,
path mismatch, malformed log, or stale timestamp; do not weaken the profile to make legacy files
pass.

Run the repository's normal documentation or full validation appropriate to the touched files. If
the project is already registered or observed, refresh it through the project's normal Mori
workflow, then verify:

```bash
mori registry bundles <namespace/project> --json
mori registry concepts <namespace/project> --bundle adrs --json
```

Every ADR row must expose a handle-form reference ending in `/concepts/ADR-N`. Query at least one
handle again with `mori registry concepts --id ADR-N --json` and confirm that the intended project,
bundle, path, and canonical reference agree. Within this repository, keep relative Markdown links
so a checkout remains self-contained. Across repositories, replace
literal filesystem paths or informal citations touched by this migration with the canonical
handle-form `mori://` reference returned by Mori.

Finish by reporting migrated ADR count, preserved and newly allocated handles, collision resolutions,
reserved-file moves, the check surface updated, exact validation commands and results, and any Mori
registration step that remains external.
