---
id: 10
slug: adopt-okf-0-9-guidance-across-existing-catalog-profiles
title: "Adopt the okf 0.9 optional-guidance schema"
kind: exec-plan
created_at: 2026-09-13T15:45:35Z
intention: "intention_01m2dg6wsre5jr07176yk9yejp"
provenance:
  revisions:
    - model: "claude-opus-5"
      harness: "claude-code"
      at: 2026-09-13T16:37:53Z
      mode: "implement"
      note: "Implemented schema adoption, docs, ADR, metadata repair, blueprints, and v0.15.0 release"
---

# Adopt the okf 0.9 optional-guidance schema

This ExecPlan is a living document. The sections Progress, Surprises & Discoveries,
Decision Log, and Outcomes & Retrospective must be kept up to date as work proceeds.
If durable project context changes, update or create ADRs in docs/adr/ in the same change.


## Purpose / Big Picture

The profile catalog currently cannot use okf 0.9's optional `guidance` field when a model needs a
small procedural hint that the structured profile cannot express. After this change, the public
catalog schema will support that field, but every existing profile and type will continue to
inherit `guidance = None Text`. A future profile author may add a narrow hint only after observed
authoring behavior shows that the model cannot reliably infer the right approach from the profile's
types, rules, descriptions, repository evidence, and ordinary context.

The intended behavior resembles an index hint in SQL: it is an escape hatch for a demonstrated
bad plan, not part of the normal query. Broad instructions, universal checklists, and duplicated
field descriptions constrain a capable model's reasoning and can make results worse. The visible
proof is therefore both positive and negative. With `okf` 0.9.0.0, a temporary local override can
add guidance and `okf profile show` will print it; the unchanged catalog exports will still print
`guidance: (none)`, their generated documentation will remain byte-for-byte unchanged, and all
existing acceptance and rejection fixtures will retain their results.

This plan does not add an assurance profile, choose a QA/runbook profile name, or promote the
upstream QA fixture into the public catalog. That profile needs a separate design covering its
purpose, taxonomy, structured evidence, and operating model. This plan only adopts the released
schema across exports that already exist, refreshes the blueprints that install those exports,
repairs known catalog metadata drift, and publishes the result.


## Progress

- [x] (2026-09-13 16:36Z) Rechecked the dependency gate: tag `v0.9.0.0` peels to
  `bdf8893ccf0dfbd77fd68fe3c58348b5e49809c7`; Hackage lists `0.9.0.0` as a normal version of both
  `okf-core` and `okf-cli`.
- [x] (2026-09-13 16:39Z) Repinned `Profile/okf.dhall` to the 0.9.0.0 commit; `dhall freeze`
  reproduced `sha256:6bdf781d…7fc3` and `package.dhall` type-checks.
- [x] (2026-09-13 16:44Z) Computed the local semantic hashes: root package
  `sha256:e1e7eaac9d08fd3409fe0d19057dba5634a4186733ccbf28323e9aa2a2512dc0`, direct capabilities
  profile `sha256:d02b2944e85109c06e7a095a81de2e7ef7c6f607b225ec99622e60810889d809`. The same
  command on the stashed v0.14.0 tree reproduced v0.14.0's published hash.
- [x] (2026-09-13 16:46Z) Repaired `mori.dhall` (failure-modes profile, adopt-capabilities
  template and DocRef, family description, all versions at v0.15.0/0.15.0) and set all five
  blueprint and Seihou registry versions to 0.15.0.
- [x] (2026-09-13 16:50Z) Retargeted the five blueprints' current descriptors, prompts, READMEs,
  and references to v0.15.0 and `okf` 0.9.0.0, keeping historical introduction statements and
  existing migration edges.
- [x] (2026-09-13 16:55Z) Updated `README.md` (compatibility, consumer upgrade order,
  description/rules/guidance split, schema evolution, generated docs, catalog, authoring),
  `package.dhall` and `profiles/okf-v0-2.dhall` example comments, and drafted the v0.15.0
  `CHANGELOG.md` entry. Drafted the ADR text outside the bundle pending ID allocation.
- [x] (2026-09-13 17:02Z) Obtained `okf v0.9.0.0 (bdf8893)`: Hackage install failed and a full
  Nix build was too slow, so the exact tagged commit was built with cabal from a shared local
  clone in a scratch directory (see Surprises & Discoveries).
- [x] (2026-09-13 17:03Z) Milestone 1 validation: `okf profile list` reports 13 profiles and 30
  types; regeneration left `docs/profiles/` unchanged; `OKF_BIN=… just check` exited 0. Committed
  the pin as `6b3e41c`.
- [x] (2026-09-13 17:04Z) Milestone 2 probes: text inspection prints `guidance: (none)` at profile
  and all six type scopes of `documentation.userDocumentation`; JSON shows null at `.guidance`
  and on all six types; the `env:OKF_GUIDANCE_PROBE` override printed the one sentence and its
  JSON equals `postgresql` once `guidance` is deleted. A scratch `okf profile document` of the
  override showed where hints render (used to correct the README).
- [x] (2026-09-13 17:05Z) Normalized JSON comparison of all 13 exports against v0.14.0: every
  `guidance` null across 30 types, no other diff.
- [x] (2026-09-13 17:07Z) `okf id next` returned `ADR-12`; added
  `docs/adr/0012-guidance-is-an-evidence-backed-exception.md`, reindexed, logged, and strict
  validation reported `OK: 12 concepts (okf_version 0.2)`. Committed as `6a32f9b`.
- [x] (2026-09-13 17:08Z) Metadata validation: `mori show --full` reports Docs (8), Templates (5),
  OKF Profiles (13); `seihou registry validate` reports 5 blueprints with versions in sync; all
  five blueprints lint valid. Committed blueprints and manifests as `6fe34ab`.
