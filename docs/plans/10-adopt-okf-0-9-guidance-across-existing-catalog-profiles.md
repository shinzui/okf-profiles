---
id: 10
slug: adopt-okf-0-9-guidance-across-existing-catalog-profiles
title: "Adopt okf 0.9 guidance across existing catalog profiles"
kind: exec-plan
created_at: 2026-09-13T15:45:35Z
intention: "intention_01m2dg6wsre5jr07176yk9yejp"
---

# Adopt okf 0.9 guidance across existing catalog profiles

This ExecPlan is a living document. The sections Progress, Surprises & Discoveries,
Decision Log, and Outcomes & Retrospective must be kept up to date as work proceeds.
If durable project context changes, update or create ADRs in docs/adr/ in the same change.


## Purpose / Big Picture

The profile catalog currently tells a reader what each published profile and concept type is,
but it cannot carry the longer procedural advice needed to author a useful document. After this
change, a maintainer who imports the next catalog release can ask `okf profile show` how to write
any of the catalog's 13 existing profiles, or read the same advice in the generated profile
documentation. Profile-wide guidance will state the workflow common to a corpus, while each of
the 30 declared type rules will add its own concrete authoring procedure.

The visible proof is deliberately end to end. With `okf` 0.9.0.0, showing
`documentation.userDocumentation` will print non-empty multiline profile guidance and distinct
guidance for `Navigation`, `Tutorial`, `Guide`, `Explanation`, `Reference`, and `Runbook`.
`docs/profiles/user-documentation/profile.md` and every page below
`docs/profiles/user-documentation/types/` will render the same prose under `## Guidance`.
Existing acceptance and rejection fixtures will still produce the same validation results,
because guidance is documentary data and never an executable or validating rule.

This plan does not add an assurance profile, choose a QA/runbook profile name, or promote the
upstream QA fixture into the public catalog. That profile needs a separate design covering its
purpose, taxonomy, structured evidence, and operating model. This plan only adopts the released
schema across exports that already exist, refreshes the blueprints that install those exports,
repairs known catalog metadata drift, and publishes the result.


## Progress

(No implementation work has started.)


## Surprises & Discoveries

(None yet.)


## Decision Log

- Decision: Publish the guidance-aware catalog as v0.15.0 and require `okf` 0.9.0.0 or later.
  Rationale: `guidance` widens the public `Profile` and `TypeRule` Dhall record types. Record
  completion keeps this repository's values source-compatible, but a consumer needs the 0.9
  decoder to load the widened values. This repository's compatibility policy therefore calls
  for a minor catalog release rather than a patch release.
  Date: 2026-09-13

- Decision: Give every existing published profile non-blank profile-wide guidance and every one
  of its declared type rules non-blank type-specific guidance.
  Rationale: a partial sample would prove that the schema can carry prose without making the
  catalog reliably useful. Complete coverage gives a caller one predictable contract: selecting
  any house profile or declared type returns authoring instructions. The `okfV02` reference
  profile has no type rules, so only profile-wide guidance applies there.
  Date: 2026-09-13

- Decision: Preserve every v0.14.0 validation rule and description verbatim; add procedure only
  through the new `guidance` fields.
  Rationale: descriptions answer what a profile, type, or field is; guidance answers how to do
  the work. Keeping the diff documentary makes the release require a tool upgrade but no corpus
  migration, and a normalized JSON comparison can prove that no rule changed accidentally.
  Date: 2026-09-13

- Decision: Reuse the released PostgreSQL example's guidance exactly where the catalog profile
  has the same meaning, then specialize the Tan profile for its extra table roles and logical
  event streams.
  Rationale: `mori://shinzui/okf` and this repository intentionally ship a worked example and an
  authoritative catalog profile with the same PostgreSQL model. Shared prose should not drift;
  Tan-specific conventions belong only in the derived profile.
  Date: 2026-09-13

- Decision: Refresh all five Seihou blueprints to target v0.15.0 without adding migration edges.
  Rationale: new adopters should receive the guidance-aware descriptors and all blueprints change
  what they install or recommend. Existing concept documents need no rewrite, so an agent-driven
  corpus migration would invent work. Bumping the blueprint versions and their three registry
  declarations follows the catalog-version rule in ADR-7.
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

