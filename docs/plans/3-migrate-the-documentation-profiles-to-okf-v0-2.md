---
id: 3
slug: migrate-the-documentation-profiles-to-okf-v0-2
title: "Migrate the documentation profiles to OKF v0.2"
kind: exec-plan
created_at: 2026-08-01T23:39:57Z
master_plan: "docs/masterplans/1-bring-okf-profiles-to-okf-v0-2-and-ship-bundle-migrations.md"
---

# Migrate the documentation profiles to OKF v0.2

This ExecPlan is a living document. The sections Progress, Surprises & Discoveries,
Decision Log, and Outcomes & Retrospective must be kept up to date as work proceeds.
If durable project context changes, update or create ADRs in docs/adr/ in the same change.


## Purpose / Big Picture

Three of this repository's seven published profiles describe documentation corpora:
architecture decision records, a pattern catalog, and research documents. All three still
demand the Open Knowledge Format v0.1 key `timestamp`, which OKF v0.2 retired, and none of
them says anything about who produced a document or whether anyone confirmed it — the whole
point of v0.2, which assumes a corpus written and maintained by agents.

After this plan, a team pinning any of the three profiles gets a check that a document
records **who wrote it** in the v0.2 `generated` family, with the producer's identity checked
against OKF's actor convention (so `human:nadeem` and `process:ddd-schema-check` pass and a
bare `nadeem` does not). Legacy corpora keep validating: `timestamp` moves to the profile's
`optional` list, where its format is still checked whenever present but its absence is never
reported. And each profile now requires the bundle to say which dialect it targets, so a
half-migrated corpus is visible rather than silently exempt from every v0.2 check.

You can see it working by running `bash scripts/test-architecture-decisions-profile.sh` and
its two siblings, which after this plan run under `--strict` — something no script in this
repository does today, and something the architecture-decision fixture currently fails.


## Progress

- [ ] Confirm EP-2 has landed and `Profile/V02.dhall` exists
- [ ] Record the baseline: run all scripts and save the output
- [ ] Migrate `profiles/documentation/architecture-decisions.dhall`
- [ ] Reclassify `supersedes`, `supersededBy`, `originatingPlan` to `optional`
- [ ] Update `fixtures/architecture-decisions` and its invalid siblings
- [ ] Extend `scripts/test-architecture-decisions-profile.sh` with `--strict`
- [ ] Migrate `profiles/documentation/pattern-catalog.dhall`, including the `sources` shape
- [ ] Update `fixtures/documentation-pattern-catalog` and its invalid sibling
- [ ] Extend `scripts/test-pattern-catalog-profile.sh` with `--strict`
- [ ] Migrate `profiles/documentation/research-documents.dhall`, including the `sources` shape
- [ ] Update `fixtures/research-documents` and its invalid siblings
- [ ] Extend `scripts/test-research-documents-profile.sh` with `--strict`
- [ ] Add invalid fixtures covering the new v0.2 rules for each profile
- [ ] Record in this plan whether the blueprint override was folded upstream
- [ ] Re-run every script and confirm all pass
- [ ] Commit with the required git trailers


## Surprises & Discoveries

(None yet.)


## Decision Log

- Decision: Fold the `adopt-architecture-decisions` blueprint's presence-class override
  upstream into `profiles/documentation/architecture-decisions.dhall`.
  Rationale: The blueprint ships
  `blueprints/adopt-architecture-decisions/files/architecture-decisions-profile.dhall`, which
  imports the shared profile and then reclassifies `supersedes`, `supersededBy`, and
  `originatingPlan` from `recommended` to `optional`. That override exists solely because the
  shipped profile is wrong: under `--strict` a recommended-and-absent field is an error, and
  essentially every real ADR corpus lacks all three (a live decision that has never been
  superseded has nothing to record). Verified locally — `okf validate fixtures/architecture-decisions --strict --profile … --profile-enforce`
  fails today on exactly those three fields. Fixing it upstream lets every adopter drop the
  override.
  Date: 2026-08-01

- Decision: Change `sources` in `patternCatalog` and `researchDocuments` from a bare list of
  text to the OKF v0.2 list-of-records shape.
  Rationale: Both profiles currently declare `sources` as `Cardinality.List` with no element
  rules, and the fixtures write it as a list of URI strings. OKF v0.2 §5.1 defines `sources`
  as a list of records whose `resource` member is required. Two different meanings for one key
  name is exactly the drift v0.2's provenance family exists to prevent, and the v0.2 shape is
  strictly richer — the existing URI becomes the entry's `resource`. This is breaking for a
  consumer corpus and is what the EP-6 migration blueprint carries.
  Date: 2026-08-01