- [ ] Release commit, annotated `v0.15.0` tag, push, remote tag verification.
- [ ] Post-publication: freeze remote root and capabilities imports and compare hashes,
  type-check shipped blueprint descriptors, rerun `just check`, `mori register --local`.


## Surprises & Discoveries

- Observation: Passing a Dhall `let` expression that contains `./package.dhall` directly to
  `--registry` does not reach Dhall evaluation. The CLI's registry preflight sees the slash and
  treats the entire argument as a nonexistent filesystem path.
  Evidence: the direct probe failed with `registry path ... does not exist`; placing the same
  expression in the task-specific `OKF_GUIDANCE_PROBE` environment variable and passing
  `env:OKF_GUIDANCE_PROBE` loaded the temporary registry successfully.

- Observation: `cabal install okf-cli-0.9.0.0` outside a Nix development shell fails because the
  Haskell `zlib` package cannot find the system C library.
  Evidence: `Failed to build zlib-0.7.1.1. The failure occurred during the configure step.
  Missing (or bad) C library: z`. A `nix build` of the tagged flake then started compiling
  the whole Haskell package set from source (dozens of library derivations after ten minutes).
  Building the tag with `cabal build exe:okf` inside `nix develop /Users/shinzui/Keikaku/bokuno/okf`
  from a `git clone --shared` checkout of `bdf8893` reused the cached cabal store and linked in
  about a minute.

- Observation: generated documentation renders profile guidance in two places, not only on type
  pages. `profile.md` gains `## Guidance`; each type page gains `## Guidance` with a
  `### Profile-wide` subsection.
  Evidence: a scratch `okf profile document` of the PostgreSQL override produced `profile.md:16:
  ## Guidance` and `types/postgresql-table.md:17: ### Profile-wide`.

- Observation: the plan's `dhall freeze --all --inplace` still works with dhall 1.42.3 but prints
  `Warning: the flag "--inplace" is deprecated`; freezing is in place by default.


## Decision Log

- Decision: Publish the optional-guidance-capable catalog as v0.15.0 and require `okf` 0.9.0.0
  or later.
  Rationale: `guidance` widens the public `Profile` and `TypeRule` Dhall record types. Record
  completion keeps this repository's values source-compatible, but a consumer needs the 0.9
  decoder to load the widened values. This repository's compatibility policy therefore calls
  for a minor catalog release rather than a patch release.
  Date: 2026-09-13

- Decision (superseded 2026-09-13): Give every existing published profile non-blank profile-wide
  guidance and every one of its declared type rules non-blank type-specific guidance.
  Rationale: this initially treated guidance coverage as catalog completeness. The user rejected
  that premise because unnecessary instructions overconstrain model reasoning. The replacement
  decision below governs implementation.
  Date: 2026-09-13

- Decision: Keep `guidance = None Text` as the catalog default and leave all 13 current profile
  values and all 30 current type rules unhinted in v0.15.0.
  Rationale: guidance is analogous to an optimizer hint. Add it only after a repeated, observable
  authoring failure shows that a model cannot infer an important procedure from structured rules,
  descriptions, repository evidence, and ordinary context. No such evidence has been established
  for the existing catalog exports. Schema availability is useful now; speculative prompting is
  not.
  Date: 2026-09-13

- Decision: A future guidance addition must be minimal, evidence-backed, and scoped to the
  smallest profile or type where the ambiguity occurs.
  Rationale: profile-wide guidance affects every declared type and type-specific guidance is added
  to it. A broad hint can suppress otherwise useful model judgment. The author must record the
  observed failure, explain why structured rules or descriptions cannot resolve it, state the
  smallest corrective nudge, and define how improved behavior will be observed. Absence needs no
  justification.
  Date: 2026-09-13

- Decision: Preserve every v0.14.0 validation rule and description verbatim; add procedure only
  through the new `guidance` fields.
  Rationale: descriptions answer what a profile, type, or field is; guidance answers how to do
  the work. Keeping the diff documentary makes the release require a tool upgrade but no corpus
  migration, and a normalized JSON comparison can prove that no rule changed accidentally.
  Date: 2026-09-13

- Decision (superseded 2026-09-13): Reuse the released PostgreSQL example's guidance and
  specialize it for the Tan profile.
  Rationale: matching examples seemed useful, but the upstream PostgreSQL file is a demonstration
  of the mechanism, not evidence that models fail against either catalog profile. Copying it would
  turn an example into a default prompt without a demonstrated need.
  Date: 2026-09-13

- Decision: Refresh all five Seihou blueprints to target v0.15.0 without adding migration edges.
  Rationale: new adopters should receive descriptors compatible with the 0.9 schema and may later
  add a narrow local hint if evidence requires one. All blueprints change what they install or
  recommend. Existing concept documents need no rewrite, so an agent-driven corpus migration
  would invent work. Bumping the blueprint versions and their three registry declarations follows
  the catalog-version rule in ADR-7.
  Date: 2026-09-13

- Decision: Repair all known `mori.dhall` publication drift in the same catalog release.
  Rationale: `package.dhall` and the documentation generator expose 13 profiles while Mori
  advertises 12 because `assurance.failureModes` is absent. Seihou advertises five blueprints
  while Mori advertises four and omits the `adopt-capabilities` guide. Leaving those omissions
  in place would make the release's discovery metadata observably incomplete.
  Date: 2026-09-13

