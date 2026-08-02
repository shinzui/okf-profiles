---
id: 5
slug: migrate-the-postgresql-profiles-to-okf-v0-2
title: "Migrate the PostgreSQL profiles to OKF v0.2"
kind: exec-plan
created_at: 2026-08-01T23:39:57Z
master_plan: "docs/masterplans/1-bring-okf-profiles-to-okf-v0-2-and-ship-bundle-migrations.md"
---

# Migrate the PostgreSQL profiles to OKF v0.2

This ExecPlan is a living document. The sections Progress, Surprises & Discoveries,
Decision Log, and Outcomes & Retrospective must be kept up to date as work proceeds.
If durable project context changes, update or create ADRs in docs/adr/ in the same change.


## Purpose / Big Picture

Two of this repository's seven published profiles describe a PostgreSQL database as an Open
Knowledge Format bundle: `postgresql`, the base conventions for schemas, tables, and views,
and `tanPostgresql`, which extends it with per-table role vocabularies and logical event
streams. Both are written for OKF v0.1. Both ask for the `timestamp` key that OKF v0.2
retired, and neither records who produced a description or whether anyone confirmed it — the
question v0.2 exists to answer.

These two profiles matter differently from the other five. A database description goes stale
on its own: a column is dropped, a projection is rebuilt, and the Markdown describing it says
nothing about the fact that it was last confirmed accurate eight months ago by a tool nobody
runs any more. That is precisely what v0.2's `generated`, `verified`, and `stale_after`
families exist for, and unlike the documentation and coordination profiles, **these two have
no house `status` key to collide with OKF's**. They can adopt the v0.2 lifecycle family in
full.

After this plan, a team pinning either profile gets a check that a table description records
who wrote it (as an OKF actor such as `human:nadeem` or `process:schema-sync`), may record who
independently confirmed it, and may declare a date after which it should not be quoted without
re-confirmation. Legacy corpora keep validating, because `timestamp` moves to the `optional`
presence class where its format is still checked but its absence is never reported.

You can see it working by running `bash scripts/test-tan-postgresql-profile.sh`, which after
this plan runs under `--strict` — a flag no script in this repository passes today, and one
the PostgreSQL fixture currently fails.


## Progress

- [x] Confirm EP-2 has landed and `Profile/V02.dhall` exists (2026-08-02)
- [x] Read EP-3's Outcomes section for the established fixture and script pattern (2026-08-02)
- [x] Read okf's own migrated `docs/profiles/postgresql.dhall` as a reference (2026-08-02)
- [x] Record the baseline: run all scripts and save the output (2026-08-02)
- [x] Capture what `--strict` reports on the tan fixture before any change (2026-08-02)
- [x] Migrate `profiles/postgresql.dhall` (2026-08-02)
- [x] Verify `profiles/tan-postgresql.dhall` inherits correctly through its `//` override (2026-08-02)
- [x] Update `fixtures/tan-postgresql` and its two invalid siblings (2026-08-02)
- [x] Add `bad-actor` and `bad-stale-after` invalid fixtures (2026-08-02)
- [x] Sweep every spliced v0.2 rule for load-bearingness (2026-08-02)
- [x] Extend `scripts/test-tan-postgresql-profile.sh` with `--strict` (2026-08-02)
- [x] Prove `requireBundleVersion` is live on a de-indexed bundle copy (2026-08-02)
- [x] Add a fixture and script for the base `postgresql` profile, which has neither today (2026-08-02)
- [x] Re-run every script and confirm all pass (2026-08-02)
- [x] Commit with the required git trailers (2026-08-02)


## Surprises & Discoveries

- **The `//` inheritance worked exactly as the plan described, and
  `profiles/tan-postgresql.dhall` was not edited at all.** All six changes to the base profile
  reached `tanPostgresql` through the record merge. Verified two ways rather than one — by
  evaluating the fields directly and by rendering the loaded profile:

  ```text
  $ dhall <<< '(./profiles/tan-postgresql.dhall).okfVersion'
  "0.2"
  $ dhall <<< '(./profiles/tan-postgresql.dhall).requireBundleVersion'
  Some "0.2"
  $ okf profile show --registry ./package.dhall tanPostgresql
  frontmatter.optional:
    - verified: §5.2. Independent confirmations that this description still matches the live object.
    - status: §5.4. Lifecycle state. Absence means `stable`, so this is never demanded.
    - stale_after: §5.5. Date after which this description should be re-confirmed against the live object.
    - timestamp: Superseded v0.1 confirmation timestamp. Prefer `generated.at`.
  ```

  `okf profile show` is the better of the two checks and the one to keep: it renders the profile
  as okf actually loaded it, so it would also catch a change that type-checks but fails okf's
  `okfVersion` cross-check. Date: 2026-08-02

- **Unlike EP-4, promoting provenance did *not* invalidate the pre-existing rejection fixtures.**
  The parent MasterPlan records EP-4's finding that requiring `generated` makes every v0.1-era
  invalid fixture fail twice. That does not happen here, and the reason is precisely the decision
  recorded below to keep `generated` `recommended` rather than `required`: a recommended field's
  absence is only reported under `--strict`, and the rejection loop does not pass it. `invalid-role`
  and `missing-source-streams` were audited and still report only their own advisories, unchanged.
  The two findings are two faces of the same rule — *presence class determines whether adding a
  family disturbs existing fixtures* — and EP-7 should record that when it promotes the
  one-advisory-per-fixture principle. Date: 2026-08-02

- **The v0.2 lifecycle vocabulary produces the diagnostic the plan asked to see**, captured
  permanently as a fixture rather than as a manual check:

  ```text
  profile: schemas/public/tables/orders: frontmatter value at status must be one of [draft, stable, deprecated], found: "current"
  ```

  `current` is the pattern-catalog profile's house word, which makes it a useful value to reject
  here: it demonstrates in one line that the two branches of the house-`status` policy really are
  different profiles with different vocabularies, not a single convention applied loosely.
  Date: 2026-08-02

