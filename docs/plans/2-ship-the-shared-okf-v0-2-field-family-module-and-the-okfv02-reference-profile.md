---
id: 2
slug: ship-the-shared-okf-v0-2-field-family-module-and-the-okfv02-reference-profile
title: "Ship the shared OKF v0.2 field-family module and the okfV02 reference profile"
kind: exec-plan
created_at: 2026-08-01T23:39:57Z
master_plan: "docs/masterplans/1-bring-okf-profiles-to-okf-v0-2-and-ship-bundle-migrations.md"
---

# Ship the shared OKF v0.2 field-family module and the okfV02 reference profile

This ExecPlan is a living document. The sections Progress, Surprises & Discoveries,
Decision Log, and Outcomes & Retrospective must be kept up to date as work proceeds.
If durable project context changes, update or create ADRs in docs/adr/ in the same change.


## Purpose / Big Picture

The Open Knowledge Format version 0.2 added six frontmatter families that describe who wrote
a document, whether anyone confirmed it, where its facts came from, and when it goes stale.
Seven profiles in this repository are about to start demanding those families. If each of the
seven writes its own description of `generated` and `sources`, the seven will disagree the
first time one of them is corrected.

This plan writes that description **once**, in a new file `Profile/V02.dhall`, and exports it
so the seven profiles can splice it in. It then assembles the same values into a standalone
profile, exported as `okfV02`, that checks nothing but the v0.2 families themselves.

Two people gain something concrete. A profile author in this repository gains
`v02.generated` — one name that expands into a fully-specified rule saying "this key's value
must be a mapping, its `by` member is required and must be an OKF actor such as
`human:nadeem` or `process:ddd-schema-check`, and its `at` member should be a UTC RFC3339
timestamp ending in `Z`". A downstream team with no house conventions at all gains a way to
check whether its v0.2 frontmatter is well formed without authoring a profile first: point
`okf validate --profile` at the `okfV02` export and run.

This plan also writes down two policy decisions that the three migration plans after it will
apply, so that they apply them identically: what happens where the house `status` key
collides with OKF's, and how the house `reviews` family relates to OKF's `verified`.


## Progress

- [x] Confirm EP-1 has landed: `Profile/okf.dhall` pins okf 0.5.0.0 (2026-08-01)
- [x] Read upstream's reference profile at `okf/docs/profiles/okf-v0-2.dhall` (2026-08-01)
- [x] Write `Profile/V02.dhall` with `trustMembers` and the six family values (2026-08-01)
- [x] Type-check `Profile/V02.dhall` and inspect the evaluated values (2026-08-01)
- [x] Write `profiles/okf-v0-2.dhall`, the standalone reference profile (2026-08-01)
- [x] Export `v02` and `okfV02` from the root `package.dhall` (2026-08-01)
- [x] Create the valid fixture bundle `fixtures/okf-v0-2/` (2026-08-01)
- [x] Create the invalid fixture bundles under `fixtures/okf-v0-2-invalid/` (2026-08-01)
- [x] Write `scripts/test-okf-v0-2-profile.sh` and make it pass (2026-08-01)
- [x] Prove the script has teeth by removing a rule and watching it fail (2026-08-01)
- [x] Add the two missing invalid fixtures the teeth-check exposed —
      `bad-verified-actor` and `bad-usage-window-date` — so all six rules are
      load-bearing (2026-08-01)
- [x] Record the `status`-collision policy in the module's doc comments (2026-08-01)
- [x] Record the `reviews`-versus-`verified` policy in the module's doc comments (2026-08-01)
- [x] Commit with the required git trailers (2026-08-01)


## Surprises & Discoveries

- **The six invalid fixtures the plan specified left two of the six rules untested.** Step 7
  asked for a teeth-check on `status` and "one other rule of your choice". Running it against
  *all six* rules instead — by deleting each entry from the profile in turn and re-running the
  script — showed that removing `v02.verified` or `v02.usageWindow` left the script passing.
  Neither had an invalid fixture: the specified six break `generated` (twice), `status`,
  `stale_after`, and `sources` (twice), and nothing exercised the other two. Two fixtures were
  added to close the gap, `bad-verified-actor` (a `verified` list entry whose `by` is the bare
  name `schema-check`) and `bad-usage-window-date` (`usage_window.from: 2026-05`, month
  precision rather than a calendar date). After that all six rules are load-bearing, verified
  by re-running the full sweep. The lesson generalises to EP-3 through EP-5: check every rule,
  not a sample, because the untested ones are exactly the ones a later edit can silently
  delete. Date: 2026-08-01

- **`bad-verified-actor` uses the list spelling on purpose.** `verified` is built with
  `field.recordOrList`, which declares `objectFields` *and* `elementFields` against the same
  member rules. The acceptance bundle's `bare-verified.md` exercises the `objectFields` branch,
  so the invalid fixture deliberately uses the list form to exercise `elementFields`. The
  diagnostic confirms the branch it hit: `frontmatter value at verified[0].by must match format
  actor`. Date: 2026-08-01