## Outcomes & Retrospective

(To be filled during and after implementation.)


## Context and Orientation

### Where you are

The repository root is `/Users/shinzui/Keikaku/bokuno/okf-profiles`. Run every command from
there. Commit directly to `master`; do not create a branch.

There is no compiler and no package manager. "Type-check" means `dhall type --file <path>`.
"Test" means running a bash script under `scripts/`, each of which invokes the `okf` binary
against a fixture bundle under `fixtures/`. `okf --version` must report `v0.5.0.0` or later.

### Prerequisite

This plan hard-depends on
`docs/plans/2-ship-the-shared-okf-v0-2-field-family-module-and-the-okfv02-reference-profile.md`.
Confirm it landed:

```bash
test -f Profile/V02.dhall && dhall type --file Profile/V02.dhall > /dev/null && echo "EP-2 present"
```

If that file does not exist, stop: every profile edit below splices values from it, and
re-authoring them here would produce three descriptions of `generated` that drift apart.

Read `Profile/V02.dhall`'s header comment before you start. It states two house policies you
must apply here and cannot infer from the code.

Two sibling plans — `docs/plans/4-migrate-the-coordination-profiles-to-okf-v0-2.md` and
`docs/plans/5-migrate-the-postgresql-profiles-to-okf-v0-2.md` — may be running concurrently.
They touch disjoint files. **Do not edit `Profile/V02.dhall`, the root `package.dhall`,
`Profile/ReviewRule.dhall`, `profiles/coordination/*`, `profiles/postgresql.dhall`, or
`profiles/tan-postgresql.dhall`.** If you discover that `Profile/V02.dhall` is wrong, stop and
record it in the parent MasterPlan's Surprises & Discoveries section so the fix is propagated
to all three plans rather than forked.

### ADRs

`docs/adr/` does not exist in this repository and there is no local ADR corpus, so **no local
ADR applies to this work**. Creating that corpus is the job of
`docs/plans/7-release-okf-profiles-v0-8-0-and-dogfood-the-migrated-adr-profile.md`.

Two cross-repository decisions from `mori://shinzui/okf` bear on what you write:

- `docs/adr/7-okf-v0-1-legacy-fallback-policy.md` (artifact-level URI pending): okf reads
  `timestamp` whenever `generated` is absent, silently, with no removal horizon. This is why
  demoting `timestamp` to `optional` rather than deleting the rule keeps unmigrated corpora
  green.
- `docs/adr/10-okf-version-declaration-and-best-effort-reading.md` (artifact-level URI
  pending): a bundle's `okf_version` declaration is optional per specification §12, so okf
  itself never demands one. A profile may, through `requireBundleVersion`, which is what makes
  it a house convention rather than a format rule.

### The three profiles you are changing

**`profiles/documentation/architecture-decisions.dhall`** — `name = "architecture-decision-records"`,
one concept type `Architecture Decision Record`, stable `ADR-N` handles in the `docId` key,
`allowUnknownTypes = False`. Required today: `type`, `title`, `docId` (format
`DocumentHandle "ADR"`), `status` (free scalar, repository-native values such as `Accepted`),
`date` (calendar date, the original decision date), `description`, and `timestamp` (RFC3339
UTC). Recommended today: `supersedes` and `supersededBy` (both handle references with
`localPrefix = "ADR"` and `externalUriSchemes = [ "mori" ]`) and `originatingPlan`.

**`profiles/documentation/pattern-catalog.dhall`** — `name = "mori-documentation-pattern-catalog"`,
eight concept types (`Navigation`, `Overview`, `Standard`, `Guide`, `Pattern`, `Runbook`,
`Reference`, `Gotcha`), each with a `pathPattern` and `resourceScheme = Some "mori"`. Required
today: `type`, `title`, `description`, `timestamp`, `resource` (URI with scheme `mori`),
`tags` (list), `status` (`current` or `deprecated`). Recommended today: `sources` (bare list)
and `supersedes`. Note this profile writes its `frontmatter` as a **bare record literal**
rather than `FrontmatterRules::{…}` — it names all three lists explicitly. Either form works;
prefer converting it to the completion form while you are in there, since that is what the
other profiles use.