- **`resourceScheme` and the profile-wide `resource` format rule are mutually redundant, so
  neither is individually load-bearing.** The plan's acceptance check asks you to remove
  `resourceScheme = Some "postgresql"` from the `PostgreSQL Table` type rule and confirm the new
  script fails on `bad-resource-scheme`. It does fail — but so does removing the profile-wide
  `resource` rule instead, and for the same fixture. Both express the same constraint over the
  same value, so `mysql://example/sales/orders` trips both and no value can trip only one:

  ```text
  profile: schemas/sales/tables/orders: frontmatter value at resource must match format uri-with-scheme(postgresql), found: "mysql://example/sales/orders"
  profile: schemas/sales/tables/orders: resource must use scheme postgresql://, found: mysql://example/sales/orders
  ```

  The fixture therefore tests the scheme constraint as a whole rather than either rule
  individually, and "the script fails when I delete the rule" is *not* sufficient evidence that a
  fixture tests that rule. `requireSchemaSection` was swept the same way and **is** individually
  load-bearing. The redundancy is not a defect — `resourceScheme` is per-type and the format rule
  is profile-wide, and tan's `Event Stream` deliberately has the latter without the former — but
  it is worth knowing before anyone tries to simplify one away. Date: 2026-08-02

- **The tan fixture had no `log.md` at all**, which the other acceptance bundles do have. Adding
  `generated.at` dates therefore produced two core `log:` advisories — the failure mode EP-2
  recorded. `okf log add fixtures/tan-postgresql --kind Migration -m "…" --date 2026-07-30`
  writes it, and with the log in place the script can pass `--log-enforce` like its siblings.
  Date: 2026-08-02


## Decision Log

- Decision: Give the `Event Stream` concept a `resource` rather than demoting the profile-wide
  `resource` rule to `optional`.
  Rationale: `resource` is `recommended` at profile scope, and presence rules accumulate — a type
  rule can narrow what the profile demands but never weaken it — so the `Event Stream` type rule
  cannot exempt itself, and `fixtures/tan-postgresql/streams/order.md` failed `--strict` for a
  missing `resource`. The plan's instruction for this case is explicit: do not weaken the profile,
  fix the fixture. Demoting the rule would have removed the nudge from tables and views, where a
  `postgresql://` URI is the single most useful thing a description can carry. The tan profile's
  own header says a stream "is a logical stream of events inside `message_store.messages`", so
  the fixture now writes `postgresql://example/message_store/messages#order` — the physical table
  it lives in, with the category as a fragment. The `Event Stream` type rule declares no
  `resourceScheme`, deliberately, but the profile-wide format rule still requires the
  `postgresql` scheme, and the fragment satisfies it.
  Date: 2026-08-02

- Decision: Add a `log.md` to `fixtures/tan-postgresql` and pass `--log-enforce` in its script.
  Rationale: Recorded in Surprises & Discoveries. The parent MasterPlan asked EP-5 to check
  whether its scripts pass the flag, after EP-4 found it was not uniform. It now matches the
  coordination and documentation scripts, and it tests something this migration created — okf
  reads `generated.at` in preference to `timestamp` when checking log coverage, so without the
  flag nothing proves the new provenance dates are accounted for.
  Date: 2026-08-02

- Decision: Write five new invalid fixtures — `bad-actor`, `bad-verified-actor`, `bad-status`,
  `bad-stale-after`, and `bad-legacy-timestamp` — rather than the two the plan budgeted for, and
  no `missing-generated`.
  Rationale: Two reasons, and they pull in the same direction. First, carrying forward the
  load-bearingness discipline EP-2 established and EP-3 and EP-4 applied: this profile splices
  five rules from `Profile/V02.dhall`, more than any other in the catalog, and `bad-actor` plus
  `bad-stale-after` would have left `verified`, `status`, and `legacyTimestamp` with no fixture at
  all — deletable from the profile with the script still green. Verified by deleting each of the
  five in turn and confirming `scripts/test-tan-postgresql-profile.sh` fails each time. Second,
  `missing-generated` is omitted for the reason the plan gives: `generated` is `recommended` here,
  so its absence is only an error under `--strict`, and such a fixture would need a different
  invocation from every other entry in the rejection loop.
  Date: 2026-08-02

- Decision: Adopt OKF v0.2's `status` and `stale_after` on both PostgreSQL profiles, unlike
  the five profiles that keep a house `status` vocabulary.
  Rationale: Neither profile declares a `status` key today, so there is no collision and no
  corpus to break. A database description is exactly the kind of content whose accuracy decays
  on a schedule whether or not anyone edits the document, which is the case §5.5's
  `stale_after` was designed for. Adopting both here means this catalog demonstrates full v0.2
  lifecycle conformance somewhere, rather than documenting the divergence and shipping nothing
  that follows the specification.
  Date: 2026-08-01

- Decision: Put `generated` in `recommended` rather than `required` on the PostgreSQL
  profiles, unlike the documentation and coordination profiles where it is required.
  Rationale: The base profile already treats `description`, `timestamp`, and `resource` as
  recommended rather than required — it is the most permissive profile in the catalog, because
  a large database is documented incrementally and a partially-documented bundle is useful.
  Promoting provenance to required would invert that stance for one key. okf's own shipped
  `docs/profiles/postgresql.dhall`, which was migrated to v0.2 upstream, makes the same
  choice: `generated` sits in `recommended` beside `description` and `resource`. Matching it
  keeps the two files comparable for anyone reading both.
  Date: 2026-08-01


## Outcomes & Retrospective

Complete on 2026-08-02, in two commits — the migration, then the new base-profile coverage, as
the plan directed.

### The headline result

The command that failed before this plan:

```text
$ okf validate fixtures/tan-postgresql --strict \
    --profile profiles/tan-postgresql.dhall --profile-enforce
schemas/public/tables/orders: missing recommended field: description
schemas/public/tables/orders: missing generated field (or legacy timestamp)
streams/order: missing recommended field: description
streams/order: missing generated field (or legacy timestamp)
profile: schemas/public/tables/orders: missing profile-recommended field: description (One or two sentences explaining the object's purpose.)
profile: schemas/public/tables/orders: missing profile-recommended field: timestamp (UTC time when this description was last confirmed accurate.)
profile: streams/order: missing profile-recommended field: description (One or two sentences explaining the object's purpose.)
profile: streams/order: missing profile-recommended field: resource (postgresql:// URI locating the live object.)
profile: streams/order: missing profile-recommended field: timestamp (UTC time when this description was last confirmed accurate.)
```

and after:

```text
OK: 2 concepts (okf_version 0.2)
```

The new base-profile bundle reports `OK: 3 concepts (okf_version 0.2)` under the same flags plus
`--log-enforce`. **There are now eight test scripts and all eight pass**, up from six when this
initiative started. The Dhall type-check sweep is clean, and `Profile/V02.dhall`,
`Profile/ReviewRule.dhall`, the root `package.dhall`, and the documentation and coordination
profiles were not touched.

`profiles/tan-postgresql.dhall` is **unchanged**. Every v0.2 change reached `tanPostgresql`
through its `//` record merge, verified with `okf profile show` rather than assumed.

`requireBundleVersion` was proven live on throwaway copies of both bundles:

```text
profile: bundle does not declare okf_version; this profile requires 0.2 or later
```

All five spliced v0.2 rules — `generated`, `verified`, `status`, `staleAfter`, `legacyTimestamp` —
are load-bearing, verified by deleting each in turn and confirming
`scripts/test-tan-postgresql-profile.sh` fails.

### What a consumer corpus must change

**Both PostgreSQL profiles** (the changes are identical, because `tanPostgresql` inherits its
frontmatter from `postgresql`):

- **`generated` is newly *recommended*** — a mapping with a required `by` (an OKF §7 actor:
  `human:<id>`, `process:<id>`, or `<producer>/<version>`) and a recommended `at` (RFC3339 UTC).
  **It is recommended, not required**, unlike the five documentation and coordination profiles.
  A concept without it validates normally and is only reported under `--strict`. For a database
  description the natural actor is `process:<sync-tool>`, not a human.
- **`timestamp` is no longer recommended, only optional.** Keep it or drop it. If kept it must
  still be RFC3339 UTC. The natural migration is `timestamp: X` →
  `generated: {by: <actor>, at: X}`, reusing the same instant so log coverage still matches.
  Because it moved from `recommended` to `optional`, a corpus that omits it **stops** failing
  `--strict` — this is a pure relaxation.
- **Add a root `index.md` declaring `okf_version: "0.2"`**, via
  `okf index <bundle> --write --okf-version 0.2`. Without it every concept passes but the bundle
  is a profile deviation. Note these trees are several levels deep, so several index files are
  generated; only the root one carries the declaration, which is correct.
- **`verified`, `status`, and `stale_after` are newly accepted** as optional families. Nothing
  breaks if they are absent.

**The divergence EP-6 must not get wrong.** These are the only two profiles in the catalog that
adopt OKF v0.2's `status` and `stale_after`. The five house-`status` profiles —
`documentation.architectureDecisions`, `documentation.patternCatalog`,
`documentation.researchDocuments`, `coordination.improvementRequests`, and
`coordination.useCases` — keep their own lifecycle vocabulary on the `status` key and do **not**
declare either. A migration prompt that tells a consumer to adopt `draft`/`stable`/`deprecated`
on an ADR or use-case bundle is telling them to break it. The observable difference:

```text
profile: … frontmatter value at status must be one of [draft, stable, deprecated], found: "current"
```

happens on a PostgreSQL bundle and must never happen on the other five.

Neither profile declares `sources` or `usage_window`, and neither declares `reviews` — the
`reviews`-versus-`verified` guidance that applies to the coordination and research profiles does
not apply here.

### The base profile now has a test

`scripts/test-postgresql-profile.sh` is new. The most-consumed export in this catalog previously
had no fixture and no script; the README suggested validating it against a sample bundle from a
checkout of the okf repository, so this repository's own checks proved nothing about it.
**EP-7 must add it to the README's validation section** alongside the seven others.

The new bundle covers all three concept types — `schemas/sales.md`,
`schemas/sales/tables/orders.md`, `schemas/sales/views/daily_totals.md` — with the `schemas/sales.md`
file and `schemas/sales/` directory coexisting exactly as the path patterns require. Two rejection
cases lock down rules that predate this plan: `bad-resource-scheme` and `missing-schema-section`.

### What went differently from the plan

Two things. The plan expected `resource` on the event stream to be a judgement call and it was —
resolved by completing the fixture rather than weakening the rule, as the plan directed, with the
stream's `resource` pointing at the message-store table it lives in. And the plan's acceptance
check for `resourceScheme` turned out not to prove what it claims; see Surprises & Discoveries.

Five rejection fixtures were written rather than two, for the reason EP-2 through EP-4 all found:
this profile splices more v0.2 rules than any other in the catalog, and the plan's budget would
have left three of the five untested.

### ADR

No ADR was written here, for the reason EP-2, EP-3, and EP-4 recorded: `docs/adr/` does not exist
and creating it is EP-7's deliverable. This plan contributes two items to EP-7's distillation
pass, both durable and neither specific to this migration:

- **Presence class determines whether adding a family disturbs existing fixtures.** EP-4 found
  that requiring `generated` invalidated fourteen rejection fixtures at once; this plan
  recommended it instead and disturbed none. Same family, same catalog, opposite outcome, and the
  difference is entirely the presence class.
- **"The script fails when I delete the rule" does not prove a fixture tests that rule** when two
  rules constrain the same value. The `resourceScheme` case is the worked example.


## Context and Orientation

### Where you are