- Decision: Do not mass-repin existing consumer repositories in this plan.
  Rationale: Mori currently observes 86 profile pins with different repository-native tool and
  validation setups. Guidance changes no corpus validity, so forcing a fleet-wide 0.9 toolchain
  update is independent rollout work. This plan updates reusable blueprints and publishes exact
  opt-in repinning steps for those consumers instead.
  Date: 2026-09-13

- Decision: Keep the prospective QA or assurance profile entirely outside this plan.
  Rationale: the `qa-runbooks` value in okf is a focused acceptance fixture, not a settled public
  convention. Separating it prevents the schema rollout from choosing a name, types, evidence
  model, or enforcement policy before those questions have been worked through.
  Date: 2026-09-13


- Decision: Build the 0.9.0.0 executable from the tagged commit with cabal inside the okf
  checkout's development shell, using a `git clone --shared` of the checkout in a scratch
  directory, rather than wait for `nix build`.
  Rationale: the plan's Hackage route failed on a missing C library, and `nix build` of the
  flake began compiling the entire Haskell package set from source. The shared clone checks out
  exactly `bdf8893` without touching the dependency checkout's branch, worktree list, or build
  products, and the resulting binary reports `okf v0.9.0.0 (bdf8893)`.
  Date: 2026-09-13

- Decision: Tell ADR-blueprint adopters already at v0.8.0 that reaching v0.15.0 needs no edge,
  only a repin after upgrading `okf`.
  Rationale: the normalized JSON of `documentation.architectureDecisions` at v0.8.0 equals the
  local value once `guidance` is removed, so an edge would invent work.
  Date: 2026-09-13

- Decision: Place the description/rules/guidance explanation in `README.md` as a subsection at the
  end of Compatibility, with the optimizer-hint analogy and a PostgreSQL override explicitly
  labeled as an illustration.
  Rationale: the compatibility section is where a consumer learns the 0.9.0.0 floor, and the
  example must not read as a recommended hint.
  Date: 2026-09-13

## Outcomes & Retrospective

(To be filled during and after implementation.)


## Context and Orientation

This repository, `mori://shinzui/okf-profiles`, is a Dhall package containing reusable OKF house
profiles. OKF is a Markdown-and-YAML knowledge format. A profile is a declarative Dhall value
that names accepted concept types and frontmatter rules. `package.dhall` is the public package
root. It currently exports 13 profiles: two under `assurance`, four under `coordination`, four
under `documentation`, the format-level `okfV02`, and two PostgreSQL profiles. Those profiles
declare 30 type rules in total. The export names are already stable and this plan introduces no
fourteenth profile.

`Profile/okf.dhall` is the single upstream schema import. It currently pins okf-core 0.8.0.0 at
commit `1b61d1d7adbdf8d90488805dc972801e45562c02`, with semantic hash
`sha256:0589682fe0acc109e523eeb4ef7ed2bdfa6f67185183e926f3a138cc071ac009`.
`Profile/Type.dhall` and `Profile/TypeRule.dhall` re-export the upstream completion records rather
than copying their types or defaults. Every catalog value uses `Profile::{ ... }` and every type
rule uses `TypeRule::{ ... }`, either directly or through a helper. Dhall record completion merges
an author's fields with an upstream default before type-checking. This is why adding a defaulted
field can be adopted by changing one pin rather than inserting `None Text` into every old value.

okf 0.9.0.0 is now released through both authoritative channels. The annotated upstream Git tag
`v0.9.0.0` peels to release commit
`bdf8893ccf0dfbd77fd68fe3c58348b5e49809c7`; Hackage publishes both `okf-core-0.9.0.0` and
`okf-cli-0.9.0.0`. Freezing the released schema import produces:

```dhall
https://raw.githubusercontent.com/shinzui/okf/bdf8893ccf0dfbd77fd68fe3c58348b5e49809c7/okf-core/dhall/package.dhall
  sha256:6bdf781d3bafac7098196fc3ed152e94d34807bd79845d024a07fb94297c7fc3
```

That release adds `guidance : Optional Text` to the top-level `Profile` type and to each
`TypeRule`, with `None Text` defaults. Guidance is multiline Markdown containing prescriptive
authoring advice. It is not a validation rule, okf never executes commands found in it, and
profile-wide plus type-specific guidance is additive rather than overriding. Text inspection
prints each field, full JSON inspection preserves it as data, and `okf profile document` renders
it. These semantics are governed by
`mori://shinzui/okf/okf/adrs/concepts/ADR-19`. Generated type pages put profile-wide guidance
before type-specific guidance and omit blank scopes, as governed by
`mori://shinzui/okf/okf/adrs/concepts/ADR-6`. The complete upstream implementation plan is in
`mori://shinzui/okf` at project-relative path
`docs/plans/65-add-first-class-guidance-to-okf-profiles.md`; Mori does not currently resolve that
plan artifact, so its artifact-level URI is pending. Everything necessary from it is restated
here.

The optional default is a design constraint, not merely a compatibility convenience. A profile
and the model consuming it already have structured rules, concise descriptions, repository
evidence, and the surrounding task. Those inputs should be allowed to do the work. Guidance is
appropriate only when actual outputs reveal a recurring wrong choice that those inputs cannot
disambiguate. It should then resemble an optimizer hint: the smallest stable nudge that corrects
the bad plan. It is not a place to restate every rule, prescribe one universal workflow, or add a
checklist because the field exists. Because profile guidance is inherited by every type and type
guidance is additive, unnecessary prose compounds rather than replaces earlier constraints.

