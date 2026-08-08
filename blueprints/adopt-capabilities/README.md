# adopt-capabilities

Agent-driven authoring of a capability catalog at `docs/capabilities/` — what a repository
**provides to a consumer today**, one concept per capability, each backed by evidence a reader can
open. The blueprint installs the shared `coordination.capabilities` descriptor, derives the
capability set from repository evidence, registers the Mori bundle, and validates under profile
enforcement.

```bash
seihou agent run adopt-capabilities
```

For non-interactive automation, use Seihou's batch launcher:

```sh
seihou agent run adopt-capabilities --batch
```

Pass a repository-specific prompt when local conventions need extra guidance:

```bash
seihou agent run adopt-capabilities \
  "Treat the Internal.* modules as private, and wire validation into just docs-check."
```

## This blueprint authors rather than migrates

`adopt-architecture-decisions` adapts an existing corpus. This one usually has no prior corpus to
adapt: it derives claims from source, tests, docs, and release history. **Fabrication is therefore
the central risk**, and three rules in the prompt exist to contain it:

1. **Evidence or it does not exist.** Every capability names an artifact — a test, conformance
   fixture, example, benchmark, module, or guide — that a reader can open, and the agent verifies
   the path before writing it. There is deliberately no `planned` status; an absent capability is an
   improvement request.
2. **Provision, not composition.** A claim only true when several repositories cooperate belongs to
   the consuming repository as a use-case feature. The working test is whether a record reads
   correctly to someone who has never heard of the surrounding portfolio.
3. **One capability is one thing a consumer adopts *and* verifies independently.** A catalog with
   one record per exported module is a worse copy of the API reference, and is the main way this
   format fails.

## What to expect

Fewer records than you would guess. Across the three repositories the profile was shaken out
against, a queue framework produced ten capabilities, a channel service seven, and a CLI with
roughly thirty command families fourteen.

The most valuable output is usually not the catalog but **what the evidence requirement exposes**:
packages with no test suite, live paths that are still stubs, surfaces that turn out to be
documentation-only. The run reports these explicitly, and each record carries a truthful `Limits`
section rather than smoothing them over.

## No-op behavior

A repository with no consumer-facing surface — a schema-only package, a pinned artifact, an internal
scaffold — finishes successfully **without** creating a bundle, profile, log, or Mori entry. This is
required because plan-module upgrades invoke the blueprint across repositories regardless of whether
they have a surface to describe.

Re-running against an adopted repository is an idempotent reconciliation: valid `CAP-N` handles are
preserved and conforming records are not rewritten.

## References

Two files ship with the blueprint and are read before any edit:

| File | Purpose |
|---|---|
| `capabilities-profile.dhall` | The version-pinned descriptor installed at `docs/capabilities/profile.dhall` |
| `authoring-reference.md` | Profile contract, granularity rule, evidence discipline, Mori declaration, validation sequence |

If the reference directory is unreadable, the run stops before editing rather than recreating the
profile from memory.

## Validation

```bash
okf validate docs/capabilities --profile docs/capabilities/profile.dhall \
  --profile-enforce --log-enforce
okf graph docs/capabilities
```

`okf graph` must show an edge for every `requires` entry; a missing edge means a requirement was
declared in frontmatter but not mirrored as a body link, which `okf` cannot detect on its own.

`--strict` additionally reports the profile-recommended `reviews` family, which a machine-authored
catalog will not have. That is expected output, not a failure — and not something to silence by
inventing review provenance. Reviewing the records and mirroring an approving entry into `verified`
is what clears it, and what moves the catalog's trust tier off `unverified`.