The repository root is `/Users/shinzui/Keikaku/bokuno/okf-profiles`. Run every command from
there. Commit directly to `master`; do not create a branch.

There is no compiler and no package manager. "Type-check" means `dhall type --file <path>`.
"Test" means running a bash script under `scripts/`, each of which invokes the `okf` binary
against a fixture bundle under `fixtures/`. `okf --version` must report `v0.5.0.0` or later.

### Prerequisites

This plan hard-depends on
`docs/plans/2-ship-the-shared-okf-v0-2-field-family-module-and-the-okfv02-reference-profile.md`.
Confirm it landed:

```bash
test -f Profile/V02.dhall && dhall type --file Profile/V02.dhall > /dev/null && echo "EP-2 present"
```

If that file does not exist, stop. Every profile edit below splices values from it, and
re-authoring them here would produce descriptions of `generated` that drift from the other
migration plans'.

Read `Profile/V02.dhall`'s header comment before you start. It states the house `status`
policy — which, uniquely for this plan, does **not** apply, because these two profiles have
no colliding key. Read it anyway so you understand why you are the exception.

This plan carries a **soft** dependency on
`docs/plans/3-migrate-the-documentation-profiles-to-okf-v0-2.md`, which establishes the
pattern for fixture index files, invalid-fixture naming, and `--strict` in a script. If it is
complete, read its Outcomes & Retrospective and copy what it did. If not, proceed anyway and
record in the parent MasterPlan's Surprises & Discoveries that you went first.

Two sibling plans may be running concurrently on disjoint files. **Do not edit
`Profile/V02.dhall`, `Profile/ReviewRule.dhall`, the root `package.dhall`, or anything under
`profiles/documentation/` or `profiles/coordination/`.**

### ADRs

`docs/adr/` does not exist in this repository and there is no local ADR corpus, so **no local
ADR applies to this work**. Creating that corpus is the job of
`docs/plans/7-release-okf-profiles-v0-8-0-and-dogfood-the-migrated-adr-profile.md`.

Two cross-repository decisions from `mori://shinzui/okf` bear on what you write:

- `docs/adr/7-okf-v0-1-legacy-fallback-policy.md` (artifact-level URI pending): okf reads
  `timestamp` whenever `generated` is absent, silently, with no removal horizon. This is why
  demoting `timestamp` to `optional` keeps unmigrated corpora green.
- `docs/adr/10-okf-version-declaration-and-best-effort-reading.md` (artifact-level URI
  pending): a bundle's `okf_version` declaration is optional per specification §12, so okf
  never demands one. A profile may, through `requireBundleVersion`.

### The two profiles you are changing

**`profiles/postgresql.dhall`** — `name = "shinzui-postgresql"`, `allowUnknownTypes = False`,
three concept types:

- `PostgreSQL Schema` at `pathPattern = Some "schemas/*"`, `resourceScheme = Some "postgresql"`.
- `PostgreSQL Table` at `schemas/*/tables/*`, same scheme, `requireSchemaSection = True` with
  `schemaColumns = [ "Column", "Type", "Nullable", "Description" ]`.
- `PostgreSQL View` at `schemas/*/views/*`, same scheme, `requireSchemaSection = True` with
  `schemaColumns = [ "Column", "Type", "Description" ]`.

Its frontmatter is deliberately permissive. Required: `type` and `title` only. Recommended:
`description`, `timestamp` (RFC3339 UTC), and `resource` (URI with scheme `postgresql`).
Optional: empty. It writes its `frontmatter` as a **bare record literal** naming all three
lists, not `FrontmatterRules::{…}`; either form works, and converting it to the completion
form while you are in there is reasonable tidying.

**`profiles/tan-postgresql.dhall`** — this one is unusual and you must understand its
mechanism before editing anything. It does **not** define a profile from scratch. It imports
`./postgresql.dhall` as `base` and produces:

```dhall
in        base
      //  { name = "tan-postgresql"
          , description = Some "…"
          , types = [ … four type rules … ]
          }
    : Profile.Type
```

The `//` operator is a right-biased record merge. Only `name`, `description`, and `types` are
overridden; **`frontmatter`, `okfVersion`, `allowUnknownTypes`, `idField`, and
`requireBundleVersion` are inherited from `base` unchanged.**

That is the single most important fact in this plan. **Everything you change in
`profiles/postgresql.dhall`'s frontmatter, `okfVersion`, and `requireBundleVersion`
automatically applies to `tanPostgresql` as well.** You do not need to edit
`tan-postgresql.dhall` at all for the v0.2 migration — but you must *verify* the inheritance
rather than assume it, because a future editor who converts `//` to an explicit record would
silently break it.

The four type rules `tanPostgresql` declares are `PostgreSQL Schema`, `PostgreSQL Table`
(with its own required `derivation`, `lifecycle`, `domain`, and conditional `sourceStreams`),
`PostgreSQL View`, and `Event Stream` at `pathPattern = Some "streams/*"` with no
`resourceScheme` — a logical stream is not a single physical table.

### The fixture situation, which is lopsided

`fixtures/tan-postgresql/` exists and holds two concepts:

```text
fixtures/tan-postgresql/schemas/public/tables/orders.md
fixtures/tan-postgresql/streams/order.md
```

`fixtures/tan-postgresql-invalid/` holds two cases, `invalid-role/` and
`missing-source-streams/`, each a one-file bundle.

**The base `postgresql` profile has no fixture and no test script at all.** The README
suggests validating it against okf's own `examples/postgresql-sample` bundle from a checkout
of the okf repository — which works but means this repository's CI proves nothing about its
most-consumed profile. Adding a small self-contained fixture and script for it is part of this
plan, because you are changing that profile's rules and a rule with no test is a rule that
silently rots.

Look at the existing valid fixture's frontmatter before you plan the edit:

```yaml
---
type: PostgreSQL Table
title: orders
resource: postgresql://example/public/orders
derivation: projection
lifecycle: durable
domain: true
sourceStreams: [order]
---
```

