# adopt-user-documentation

An adaptive Seihou playbook for migrating existing reader-facing pages under `docs/user/` and
`docs/guides/` to the shared `documentation.userDocumentation` profile.

```bash
seihou agent run adopt-user-documentation
```

The blueprint handles first-time adoption and idempotent reconciliation. It has no version-window
migration edges because no earlier user-documentation profile contract exists. A repository with
neither applicable directory completes successfully without changes.

## What it does

The playbook inventories each target directory independently and preserves page bodies, curated
`README.md` navigation, valid metadata, and unrelated working-tree changes. It installs one frozen
v0.13.1 descriptor, then adds or reconciles:

- one reader-intent type: `Navigation`, `Tutorial`, `Guide`, `Explanation`, `Reference`, or
  `Runbook`;
- stable bundle-scoped `DOC-N` handles, titles, descriptions, search tags, and truthful generation
  provenance;
- generated OKF v0.2 indexes and migration logs;
- separate Mori bundle declarations with typed publisher bindings when the pinned schema supports
  them; and
- strict profile and log enforcement in the repository's existing verification system.

It derives meaningful revision dates from Git rather than restamping prose during adoption. If a
stable producer actor cannot be established from repository evidence, it asks one focused question
instead of inventing authorship.

## What it does not do

The blueprint does not treat all of `docs/` as one bundle, overwrite another profile, renumber a
valid handle, infer provenance without evidence, rewrite page bodies to fit a category, introduce a
new build system, commit, push, or mutate a shared Mori registry without explicit authorization.
Duplicate pre-existing handles and incompatible local profiles are reported for human resolution.

## Prerequisites

- the released `okf-profiles` v0.13.1 catalog;
- `okf` 0.8.0.0 or later, `dhall`, `git`, and `rg`;
- Mori when the target repository has a `mori.dhall`; and
- a tool-capable Seihou provider such as `codex-cli` or `claude-cli`.

Pass repository-specific facts, such as the approved producer actor, as the optional instruction:

```bash
seihou agent run adopt-user-documentation \
  "Use human:nadeem for existing pages whose Git history names Nadeem as the author."
```

Validate the blueprint artifact itself with:

```bash
seihou validate-blueprint blueprints/adopt-user-documentation --lint
```

Previewing an installed blueprint with `seihou agent --debug run` may still update
`.seihou/manifest.json`; use a clean or disposable checkout when that receipt is unwanted.
