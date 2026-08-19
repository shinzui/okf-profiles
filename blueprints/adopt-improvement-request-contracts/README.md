# adopt-improvement-request-contracts

An optional Seihou playbook for repositories that want to promote existing improvement-request
dependencies and acceptance conditions from prose into the structured frontmatter introduced by
`coordination.improvementRequests` in okf-profiles v0.12.0.

```bash
seihou agent run adopt-improvement-request-contracts
```

This is deliberately a standalone blueprint, not a blueprint migration. A repository can consume
v0.12.0 without running it: `dependencies` and `acceptanceCriteria` are optional, and existing
bundles remain valid. Run the playbook only when the repository wants the new relationships and
completion contracts to be machine-validated and available to registry consumers.

## What it does

The playbook discovers bundles governed by `coordination.improvementRequests` from Mori metadata,
local profile descriptors, and validation commands. It can repin a shared descriptor to v0.12.0
while preserving local overlays, then structures only information the repository already states:

- canonical cross-repository `mori://` improvement-request dependencies with explicit `hard`,
  `soft`, or `integration` meanings and reasons; and
- stable request-local `AC-N` criteria with both an observable statement and an explicit
  verification procedure.

It preserves source prose, stable `IR-N` and `AC-N` handles, unrelated frontmatter, and inherited
validation failures. Ambiguous material remains prose and is reported for human resolution.

## What it does not do

The playbook does not invent cross-repository targets, infer dependency kinds from urgency, turn
task lists into acceptance criteria, claim evidence exists, compute readiness, or change request
status. It does not replace a locally authored profile with the shared profile.

A repository without an applicable improvement-request bundle completes successfully without
changes. Re-running the playbook preserves valid structured records and adds no duplicates.

## Prerequisites

- the released `okf-profiles` v0.12.0 catalog;
- `okf` 0.8.0.0 or later and `dhall`; and
- a tool-capable Seihou provider such as `codex-cli` or `claude-cli`.

Preview the rendered playbook without contacting a provider:

```bash
seihou agent --debug run adopt-improvement-request-contracts
```

Seihou may still record applied-blueprint provenance in `.seihou/manifest.json` during an
`agent run --debug`, so use a clean or disposable checkout when the manifest must remain
untouched.

After a run, use the repository's own validation target. Where no wrapper exists:

```bash
okf validate <bundle> --strict --profile <bundle>/profile.dhall \
  --profile-enforce --log-enforce
```