Note what is **absent**: no `description` and no `timestamp`, both of which the base profile
lists as `recommended`. The script does not pass `--strict` today, so their absence is never
reported. Adding `--strict` will report both, plus core strict's own demand for `title`,
`description`, and `generated` on every concept. Expect a wall of failures on the first strict
run and work through it deliberately — that is the point of capturing the before-state in
Step 2.

### The constraint that forces an atomic change

As of okf 0.5.0.0 a profile's declared `okfVersion` is compile-checked against the rules it
declares, in both directions. Verified against the installed binary:

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

So the profile flips atomically. A Dhall type-check cannot catch this — okf enforces it when
it *loads* the profile — which is why every verification step below uses `okf profile show` or
`okf validate` rather than `dhall type` alone.

Because `tanPostgresql` inherits `okfVersion` through `//`, both profiles flip together in one
edit to one file. There is no window in which they disagree.

### The trap that will bite you first

Every fixture bundle in this repository has **no `index.md` at any level** — confirmed by
search. Both migrated profiles will set `requireBundleVersion = Some "0.2"`, and
`scripts/test-tan-postgresql-profile.sh` passes `--profile-enforce`. The moment you migrate,
the script fails with a diagnostic that names no concept at all:

```text
profile: bundle does not declare okf_version; this profile requires 0.2 or later
```

The fix is one command per bundle:

```bash
okf index fixtures/tan-postgresql --write --okf-version 0.2
```

It generates an `index.md` per directory — and this fixture is three levels deep
(`schemas/public/tables/`), so expect several — writes `okf_version: "0.2"` into the
frontmatter of the **root** one only, overwrites exactly what it generates, never deletes, and
preserves an existing declaration on a re-run. Do this for the valid bundle and both invalid
siblings.

### The reference to work from

Upstream okf migrated its own sample PostgreSQL profile to v0.2 and ships it at
`/Users/shinzui/Keikaku/bokuno/okf/docs/profiles/postgresql.dhall` in the local checkout.
**Read it before writing anything.** It is the closest possible analogue: same profile name
(`shinzui-postgresql`), same three concept types, and it has already made the exact choices
you are about to make — `okfVersion = "0.2"`, `generated` in `recommended` rather than
`required`, `timestamp` dropped, `requireBundleVersion = Some "0.2"` set with a comment
explaining that it is a house convention rather than a rule of the format.

Two differences you should keep. That file is a self-contained worked example annotated
against okf's schema by relative path; yours imports through this repository's
`Profile/okf.dhall` pin and splices values from `Profile/V02.dhall`. And that file drops
`timestamp` entirely; yours demotes it to `optional`, because this repository's profile is
pinned by real consumers whose corpora still carry the key and whose malformed values should
still be caught.


## Plan of Work

Three milestones. The first two are the migration proper; the third closes the base profile's
test gap.

### Milestone 1 — migrate the base profile and verify the inheritance

Scope: `profiles/postgresql.dhall`, plus a read-only verification of
`profiles/tan-postgresql.dhall`.

Make these changes to `profiles/postgresql.dhall`, all in one edit:

1. Set `okfVersion = "0.2"`.
2. Set `requireBundleVersion = Some "0.2"`, with a comment saying this is a house convention
   and not a rule of the format — specification §12 makes the bundle declaration a MAY.
3. Remove the hand-written `timestamp` rule from `recommended` and add `v02.legacyTimestamp`
   to `optional`.
4. Add `v02.generated` to `recommended`, beside `description` and `resource`. See the Decision
   Log for why `recommended` rather than `required`.
5. Add `v02.verified`, `v02.status`, and `v02.staleAfter` to `optional`. This is the branch of
   the house-`status` policy that applies to non-colliding profiles, and this plan is the only
   one of the three migration plans that takes it.
6. Extend the profile's `description` to say it targets OKF v0.2 and records provenance and
   lifecycle in the v0.2 families.

Then **verify** that `tanPostgresql` inherited all six. Do not take the `//` operator on
faith:

```bash
dhall <<< '(./profiles/tan-postgresql.dhall).okfVersion'
dhall <<< '(./profiles/tan-postgresql.dhall).requireBundleVersion'
dhall <<< '(./profiles/tan-postgresql.dhall).frontmatter.optional'
```

The first must print `"0.2"`, the second `Some "0.2"`, and the third must include the
`timestamp`, `verified`, `status`, and `stale_after` rules. If any is wrong, the override
record in `tan-postgresql.dhall` is naming a field it should not; read it and fix the
override, not the base.

Also confirm both profiles load inside okf, which is where the `okfVersion` rules are enforced:

```bash
okf profile show --registry ./package.dhall postgresql 2>&1 | head -40
okf profile show --registry ./package.dhall tanPostgresql 2>&1 | head -40
```

Neither may print `Failed to load profile`.

### Milestone 2 — bring the tan fixture up and add `--strict`

Scope: `fixtures/tan-postgresql/`, `fixtures/tan-postgresql-invalid/*`, and
`scripts/test-tan-postgresql-profile.sh`.

Add to both concepts in the valid fixture: a `description`, a `generated` block, and — on one
of them — a `stale_after`, so the new lifecycle rule is exercised somewhere:

```yaml
description: Order projection rebuilt from the order event stream.
generated:
  by: process:schema-sync
  at: 2026-07-30T00:00:00Z
stale_after: 2027-07-30
```

Use a `process:` actor here rather than `human:`, because a database description genuinely is
produced by a synchronisation process in most real deployments and the fixture should model
the realistic case. Give the other concept a `verified` entry with a `human:` actor, so the
fixture exercises both the machine and human trust paths and the `recordOrList` bare-mapping
spelling:

```yaml
verified:
  by: human:nadeem
  at: 2026-07-31T00:00:00Z
```

Add `status: stable` to one concept — an explicit `stable` is redundant with OKF's default but
proves the vocabulary rule is wired, and a fixture that only ever omits an optional key does
not test it.