- **The valid fixture needed a `log.md`, which the plan did not mention.** Under `--strict` the
  bundle initially emitted three `log:` advisories — `generated date 2026-07-30 has no enclosing
  log.md` — one per concept. These are core strict authoring checks, not profile deviations, so
  `okf validate … --profile-enforce` still exited `0` and the acceptance criterion as literally
  written ("no `profile:` lines") was already met. It was still noise in a fixture meant to be
  exemplary, and every other acceptance bundle in this repository carries a `log.md`. Adding one
  with `okf log add fixtures/okf-v0-2 --kind Migration -m "…" --date 2026-07-30` clears it, and
  the test script now passes `--log-enforce` as `scripts/test-research-documents-profile.sh`
  does. EP-3 through EP-5 should expect the same when they add v0.2 provenance to existing
  fixtures: a `generated.at` date needs an enclosing `log.md` covering it. Date: 2026-08-01

- **`grep -c <sha> Profile/okf.dhall` now prints `2`, not the `1` this plan's Step 1 expects.**
  EP-1 added the commit SHA to `Profile/okf.dhall`'s doc comment as well as the URL, because the
  comment previously named no version at all. The prerequisite check is still meaningful — `0`
  means the pin never moved — but a later plan copying this idiom should test for a non-zero
  count rather than exactly `1`. Date: 2026-08-01

- **`[] : List Profile.Type.frontmatter.required` does not type-check.** Dhall cannot project a
  field type out of a record *type* that way (`Not a record or a union`). The empty
  `recommended` list needs a real type annotation: `[] : List okf.defaults.FieldRule.Type`.
  Upstream's reference profile sidesteps this because it binds `FieldRule` as a top-level
  `let`. Worth knowing for the migration plans, which will write empty presence lists too.
  Date: 2026-08-01

- **Keeping descriptions short paid off visibly.** okf echoes a rule's description inside the
  missing-field diagnostic, exactly as the plan warned:

  ```text
  profile: concept: missing profile-required field: sources[0].resource (§5.1. What the source
  is: a followable artifact, or a scope descriptor.)
  ```

  A paragraph there would have made this line unreadable. All ten shared descriptions are one
  sentence. Date: 2026-08-01


## Decision Log

- Decision: Put the shared field families in `Profile/V02.dhall` rather than in
  `profiles/okf-v0-2.dhall` and importing the profile's pieces back out.
  Rationale: `Profile/` holds schema and shared building blocks; `profiles/` holds finished
  profile *values* that consumers select by name. A migration plan needs the building blocks,
  not the assembled profile, and reaching into a profile's `frontmatter.required` list to pick
  individual rules is fragile — it depends on list ordering.
  Date: 2026-08-01

- Decision: `verified` is declared `optional`, not `recommended`, in the reference profile.
  Rationale: OKF specification §11 forbids treating a missing optional family as a
  deficiency. A reference profile that made `--strict` complain about every unverified
  concept would advise the opposite of the specification. This mirrors okf's own shipped
  `docs/profiles/okf-v0-2.dhall`, which makes the same choice for the same stated reason.
  Date: 2026-08-01

- Decision: `okfV02` sets `requireBundleVersion = None Text`.
  Rationale: Specification §12 makes the bundle's `okf_version` declaration a MAY. A
  format-level reference profile that demanded what the format merely permits would advise
  against the specification. House profiles that have finished migrating do set it; this one
  must not. Again this mirrors okf's shipped reference profile.
  Date: 2026-08-01

- Decision: `sources[].resource` carries no `path` rule.
  Rationale: OKF §5.1 sanctions a scope descriptor there — "all queries in BigQuery project
  X" — as well as a followable artifact. Demanding a resolvable path is a house convention,
  not a v0.2 rule, and a reference profile must not encode one.
  Date: 2026-08-01

- Decision: Add two invalid fixtures beyond the six the plan specified, and check every rule for
  load-bearingness rather than the two Step 7 asked for.
  Rationale: See Surprises & Discoveries. The specified six left `verified` and `usage_window`
  untested, so the script would have passed with either rule deleted from the profile. A test
  suite that does not fail when a rule is removed is not testing that rule, and these two rules
  are the ones EP-3 through EP-5 will splice into house profiles.
  Date: 2026-08-01

- Decision: Give the acceptance bundle a `log.md` and pass `--log-enforce` in the test script.
  Rationale: The bundle is a worked example as much as a test fixture, and every other
  acceptance bundle in this repository carries one. Without it, `--strict` emitted three
  `log:` advisories that a reader would reasonably mistake for a defect in the profile. The
  advisories never affected the pass/fail result, so this is a clarity fix rather than a
  correctness one.
  Date: 2026-08-01

- Decision: Name `recommended = [] : List okf.defaults.FieldRule.Type` explicitly in the
  reference profile rather than letting `FrontmatterRules`'s default supply it.
  Rationale: The emptiness is a decision — nothing in a format-level profile should be
  recommended, because §11 forbids treating a missing optional family as a deficiency — and an
  omitted field reads as an oversight where an explicit empty list with a comment reads as
  intent.
  Date: 2026-08-01


## Outcomes & Retrospective

Complete on 2026-08-01. Every acceptance criterion in Validation and Acceptance holds.