**`profiles/documentation/research-documents.dhall`** — `name = "research-documents"`, one
concept type `Research Document` with `pathPattern = Some "**"` and `RES-N` handles in
`researchId`. Required today: `type`, `title`, `description`, `timestamp`, `researchId`,
`status` (`active`/`complete`/`superseded`), `scope`, and a conditional `supersededBy` that
becomes required when `status` is `superseded`. Recommended today: the shared `reviewRule`
from `Profile/ReviewRule.dhall`, `sources` (bare list), `relatedPlans`, `relatedDecisions`,
and `supersedes`.

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

So each profile flips atomically: you cannot add `generated` (which carries the `actor`
format) without declaring `okfVersion = "0.2"`, and you cannot declare `"0.2"` while
`timestamp` sits in `required` or `recommended`. Do both halves in one edit and never leave a
profile in an intermediate state across a commit.

`Profile/V02.dhall` exports `legacyTimestamp` for the demoted rule; use it rather than
re-authoring the RFC3339 rule, so all three profiles demote identically.

### The trap that will bite you first

Every fixture bundle in this repository has **no `index.md` at any level** — confirmed by
search. Every migrated profile sets `requireBundleVersion = Some "0.2"`, and every
`scripts/test-*.sh` passes `--profile-enforce`. The moment you migrate a profile, its test
script fails with a diagnostic that names no concept at all:

```text
profile: bundle does not declare okf_version; this profile requires 0.2 or later
```

The fix is one command per bundle:

```bash
okf index fixtures/architecture-decisions --write --okf-version 0.2
```

It generates an `index.md` per directory, writes `okf_version: "0.2"` into the frontmatter of
the **root** one only, overwrites exactly what it generates, never deletes, and preserves an
existing declaration on a re-run. Do this for the valid bundle **and every invalid sibling
bundle**, because an invalid fixture must fail for the reason it was written for, not because
it lacks an index.

### The house `status` key stays as it is

All three of these profiles use `status` for a house lifecycle vocabulary that collides with
OKF v0.2 §5.4's `draft`/`stable`/`deprecated`. Per the policy recorded in `Profile/V02.dhall`
and in the parent MasterPlan's Decision Log, **the house key wins**: do not splice
`v02.status` or `v02.staleAfter` into any of these three profiles, and do not change any
existing `allowedValues` list. okf sanctions this — a profile key name does not imply the OKF
core key of that name — and the accepted consequence is that `okf trust` prints the house
value verbatim as a status it does not recognise.

### `reviews` and `verified` coexist

`profiles/documentation/research-documents.dhall` imports the shared `reviewRule` from
`Profile/ReviewRule.dhall`, a rich house review record. OKF `verified` records only `by` and
`at`. Neither is a superset. Keep `reviews` exactly as it is, add `v02.verified` to the
`optional` list, and say in the profile's `description` that an approving `reviews` entry
should be mirrored into `verified` so the derived trust tier is accurate. Do **not** edit
`Profile/ReviewRule.dhall` — a sibling plan uses it too.


## Plan of Work

Three milestones, one per profile. Each is independently verifiable: at the end of each, that
profile's test script passes under `--strict --profile-enforce` and the other two are
untouched. Commit at the end of each milestone.

Do the architecture-decision profile first. It is the smallest, it has the richest set of
existing invalid fixtures to learn the pattern from, and it is the one whose blueprint the
next plan extends.

### Milestone 1 — architecture decisions

Scope: `profiles/documentation/architecture-decisions.dhall`,
`fixtures/architecture-decisions/`, `fixtures/architecture-decisions-invalid/*`, and
`scripts/test-architecture-decisions-profile.sh`.

Make five changes to the profile, all in one edit:

1. Set `okfVersion = "0.2"`.
2. Set `requireBundleVersion = Some "0.2"`.
3. Remove the hand-written `timestamp` rule from `required` and add `v02.legacyTimestamp` to
   `optional`. Override its description if the generic wording reads oddly for an ADR.
4. Add `v02.generated` to `required`, and `v02.verified` to `optional`.
5. Move `supersedes`, `supersededBy`, and `originatingPlan` from `recommended` to `optional`,
   leaving their constraints — including the `ADR` handle-reference rules — exactly as they
   are. See the Decision Log for why; this is the fix that lets the blueprint drop its
   override.