Neither concept should gain a `timestamp`. The base profile now lists it as `optional`, and no
PostgreSQL fixture carries one today, so the "absence is never reported" behaviour is already
covered. If you want positive coverage of the demoted rule's *format* check, add
`timestamp: 2026-07-30T00:00:00Z` to one concept — that is worth doing, because otherwise
nothing in this repository proves the demoted rule still checks anything.

Generate index files for the valid bundle and both invalid siblings. Then add two new invalid
fixtures under `fixtures/tan-postgresql-invalid/`, each a minimal one-file bundle following
the shape of the existing `invalid-role/`:

- `bad-actor/` — an otherwise-valid table whose `generated.by` is `schema-sync`, missing the
  `process:` prefix and matching none of the three actor shapes.
- `bad-stale-after/` — an otherwise-valid table whose `stale_after` is `2027-13-45`, not a
  calendar date.

Note the second is not `missing-generated`, unlike the other two migration plans: `generated`
is `recommended` here, not `required`, so its absence is only an error under `--strict`. If you
want a `missing-generated` case, it must be validated with `--strict` in the rejection loop —
which is a different invocation from the other cases and complicates the script. Prefer
`bad-stale-after`, and note the reasoning in this plan's Decision Log.

Finally extend `scripts/test-tan-postgresql-profile.sh`: add `--strict` to the accepting
invocation and add the two new names to the rejection loop.

Expect the first strict run to fail on things you did not change. Work through them one at a
time. `description` was recommended and absent — you just added it. `resource` is recommended
and present on the table but check the stream concept. Core strict wants `title`,
`description`, and `generated` on every concept including the stream. Do not weaken the
profile to make it green; fix the fixture, which is what a real corpus would have to do.

### Milestone 3 — give the base profile a fixture and a script

Scope: a new `fixtures/postgresql/` tree, a new `fixtures/postgresql-invalid/` tree, and a new
`scripts/test-postgresql-profile.sh`.

The base profile is the most-consumed export in this catalog and currently has no test in this
repository. You are changing its rules; leaving it untested afterwards is worse than it was
before, because now the rules are new.

Build a minimal bundle exercising all three concept types:

```text
fixtures/postgresql/schemas/sales.md                    (PostgreSQL Schema)
fixtures/postgresql/schemas/sales/tables/orders.md      (PostgreSQL Table, with # Schema)
fixtures/postgresql/schemas/sales/views/daily_totals.md (PostgreSQL View, with # Schema)
```

Note the path patterns: a schema concept is at `schemas/*` — that is `schemas/sales.md`, a
file, not a directory — while its tables are at `schemas/*/tables/*`, which is
`schemas/sales/tables/orders.md`. Both a `schemas/sales.md` file and a `schemas/sales/`
directory coexisting is legal and is what the pattern requires; do not try to "fix" it.

The table and view concepts each need a `# Schema` section with exactly the columns the type
rule names — `Column | Type | Nullable | Description` for a table, `Column | Type | Description`
for a view — because both type rules set `requireSchemaSection = True`. Copy the table shape
from `fixtures/tan-postgresql/schemas/public/tables/orders.md`.

Give every concept `type`, `title`, `description`, `resource` (a `postgresql://` URI), and
`generated`, so the bundle passes `--strict`.

For invalid cases, two suffice:

- `fixtures/postgresql-invalid/bad-resource-scheme/` — a table whose `resource` uses
  `mysql://`, which the type rule's `resourceScheme` rejects.
- `fixtures/postgresql-invalid/missing-schema-section/` — a table with no `# Schema` heading,
  which `requireSchemaSection` rejects.

Both test rules that predate this plan, which is deliberate: the new script's first job is to
lock down behaviour that was previously only checked against an out-of-repository sample.

Write `scripts/test-postgresql-profile.sh` following the shape of
`scripts/test-tan-postgresql-profile.sh` exactly — same variable names, same loop, same final
`echo "OK: …"` line — so the six existing scripts and the two new ones read as one family.


## Concrete Steps

All commands run from `/Users/shinzui/Keikaku/bokuno/okf-profiles`.

**Step 1 — verify prerequisites and capture the baseline.**

```bash
okf --version
test -f Profile/V02.dhall && echo "EP-2 present"
mkdir -p /tmp/ep5
for s in scripts/*.sh; do echo "--- $s"; bash "$s" 2>&1; done > /tmp/ep5/before.txt
grep -c '^OK:' /tmp/ep5/before.txt
```

Every script must pass before you start.

**Step 2 — capture what `--strict` reports today.** This is the most important preparatory
step in this plan, because the PostgreSQL fixture is the least complete in the repository and
you need to know which failures you inherited:

```bash
okf validate fixtures/tan-postgresql --strict \
  --profile profiles/tan-postgresql.dhall --profile-enforce 2>&1 | tee /tmp/ep5/tan-strict-before.txt
cat /tmp/ep5/tan-strict-before.txt
```

Read every line. Each one is either a fixture you must complete or a rule you must reclassify;
decide which, per line, and record the decisions in this plan's Decision Log.

**Step 3 — read the upstream reference.**

```bash
cat /Users/shinzui/Keikaku/bokuno/okf/docs/profiles/postgresql.dhall
```

**Step 4 — edit `profiles/postgresql.dhall`**, then type-check and verify the inheritance:

```bash
dhall type --file profiles/postgresql.dhall > /dev/null && echo "base type-checks"
dhall type --file profiles/tan-postgresql.dhall > /dev/null && echo "tan type-checks"
dhall <<< '(./profiles/tan-postgresql.dhall).okfVersion'
dhall <<< '(./profiles/tan-postgresql.dhall).requireBundleVersion'
```

Expected:

```text
"0.2"
Some "0.2"
```

If `tanPostgresql` reports `"0.1"`, the `//` override is naming `okfVersion` explicitly and
must stop.

**Step 5 — confirm both load inside okf.**