**What exists now.** `Profile/V02.dhall` defines the six v0.2 families once, exporting all ten
names the Interfaces and Dependencies section promised — `trustMembers`, `generated`, `verified`,
`status`, `staleAfter`, `sourceMembers`, `sources`, `usageWindowMembers`, `usageWindow`, and
`legacyTimestamp`. EP-3, EP-4, and EP-5 can import it and splice values in without re-authoring a
rule. `profiles/okf-v0-2.dhall` assembles them into a shipped format-level profile, exported as
`okfV02`; the root `package.dhall` now also exports the module itself as `v02`. Every export EP-1
left in place is untouched.

**The rules are right, verified three ways.** `generated` evaluates to `objectFields = Some` with
`by` carrying `FieldFormat.Actor` and `elementFields = None`; `verified` carries both, pointing at
the same member rules. `okf profile show --registry ./package.dhall okfV02` renders the compiled
profile with `generated`'s object members displayed, which proves it loads inside okf and not
merely inside Dhall — the `okfVersion` consistency rules are enforced at profile load time and no
Dhall type-check can catch them. And the acceptance bundle passes
`--strict --profile-enforce --log-enforce` with `OK: 3 concepts` and no advisories of any kind.

**Eight invalid fixtures, each failing for exactly the right reason.** Every one produces exactly
one deviation naming precisely the field it breaks — `generated.by`, `stale_after`, `status`,
`generated`, `sources[0].resource`, `sources[0].usage_count`, `verified[0].by`, and
`usage_window.from`. No fixture fails for an unintended reason, which was the risk the plan
called out.

**The teeth-check found a real gap, and that is the transferable lesson.** Checking all six rules
rather than the two Step 7 asked for exposed that `verified` and `usage_window` had no invalid
fixture at all — the profile could have lost either rule silently. Two fixtures closed it. EP-3
through EP-5 should apply the same sweep to their own profiles: delete each rule in turn and
confirm the script fails. Sampling two rules would have shipped a suite with a third of its rules
untested.

**Nothing regressed.** All seven test scripts pass and the Dhall type-check sweep is clean across
`Profile/`, `profiles/`, and both family packages. This plan was purely additive apart from two
new fields in the root `package.dhall`.

**No ADR written, deliberately.** The two policies this plan records — the house `status` key
winning where it collides with OKF v0.2 §5.4, and `reviews` coexisting with `verified` — are
durable project context and do belong in an ADR. But `docs/adr/` does not exist yet and creating
it is EP-7's job, which dogfoods the migrated architecture-decision profile. Writing the corpus
here would either duplicate that work or create it under the unmigrated v0.1 profile. The
policies are instead written in full, with their reasoning, in `Profile/V02.dhall`'s header
comment, where the three plans that import the module will read them; EP-7 promotes them into
`docs/adr/` and can cite the module as the source. This is recorded in the parent MasterPlan so
EP-7 does not lose it.


## Context and Orientation

### Where you are and what to run

The repository root is `/Users/shinzui/Keikaku/bokuno/okf-profiles`. Run every command from
there. Commit directly to `master`; do not create a branch.

There is no compiler and no package manager. "Type-check" means `dhall type --file <path>`.
"Test" means running a bash script under `scripts/`, each of which invokes the `okf` binary
against a fixture bundle. `okf --version` must report `v0.5.0.0` or later.

### Prerequisite

This plan requires
`docs/plans/1-move-the-profile-schema-pin-to-okf-0-5-0-0-and-widen-the-exported-descriptor-surface.md`
to be complete. Confirm it with:

```bash
grep -c 2e34d3042f0a919ed4f2c9d2db5fb89a139e25ee Profile/okf.dhall
```

which must print `1`. If it prints `0`, the schema pin is still at okf 0.4.0.0, none of the
descriptor features this plan uses exist yet, and every step below fails with a Dhall type
error. Stop and implement EP-1 first.

### ADRs

`docs/adr/` does not exist in this repository and there is no local ADR corpus, so **no local
ADR applies**. Creating the corpus is the job of
`docs/plans/7-release-okf-profiles-v0-8-0-and-dogfood-the-migrated-adr-profile.md`.

One cross-repository decision governs a choice you will make. `mori://shinzui/okf` records at
`docs/adr/8-derived-not-stored-trust-and-credibility.md` (artifact-level URI pending) that a
document's *trust tier* is computed on every read from `verified` and is never written into a
bundle. The practical consequence for you: **do not declare a `trust` key** in any rule you
write here. A document carrying `trust:` is carrying an ordinary extension field that okf
ignores.

### What a profile is, in this repository's terms

A profile is a Dhall record matching the type `Profile.dhall` that upstream `okf` publishes
and this repository re-exports through `Profile/Type.dhall`. Its important members:

- `name` and `description` — documentation.
- `okfVersion : Text` — which version of the OKF *format* the profile's conventions target.
- `frontmatter : { required, recommended, optional }` — three lists of `FieldRule`. A
  `required` key must be present on every document. A `recommended` key must be present only
  under `--strict`. An **`optional`** key is never reported when absent in any mode, while
  every constraint it declares still applies whenever it *is* present.
- `types : List TypeRule` — per-`type:` rules, each of which can carry its own three
  frontmatter lists that merge with the profile-wide ones.
- `requireBundleVersion : Optional Text` — demands that the bundle's root `index.md` declare
  `okf_version` at that version or later.