The profile sources live below `profiles/`. `profiles/postgresql.dhall` is the authoritative
catalog form of the worked PostgreSQL profile in okf. `profiles/tan-postgresql.dhall` starts from
that value but replaces its name, description, and type list to add table-role rules and an
`Event Stream` type. Helpers in `profiles/documentation/pattern-catalog.dhall` and
`profiles/documentation/user-documentation.dhall` construct several type rules from their type
name and description; they should remain unchanged and inherit `None Text` like direct
constructors. `Profile/V02.dhall` defines shared frontmatter rules, not profiles or type rules,
and must not gain guidance in this work.

`scripts/test-profile-docs.sh` enumerates all 13 public exports and regenerates one ordinary OKF
bundle below `docs/profiles/` for each. A root `profile.md` explains profile-wide behavior; each
`types/*.md` page explains the effective profile-wide and type-specific contract. The script's
check mode generates a temporary copy, compares it byte for byte, and strictly validates every
generated bundle. Because all guidance is currently absent, none of the checked-in pages has a
guidance section. The matching 0.9 renderer continues to omit those sections for `None Text`, so
adopting the schema without authoring hints must leave the generated tree unchanged.

Every behavioral profile also has a conforming fixture and focused rejection fixtures exercised
by `scripts/test-*-profile.sh`. `just check` type-checks the descriptor graph, runs all scripts,
checks generated documentation for drift, validates this repository's own ADR bundle, and lints
the Seihou blueprints. The globally installed executable currently reports `okf v0.8.0.0`, so
implementation must explicitly install or select `okf` 0.9.0.0 and pass its path through
`OKF_BIN`; otherwise a correct widened descriptor will fail to load for the wrong reason.

Three local decisions constrain the change. [ADR-2](../adr/0002-a-profile-flips-to-okf-v0-2-atomically.md)
requires load-time validation as well as Dhall type checks. This plan does not change OKF version
or structured rules, but all profiles still have to load under the new decoder.
[ADR-5](../adr/0005-v0-2-field-families-are-defined-once.md) makes `Profile/V02.dhall` the sole
source for shared v0.2 field constraints, so guidance must stay on profiles and type rules rather
than being smuggled into field descriptions. [ADR-7](../adr/0007-blueprint-versions-track-the-catalog-tag.md)
requires a blueprint whose installed target changes to use the catalog tag in its own
`blueprint.dhall`, `seihou-registry.dhall`, and `mori.dhall` entry.
[ADR-9](../adr/0009-a-rejection-fixture-must-fail-for-exactly-one-reason.md) governs rule tests;
because guidance adds no rule and this release authors no guidance, this plan adds neither a
rejection fixture nor a permanent guidance-coverage test. [ADR-11](../adr/0011-user-documentation-shares-reader-intent-types-and-doc-handles.md)
defines the six user-documentation types, but their taxonomy is not by itself evidence that each
type needs an instruction prompt.

`mori.dhall` is the discovery manifest. Its current `profiles` list omits
`assurance.failureModes`, although `package.dhall` and `scripts/test-profile-docs.sh` already
publish it. Its `templates` list omits `adopt-capabilities`, although `seihou-registry.dhall`
publishes that blueprint, and its `docs` list omits the matching blueprint README. The local Mori
projection consequently reports 12 profile publishers, four Seihou templates, and seven docs
instead of 13, five, and eight. Repair those omissions as part of publication. Mori currently
observes 86 downstream profile pins into this project. They are an impact inventory, not a
license to mutate 86 repositories from this plan.


## Plan of Work

### Milestone 1: Move the catalog onto the released schema

First establish that the dependency gate is still true at implementation time. Use Mori to locate
`mori://shinzui/okf`, then independently check Hackage and the upstream tag rather than trusting a
possibly stale registry projection. Install `okf-cli-0.9.0.0` into a temporary directory so no
global executable is replaced.

Update `Profile/okf.dhall` as one atomic pin change: replace the 0.8 commit and integrity hash with
the exact 0.9 commit and hash recorded above, and update its module comment to say why 0.9.0.0 is
required. Run `dhall freeze --all --inplace Profile/okf.dhall` after changing the URL and confirm
that it reproduces the expected hash. Do not fork any schema type or default locally.

After repinning, type-check `package.dhall`, list all profiles with the 0.9 executable, and
regenerate the documentation once. Every completed value should
contain `guidance = None Text`, the profile list should still report 13 profiles and 30 types, all
existing validation scripts should pass, and regeneration should leave `docs/profiles/` unchanged
because the 0.9 renderer omits absent guidance. This proves that the pin itself is compatible and
separates schema effects from authored prose.

### Milestone 2: Preserve the no-guidance default and define the escape hatch

Do not add `guidance` to any value under `profiles/`. The completed values should all inherit
`None Text` from okf 0.9. This includes profiles whose source headers contain useful background:
comments and repository documentation can explain a contract without injecting that prose into
every model invocation. Do not widen helper functions such as `rule` in
`profiles/documentation/pattern-catalog.dhall` or `documentType` in
`profiles/documentation/user-documentation.dhall`; they should continue to inherit the default.

Document the threshold for a later hint. Guidance is justified only when all of these conditions
are met:

- repeated or otherwise compelling output evidence shows a specific bad authoring choice;
- the structured profile, its descriptions, repository evidence, and normal task context do not
  already make the correct choice reliably inferable;
- the correction is stable across consumers of the selected scope rather than local to one task;
- the hint can be narrower than a replacement workflow or universal checklist; and
- there is an observable way to tell whether the hint improves the failure it targets.

When that evidence exists, choose the smallest scope. Use profile guidance only for ambiguity
shared by every type. Use type guidance only for a type-specific ambiguity; it is added after any
profile guidance rather than replacing it. Prefer one precise nudge over background education.
Do not use guidance to repeat allowed values, required fields, path rules, descriptions, ordinary
best practices, or instructions that belong in a task-specific runbook. Remove or reduce a hint
when the model, structured schema, or surrounding context can infer the behavior without it.