```bash
okf profile show --registry ./package.dhall postgresql 2>&1 | head -30
okf profile show --registry ./package.dhall tanPostgresql 2>&1 | head -30
```

Neither may print `Failed to load profile`. If one does with a line about
`okfVersion 0.2 supersedes the frontmatter key timestamp`, the demoted rule is still in
`required` or `recommended`.

**Step 6 — update the tan fixture and generate indexes.**

```bash
okf index fixtures/tan-postgresql --write --okf-version 0.2
for d in fixtures/tan-postgresql-invalid/*/; do
  okf index "$d" --write --okf-version 0.2
done
head -3 fixtures/tan-postgresql/index.md
find fixtures/tan-postgresql -name index.md
```

The root index must carry the declaration; the nested ones will not, which is correct.

**Step 7 — validate the migrated tan bundle strictly.**

```bash
okf validate fixtures/tan-postgresql --strict \
  --profile profiles/tan-postgresql.dhall --profile-enforce
```

Expected:

```text
OK: 2 concepts (okf_version 0.2)
```

with no `profile:` lines. The `(okf_version 0.2)` suffix is new and is how you know the
declaration took effect. If you still see `missing recommended field:` lines, they are core
strict's demands and the fixture is still incomplete — finish it.

**Step 8 — confirm the new invalid fixtures reject for the right reason**, without
`--profile-enforce` so you can read the advisory:

```bash
okf validate fixtures/tan-postgresql-invalid/bad-actor --profile profiles/tan-postgresql.dhall
okf validate fixtures/tan-postgresql-invalid/bad-stale-after --profile profiles/tan-postgresql.dhall
```

The first must name `generated.by` and the `actor` format; the second must name `stale_after`
and the `date` format.

**Step 9 — extend and run the tan script.**

```bash
bash scripts/test-tan-postgresql-profile.sh
```

Expected:

```text
OK: 2 concepts (okf_version 0.2)
OK: tan-postgresql profile acceptance and rejection fixtures
```

**Step 10 — commit Milestones 1 and 2.**

```bash
git add profiles/postgresql.dhall fixtures/tan-postgresql fixtures/tan-postgresql-invalid scripts/test-tan-postgresql-profile.sh
git commit -F - <<'MSG'
feat(postgresql)!: move the PostgreSQL profiles to OKF v0.2

Declare okfVersion 0.2, recommend the generated provenance family with an
actor-checked by member, and demote timestamp to the optional list where
its RFC3339-UTC format is still checked but its absence never reported.
Require the bundle to declare okf_version 0.2 in its root index.

Adopt OKF v0.2's status and stale_after in full. Unlike the five profiles
that carry a house lifecycle vocabulary on the status key, neither of
these declares one, so there is no collision -- and a database
description is exactly the content whose accuracy decays on a schedule
whether or not anyone edits the document.

tanPostgresql inherits all of this through its record-merge override; the
inheritance is verified rather than assumed.

MasterPlan: docs/masterplans/1-bring-okf-profiles-to-okf-v0-2-and-ship-bundle-migrations.md
ExecPlan: docs/plans/5-migrate-the-postgresql-profiles-to-okf-v0-2.md
MSG
```

**Step 11 — build the base-profile fixture and script**, then:

```bash
okf index fixtures/postgresql --write --okf-version 0.2
for d in fixtures/postgresql-invalid/*/; do okf index "$d" --write --okf-version 0.2; done
okf validate fixtures/postgresql --strict --profile profiles/postgresql.dhall --profile-enforce
chmod +x scripts/test-postgresql-profile.sh
bash scripts/test-postgresql-profile.sh
```

Expected:

```text
OK: 3 concepts (okf_version 0.2)
OK: postgresql profile acceptance and rejection fixtures
```

**Step 12 — final sweep.**

```bash
for s in scripts/*.sh; do echo "--- $s"; bash "$s" 2>&1 | tail -1; done
for f in Profile/*.dhall profiles/*.dhall profiles/*/*.dhall; do
  dhall type --file "$f" > /dev/null || echo "FAILED: $f"
done; echo "type-check sweep done"
git status --short
```

All scripts pass, no `FAILED:` lines, and `git status` shows nothing outside the two
PostgreSQL profiles, their fixtures, and their scripts.

**Step 13 — commit Milestone 3.**

```bash
git add fixtures/postgresql fixtures/postgresql-invalid scripts/test-postgresql-profile.sh
git commit -F - <<'MSG'
test(postgresql): give the base profile a fixture and a check

The most-consumed profile in this catalog had no fixture and no script;
the README suggested validating it against a sample bundle from a
checkout of the okf repository, so this repository's own checks proved
nothing about it. Add a self-contained three-concept bundle covering
schemas, tables, and views, two rejection cases for the resource scheme
and the required # Schema section, and a script matching the shape of the
six that already exist.

MasterPlan: docs/masterplans/1-bring-okf-profiles-to-okf-v0-2-and-ship-bundle-migrations.md
ExecPlan: docs/plans/5-migrate-the-postgresql-profiles-to-okf-v0-2.md
MSG
```


## Validation and Acceptance

**Both profiles compile inside okf with `okfVersion = "0.2"`.**
`okf profile show --registry ./package.dhall postgresql` and `… tanPostgresql` each render
without a `Failed to load profile` line and show `generated` under recommended with its
`objectFields` members displayed.

**The inheritance is proven, not assumed.**

```bash
dhall <<< '(./profiles/tan-postgresql.dhall).okfVersion'
dhall <<< '(./profiles/tan-postgresql.dhall).requireBundleVersion'
```

print `"0.2"` and `Some "0.2"`. This is the check that would catch a future editor converting
the `//` override into an explicit record and silently reverting `tanPostgresql` to v0.1.

**Both acceptance fixtures validate under `--strict --profile-enforce`** and report the version
declaration:

```text
OK: 2 concepts (okf_version 0.2)
OK: 3 concepts (okf_version 0.2)
```