A `FieldRule` names one frontmatter key and constrains it: `allowedValues` for a closed
vocabulary, `cardinality` for scalar-versus-list, `format` for a parser-backed value contract,
`elementFields` for the record inside each element of a list, and `objectFields` for the
record that *is* the value.

The distinction between `elementFields` and `objectFields` is the one people get wrong.
`reviews: [{kind: human}, …]` is a list of records and takes `elementFields`.
`generated: {by: …, at: …}` *is* a record and takes `objectFields`. Declaring **both** against
the same member rules accepts either spelling and checks both — which is exactly what OKF
`verified` needs, because §5.2 permits it as a list of mappings or as one bare mapping.

The constructor module `mk`, exported from this repository's root `package.dhall` as `mk`,
gives you `field.record` (objectFields only), `field.recordList` (elementFields plus
`Cardinality.List`), and `field.recordOrList` (both, sharing one member spec).

### The six OKF v0.2 families you are describing

All six are **optional** in the format itself — `type` remains the only key a concept must
have, and specification §11 forbids a consumer from rejecting a bundle for omitting an
optional family. What follows is their shape, not a demand.

**`generated`** — a mapping recording who or what produced the document's current content and
when.

```yaml
generated:
  by: human:nadeem
  at: 2026-06-18T00:00:00Z
```

`by` is required within the record; `at` is a UTC RFC3339 timestamp. This key **supersedes**
the v0.1 `timestamp` key.

**`verified`** — independent confirmation, distinct from authorship. Written as a list, newest
last, or as one bare mapping meaning a one-element list:

```yaml
verified:
  - by: process:ddd-schema-check
    at: 2026-06-20T00:00:00Z
  - by: human:nadeem
    at: 2026-06-21T00:00:00Z
```

Its members are the same `by` and `at` as `generated`, which is why they share one
`NestedRules` value.

**`status`** — one of `draft`, `stable`, or `deprecated`. **An absent `status` means
`stable`.** A value outside the three is preserved as written rather than rejected by okf's
core; a profile is what turns it into a deviation.

**`stale_after`** — an absolute `YYYY-MM-DD` date after which the content should be
re-confirmed. A concept is stale when `today >= stale_after`, inclusive.

**`sources`** — a list of records describing what the document was derived from. Only
`resource` is required within an entry:

```yaml
sources:
  - id: ddd-schema
    resource: mori://shinzui/mori
    title: The Mori DDD schema at mori/ddd.dhall
    author: human:nadeem
    usage_count: 40
    last_modified: 2026-05-02
```

`usage_count` must be a YAML integer — a quoted `"5000"` is not read, because coercing it
would hide a producer mistake. `author` is an actor.

**`usage_window`** — a mapping with `from` and `to` calendar dates, a **sibling** of `sources`
rather than a member of it, framing every entry's usage count. A single `sources` entry may
carry its own `usage_window` overriding the shared one; that is at nesting depth two and the
descriptor language, which is deliberately bounded to one level, cannot reach it.

### The actor convention (§7)

Three fields carry an *actor*: `generated.by`, `verified[].by`, and `sources[].author`. An
actor takes exactly one of three shapes:

```text
<producer>/<version>   an agent or tool, e.g. okf-authoring-agent/1.4
human:<id>             a person, e.g. human:nadeem
process:<id>           an automated process, e.g. process:ddd-schema-check
```

The `human:` prefix is load-bearing: it is the single test separating the
`machine-confirmed` trust tier from `human-reviewed`. Matching is case-sensitive, so
`Human:nadeem` is not a person as far as okf is concerned. Text matching none of the three
shapes is preserved verbatim and treated as unclassified.

`FieldFormat.Actor` accepts all three shapes; `FieldFormat.HumanActor` accepts only the
`human:` form.

### The constraint that makes this plan necessary

As of okf 0.5.0.0, a profile's declared `okfVersion` is **compile-checked against the rules
it declares**, in both directions. Verified against the installed binary:

```text
Failed to load profile probe.dhall: invalid profile definition:
  - profile frontmatter: declared okfVersion 0.2 supersedes the frontmatter key timestamp
    (OKF 0.2); move it to the optional list or replace it with generated
```

```text
Failed to load profile probe2.dhall: invalid profile definition:
  - profile frontmatter: declared okfVersion 0.1 does not support the format actor at
    generated.by, which OKF 0.2 introduced
```

So: the moment a profile uses `FieldFormat.Actor`, it **must** declare `okfVersion = "0.2"`,
and the moment it declares `"0.2"` it **must not** have `timestamp` in `required` or
`recommended`. `optional` is explicitly legal and is how a migration in progress is
described. This is the mechanism the three plans after this one depend on; you are not
fighting it here, but the rules you write make it unavoidable for them.

Note that a Dhall type-check cannot catch this. It is enforced by okf when it *loads* the
profile, which is why this plan validates with `okf profile show` and `okf validate` rather
than with `dhall type` alone.

### The reference implementation to work from

Upstream okf ships its own version of exactly this file at
`/Users/shinzui/Keikaku/bokuno/okf/docs/profiles/okf-v0-2.dhall` in the local checkout. **Read
it before writing anything.** It is 188 lines, annotated with specification section numbers,
and it encodes several judgements you should copy rather than re-derive — including why
`verified` is optional, why `sources[].resource` carries no path rule, and why the profile
sets `requireBundleVersion = None Text`.