The profile sources live below `profiles/`. `profiles/postgresql.dhall` is the authoritative
catalog form of the worked PostgreSQL profile in okf. `profiles/tan-postgresql.dhall` starts from
that value but replaces its name, description, and type list to add table-role rules and an
`Event Stream` type. Helpers in `profiles/documentation/pattern-catalog.dhall` and
`profiles/documentation/user-documentation.dhall` construct several type rules from their type
name and description; they must be widened to take guidance as another argument. All remaining
profile files construct their rules directly. `Profile/V02.dhall` defines shared frontmatter
rules, not profiles or type rules, and must not gain guidance in this work.

`scripts/test-profile-docs.sh` enumerates all 13 public exports and regenerates one ordinary OKF
bundle below `docs/profiles/` for each. A root `profile.md` explains profile-wide behavior; each
`types/*.md` page explains the effective profile-wide and type-specific contract. The script's
check mode generates a temporary copy, compares it byte for byte, and strictly validates every
generated bundle. Because all guidance is currently absent, none of the checked-in pages has a
guidance section. The matching 0.9 renderer will add `## Guidance`, `### Profile-wide`, and
`### Type-specific` headings once the source values carry prose.

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
because guidance adds no rule, this plan adds a positive coverage test instead of meaningless
rejection fixtures. [ADR-11](../adr/0011-user-documentation-shares-reader-intent-types-and-doc-handles.md)
defines the six user-documentation types whose procedures this plan must respect.

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

Before authoring guidance, type-check `package.dhall`, list all profiles with the 0.9 executable,
and regenerate the documentation once. At this intermediate point every completed value should
contain `guidance = None Text`, the profile list should still report 13 profiles and 30 types, all
existing validation scripts should pass, and regeneration should leave `docs/profiles/` unchanged
because the 0.9 renderer omits absent guidance. This proves that the pin itself is compatible and
separates schema effects from authored prose.

### Milestone 2: Author guidance for every existing profile and type

Add a non-blank multiline `guidance = Some ''...''` value beside `description` in each of these
sources: `profiles/assurance/failure-modes.dhall`, `profiles/assurance/reviews.dhall`, all four
files under `profiles/coordination/`, all four files under `profiles/documentation/`,
`profiles/okf-v0-2.dhall`, `profiles/postgresql.dhall`, and `profiles/tan-postgresql.dhall`.
Do not change descriptions, field rules, allowed values, presence classifications, conditions,
paths, identity prefixes, or schema-section requirements. Guidance may mention those rules when
explaining how to work, but must not merely recite them.

Use profile-wide prose for actions common to every type in that corpus, and type-specific prose
for the work unique to one type. The content must cover these concrete authoring contracts:

- `assurance.failureModes` starts from repeated evidence rather than a one-off incident, records
  the recognizable signature separately from ordered diagnostic checks, preserves each eliminated
  explanation with the check that disproved it, makes mechanism claims only when evidence supports
  them, and places the control at the same scope as the failure mechanism. Its `Failure Mode`
  guidance tells an author to compare occurrences, reproduce the signature, test cheapest
  diagnoses first, and verify the control and standing detection.
- `assurance.reviews` first fixes the exact subject, repository, immutable reviewed commit, and
  full or incremental coverage. Its `Review` guidance tells the reviewer to examine only named
  dimensions, record bounded context and evidence, make the outcome match the findings, link the
  preceding review for incremental work, and create rather than bury any actionable bug report or
  improvement request.
- `coordination.bugReports` reproduces behavior from a version a consumer can actually use,
  distinguishes a defect from a missing capability, names the authority for expected behavior,
  grades severity by observed consequence, and keeps reproduction steps minimal and ordered. Its
  `Bug Report` guidance requires rechecking status-dependent resolution, duplicate, version, and
  workaround data as the report changes.
- `coordination.capabilities` inspects shipped code and evidence before making a provision claim,
  scopes one record to one independently adoptable and verifiable behavior, and separates current
  availability from compatibility stability. Its `Capability` guidance tells an author to name
  consumer entry points, cite evidence a reader can open, mirror requirements in the body graph,
  and use replacement records without rewriting historical availability.
