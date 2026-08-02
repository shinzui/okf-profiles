---
type: Architecture Decision Record
title: Blueprint versions track the catalog tag
description: A blueprint is versioned to the okf-profiles tag it targets, because that tag is the only version a consumer can read off their own repository.
docId: ADR-7
status: Accepted
date: 2026-08-02
generated:
  by: human:nadeem
  at: "2026-08-02T00:00:00Z"
---

# Blueprint versions track the catalog tag

## Context

This repository ships Seihou blueprints that migrate a consumer's OKF bundles
onto its profiles. A Seihou blueprint carries its own `version`, and
`seihou agent migrate` selects declared edges by a version window the consumer
passes as `--from` and `--to`.

The question is what that version counts. A blueprint could be versioned
independently of the catalog, on its own release cadence.

It cannot usefully be. A consumer running `seihou agent migrate` has to supply a
`--from`, and the only version they can read off their own repository is the
`okf-profiles` tag pinned in their installed descriptor:

```bash
grep okf-profiles docs/adr/profile.dhall
```

There is no record anywhere of which blueprint version they last ran — Seihou's
receipts live in `.seihou/manifest.json` and are keyed by edge, not by a version
a human would look up.

## Decision

**A blueprint's `version` is the `okf-profiles` tag it targets.** Both blueprints
are `0.8.0` for this release. A blueprint version is bumped in lockstep with the
catalog tag whenever a release changes what that blueprint installs or migrates,
and in three places that must agree: the blueprint's own `blueprint.dhall`,
`seihou-registry.dhall`, and `mori.dhall`'s `templates` list.

A migration edge is declared **keyed at the last release before the change**, not
at the oldest version still in the wild. An edge is selected only when it falls
inside the requested window, so keying it too early makes it unreachable from
every later `--from`.

## Rationale

Aligning the two versions makes `--from` derivable from evidence the consumer
actually has. Any other scheme requires them to remember something.

The rule was stated in `blueprints/adopt-architecture-decisions/README.md` before
this release, and the three files disagreed anyway: `seihou-registry.dhall` said
`0.7.0` while `mori.dhall` said `0.1.3` for the same blueprint. A rule that lives
only in one artifact's README is a rule that drifts. Promoting it to a decision
record and reconciling all three is what this release does.

## Consequences

A release that does not change a blueprint still bumps its version, because the
version is not a description of the blueprint's own content — it is a pointer to
the catalog release it targets. This costs nothing and keeps `--from` meaningful.

`0.8.0` is correct in all three files as of this release. Any future divergence
between them is a bug.

Two operational cautions were learned while shipping the v0.8.0 blueprints and
are recorded here because they will recur every release:

- **`seihou agent --debug` renders the *installed* copy** under
  `~/.config/seihou/installed/<name>/`, not the working tree, and there is no
  `--path` flag. A dry-run of an unreleased edge reports
  `No blueprint migrations are declared inside the requested version window`,
  which is indistinguishable from a wrongly-keyed edge. Reinstall, or stage the
  working tree over the installed copy and restore it afterwards.
- **`seihou agent --debug` is not a pure dry run.** It contacts no provider and
  changes no target file, but it writes a `blueprint` receipt into
  `.seihou/manifest.json`. Check `git status` after dry-running and revert it.