Your file differs from it in three ways. It imports through this repository's
`Profile/okf.dhall` pin rather than by relative path into okf. It splits the field values out
as named exports so other profiles can reuse them, which upstream's does not need to do. And
it adds the two policy notes described below, which are this repository's decisions and not
upstream's.

### The two policies you are writing down

These were decided by the user on 2026-08-01 and are recorded in the parent MasterPlan's
Decision Log. Your job is to state them in `Profile/V02.dhall`'s doc comments so that the
three migration plans that import it cannot miss them.

**Policy one — the house `status` key wins where it collides.** Five profiles in this
repository already use `status` for a house lifecycle vocabulary:
`documentation.architectureDecisions` (repository-native values such as `Accepted`),
`documentation.patternCatalog` (`current`, `deprecated`), `documentation.researchDocuments`
(`active`, `complete`, `superseded`), `coordination.improvementRequests` (`proposed`,
`accepted`, `in-progress`, `completed`, `rejected`, `withdrawn`, `superseded`), and
`coordination.useCases` (`draft`, `validated`, `planned`, `in-progress`, `delivered`,
`retired`). OKF v0.2 §5.4 gives the same key the vocabulary `draft`/`stable`/`deprecated`.

Those five keep their house vocabulary and **do not** declare `v02.status` or
`v02.staleAfter`. okf sanctions this explicitly: a profile key name does not imply the OKF
core key of that name, and okf never rejects a profile for it — what okf checks instead is
value *formats*, because a format has no house-convention reading. The accepted consequence
is that `okf trust` prints the house value verbatim as a status it does not recognise.
Profiles with no collision — `postgresql`, `tanPostgresql`, and this plan's `okfV02` — do
declare both.

**Policy two — `reviews` and `verified` coexist.** `Profile/ReviewRule.dhall` defines a rich
house review record (reviewer identity, review scope, outcome, serving provider, model
identifier, reasoning effort, evidence context) used by three profiles. OKF `verified`
records only `by` and `at`. Neither is a superset of the other. Both are declared; a producer
that records an approving `reviews` entry should mirror it into `verified` so the derived
trust tier is accurate.


## Plan of Work

### Milestone 1 — the shared module

Scope: one new file, `Profile/V02.dhall`. At the end of this milestone a profile author can
write `v02.generated` and get a complete, correct rule, and the two policies above are
written where a reader of that module will see them.

The module imports the pinned schema through `./okf.dhall` — the same one-way import every
other file under `Profile/` uses — and returns a record with these members:

- `trustMembers : NestedRules` — the shared `{ required = [ by ], recommended = [ at ] }`
  value that `generated` and `verified` both use. `by` carries `FieldFormat.Actor`; `at`
  carries `FieldFormat.Rfc3339Utc`.
- `generated : FieldRule` — built with `field.record "generated" trustMembers`, described as
  §5.2, noting in a comment that it supersedes the v0.1 `timestamp` key per §13.1 and that it
  is a mapping rather than a list because content is produced once.
- `verified : FieldRule` — built with `field.recordOrList "verified" trustMembers`, so both
  the list and the bare-mapping spellings are accepted and checked.
- `status : FieldRule` — `allowedValues = [ "draft", "stable", "deprecated" ]`,
  `cardinality = Cardinality.Scalar`, described as §5.4 with the note that absence means
  `stable`.
- `staleAfter : FieldRule` — the key `stale_after`, `Cardinality.Scalar`,
  `format = Some FieldFormat.Date`, described as §5.5.
- `sourceMembers : NestedRules` — `resource` required; `id`, `title`, `author` (actor),
  `usage_count` (non-negative integer), and `last_modified` (date) optional.
- `sources : FieldRule` — `field.recordList "sources" sourceMembers`.
- `usageWindowMembers : NestedRules` — `from` and `to`, both optional dates.
- `usageWindow : FieldRule` — `field.record "usage_window" usageWindowMembers`.
- `legacyTimestamp : FieldRule` — `field.rfc3339Utc "timestamp"`, described as the superseded
  v0.1 key, **for placement in a profile's `optional` list only**. Exporting it as a named
  value means the three migration plans demote the key identically instead of each
  re-authoring the rule, and its doc comment is the natural place to say that putting it in
  `required` or `recommended` alongside `okfVersion = "0.2"` is a hard load failure.

Two things to be careful about. Keep every `description` string **short**: okf echoes a
description back inside the missing-field diagnostic, so a paragraph there produces an
unreadable error line. Put the explanation in a Dhall comment instead — upstream's file does
exactly this and says so. And write descriptions that make sense in *any* of the seven
profiles, since all of them will surface the same text; a consuming profile that needs
different wording overrides it with the `//` operator rather than redefining the rule, like
this:

```dhall
v02.generated // { description = Some "How this decision record was produced." }
```

The two policies go in the module's header comment, in prose, with the reasoning — not just
the conclusion. A migration plan's implementer will read this file and needs to know *why*
`status` is not spliced into five of the seven profiles.

### Milestone 2 — the reference profile and its exports

