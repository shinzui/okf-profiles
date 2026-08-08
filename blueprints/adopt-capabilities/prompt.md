# Adopt the shared OKF capability profile

Author a profile-governed capability catalog at `docs/capabilities/` for the current repository:
what this repository **provides to a consumer today**, one concept per capability, each backed by
evidence a reader can open. Complete the catalog, enforced profile validation, and Mori
registration.

This run requires a tool-capable local CLI provider such as `claude-cli` or `codex-cli`.

Treat any additional prompt supplied to `seihou agent run` as repository-specific guidance — for
example, which surfaces are internal, a preferred check target, or a capability the operator knows
is missing. Apply it together with repository evidence, but do not let it weaken the evidence
requirement or the granularity rule below.

## This blueprint authors; it does not migrate

Unlike a corpus migration, there is usually no prior capability catalog to adapt. You are deriving
claims from source code, tests, documentation, and release history. **That makes fabrication the
central risk of this run.** Everything below exists to prevent it.

Read `authoring-reference.md` before editing. It defines the profile contract, the granularity
rule, the evidence discipline, the Mori declaration, and the validation sequence. If Seihou reports
no readable reference directory, stop before editing and report that the blueprint cannot safely
install the authoritative profile. Do not recreate the profile from memory.

`capabilities-profile.dhall` is the version-pinned descriptor to install at
`docs/capabilities/profile.dhall`. Install it verbatim.

## Working rules

Read every repository-local instruction file before editing. Preserve unrelated changes and work on
the current branch. Follow the repository's commit conventions, but do not commit or push unless the
operator explicitly asks.

If `mori.dhall` exists, run `mori show --full` before planning changes. Use Mori before guessing any
dependency or tool API. Never search `/nix/store` or traverse `/`; scope searches to the current
repository and exact paths Mori returns.

## The three rules that decide what becomes a record

**1. Evidence or it does not exist.** Every capability names at least one artifact — a test, a
conformance fixture, an example, a benchmark, a module, or a guide — that a reader can open. Before
writing an evidence entry, confirm the path exists. A capability you cannot evidence is not a
capability record; it is an improvement request. There is deliberately no `planned` status.

**2. Provision, not composition.** A capability is something *this repository's code* does. If a
claim is only true when several repositories cooperate, no single repository can assert or prove it
— it belongs to the consuming repository as a use-case feature. A useful test: a record must read
correctly to someone who has never heard of the other repositories in this portfolio. In practice
this filters more than vocabulary; a claim that cannot be phrased without naming a sibling service
is usually a composition claim in disguise.

**3. One capability is one thing a consumer adopts *and* verifies independently.** Where two
candidates always ship together and are proven by the same evidence, they are one capability. A
catalog with one record per exported module or per CLI subcommand is a worse copy of the API
reference, and is the main way this format fails.

## Phase 1: Inventory the real surface

Start with:

```bash
git status --short --branch
```

Then gather evidence, in this order, because later sources correct earlier ones:

- **Packages and their descriptions** — what units a consumer can actually depend on.
- **Exported modules, public API, CLI command tree** — the surface a consumer touches.
- **Tests** — the strongest evidence available, and the honest bound on what is proven.
- **User documentation and README** — often already a feature list, but written to persuade.
- **Release history / changelog** — the only reliable source for `since`.

Read module headers rather than trusting names. They frequently say the quiet part directly: that a
path is a stub, a placeholder, an in-memory default, or proven only against a fixture.

If the repository has no consumer-facing surface — it is a schema-only package, a pinned artifact,
or an internal scaffold with nothing another project adopts — report that capability adoption is not
applicable and finish successfully **without creating an empty bundle, profile, log, or Mori
entry**. This no-op behavior is required, because plan-module upgrades invoke this blueprint across
repositories regardless of whether they have a surface to describe.

If `docs/capabilities/` already uses the shared profile, treat the run as an idempotent
reconciliation: preserve every valid `CAP-N` handle, repair only missing registration or validation
wiring, and do not rewrite conforming records.

## Phase 2: Decide the capability set

Group the inventory by rule 3. Expect substantially fewer capabilities than commands, modules, or
documentation pages — a large CLI with thirty command families may honestly have a dozen or so
capabilities.

Assign a stable `CAP-N` handle per capability, numbered from 1 in a stable order.

Two judgments recur:

- **A capability that grew materially in a later release** becomes its own record that `requires`
  the older one, rather than moving the older record's `since` forward. Claiming an early `since`
  for behavior that arrived later, or silently advancing it, both misinform a consumer pinning an
  older version.
- **`stability` is not `status`.** Availability and compatibility are different questions. A shipped
  capability in a pre-1.0 project is usable *and* unstable. In a project with a uniform
  compatibility promise the field is uniform too — that is correct, not a defect.

## Phase 3: Write the records

One file per capability, plus the reserved `index.md` and `log.md`. Follow the frontmatter contract
in `authoring-reference.md` exactly.

For each record:

- State what it does for a consumer, in that consumer's terms.
- Give the shortest real usage that shows the shape — a command, a call, a config value.
- **Write a `Limits` section, and make it truthful.** An in-memory default, a fixture-only proof, a
  stub live path, an interim implementation, an untested package, an operational footgun: record it
  here. This section is what makes the catalog worth trusting, and the temptation to soften it is
  exactly why it is required. If a capability's evidence is weaker than the rest of the catalog,
  say so in the record.
- Mirror every `requires` entry as a Markdown body link. `okf` derives concept-to-concept graph
  edges from body links only; a frontmatter-only requirement validates cleanly and is invisible to
  `okf graph`.

Set `generated.by` to your own actor identity in `<producer>/<version>` form. **Do not write a
`human:` actor for content you authored** — OKF uses that prefix to distinguish human-reviewed from
machine-generated content, and claiming it misreports the trust tier.

Write `index.md` with `okf_version: "0.2"`, a short statement of what the repository provides, an
explicit note of anything deliberately excluded, and a table of the records. Write `log.md` with one
dated entry describing the adoption.

## Phase 4: Register and validate

Declare the bundle in `mori.dhall` under `okfBundles` as described in `authoring-reference.md`, then:

```bash
mori validate
okf validate docs/capabilities --profile docs/capabilities/profile.dhall \
  --profile-enforce --log-enforce
okf graph docs/capabilities
```

Validation must pass. Inspect the graph and confirm the edges match the `requires` you declared; a
missing edge means a requirement was not mirrored as a body link.

If the repository has a documentation or check target, wire this validation into it the way the
repository already wires its other checks.

`--strict` additionally reports the profile-recommended `reviews` family, which machine-authored
records will not have. That is expected and is not a failure of this run; do not fabricate review
provenance to silence it.

## Phase 5: Report

Report concisely:

- The capability set and why the grouping is what it is.
- Anything you deliberately excluded, and under which of the three rules.
- **Every gap the evidence requirement exposed** — untested packages, stub live paths, surfaces that
  turned out to be documentation-only. These are the most valuable output of the run, because they
  are things the repository did not previously know it was claiming.
- Any `since` you could not establish from release history.