Prove both sides of the interface without committing a hint. `okf profile show` and its JSON form
must report absent guidance for every current export. Then construct a temporary registry
expression that overrides only `postgresql.guidance`; showing that temporary value must print the
hint while validation behavior remains identical. This demonstrates that the capability is ready
for an evidence-backed exception without turning the exception into catalog policy.

Do not add a permanent test that counts guided profiles or types, and do not add rejection
fixtures for prose. The existing generated-documentation drift test will cover any future hint
once one is deliberately authored. This release's one-off audit records that every current scope
is absent; it is release evidence, not a rule forbidding future evidence-backed additions.

### Milestone 3: Publish the sparse-use policy, compatibility docs, ADR, and Mori metadata

Run `just docs` with `OKF_BIN` pointing to 0.9.0.0 and require no diff below `docs/profiles/`.
Inspect the generated tree and confirm that it contains no `## Guidance`, `### Profile-wide`, or
`### Type-specific` headings. The 0.9 renderer omits absent guidance, so this unchanged tree is the
expected result rather than missing work. Run generation a second time as the ordinary
reproducibility check. Never hand-edit anything below `docs/profiles/`.

Update `README.md` in the compatibility, schema-evolution, generated-documentation, and
profile-authoring sections. State that v0.15.0 requires `okf` 0.9.0.0 or later, define the
description/guidance/rules split, and make `None Text` the normal guidance state. Use the optimizer-
hint analogy: add guidance only for demonstrated ambiguity, keep it minimal, and scope it as
narrowly as possible. Show one short local override as an example, not a catalog default. Explain
that generated guidance is profile-wide and then type-specific when present, while absent guidance
produces no documentation section. Give a consumer the upgrade order: update the CLI first, repin
and freeze the profile second, then run the repository's strict validation. Also update the stale
version example in `profiles/okf-v0-2.dhall` and the public-package example comment in
`package.dhall` when the final v0.15.0 hash is known.

Create a v0.15.0 entry in `CHANGELOG.md`. The release summary should say that the public authoring
schema now supports optional profile and type guidance while all existing exports deliberately
leave it absent. No structured rules, descriptions, or export names change. The migration section
must distinguish document migration from tool migration: existing concept files need no edits,
but any consumer repinning to v0.15.0 must run `okf` 0.9.0.0 or later. Record the final remote
package import and semantic hash in the same form as previous releases.

Record the lasting catalog policy in a new ADR. Ask the local bundle for the next ID with `okf id
next docs/adr --profile docs/adr/profile.dhall ADR`; it is expected to return `ADR-12`, but use the
command's result rather than assuming. Create the next four-digit file under `docs/adr/` with the
title “Guidance is an evidence-backed exception.” The decision should preserve the three-way
split: descriptions identify, structured rules validate, and guidance narrowly corrects a
demonstrated authoring ambiguity without execution. It must state that absence is the default and
needs no justification, while an addition needs failure evidence, a reason other inputs are
insufficient, the smallest applicable scope, and an observable improvement criterion. Add
`originatingPlan` pointing to this file, update the bundle index with `okf index`, and add one
dated `Addition` entry to `docs/adr/log.md` with `okf log add`.

Repair `mori.dhall` while publishing the new behavior. Add the missing
`assurance.failureModes` profile record, update all 13 profile `version` values to `v0.15.0`
because the public record shape gains the optional field even though its value is absent, add the
missing `adopt-capabilities` template and guide DocRef, and make the package description name the
assurance family. After the blueprint milestone, all five template versions must agree with their
blueprint and Seihou registry values. The intended local projection is 13 published profiles,
five templates, and eight docs.

### Milestone 4: Refresh the reusable adoption blueprints

Bring all five existing Seihou blueprints forward so a new adopter receives the 0.9-compatible
profile schema and may add a targeted local hint later if evidence warrants one. Set each
`blueprints/*/blueprint.dhall` version, each corresponding entry in
`seihou-registry.dhall`, and each corresponding template version in `mori.dhall` to `0.15.0`.
Do not add a migration edge: there is no concept-frontmatter or body repair for guidance.

Update only the current target of each blueprint, preserving historical statements about when a
profile or migration rule was introduced. In `blueprints/adopt-architecture-decisions/`, repin
`files/architecture-decisions-profile.dhall` and update the README's “new adopter” target and
minimum CLI; leave the `0.6.0 -> 0.7.0` and `0.7.0 -> 0.8.0` edge documents unchanged. In
`blueprints/adopt-capabilities/`, repin `files/capabilities-profile.dhall` and update current
requirements while retaining statements that the capability contract originated in v0.9.0.

In `blueprints/adopt-improvement-request-contracts/`, make the prompt, README, and
`files/contract-reference.md` install or repin v0.15.0 and require `okf` 0.9.0.0; continue saying
that `dependencies` and `acceptanceCriteria` were introduced in v0.12.0. In
`blueprints/adopt-user-documentation/`, update `files/user-documentation-profile.dhall`,
`files/migration-reference.md`, the prompt, and the README to target v0.15.0 and `okf` 0.9.0.0;
continue saying that the shared taxonomy originated in v0.13.0. In
`blueprints/migrate-okf-bundles-to-v0-2/`, update the current destination imports and present-day
tool requirement to v0.15.0 and 0.9.0.0 while retaining the historical explanation and migration
edges for the v0.8.0 transition that introduced OKF v0.2.