Scope: one new file `profiles/okf-v0-2.dhall`, plus two new fields in the root
`package.dhall`. At the end, `okfV02` is a shipped profile a consumer can point `--profile`
at.

The profile assembles the module's values:

- `name = "okf-v0-2"`, with a description saying it is a reference profile for the OKF v0.2
  frontmatter families.
- `okfVersion = "0.2"`.
- `required = [ type, title, description, v02.generated ]`. The first three are plain
  documented rules; `type` must carry **no** `allowedValues`, because OKF defines no fixed
  taxonomy and requires consumers to tolerate unknown types.
- `recommended = []`.
- `optional = [ v02.verified, v02.status, v02.staleAfter, v02.sources, v02.usageWindow ]`.
- `allowUnknownTypes = True`, `allowUnknownFields = True`, `idField = None Text`,
  `types = []`, `requireBundleVersion = None Text`.

Every one of those last six is deliberate and each deserves a comment. This is a
*format-level* profile: it says how the v0.2 families must look when present and says nothing
about which concept types a team has. A house profile adds type rules; this one would be
wrong to.

Then export from the root `package.dhall`:

```dhall
, v02 = ./Profile/V02.dhall
, okfV02 = ./profiles/okf-v0-2.dhall
```

Place `v02` beside the other `Profile/` exports and `okfV02` beside the other profile
exports, matching the file's existing grouping. Do not disturb any existing export name — a
downstream repository pins this package by URL, and a renamed field fails at Dhall evaluation
time in their build, not yours.

Note that `profiles/okf-v0-2.dhall` sits at the top level of `profiles/` rather than in a
family subdirectory, exactly as `postgresql.dhall` and `tan-postgresql.dhall` do. It is not a
member of `coordination` or `documentation` because it is not a house profile at all.

### Milestone 3 — fixtures and a test script

Scope: `fixtures/okf-v0-2/`, `fixtures/okf-v0-2-invalid/`, and
`scripts/test-okf-v0-2-profile.sh`. At the end, `bash scripts/test-okf-v0-2-profile.sh`
prints an `OK:` line, and it fails if any of the new rules is deleted from the profile.

Every existing test script follows the same two-part shape: validate a bundle that must pass
under `--profile-enforce`, then loop over a list of deliberately broken bundles and fail the
script if any of them *passes*. Copy that shape from
`scripts/test-research-documents-profile.sh`, which is the closest analogue.

The valid bundle `fixtures/okf-v0-2/` needs three concepts so the fixture exercises more than
one shape:

- One concept using every family — `generated`, `verified` as a two-element list, `status`,
  `stale_after`, `sources` with all six member keys populated, and a document-level
  `usage_window`. This is the "everything present" case.
- One concept with only `type`, `title`, `description`, and `generated`, using the
  `process:<id>` actor form. This is the "minimum that passes" case and proves the optional
  families really are optional.
- One concept using the **bare-mapping** spelling of `verified`, which is the `recordOrList`
  behaviour and would go untested otherwise.

The invalid bundles, one directory each, named for what they break:

- `bad-actor` — `generated.by: nadeem`, matching none of the three actor shapes.
- `missing-generated` — a concept with `type`, `title`, and `description` but no `generated`.
- `bad-status` — `status: current`, outside the `draft`/`stable`/`deprecated` vocabulary.
- `bad-stale-after` — `stale_after: 2026-13-45`, not a calendar date.
- `missing-source-resource` — a `sources` entry with `id` and `title` but no `resource`.
- `quoted-usage-count` — `usage_count: "40"`, a quoted string where a YAML integer is
  required. This one is worth having because it is the mistake the format documentation
  explicitly calls out, and it proves `NonNegativeInteger` is doing real work.

Do not create empty directories. Two of the existing invalid fixture directories
(`fixtures/improvement-requests-invalid/empty-reviews` and `.../missing-reviews`) are empty on
disk; that is pre-existing and not your problem, but do not add to the pattern.

Write the test script to run the valid bundle under `--strict --profile-enforce` and each
invalid bundle under `--profile-enforce`, checking that `okf` exits non-zero for each invalid
one.

There is one trap. `okf validate --strict` applies *core* strict authoring checks in addition
to profile checks, and core strict checks the **footnote/`sources` join in both directions**:
a `sources` entry whose `id` no body footnote cites is reported as a lint, and a footnote
label naming no `sources` entry is reported too. Each direction fires only when the other side
has opted in. So the concept carrying `sources` must either cite its entries with footnotes
whose labels are the `sources` ids, like this —

```markdown
The aggregate record mirrors the schema verbatim[^ddd-schema].

[^ddd-schema]: The aggregate record in the DDD schema.
```

— or omit `id` from its `sources` entries. Cite them: it makes the fixture a better worked
example and exercises a v0.2 behaviour nothing else here covers.

The valid bundle does **not** need a root `index.md`, because `okfV02` sets
`requireBundleVersion = None Text`. Adding one anyway is harmless and makes the fixture a
more realistic example; if you do, write it with
`okf index fixtures/okf-v0-2 --write --okf-version 0.2` rather than by hand.


## Concrete Steps

All commands run from `/Users/shinzui/Keikaku/bokuno/okf-profiles`.