- `coordination.improvementRequests` describes an observable gap owned by the target project,
  keeps proposed solutions subordinate to the desired outcome, and derives dependencies and
  acceptance criteria only from evidence. Its `Improvement Request` guidance states dependency
  kinds from the source request's perspective, gives each criterion a stable local ID and a
  reproducible verification method, and closes the request only with evidence satisfying those
  criteria.
- `coordination.useCases` begins with a real actor, situation, motivation, and observable outcome;
  then connects cross-repository features to accountable owners and request records. `Use Case`
  guidance distinguishes user progress from implementation tasks and keeps feature status and
  acceptance current. `Use Case Theme` guidance is for a recurring cluster found across use cases,
  not a speculative category, and must link the concrete cases that justify it.
- `documentation.architectureDecisions` captures a durable decision only after its context,
  alternatives, rationale, and consequences are known. Its type guidance says to update an
  existing ADR when the decision is merely clarified, allocate a new stable ADR when the decision
  changes, and record supersession in both directions without rewriting the historical decision.
- `documentation.patternCatalog` verifies guidance against the current implementation and cites
  sources before publication. Its eight type rules then specialize the job: `Navigation` curates
  routes and prerequisites; `Overview` explains boundaries and relationships; `Standard` states
  normative scope, conformance, and exceptions; `Guide` gives tested goal-oriented steps;
  `Pattern` records recurring context, forces, solution, and trade-offs; `Runbook` includes ordered
  operations, safety gates, verification, rollback, and recovery; `Reference` provides complete
  current lookup facts; and `Gotcha` gives a recognizable symptom, cause, trigger conditions,
  avoidance, and recovery.
- `documentation.researchDocuments` starts from a bounded question, identifies sources and method,
  separates observations from inference, and records limitations and contradictory evidence. Its
  `Research Document` guidance tells an author to make findings traceable, link decisions or plans
  the work informed, and supersede rather than silently rewrite a materially obsolete record.
- `documentation.userDocumentation` chooses one primary reader intent, names audience,
  prerequisites, and expected outcome, verifies claims against current product evidence, and uses
  lifecycle metadata rather than leaving stale instructions apparently current. Its six type
  rules follow ADR-11: `Navigation` curates a route; `Tutorial` creates a verified first success;
  `Guide` completes one goal; `Explanation` develops a mental model and trade-offs; `Reference`
  provides authoritative lookup organized for scanning; and `Runbook` includes preconditions,
  ordered operations, safety checks, verification, rollback, and escalation.
- `okfV02` explains that it checks the shape of v0.2 frontmatter families without choosing a
  taxonomy or demanding optional metadata. It tells authors to record provenance, sources,
  verification, lifecycle, and observation windows truthfully, and to create a house profile when
  they need presence policy. It has no type-specific guidance because it declares no types.
- `postgresql` copies the profile, schema, table, and view guidance from the released
  `mori://shinzui/okf` file at project-relative path `docs/profiles/postgresql.dhall`. This keeps
  the worked example and authoritative catalog wording aligned: inspect live DDL; document current
  rather than intended state; explain namespace responsibility; inspect table columns, keys,
  constraints, and indexes; and inspect each view definition, sources, filters, refresh, security,
  and performance behavior.
- `tanPostgresql` retains that live-database discipline and adds the Tan-specific distinction
  between physical database objects and logical event streams. Its table guidance derives
  `derivation`, `lifecycle`, `domain`, and conditional `sourceStreams` from real producer and
  consumer behavior. Its `Event Stream` guidance inspects producer code and the message store,
  explains aggregate identity, event categories, ordering and versioning assumptions, and names
  downstream projections without pretending the logical stream is a physical table.

Extend the two helper constructors rather than bypassing them.
`profiles/documentation/pattern-catalog.dhall`'s `rule` function and
`profiles/documentation/user-documentation.dhall`'s `documentType` function must each accept a
third `Text` argument and set `guidance = Some guidance` in the completed `TypeRule`. Every call
site then supplies the procedure for that type. This preserves one construction path for each
taxonomy.