Then bring the fixtures up. `fixtures/architecture-decisions/` has two concepts and a
`log.md`. Add `generated` to both concepts:

```yaml
generated:
  by: human:nadeem
  at: 2026-07-26T00:00:00Z
```

Reuse each document's existing `timestamp` value as the `at` — that is what `generated.at`
supersedes, and inventing a new instant would break the `--log-enforce` gate, which compares
each concept's date against the nearest enclosing `log.md` entry and now reads `generated.at`
in preference to `timestamp`. Keep the `timestamp` key on **one** of the two concepts and drop
it from the other, so the fixture proves both that the legacy key is still accepted and that
its absence is not reported.

Give one of the two a `verified` entry so the `recordOrList` shape is exercised somewhere in
this repository's own fixtures:

```yaml
verified:
  by: human:nadeem
  at: 2026-07-27T00:00:00Z
```

Then generate the index files for the valid bundle and every invalid sibling, and add two new
invalid fixtures under `fixtures/architecture-decisions-invalid/`:

- `bad-actor/` — a complete, otherwise-valid ADR whose `generated.by` is `nadeem`, matching
  none of the three actor shapes.
- `missing-generated/` — a complete, otherwise-valid ADR with no `generated` key at all.

Finally extend `scripts/test-architecture-decisions-profile.sh`: add `--strict` to the
accepting `okf validate` invocation, and add `bad-actor` and `missing-generated` to the
rejection loop. The script's shape is already right; you are adding one flag and two list
entries.

Adding `--strict` is the interesting part. It is what proves the migration did something: the
same command **fails today**, before your change, on `supersedes`, `supersededBy`, and
`originatingPlan`. Capture that failure before you edit anything so you can quote the
before-and-after in this plan's Outcomes section.

### Milestone 2 — pattern catalog

Scope: `profiles/documentation/pattern-catalog.dhall`,
`fixtures/documentation-pattern-catalog/`, `fixtures/documentation-pattern-catalog-invalid/`,
and `scripts/test-pattern-catalog-profile.sh`.

The same five changes as Milestone 1, minus the presence reclassification (this profile has no
provenance fields to reclassify), plus one shape change.

The shape change: `sources` is currently `FieldRule::{ field = "sources", cardinality = Cardinality.List }`
in the `recommended` list, and the fixture writes it as a list of bare `mori://` strings.
Replace it with `v02.sources`, which is the OKF v0.2 list-of-records shape, and move it to
`optional` — provenance whose absence is ordinary rather than deficient, and leaving it
`recommended` would fail every catalog document under `--strict`. Then rewrite the fixture
entries:

```yaml
sources:
  - id: runtime-source
    resource: mori://example/runtime
    title: The example runtime project
```

Note that `resource` is also a **top-level required key** in this profile, constrained to the
`mori` scheme. That is OKF §4.1's `resource` and is unrelated to `sources[].resource`; do not
conflate them and do not change it.

The existing single invalid fixture is `invalid-policy.md` sitting directly in
`fixtures/documentation-pattern-catalog-invalid/` rather than in a subdirectory — unlike every
other invalid fixture tree, which uses one directory per case. Leave that structure alone;
converting it is churn this plan does not need. Add the two new v0.2 cases as **sibling
directories** only if you first restructure, or more simply add them as additional bundles
under a new `fixtures/documentation-pattern-catalog-invalid-v02/` tree with `bad-actor/` and
`missing-generated/` subdirectories, and extend the script with a second loop. Pick one and
record which in this plan's Decision Log so the next reader is not confused by the
inconsistency.

The valid bundle has a `runtime/` subdirectory, so `okf index --write` generates two index
files. Only the root one carries the version declaration; that is correct and expected.

### Milestone 3 — research documents

Scope: `profiles/documentation/research-documents.dhall`, `fixtures/research-documents/`,
`fixtures/research-documents-invalid/*`, and `scripts/test-research-documents-profile.sh`.

The same five changes, plus the same `sources` shape change as Milestone 2 (this profile also
declares `sources` as a bare list and its fixture writes `- mori://example/runtime`), plus the
`reviews`/`verified` coexistence.