Imports of the root `package.dhall` use the final local root-package semantic hash. The direct
capabilities-profile import uses the semantic hash of
`profiles/coordination/capabilities.dhall`, not the root-package hash. These self-targeting remote
URLs cannot resolve until v0.15.0 is pushed; compute the hashes from the equivalent local values,
record them before tagging, and defer the final remote-import proof until Milestone 5. Structural
blueprint linting and every non-remote catalog check must already pass before publication.

### Milestone 5: Release v0.15.0 and verify the immutable artifacts

Run the full test matrix with the selected 0.9 executable, compute both semantic hashes, and finish
the changelog and embedded blueprint pins. Verify the public package's normalized JSON against
v0.14.0 after confirming every new `guidance` member is null and then deleting those members;
every export should otherwise compare equal. This is the load-bearing proof that the release adds
an optional schema capability rather than changing catalog policy.

Commit in coherent, passing units using Conventional Commits. Every implementation and release
commit must include both the `ExecPlan:` and `Intention:` trailers shown in Concrete Steps. The
final release commit should leave `git status --short` empty. Create an annotated `v0.15.0` tag,
push the branch and tag, then verify that the peeled remote tag points at the release commit.

After publication, freeze the remote root package and direct capabilities profile and require
their hashes to match the local values exactly. Type-check each shipped blueprint descriptor now
that its remote v0.15.0 URL exists, reinstall or validate the five public blueprints, and run the
catalog checks once more. Register the clean checkout locally with Mori and confirm the published
projection reports 13 profiles, five templates, and eight docs. Finally, record the release
commit, peeled tag, hashes, validation transcript, and any remaining rollout gap in this plan's
living sections.


## Concrete Steps

Run all commands from `/Users/shinzui/Keikaku/bokuno/okf-profiles` unless a command explicitly
changes directory. Start by confirming the working tree is clean and rechecking the dependency:

```bash
git status --short
mori registry show shinzui/okf --full
git ls-remote --tags https://github.com/shinzui/okf.git \
  refs/tags/v0.9.0.0 'refs/tags/v0.9.0.0^{}'
curl -fsSL https://hackage.haskell.org/package/okf-core/preferred.json
curl -fsSL https://hackage.haskell.org/package/okf-cli/preferred.json
```

The tag output must contain peeled commit
`bdf8893ccf0dfbd77fd68fe3c58348b5e49809c7`, and both Hackage documents must list `0.9.0.0` as a
normal version. Install the matching executable into a disposable directory and keep these
exports in the same shell for the rest of the work:

```bash
export OKF_090_BIN="$(mktemp -d)"
cabal install okf-cli-0.9.0.0 \
  --installdir "$OKF_090_BIN" \
  --overwrite-policy=always
export OKF_BIN="$OKF_090_BIN/okf"
export PATH="$OKF_090_BIN:$PATH"
"$OKF_BIN" --version
```

Expected version evidence:

```text
okf v0.9.0.0 (...)
```

After editing the upstream URL in `Profile/okf.dhall`, freeze and establish the no-guidance
baseline:

```bash
dhall freeze --all --inplace Profile/okf.dhall
dhall type --file package.dhall >/dev/null
"$OKF_BIN" profile list --no-local --registry package.dhall
OKF_BIN="$OKF_BIN" bash scripts/test-profile-docs.sh --regenerate
git diff --exit-code -- docs/profiles
OKF_BIN="$OKF_BIN" just check
```

The list must contain 13 profiles and 30 types in aggregate. The generated-doc diff must be empty
and remains the expected final state because this release authors no guidance. After Milestone 2,
exercise both the default and the escape hatch directly:

```bash
"$OKF_BIN" profile show --no-local --registry package.dhall \
  documentation.userDocumentation
"$OKF_BIN" profile show --no-local --registry package.dhall \
  documentation.userDocumentation --json \
  | jq '{guidance, types: [.types[] | {type, guidance}]}'
export OKF_GUIDANCE_PROBE='let catalog = /Users/shinzui/Keikaku/bokuno/okf-profiles/package.dhall in { hinted = catalog.postgresql // { guidance = Some "Inspect the live database only when repository evidence cannot establish the deployed schema." } }'
"$OKF_BIN" profile show --no-local --registry env:OKF_GUIDANCE_PROBE hinted
unset OKF_GUIDANCE_PROBE
```

The catalog text output must show `guidance: (none)` at profile and type scope. The JSON result
must contain null at `.guidance` and on all six type objects. The temporary `hinted` value must
print the one supplied sentence under `guidance:` while retaining the PostgreSQL rules. Keep the
expression behind `env:OKF_GUIDANCE_PROBE`: passing it directly makes the registry preflight
mistake its local import for a path to the registry itself.

Generate and prove that absent guidance remains absent:

```bash
OKF_BIN="$OKF_BIN" just docs
if rg -n '^## Guidance$|^### Profile-wide$|^### Type-specific$' docs/profiles; then
  echo "unexpected committed guidance; record its failure evidence or remove it" >&2
  exit 1
fi
git diff --exit-code -- docs/profiles
OKF_BIN="$OKF_BIN" just docs
git diff --check
OKF_BIN="$OKF_BIN" just check
```

Allocate and validate the ADR with the same 0.9 executable:

```bash
"$OKF_BIN" id list docs/adr --profile docs/adr/profile.dhall
"$OKF_BIN" id next docs/adr --profile docs/adr/profile.dhall ADR
"$OKF_BIN" index docs/adr --write --okf-version 0.2
"$OKF_BIN" log add docs/adr --kind Addition \
  --message "Guidance is an evidence-backed exception and remains absent by default."
"$OKF_BIN" validate docs/adr --strict \
  --profile docs/adr/profile.dhall --profile-enforce --log-enforce
```

After repairing the manifests and blueprint versions, run:

```bash
dhall type --file mori.dhall >/dev/null
dhall type --file seihou-registry.dhall >/dev/null
mori show --full
seihou registry validate
for blueprint in blueprints/*/blueprint.dhall; do
  seihou validate-blueprint "$(dirname "$blueprint")" --lint
done
```

The Mori output must report 13 profile publishers, five Seihou templates, and eight docs. Compute
release hashes only after the guidance is final:

```bash
dhall hash --file package.dhall
dhall hash --file profiles/coordination/capabilities.dhall
```

Record those two outputs as `ROOT_HASH` and `CAPABILITIES_HASH` task-specific shell variables in
the same session. Use the root hash for every import that selects from v0.15.0 `package.dhall` and
the direct hash only for the direct capabilities import.

Before tagging, confirm the current values leave guidance absent, then compare them with v0.14.0
while ignoring only the new schema member. Run this loop over all 13 exports:

```bash
profiles=(
  assurance.failureModes
  assurance.reviews
  coordination.bugReports
  coordination.capabilities
  coordination.improvementRequests
  coordination.useCases
  documentation.architectureDecisions
  documentation.patternCatalog
  documentation.researchDocuments
  documentation.userDocumentation
  okfV02
  postgresql
  tanPostgresql
)
old_registry='https://raw.githubusercontent.com/shinzui/okf-profiles/v0.14.0/package.dhall sha256:87d2e4076b2491ee608ac1c7a28b24156ba2634f2b09de49ad4ba79f039acf50'
for export_name in "${profiles[@]}"; do
  "$OKF_BIN" profile show --no-local --registry package.dhall \
    "$export_name" --json \
    | jq -e '.guidance == null and all(.types[]; .guidance == null)' >/dev/null
  diff -u \
    <("$OKF_BIN" profile show --no-local --registry "$old_registry" \
        "$export_name" --json \
        | jq -S 'del(.guidance) | .types |= map(del(.guidance))') \
    <("$OKF_BIN" profile show --no-local --registry package.dhall \
        "$export_name" --json \
        | jq -S 'del(.guidance) | .types |= map(del(.guidance))')
done
```

The null checks must all pass and the loop must print no diff. If a guidance value is present,
either add its concrete failure evidence and narrow justification to this plan and the new ADR or
remove it. If the comparison reports another change, restore the v0.14 structured value or
explicitly revise this plan and the release's migration contract before continuing.

Use Conventional Commits and the mandatory trailers. A representative implementation commit is:

```text
feat(profiles): adopt the optional guidance schema

ExecPlan: docs/plans/10-adopt-okf-0-9-guidance-across-existing-catalog-profiles.md
Intention: intention_01m2dg6wsre5jr07176yk9yejp
```

The final release commit should use `chore(release): prepare okf-profiles 0.15.0` with the same
trailers. Once every pre-publication check passes:

```bash
git status --short
git tag -a v0.15.0 -m "v0.15.0 — optional profile guidance"
git push origin master
git push origin v0.15.0
git ls-remote --tags origin refs/tags/v0.15.0 'refs/tags/v0.15.0^{}'
```

Verify the immutable remote values after the push:

```bash
dhall freeze <<< \
  'https://raw.githubusercontent.com/shinzui/okf-profiles/v0.15.0/package.dhall'
dhall freeze <<< \
  'https://raw.githubusercontent.com/shinzui/okf-profiles/v0.15.0/profiles/coordination/capabilities.dhall'
dhall type <<< \
  'https://raw.githubusercontent.com/shinzui/okf-profiles/v0.15.0/package.dhall'
dhall type --file blueprints/adopt-architecture-decisions/files/architecture-decisions-profile.dhall
dhall type --file blueprints/adopt-capabilities/files/capabilities-profile.dhall
dhall type --file blueprints/adopt-user-documentation/files/user-documentation-profile.dhall
OKF_BIN="$OKF_BIN" just check
mori register --local
mori registry show shinzui/okf-profiles --full
```

The two frozen imports must reproduce the local root and direct-profile hashes. The remote tag's
peeled commit must equal the release commit. The final Mori projection must show v0.15.0 for all
13 published profiles and 0.15.0 for all five templates.


## Validation and Acceptance

Acceptance requires all of the following observable results.

First, dependency provenance is exact: the only schema URL and integrity hash in
`Profile/okf.dhall` name upstream release commit
`bdf8893ccf0dfbd77fd68fe3c58348b5e49809c7` and hash
`sha256:6bdf781d3bafac7098196fc3ed152e94d34807bd79845d024a07fb94297c7fc3`.
The selected executable prints version 0.9.0.0. The package and every profile type-check and load.

Second, the default is demonstrably sparse. Full JSON inspection reports `.guidance == null` for
all 13 profiles and all 30 type rules. Text inspection renders `guidance: (none)` rather than
inventing content. A temporary PostgreSQL override that changes only `guidance` renders the exact
hint supplied, proving that an evidence-backed exception is available without making it the
catalog default.

Third, the change is documentary only. The v0.14.0-versus-local JSON comparison is byte-identical
after deleting `guidance` at profile and type scope. Every pre-existing conforming fixture still
passes; every focused rejection fixture still fails; and no fixture document is changed merely to
adopt guidance. `OKF_BIN="$OKF_BIN" just check` exits zero and includes the existing profile,
generated-doc, ADR-bundle, and blueprint success lines, including:

```text
OK: profile documentation is current and validates
```

Fourth, generated documentation respects omission. No committed page contains `## Guidance`,
`### Profile-wide`, or `### Type-specific`, and a 0.9 regeneration changes no byte. The README,
not every generated profile page, demonstrates how a local author can add a minimal hint after
gathering evidence. The new ADR makes absence the unremarkable default and places the burden of
justification on additions.