Add `scripts/test-profile-guidance.sh`. It should use `${OKF_BIN:-okf}`, enumerate the same 13
public exports as `scripts/test-profile-docs.sh`, and call `okf profile show --no-local --registry
./package.dhall EXPORT` for each. Fail if the root output contains `guidance: (none)` or any type
block contains `  guidance: (none)`. Count lines beginning exactly `type:` across the outputs and
require 30. On success print:

```text
OK: 13 profiles and 30 type rules carry authoring guidance
```

The existing `just test` loop will discover this script automatically. This is a positive
coverage invariant, not a claim that prose can be validated for semantic correctness. Review the
prose manually against the profile source headers and local ADRs before accepting the milestone.

### Milestone 3: Publish generated docs, compatibility guidance, ADR, and Mori metadata

Run `just docs` with `OKF_BIN` pointing to 0.9.0.0. Inspect all 13 generated `profile.md` files and
all 30 generated type pages. Every profile root must contain `## Guidance`; every type page must
contain `### Profile-wide` followed by `### Type-specific`. Run generation a second time and
require a clean diff to prove that multiline prose did not introduce nondeterministic output.
Never hand-edit anything below `docs/profiles/`.

Update `README.md` in the compatibility, schema-evolution, generated-documentation, testing, and
profile-catalog sections. State that v0.15.0 requires `okf` 0.9.0.0 or later, define the
description/guidance/rules split, show a short completed Dhall example, explain effective
profile-wide-then-type-specific rendering, name `scripts/test-profile-guidance.sh`, and give a
consumer the upgrade order: update the CLI first, repin and freeze the profile second, then run
the repository's strict validation. Also update the stale version example in
`profiles/okf-v0-2.dhall` and the public-package example comment in `package.dhall` when the final
v0.15.0 hash is known.

Create a v0.15.0 entry in `CHANGELOG.md`. The release summary should say that all existing
profiles gain authoring guidance and that no structured rules or export names change. The
migration section must distinguish document migration from tool migration: existing concept
files need no edits, but any consumer repinning to v0.15.0 must run `okf` 0.9.0.0 or later. Record
the final remote package import and semantic hash in the same form as previous releases.

Record the lasting catalog policy in a new ADR. Ask the local bundle for the next ID with `okf id
next docs/adr --profile docs/adr/profile.dhall ADR`; it is expected to return `ADR-12`, but use the
command's result rather than assuming. Create the next four-digit file under `docs/adr/` with the
title “Published profiles carry authoring guidance at both scopes.” The decision should preserve
the three-way split: descriptions identify, structured rules validate, and guidance prescribes
authoring work without execution. It should require non-blank profile guidance and non-blank
guidance on every declared type for published house profiles, while recognizing that a
type-less reference profile has no type scope. Add `originatingPlan` pointing to this file, update
the bundle index with `okf index`, and add one dated `Addition` entry to `docs/adr/log.md` with
`okf log add`.

Repair `mori.dhall` while publishing the new behavior. Add the missing
`assurance.failureModes` profile record, update all 13 profile `version` values to `v0.15.0`
because every exported value gains guidance, add the missing `adopt-capabilities` template and
guide DocRef, and make the package description name the assurance family. After the blueprint
milestone, all five template versions must agree with their blueprint and Seihou registry values.
The intended local projection is 13 published profiles, five templates, and eight docs.

### Milestone 4: Refresh the reusable adoption blueprints

Bring all five existing Seihou blueprints forward so a new adopter receives a guidance-aware
profile. Set each `blueprints/*/blueprint.dhall` version, each corresponding entry in
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
v0.14.0 after deleting only the new `guidance` members; every export should otherwise compare
equal. This is the load-bearing proof that the release changes documentation rather than policy.

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
until guidance is authored. After Milestone 2, exercise the new data directly:

```bash
OKF_BIN="$OKF_BIN" bash scripts/test-profile-guidance.sh
"$OKF_BIN" profile show --no-local --registry package.dhall \
  documentation.userDocumentation
"$OKF_BIN" profile show --no-local --registry package.dhall \
  documentation.userDocumentation --json \
  | jq '{guidance, types: [.types[] | {type, guidance}]}'
```