**Step 1 — verify the prerequisite and the toolchain.**

```bash
okf --version
grep -c 2e34d3042f0a919ed4f2c9d2db5fb89a139e25ee Profile/okf.dhall
for s in scripts/*.sh; do bash "$s" >/dev/null 2>&1 || echo "FAILING: $s"; done; echo "baseline checked"
```

Expect `okf v0.5.0.0 …`, a `1` from the grep, and no `FAILING:` lines.

**Step 2 — read the upstream reference.**

```bash
cat /Users/shinzui/Keikaku/bokuno/okf/docs/profiles/okf-v0-2.dhall
```

**Step 3 — write `Profile/V02.dhall`**, then type-check and inspect it:

```bash
dhall type --file Profile/V02.dhall > /dev/null && echo "V02 type-checks"
dhall <<< '(./Profile/V02.dhall).generated'
```

The second command prints the evaluated `FieldRule`. Confirm by eye that `objectFields` is
`Some` with a `required` list containing `by`, that `by`'s `format` is
`Some FieldFormat.Actor`, and that `elementFields` is `None`.

```bash
dhall <<< '(./Profile/V02.dhall).verified.elementFields'
dhall <<< '(./Profile/V02.dhall).verified.objectFields'
```

Both must be `Some …` — that is what makes both YAML spellings acceptable.

**Step 4 — write `profiles/okf-v0-2.dhall` and add the exports**, then:

```bash
dhall type --file profiles/okf-v0-2.dhall > /dev/null && echo "profile type-checks"
dhall type --file package.dhall > /dev/null && echo "package type-checks"
okf profile show --registry ./package.dhall okfV02 2>&1 | head -40
```

`okf profile show` renders the compiled profile, including `objectFields`, which it did not in
okf 0.4.0.0. Seeing `generated` with its member rules printed here proves the profile compiles
inside okf and not merely inside Dhall — a Dhall type-check cannot catch the `okfVersion`
consistency rules, which okf enforces at load time. If you get

```text
Failed to load profile: invalid profile definition:
  - profile frontmatter: declared okfVersion 0.2 supersedes the frontmatter key timestamp …
```

then `legacyTimestamp` has been spliced into `required` or `recommended`; the reference
profile does not need it at all, so remove it from this profile.

**Step 5 — create the fixtures**, then check the valid bundle:

```bash
okf validate fixtures/okf-v0-2 --strict --profile profiles/okf-v0-2.dhall --profile-enforce
```

Expected:

```text
OK: 3 concepts
```

with no `profile:` lines. Then check each invalid bundle rejects:

```bash
for f in fixtures/okf-v0-2-invalid/*/; do
  if okf validate "$f" --profile profiles/okf-v0-2.dhall --profile-enforce >/dev/null 2>&1; then
    echo "NOT REJECTED: $f"
  else
    echo "rejected: $f"
  fi
done
```

Every line must read `rejected:`. A `NOT REJECTED:` line means that fixture does not actually
violate the rule you thought it did — read the fixture and the rule again rather than
loosening the profile.

**Step 6 — write and run the test script.**

```bash
chmod +x scripts/test-okf-v0-2-profile.sh
bash scripts/test-okf-v0-2-profile.sh
```

Expected final line:

```text
OK: okf-v0-2 reference profile acceptance and rejection fixtures
```

**Step 7 — prove the script has teeth.** Temporarily delete the `v02.status` entry from
`profiles/okf-v0-2.dhall`'s `optional` list and re-run the script. It must fail on the
`bad-status` fixture. Restore the entry with `git checkout -- profiles/okf-v0-2.dhall` if you
have already committed Milestone 2, or by re-editing if not. Repeat for one other rule of your
choice. A test script that passes with a rule removed is not testing that rule.

**Step 8 — re-run every other script** to confirm you changed nothing else:

```bash
for s in scripts/*.sh; do echo "--- $s"; bash "$s" 2>&1 | tail -1; done
```

Seven `OK: … fixtures` lines now, one per script including the new one.

**Step 9 — commit.**

```bash
git add Profile/V02.dhall profiles/okf-v0-2.dhall package.dhall fixtures/okf-v0-2 fixtures/okf-v0-2-invalid scripts/test-okf-v0-2-profile.sh
git commit -F - <<'MSG'
feat(profiles): describe the OKF v0.2 field families once and ship them

Add Profile/V02.dhall, the single definition of the six v0.2 frontmatter
families -- generated, verified, status, stale_after, sources, and
usage_window -- plus the shared trust-member rules and the superseded v0.1
timestamp rule that migrating profiles place in their optional list.

Assemble the same values into profiles/okf-v0-2.dhall, exported as okfV02:
a format-level reference profile that says how the v0.2 families must look
when present and nothing about which concept types a team has.

Record two house policies in the module: where the house status key
collides with OKF v0.2 section 5.4 the house key wins, and the house
reviews family coexists with OKF verified rather than replacing it.

MasterPlan: docs/masterplans/1-bring-okf-profiles-to-okf-v0-2-and-ship-bundle-migrations.md
ExecPlan: docs/plans/2-ship-the-shared-okf-v0-2-field-family-module-and-the-okfv02-reference-profile.md
MSG
```