For coexistence: leave `reviewRule` in `recommended` where it is, add `v02.verified` to
`optional`, and extend the profile's top-level `description` to say that an approving
`reviews` entry should be mirrored into `verified`. The fixture already carries a model
review with `outcome: approved`; mirror it:

```yaml
verified:
  - by: example-agent
    at: 2026-07-28T17:05:00Z
```

Note `example-agent` alone does not match any actor shape. Write it as
`process:example-agent` or `example-agent/1.0` — this is exactly the kind of thing the actor
format is for, and getting it wrong in the fixture is a good sign the rule works.

Watch for one interaction. `supersedes` and `relatedPlans` and `relatedDecisions` are all
`recommended` and absent from the fixture, so adding `--strict` to this script will fail on
them the same way it fails on the ADR profile's three provenance fields. Apply the same
remedy: move `relatedPlans`, `relatedDecisions`, `supersedes`, and `sources` to `optional`.
`reviewRule` is a judgement call — the fixture does carry `reviews`, so leaving it
`recommended` is defensible and means a research corpus is nudged toward recording review
provenance. Leave it recommended, and record the reasoning in this plan's Decision Log.

Add `bad-actor/` and `missing-generated/` invalid fixtures and extend the rejection loop, as
in Milestone 1.


## Concrete Steps

All commands run from `/Users/shinzui/Keikaku/bokuno/okf-profiles`.

**Step 1 — verify prerequisites and capture the baseline.**

```bash
okf --version
test -f Profile/V02.dhall && echo "EP-2 present"
mkdir -p /tmp/ep3
for s in scripts/*.sh; do echo "--- $s"; bash "$s" 2>&1; done > /tmp/ep3/before.txt
tail -2 /tmp/ep3/before.txt
```

Every script must pass before you start.

**Step 2 — capture the strict failure you are about to fix.**

```bash
okf validate fixtures/architecture-decisions --strict \
  --profile profiles/documentation/architecture-decisions.dhall \
  --profile-enforce 2>&1 | tee /tmp/ep3/adr-strict-before.txt
```

Expected today — six advisories, exit code 1:

```text
profile: 0001-use-stable-identifiers: missing profile-recommended field: originatingPlan (Plan that produced the decision, when recorded.)
profile: 0001-use-stable-identifiers: missing profile-recommended field: supersededBy (Later ADR handle replacing this decision.)
profile: 0001-use-stable-identifiers: missing profile-recommended field: supersedes (Earlier ADR handles replaced by this decision.)
profile: 0002-keep-local-links: missing profile-recommended field: originatingPlan (Plan that produced the decision, when recorded.)
profile: 0002-keep-local-links: missing profile-recommended field: supersededBy (Later ADR handle replacing this decision.)
profile: 0002-keep-local-links: missing profile-recommended field: supersedes (Earlier ADR handles replaced by this decision.)
```

**Step 3 — edit `profiles/documentation/architecture-decisions.dhall`**, then check it
compiles inside okf, which is where the `okfVersion` rules are enforced:

```bash
dhall type --file profiles/documentation/architecture-decisions.dhall > /dev/null && echo "type-checks"
okf profile show --registry ./package.dhall documentation.architectureDecisions 2>&1 | head -30
```

If you see `Failed to load profile: invalid profile definition:` followed by a line about
`okfVersion 0.2 supersedes the frontmatter key timestamp`, the demoted rule is still in
`required` or `recommended`; move it to `optional`.

**Step 4 — update the fixtures and generate indexes.**

```bash
okf index fixtures/architecture-decisions --write --okf-version 0.2
for d in fixtures/architecture-decisions-invalid/*/; do
  okf index "$d" --write --okf-version 0.2
done
cat fixtures/architecture-decisions/index.md
```

Expected head of the generated root index:

```text
---
okf_version: "0.2"
---
```

**Step 5 — validate the migrated bundle strictly.**

```bash
okf validate fixtures/architecture-decisions --strict \
  --profile profiles/documentation/architecture-decisions.dhall \
  --profile-enforce --log-enforce
```

Expected:

```text
OK: 2 concepts (okf_version 0.2)
```

with no `profile:` lines. The `(okf_version 0.2)` suffix is new and is how you know the
declaration took effect.

**Step 6 — confirm the new invalid fixtures reject for the right reason.** Run each without
`--profile-enforce` so you can read the advisory:

```bash
okf validate fixtures/architecture-decisions-invalid/bad-actor \
  --profile profiles/documentation/architecture-decisions.dhall
okf validate fixtures/architecture-decisions-invalid/missing-generated \
  --profile profiles/documentation/architecture-decisions.dhall
```

The first must name `generated.by` and the `actor` format; the second must name a missing
`generated` field. If either names something else, the fixture is broken in more ways than
intended — fix the fixture, do not loosen the profile.

**Step 7 — extend and run the script.**

```bash
bash scripts/test-architecture-decisions-profile.sh
```

Expected:

```text
OK: 2 concepts (okf_version 0.2)
OK: architecture-decision profile acceptance and rejection fixtures
```

**Step 8 — commit Milestone 1.**

```bash
git add profiles/documentation/architecture-decisions.dhall fixtures/architecture-decisions fixtures/architecture-decisions-invalid scripts/test-architecture-decisions-profile.sh
git commit -F - <<'MSG'
feat(documentation)!: move the architecture-decision profile to OKF v0.2

Declare okfVersion 0.2, require the generated provenance family with an
actor-checked by member, and demote timestamp to the optional list where
its RFC3339-UTC format is still checked but its absence never reported.
Require the bundle to declare okf_version 0.2 in its root index.

Reclassify supersedes, supersededBy, and originatingPlan from recommended
to optional. Under --strict a recommended-and-absent field is an error and
essentially every real ADR corpus lacks all three, which is why the
adopt-architecture-decisions blueprint shipped a consumer-side override.
That override is now unnecessary.

The acceptance fixture validates under --strict for the first time.

MasterPlan: docs/masterplans/1-bring-okf-profiles-to-okf-v0-2-and-ship-bundle-migrations.md
ExecPlan: docs/plans/3-migrate-the-documentation-profiles-to-okf-v0-2.md
MSG
```

**Steps 9 through 12 — repeat for the pattern catalog**, then **Steps 13 through 16 for
research documents**, following the same sequence: edit the profile, check it loads in okf,
update fixtures, generate indexes for the valid bundle and every invalid sibling, add the two
new invalid cases, extend the script with `--strict` and the new cases, run it, commit.

**Step 17 — final sweep.**

```bash
for s in scripts/*.sh; do echo "--- $s"; bash "$s" 2>&1 | tail -1; done
for f in Profile/*.dhall profiles/*.dhall profiles/*/*.dhall; do
  dhall type --file "$f" > /dev/null || echo "FAILED: $f"
done; echo "type-check sweep done"
git status --short
```

All scripts pass, no `FAILED:` lines, and `git status` shows nothing outside the three
profiles, their fixtures, and their scripts.


## Validation and Acceptance

**All three profiles compile inside okf with `okfVersion = "0.2"`.**
`okf profile show --registry ./package.dhall documentation.architectureDecisions` (and the
same for `documentation.patternCatalog` and `documentation.researchDocuments`) renders
without a `Failed to load profile` line and shows `generated` under required with its
`objectFields` members displayed.

**Each acceptance fixture validates under `--strict --profile-enforce`** and reports the
version declaration:

```text
OK: 2 concepts (okf_version 0.2)
```

This is the headline result. Before this plan, the ADR fixture fails that exact command with
six advisories, captured in `/tmp/ep3/adr-strict-before.txt`. Quote both in this plan's
Outcomes & Retrospective.

**The demoted `timestamp` rule behaves as intended.** Both ADR fixture concepts carry
`generated`, which is now required. One of them *also* carries `timestamp`, proving the
demoted rule still accepts and format-checks the key; the other has no `timestamp` at all,
proving its absence is never reported in any mode. Confirm the second concept's file genuinely
has no `timestamp` line:

```bash
grep -L '^timestamp:' fixtures/architecture-decisions/*.md
```

must list one of the two concept files.

**Every new invalid fixture rejects, for the right reason.** Six new bundles in total (two per
profile) each produce an advisory naming `generated` or `generated.by`, and each makes its
script's rejection loop pass.

**A bundle without the version declaration is now reported.** Prove `requireBundleVersion` is
live by temporarily removing the root index from a copy of a fixture:

```bash
cp -r fixtures/architecture-decisions /tmp/ep3/noindex && rm /tmp/ep3/noindex/index.md
okf validate /tmp/ep3/noindex --profile profiles/documentation/architecture-decisions.dhall
```

Expected:

```text
profile: bundle does not declare okf_version; this profile requires 0.2 or later
OK: 2 concepts
```

Then `rm -rf /tmp/ep3/noindex`.

**Nothing outside this plan's scope changed.** `git status --short` lists only files under
`profiles/documentation/`, `fixtures/architecture-decisions*`,
`fixtures/documentation-pattern-catalog*`, `fixtures/research-documents*`, `scripts/`, and
this plan file. In particular `Profile/V02.dhall`, `Profile/ReviewRule.dhall`, and the root
`package.dhall` are untouched.

**The other four scripts still pass**, proving the sibling plans' territory is undisturbed.


## Idempotence and Recovery

`okf index --write` is idempotent: it overwrites exactly the index files it generates, never
deletes, and preserves an existing `okf_version` declaration on a re-run. Running it twice on
the same bundle produces no diff.

`okf validate` and `dhall type` are read-only. Editing Dhall and Markdown is ordinary
authoring.

Commit at the end of each milestone. That gives three clean rollback points, and it means a
mistake in the pattern catalog cannot cost you the architecture-decision work. Before a
commit, recovery is `git checkout -- <paths>`; after, `git revert`.

The riskiest single step is the `sources` shape change in Milestones 2 and 3, because it
changes fixture YAML and the profile rule together. If the fixture and the rule disagree you
get a confusing nested-path advisory such as `missing profile-required field: sources[0].resource`.
Read the advisory's index — it names which list element is wrong — and fix the fixture.

If a `--strict` run produces a wall of failures you did not anticipate, do not start deleting
rules to make it green. Run without `--profile-enforce` first, read the advisories, and decide
per field whether it belongs in `optional` (absence is ordinary) or whether the fixture is
genuinely deficient. Record each such decision in this plan's Decision Log.


## Interfaces and Dependencies

**Hard dependency on EP-2**
(`docs/plans/2-ship-the-shared-okf-v0-2-field-family-module-and-the-okfv02-reference-profile.md`),
which owns `Profile/V02.dhall`. This plan consumes these names from it and must not redefine
them: `generated`, `verified`, `sources`, `legacyTimestamp`. It must **not** consume `status`
or `staleAfter` — see the house-`status` policy above.

**Soft dependency direction**: `docs/plans/4-migrate-the-coordination-profiles-to-okf-v0-2.md`
and `docs/plans/5-migrate-the-postgresql-profiles-to-okf-v0-2.md` are expected to follow the
pattern this plan establishes — fixture indexes, the `bad-actor` / `missing-generated` invalid
cases, and `--strict` in the script. If you deviate from that shape, say so in the parent
MasterPlan's Surprises & Discoveries so they can follow.

**`okf` 0.5.0.0 or later** and **`dhall` ≥ 1.42**.

**Files this plan owns for its duration** (no other plan may edit them):

```text
profiles/documentation/architecture-decisions.dhall
profiles/documentation/pattern-catalog.dhall
profiles/documentation/research-documents.dhall
fixtures/architecture-decisions/**
fixtures/architecture-decisions-invalid/**
fixtures/documentation-pattern-catalog/**
fixtures/documentation-pattern-catalog-invalid/**
fixtures/research-documents/**
fixtures/research-documents-invalid/**
scripts/test-architecture-decisions-profile.sh
scripts/test-pattern-catalog-profile.sh
scripts/test-research-documents-profile.sh
```

**Files this plan must not edit**: `Profile/V02.dhall`, `Profile/okf.dhall`,
`Profile/ReviewRule.dhall`, the root `package.dhall`,
`profiles/documentation/package.dhall` (no new exports here), anything under
`profiles/coordination/`, `profiles/postgresql.dhall`, `profiles/tan-postgresql.dhall`, and
anything under `blueprints/`.

**What EP-6 needs from this plan.**
`docs/plans/6-ship-seihou-blueprint-migrations-for-consumer-okf-bundles.md` writes migration
instructions for consumers, and it reads this plan's record of what changed. Two things it
needs you to state explicitly in Outcomes & Retrospective:

1. Whether the three provenance fields were reclassified upstream, so EP-6 knows whether
   `blueprints/adopt-architecture-decisions/files/architecture-decisions-profile.dhall` can
   drop its override.
2. The exact list of frontmatter changes a consumer corpus must make per profile — which key
   was added, which was demoted, which changed shape — because that list becomes the migration
   edge's prose.