The text output must show a multiline root `guidance:` block and six indented type guidance
blocks. The JSON result must contain a string at `.guidance` and six objects whose `.guidance`
members are strings, not null.

Generate, inspect, and prove coverage:

```bash
OKF_BIN="$OKF_BIN" just docs
test "$(rg -l '^## Guidance$' docs/profiles/*/profile.md | wc -l | tr -d ' ')" = 13
test "$(rg -l '^### Profile-wide$' docs/profiles/*/types/*.md | wc -l | tr -d ' ')" = 30
test "$(rg -l '^### Type-specific$' docs/profiles/*/types/*.md | wc -l | tr -d ' ')" = 30
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
  --message "Published profiles now carry authoring guidance at profile and type scope."
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

Before tagging, compare the new public values with v0.14.0 while ignoring only guidance. Run this
loop over the same 13-export array used by `scripts/test-profile-guidance.sh`:

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
  diff -u \
    <("$OKF_BIN" profile show --no-local --registry "$old_registry" \
        "$export_name" --json \
        | jq -S 'del(.guidance) | .types |= map(del(.guidance))') \
    <("$OKF_BIN" profile show --no-local --registry package.dhall \
        "$export_name" --json \
        | jq -S 'del(.guidance) | .types |= map(del(.guidance))')
done
```

The loop must print no diff. If it reports a change, either restore the v0.14 structured value or
explicitly revise this plan and the release's migration contract before continuing.

Use Conventional Commits and the mandatory trailers. A representative implementation commit is:

```text
feat(profiles): add authoring guidance to existing profiles

ExecPlan: docs/plans/10-adopt-okf-0-9-guidance-across-existing-catalog-profiles.md
Intention: intention_01m2dg6wsre5jr07176yk9yejp
```

The final release commit should use `chore(release): prepare okf-profiles 0.15.0` with the same
trailers. Once every pre-publication check passes:

```bash
git status --short
git tag -a v0.15.0 -m "v0.15.0 — first-class profile guidance"
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

Second, guidance coverage is complete. `scripts/test-profile-guidance.sh` reports exactly 13
profiles and 30 guided type rules. `okf profile show` displays multiline guidance for a profile
and each of its types, and the full JSON form preserves the same prose as strings. In particular,
the user-documentation profile exposes six distinct procedures and `okfV02` exposes only its
profile-wide procedure because it has no type rules.

Third, the change is documentary only. The v0.14.0-versus-local JSON comparison is byte-identical
after deleting `guidance` at profile and type scope. Every pre-existing conforming fixture still
passes; every focused rejection fixture still fails; and no fixture document is changed merely to
adopt guidance. `OKF_BIN="$OKF_BIN" just check` exits zero and includes the existing profile,
generated-doc, ADR-bundle, and blueprint success lines plus:

```text
OK: 13 profiles and 30 type rules carry authoring guidance
OK: profile documentation is current and validates
```

Fourth, generated documentation makes the feature visible. Exactly 13 root profile pages contain
`## Guidance`, exactly 30 type pages contain `### Profile-wide`, and the same 30 contain
`### Type-specific`. A second `just docs` run changes no byte. Spot-check PostgreSQL against the
released upstream example and spot-check at least one profile in each of the assurance,
coordination, and documentation families for clear separation between identity and procedure.

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

If a guidance edit causes a validation change, use the normalized JSON comparison to identify the
non-guidance field and restore it before proceeding. If generated documentation is surprising,
fix the source `guidance` and regenerate twice. If the new ADR ID is no longer ADR-12, use the
fresh value from `okf id next`; never fill a gap or recycle an ID.

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
and import freezing; `rg` for source and rendered-coverage checks; `jq` only for the release-time
JSON equivalence audit; Seihou for blueprint linting and registry validation; and Mori for
dependency discovery, local registration, and publication projections. Dependency source must be
located through Mori before inspection, and release pins must continue to be checked against
Hackage and upstream Git rather than chosen from local registry metadata alone.