Fifth, release and discovery metadata is complete. The README states the 0.9.0.0 minimum and the
consumer upgrade order. The changelog says documents require no migration. The new ADR and its log
entry validate strictly. Local and registered Mori views expose 13 profile publishers, five
templates, and eight docs, including `assurance.failureModes` and `adopt-capabilities`. The five
blueprints agree on version 0.15.0 across `blueprint.dhall`, `seihou-registry.dhall`, and
`mori.dhall`, install or recommend v0.15.0 descriptors, and add no migration edge.

Finally, the release is reproducible. The annotated remote v0.15.0 tag peels to the local release
commit, the remote root and direct capabilities imports reproduce their locally computed semantic
hashes, all embedded descriptor imports type-check after publication, and the checkout is clean.
No new profile export, fixture tree, profile-documentation directory, or profile metadata record
exists beyond the 13 pre-existing exports.


## Idempotence and Recovery

`dhall freeze`, `just docs`, `okf index`, and all validation commands are deterministic and may be
rerun. The documentation generator removes and recreates only its named directory beneath
`docs/profiles/`; it does not touch source profiles or fixture corpora. Always inspect `git diff`
after regeneration, and never repair a generated page by hand.

Keep the 0.9 executable in a `mktemp` directory and point `OKF_BIN` at it. If the shell is closed,
create another directory and reinstall; do not overwrite the user's global 0.8 executable. Remove
the disposable directory only after the release evidence is recorded. If `cabal install` cannot
resolve Hackage, build the exact v0.9.0.0 tag from the Mori-located okf checkout in a separate
temporary worktree; do not change branches or build products in the dependency's active checkout.

If guidance appears unexpectedly, use the normalized JSON comparison to identify its source and
remove it unless its evidence and narrow justification have first been added to this plan and the
new ADR. If any non-guidance field changes, restore it before proceeding. If generated
documentation is surprising, inspect the source profiles and regenerate twice. If the new ADR ID
is no longer ADR-12, use the fresh value from `okf id next`; never fill a gap or recycle an ID.

Do not create or move the v0.15.0 tag until the release commit is final and every pre-publication
check passes. Before pushing, a mistaken local tag is recoverable by deleting only that explicit
tag and recreating it. After pushing, treat the tag as immutable: do not force-move it. If remote
verification fails because the published bytes differ from the release commit, stop and record
the failure in this plan rather than changing consumer hashes to conceal it.

The self-referential blueprint URLs are expected to be unavailable before the tag exists. Their
hashes come from equivalent local Dhall values; validate every other surface before publication
and then type-check those exact files immediately after the tag is pushed. Historical migration
documents must not be globally search-and-replaced: phrases such as “introduced in v0.8.0” remain
true even though the blueprint's current destination becomes v0.15.0.

`mori register --local` updates local registry state and is safe to repeat for the same clean
commit. It does not replace the repository's own `mori show --full` validation. Existing consumer
repositories are read-only impact evidence for this plan; do not edit, commit, or push them.


## Interfaces and Dependencies

The upstream dependency is `okf-core` 0.9.0.0 from `mori://shinzui/okf`, verified against Hackage
and Git tag v0.9.0.0. Its published `okf-core/dhall/package.dhall` exposes completion records whose
relevant final shapes are conceptually:

```dhall
Profile.Type =
  { name : Text
  , description : Optional Text
  , guidance : Optional Text
  , okfVersion : Text
  , frontmatter : FrontmatterRules
  , allowUnknownTypes : Bool
  , allowUnknownFields : Bool
  , idField : Optional Text
  , requireBundleVersion : Optional Text
  , types : List TypeRule.Type
  }

TypeRule.Type =
  { type : Text
  , description : Optional Text
  , guidance : Optional Text
  , frontmatter : FrontmatterRules
  , pathPattern : Optional Text
  , resourceScheme : Optional Text
  , requireSchemaSection : Bool
  , schemaColumns : List Text
  , idPrefix : Optional Text
  }
```

Both completion defaults set `guidance = None Text`. This repository must continue to re-export
those upstream records through `Profile/Type.dhall`, `Profile/TypeRule.dhall`, and `package.dhall`;
it must not add a second schema layer.

The runtime dependency is `okf-cli` 0.9.0.0. `okf profile show` is the human inspection interface,
`okf profile show --json` is the structured inspection interface, and `okf profile document` is
the generated-documentation interface used by `scripts/test-profile-docs.sh`. Guidance is data on
all three interfaces. `okf validate` deliberately ignores the prose while loading the rest of the
profile normally.

The catalog's public API remains the existing `package.dhall` record with the same 13 export
paths. Its normalized type widens because the nested profile values widen, which is why v0.15.0
requires the new decoder. No new Haskell package or runtime service is introduced.

The implementation uses the existing Dhall CLI 1.42 or later for type-checking, semantic hashing,
and import freezing; `rg` for source and rendered-omission checks; `jq` only for the release-time
JSON equivalence audit; Seihou for blueprint linting and registry validation; and Mori for
dependency discovery, local registration, and publication projections. Dependency source must be
located through Mori before inspection, and release pins must continue to be checked against
Hackage and upstream Git rather than chosen from local registry metadata alone.


## Revision Note

2026-09-13: Revised the plan after the user clarified that guidance should behave like an SQL
optimizer hint. Removed blanket guidance authoring, type-helper changes, generated guidance
coverage targets, and the permanent coverage test. The plan now preserves `None Text` across all
existing profiles and types, demonstrates the capability with a temporary override, and records
an evidence-backed, minimally scoped exception policy in the proposed ADR.