Compare against `/tmp/ep5/tan-strict-before.txt`, which shows the same command failing before
this plan, and quote both in Outcomes & Retrospective.

**The v0.2 lifecycle family does real work.** This plan is the only one of the three migration
plans that adopts `status` and `stale_after`, so it is the only place this repository proves
they work. `fixtures/tan-postgresql-invalid/bad-stale-after` must be rejected with an advisory
naming `stale_after` and the `date` format, and temporarily changing the valid fixture's
`status: stable` to `status: current` must produce a vocabulary advisory. Do that check
manually and restore the fixture; note the observed diagnostic in Surprises & Discoveries.

**The pre-existing rules still fire.** `fixtures/tan-postgresql-invalid/invalid-role` and
`missing-source-streams` must still be rejected, proving the `okfVersion` change did not
disturb the `derivation` vocabulary or the conditional `sourceStreams` rule.

**A bundle without the version declaration is now reported.**

```bash
cp -r fixtures/tan-postgresql /tmp/ep5/noindex && rm /tmp/ep5/noindex/index.md
okf validate /tmp/ep5/noindex --profile profiles/tan-postgresql.dhall
```

Expected:

```text
profile: bundle does not declare okf_version; this profile requires 0.2 or later
OK: 2 concepts
```

Then `rm -rf /tmp/ep5/noindex`.

**The base profile now has a check that fails when the profile is wrong.** Temporarily remove
`resourceScheme = Some "postgresql"` from the `PostgreSQL Table` type rule and confirm
`bash scripts/test-postgresql-profile.sh` fails on `bad-resource-scheme`. Restore it. A script
that passes with a rule removed is not testing that rule.

**Nothing outside this plan's scope changed.** `git status --short` lists only
`profiles/postgresql.dhall`, `fixtures/tan-postgresql*`, `fixtures/postgresql*`, `scripts/`,
and this plan file. `profiles/tan-postgresql.dhall` should be **unchanged** — if you had to
edit it, say why in the Decision Log, because it means the inheritance did not work as
described.

**The other six scripts still pass**, proving the sibling plans' territory is undisturbed.


## Idempotence and Recovery

`okf index --write` is idempotent: it overwrites exactly the index files it generates, never
deletes, and preserves an existing `okf_version` declaration on a re-run. Running it twice on
the same bundle produces no diff. Note this fixture tree is several levels deep, so it
generates several index files; that is expected and they are all committed.

`okf validate`, `okf profile show`, and `dhall type` are read-only. Editing Dhall and Markdown
is ordinary authoring.

Commit at the end of Milestone 2 and again at the end of Milestone 3. That separates the
migration from the new test coverage, which are independently useful and independently
revertable.

The riskiest step is Milestone 2's strict pass, because the PostgreSQL fixture is the least
complete in the repository and the first `--strict` run will produce more failures than any
other plan's. Do not weaken the profile to make it green. Work through the list one line at a
time and, for each, decide whether the fixture is deficient (complete it) or the rule demands
something ordinary corpora lack (reclassify to `optional`, and record why). Record every such
decision, because EP-6 turns them into consumer-facing migration instructions.

If Milestone 3's new fixture proves harder than expected — the `schemas/sales.md` file
alongside a `schemas/sales/` directory is the part most likely to surprise — remember that
Milestones 1 and 2 are already committed and independently complete. Milestone 3 can be
finished in a follow-up without leaving the repository in a broken state.


## Interfaces and Dependencies

**Hard dependency on EP-2**
(`docs/plans/2-ship-the-shared-okf-v0-2-field-family-module-and-the-okfv02-reference-profile.md`),
which owns `Profile/V02.dhall`. This plan consumes these names from it and must not redefine
them: `generated`, `verified`, `status`, `staleAfter`, `legacyTimestamp`. It is the **only**
one of the three migration plans that consumes `status` and `staleAfter` — see the Decision
Log. It does not need `sources` or `usageWindow`; a table description derived from a live
database schema has one obvious source and inventing a convention for recording it is out of
scope.

**Soft dependency on EP-3**
(`docs/plans/3-migrate-the-documentation-profiles-to-okf-v0-2.md`), for the established
pattern only.

**`okf` 0.5.0.0 or later** and **`dhall` ≥ 1.42**.

**Read-only reference**: `/Users/shinzui/Keikaku/bokuno/okf/docs/profiles/postgresql.dhall`.
Never edit that checkout, and never import from it in committed code.

**Files this plan owns for its duration** (no other plan may edit them):

```text
profiles/postgresql.dhall
profiles/tan-postgresql.dhall
fixtures/tan-postgresql/**
fixtures/tan-postgresql-invalid/**
fixtures/postgresql/**            (new)
fixtures/postgresql-invalid/**    (new)
scripts/test-tan-postgresql-profile.sh
scripts/test-postgresql-profile.sh (new)
```

**Files this plan must not edit**: `Profile/V02.dhall`, `Profile/okf.dhall`,
`Profile/ReviewRule.dhall`, the root `package.dhall` (the `postgresql` and `tanPostgresql`
exports already exist and their names must not change), anything under
`profiles/documentation/` or `profiles/coordination/`, and anything under `blueprints/`.

**What EP-6 and EP-7 need from this plan.**
`docs/plans/6-ship-seihou-blueprint-migrations-for-consumer-okf-bundles.md` writes consumer
migration instructions and reads this plan's record of what changed. State explicitly in
Outcomes & Retrospective: the exact list of frontmatter changes a PostgreSQL corpus must make,
and — because this plan diverges from the other two — that `status` and `stale_after` are
newly available here and *not* available on the five house-`status` profiles, so the migration
prompt does not tell a consumer to add them to the wrong bundle.
`docs/plans/7-release-okf-profiles-v0-8-0-and-dogfood-the-migrated-adr-profile.md` needs the
new `scripts/test-postgresql-profile.sh` named so the README's validation section lists it.