## Validation and Acceptance

**The shared module evaluates to correct rules.** `dhall <<< '(./Profile/V02.dhall).generated'`
shows `objectFields = Some { required = [ … "by" … ] }` with `format = Some FieldFormat.Actor`
on `by`, and `elementFields = None`. `verified` shows *both* `objectFields` and
`elementFields` as `Some`, pointing at the same member rules.

**The reference profile compiles inside okf, not just inside Dhall.**
`okf profile show --registry ./package.dhall okfV02` renders without a
`Failed to load profile` error and lists `generated` under required with its object members
displayed.

**A conforming bundle passes strictly.**

```bash
okf validate fixtures/okf-v0-2 --strict --profile profiles/okf-v0-2.dhall --profile-enforce
```

prints `OK: 3 concepts` with no `profile:` lines and exits `0`.

**Each deliberate mistake is caught, with a diagnostic that names the right thing.** Run each
invalid fixture *without* `--profile-enforce` so you can read the advisory text, and confirm
it points at the field you broke. For example:

```text
$ okf validate fixtures/okf-v0-2-invalid/bad-actor --profile profiles/okf-v0-2.dhall
profile: concept: frontmatter value at generated.by must match format actor, found: "nadeem"
```

The exact wording may differ between okf releases; what matters is that the diagnostic names
the field path you broke and not some unrelated one. If a diagnostic names an unexpected
field, the fixture is wrong in more ways than intended — fix it, because an invalid fixture
that fails for the wrong reason silently stops testing the rule it was written for.

**The script has teeth.** Removing any one rule from the profile makes
`scripts/test-okf-v0-2-profile.sh` fail. Verify this for at least `status` (Step 7) and one
other rule, and note in Surprises & Discoveries if any fixture turns out not to be
load-bearing.

**Nothing else regressed.** All seven scripts pass.

**The policies are written down.** `Profile/V02.dhall`'s header comment states the `status`
collision policy and the `reviews`/`verified` policy, each with its reasoning, in terms a
reader who has not seen the MasterPlan can act on.


## Idempotence and Recovery

Every step is safe to repeat. Type-checking and `okf validate` are read-only. Writing the
Dhall and Markdown files is ordinary file authoring; re-running Step 4 or Step 5 overwrites
what you wrote with what you meant.

The one command that writes into the repository is
`okf index fixtures/okf-v0-2 --write --okf-version 0.2`, if you choose to add an index. It is
idempotent: it overwrites exactly the index files it generates, never deletes, and preserves
an existing version declaration.

This plan is purely additive — one new module, one new profile, two new export fields, one new
fixture tree, one new script. Nothing existing is modified except the root `package.dhall`,
where you only add fields. Recovery before committing is

```bash
git checkout -- package.dhall
rm -rf Profile/V02.dhall profiles/okf-v0-2.dhall fixtures/okf-v0-2 \
       fixtures/okf-v0-2-invalid scripts/test-okf-v0-2-profile.sh
```

Committing Milestone 2 before starting Milestone 3 makes Step 7's teeth-check trivially
recoverable with `git checkout -- profiles/okf-v0-2.dhall`, and is the recommended order.


## Interfaces and Dependencies

**Hard dependency on EP-1**
(`docs/plans/1-move-the-profile-schema-pin-to-okf-0-5-0-0-and-widen-the-exported-descriptor-surface.md`).
This plan uses `objectFields`, `FieldFormat.Actor`, `FieldFormat.NonNegativeInteger`, and the
`field.record` / `field.recordOrList` / `field.recordList` constructors, none of which exist in
the okf 0.4.0.0 schema.

**`okf` 0.5.0.0 or later** on `PATH`, and **`dhall` ≥ 1.42**.

**Read-only reference**: `/Users/shinzui/Keikaku/bokuno/okf/docs/profiles/okf-v0-2.dhall` and
`/Users/shinzui/Keikaku/bokuno/okf/docs/user/profiles.md`. Never edit that checkout, and never
import from it in committed code — the committed import must go through
`Profile/okf.dhall`'s frozen URL.

At the end of this plan `Profile/V02.dhall` must export at least these names, because three
later plans import them by name:

```dhall
{ trustMembers       : NestedRules.Type
, generated          : FieldRule.Type
, verified           : FieldRule.Type
, status             : FieldRule.Type
, staleAfter         : FieldRule.Type
, sourceMembers      : NestedRules.Type
, sources            : FieldRule.Type
, usageWindowMembers : NestedRules.Type
, usageWindow        : FieldRule.Type
, legacyTimestamp    : FieldRule.Type
}
```

and the root `package.dhall` must export `v02` and `okfV02` in addition to everything EP-1
left in place.

**Downstream consumers of this plan.** Three plans import `Profile/V02.dhall` read-only and
must not edit it:

- `docs/plans/3-migrate-the-documentation-profiles-to-okf-v0-2.md`
- `docs/plans/4-migrate-the-coordination-profiles-to-okf-v0-2.md`
- `docs/plans/5-migrate-the-postgresql-profiles-to-okf-v0-2.md`

If one of them finds a shared value wrong, the fix belongs here and must be propagated to all
three, with the discovery recorded in the parent MasterPlan's Surprises & Discoveries section.
