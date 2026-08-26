# Adopt the shared user-documentation profile

Migrate this repository's existing reader-facing documentation into profile-governed OKF bundles.
The conventional candidates are `docs/user/` and `docs/guides/`; treat each applicable directory
as a separate bundle so unrelated documentation under `docs/` is never absorbed. Preserve the
meaning and body of every page while adding reader-intent metadata, stable `DOC-N` handles,
generated indexes, change logs, Mori registration, and repository-native validation.

Treat any additional prompt supplied to `seihou agent run` as repository-specific guidance, such
as another known reader-facing directory or the approved producer actor. Do not let additional
guidance weaken the shared profile, identity stability, provenance truthfulness, or validation.

## Read the shipped contract first

This blueprint ships two references. Read both before editing:

- `user-documentation-profile.dhall` is the exact pinned descriptor to install once and share
  across the adopted bundles.
- `migration-reference.md` defines the required metadata, six reader-intent types, stable-handle
  allocation, Mori declaration, and validation sequence.

If either reference is unavailable, stop before editing and report that the blueprint cannot
safely install the authoritative contract. Do not recreate the profile from memory.

## Working rules

Read all repository-local instruction files before editing. Preserve unrelated working-tree
changes, use the current branch, and follow the repository's own formatting and check conventions.
Do not commit, push, observe into a shared registry, or modify external state unless the operator
explicitly asks.

Use Mori before guessing dependency or manifest APIs. Run `mori registry list`,
`mori registry show shinzui/okf-profiles --full`, and, when this project is registered,
`mori show --full`. Read dependency source from the exact path Mori returns. Never search
`/nix/store`, traverse `/`, or scan an unbounded parent directory. Every durable cross-repository
reference must use a canonical `mori://` URI.

Do not invent authorship, content dates, titles, descriptions, or operational claims. Derive them
from the page, repository metadata, and Git history. If the repository does not establish a stable
OKF producer actor, ask one focused question for the actor to use; acceptable shapes are
`human:<id>`, `process:<id>`, and `<producer>/<version>`. The metadata migration agent is not the
author of pre-existing prose.

## Phase 1: inventory and establish the baseline

Start with read-only checks:

```bash
git status --short --branch
rg --files docs/user docs/guides -g '*.md'
```

Missing candidate directories are normal. An applicable directory contains at least one
reader-facing Markdown page. Exclude reserved `index.md` and `log.md`; retain a substantive
`README.md` as a `Navigation` concept. Do not create an empty bundle. If neither conventional
directory nor an explicitly supplied directory is applicable, change nothing and report a
successful no-op.

For each applicable directory, inventory frontmatter, the first H1, links, and Git history. Record
existing `DOC-N` handles, duplicate handles, generated dates, local profile descriptors, bundle
entries in `mori.dhall`, and validation commands in build files or CI. A valid existing handle is
permanent even if its filename or type now seems inconvenient. Stop for human resolution if two
different pages already claim the same valid handle.

Run the repository's existing documentation checks before editing and retain their output. An
inherited failure must not be attributed to this migration. If a candidate is governed by a
different published profile or a locally authored profile, do not overwrite it; report the
conflict and leave that directory unchanged. If it already imports
`documentation.userDocumentation`, perform an idempotent reconciliation and repair only missing
metadata, registration, indexes, logs, or check integration.

## Phase 2: install the shared descriptor and classify pages

Follow an established project convention for shared profile selectors when one exists. Otherwise
install the shipped descriptor byte-for-byte at `mori/user-documentation-profile.dhall`, creating
the `mori/` directory if needed. Both bundles must refer to that one descriptor. Type-check it:

```bash
dhall type --file mori/user-documentation-profile.dhall
```

If the command fails only because the execution sandbox cannot reach the pinned remote import,
confirm that the installed file is byte-for-byte identical to the shipped reference and continue
using `migration-reference.md`; the final validation outside the sandbox must still resolve the
descriptor before the migration is complete.

Add or reconcile YAML frontmatter on every concept. Preserve valid existing metadata and optional
producer-owned fields. Supply the required fields `type`, `title`, `description`, `docId`, `tags`,
and `generated` exactly as described in the reference.

