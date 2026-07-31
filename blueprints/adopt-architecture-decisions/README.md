# adopt-architecture-decisions

Agent-driven migration of an existing `docs/adr/` corpus to the shared OKF architecture-decision
profile. The blueprint adapts legacy metadata and numbering, registers the `adrs` Mori bundle, adds
strict profile enforcement to the repository's existing check surface, and verifies rename-stable
`mori://…/concepts/ADR-N` references.

The blueprint serves two distinct jobs. Pick by whether the target repository already has a
`docs/adr/profile.dhall`:

| Target state | Command | What it does |
|--------------|---------|--------------|
| No `docs/adr/profile.dhall` — never adopted | `seihou agent run` | Adoption: inventory the legacy corpus, assign `ADR-N` handles, install the descriptor, register the bundle |
| `docs/adr/profile.dhall` pins an older `okf-profiles` tag | `seihou agent migrate` | Upgrade: move the pin forward and bring the corpus up to what the newer profile enforces |

Adoption has no version axis to move along — it inventories and adapts from repository evidence.
The upgrade path does have one: the `okf-profiles` tag pinned in the installed descriptor. That is
why these are separate entry points rather than one command, and why each refuses the other's job.

## Adoption

Install the blueprint from this repository and run it in the target repository:

```bash
seihou agent run adopt-architecture-decisions
```

For module migrations and other non-interactive automation, use Seihou's batch
launcher:

```sh
seihou agent run adopt-architecture-decisions --batch
```

Pass a repository-specific prompt when local history or checks need extra guidance:

```bash
seihou agent run adopt-architecture-decisions \
  "Keep our supersession fields and wire validation into just docs-check."
```

Preview the complete rendered prompt without changing the target:

```bash
seihou agent --debug run adopt-architecture-decisions
```

A freshly adopted bundle lands on whatever tag the shipped descriptor pins — currently
**v0.7.0** — so a new adopter needs no migration afterwards.

## Upgrading an adopted bundle

### Declared edges

| Edge | Covers |
|------|--------|
| `0.6.0 -> 0.7.0` | `description`/`timestamp` promoted to required; new `rfc3339-utc`, calendar-date, and strict `ADR-N` handle formats; handle-reference rules on `supersedes`/`supersededBy` |

Only releases that need agent intervention get an edge. v0.4.1 through v0.6.0 left the
architecture-decision profile untouched, so no edge is declared across that range — the single
`0.6.0 -> 0.7.0` edge covers every consumer pinned anywhere from v0.4.0 up.

### Find your current version

The version to pass as `--from` is the `okf-profiles` tag pinned in your installed descriptor:

```bash
grep okf-profiles docs/adr/profile.dhall
```

An edge is selected when it falls inside the requested window, so any starting tag from `0.4.0`
through `0.6.0` selects the edge above:

```bash
seihou agent migrate adopt-architecture-decisions --from 0.4.0 --to 0.7.0
```

### Preview first

`--debug` on the parent `agent` command is a true dry run: it renders every pending session in
order, contacts no provider, and writes nothing.

```bash
seihou agent --debug migrate adopt-architecture-decisions --from 0.4.0 --to 0.7.0
```

### What the edge changes

It moves the pin to v0.7.0 and reclassifies `supersedes`, `supersededBy`, and `originatingPlan`
from `recommended` to `optional` in one step. Both halves are required together: under `--strict`
an absent recommended field is an error, and essentially every real corpus lacks all three, so
bumping the pin alone turns a green bundle red.

It then repairs whatever the newly enforced formats reject — most often `timestamp` values
carrying a UTC offset instead of `Z`. Those are converted preserving the instant rather than
restamped, so `okf log` coverage survives.

Customizations layered on top of the imported profile are preserved. Only the pinned tag, its
hash, and those three presence classifications are the edge's to change.

The edge covers the architecture-decision bundle only. Other OKF bundles in the same repository —
research documents, improvement requests, use cases — have their own profiles and are explicitly
out of scope.

### Prerequisites

- **The project's `.seihou/manifest.json` must be at the current schema.** Migrations read and
  write receipts there, and an older manifest fails before any session starts, with a message
  naming `seihou manifest upgrade`. Run that first and review its diff — it converts recorded
  absolute module paths into portable origins.
- **A tool-capable local CLI provider**, such as `claude-cli` or `codex-cli`. Some providers reject
  an empty instruction, so pass the optional prompt argument if the session fails to start:

  ```bash
  seihou agent migrate adopt-architecture-decisions --from 0.4.0 --to 0.7.0 \
    "Follow the edge instructions for this repository." --provider claude-cli
  ```

### If the repository never adopted the profile

The edge checks this first and stops without changing anything, pointing you at
`seihou agent run`. Be aware of one consequence: Seihou records a receipt whenever a session
returns, and a deliberate refusal returns normally, so that edge is then marked done and skipped on
the run that should have applied it. Pass `--rerun` to execute it anyway.

This is tracked upstream as `mori://shinzui/seihou`'s IR-1, which asks for a not-applicable outcome
distinct from both success and provider failure. In practice it rarely bites here: a repository
that adopts afterwards lands directly on the tag the shipped descriptor pins, so the skipped edge
would have been a no-op reconciliation.

## For maintainers: adding an edge

When a future `okf-profiles` release changes `profiles/documentation/architecture-decisions.dhall`:

1. Write the edge prompt under `migrations/`, naming the exact constraints that changed and the
   validation that proves the upgrade worked.
2. Declare it in `blueprint.dhall` keyed at the **last release before the change**, not at the
   oldest version still in the wild. An edge is selected only when it falls inside the requested
   window, so keying it too early makes it unreachable from every later `--from`.
3. Update the shipped `files/architecture-decisions-profile.dhall` to the new tag and re-freeze its
   hash with `dhall freeze`, so new adopters do not start stale.
4. Bump the blueprint `version` in both `blueprint.dhall` and `seihou-registry.dhall` to match the
   `okf-profiles` tag it targets. The blueprint version is deliberately aligned with the profile
   tag, because that tag is the only version a consumer can read off their own repository.
5. Verify with `seihou validate-blueprint blueprints/adopt-architecture-decisions`, then dry-run
   `seihou agent --debug migrate` from every version still plausibly in use and confirm each one
   selects the new edge.