Choose one primary type by what the reader is trying to do, not by the directory name:

- `Navigation` routes readers to other documentation.
- `Tutorial` teaches through a first working experience.
- `Guide` helps complete a bounded goal.
- `Explanation` develops conceptual understanding or decision-making judgment.
- `Reference` is authoritative lookup material.
- `Runbook` is an ordered operational procedure where safety and recovery matter.

When a page mixes intents, classify its dominant purpose and preserve the body. Do not split or
rewrite a page merely to make the taxonomy pure. Preserve the visible H1. Use it as `title` unless
existing evidence supplies a better authoritative title. Write a truthful one-sentence
`description` and a concise non-empty tag list using repository vocabulary.

`generated.at` is the last meaningful content revision, normalized to UTC with a trailing `Z`, not
the migration time. Prefer an existing valid value; otherwise use the page's latest meaningful Git
commit after inspecting that commit. For untracked or history-free content, ask for the date rather
than fabricating one. `generated.by` identifies the producer of the current content using the
approved actor mapping, not this blueprint or the migration agent.

Allocate IDs independently in each bundle. Preserve every valid `DOC-N`; never renumber, recycle,
or fill a gap. List existing IDs and ask OKF for the next handle:

```bash
okf id list <bundle> --profile mori/user-documentation-profile.dhall
okf id next <bundle> DOC --profile mori/user-documentation-profile.dhall
```

For a completely unnumbered corpus, allocate from `DOC-1` in a deterministic order: a substantive
`README.md` first, then remaining paths lexicographically. Continue above the largest allocated
number. The same number may appear once in each separate bundle.

## Phase 3: create reserved bundle files and registration

Generate a canonical inventory and declare OKF v0.2 in each bundle root:

```bash
okf index <bundle> --write --okf-version 0.2
```

Add or update the nearest `log.md` using the repository's convention. One root migration entry on
the adoption date may cover all pages whose `generated.at` dates are not later. Do not restamp old
pages merely to satisfy log coverage. The standard command is:

```bash
okf log add <bundle> --kind Migration \
  -m "Adopt the shared user-documentation profile and assign stable document handles."
```

If `mori.dhall` exists, preserve its pinned schema and add one `Schema.OkfBundle` entry per adopted
directory. Use bundle name `user-documentation` for `docs/user` and `guides` for `docs/guides`
unless a non-conflicting name is already established. Set `okfVersion = "0.2"` and the legacy
`profile` path to the installed descriptor. When the pinned schema exposes `profileBinding`, also
add the typed published binding from `migration-reference.md`; otherwise retain the legacy path
and report that typed publisher metadata requires a later schema upgrade. Do not guess the record
shape or upgrade the whole manifest as a side effect. Run `dhall type --file mori.dhall` after the
edit.

Integrate strict validation into the repository's existing task runner and aggregate verification
target. Use one project-level target that validates and graphs every adopted bundle with the shared
descriptor. Preserve existing CI structure. If no task runner or aggregate check exists, document
the exact commands in the nearest contributor guide instead of introducing an unrelated build
system.

## Phase 4: prove the migration and report

Run, for every adopted bundle:

```bash
okf validate <bundle> --strict \
  --profile mori/user-documentation-profile.dhall \
  --profile-enforce --log-enforce
okf graph <bundle> --json
```

Then run the repository-native documentation target, type-check `mori.dhall` when present, and run
the smallest aggregate check that proves the new target is wired in. Inspect the diff to ensure
the original page bodies and curated navigation remain unchanged below frontmatter. Regenerate an
index once more and require a clean index diff.

Finish with a report naming every candidate inspected, every bundle adopted or skipped, the actor
and date evidence used, the allocated and preserved handle ranges, the descriptor and Mori entries,
the check integration, all commands and outcomes, inherited failures, and anything left for human
resolution. Include the canonical bundle URIs when Mori metadata exists.

Re-running this playbook must be safe. A conforming page, descriptor, manifest entry, index, or log
must not be rewritten for formatting alone; no duplicate handle, log entry, task, or bundle may be
added.
