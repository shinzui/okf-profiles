---
id: 4
slug: migrate-the-coordination-profiles-to-okf-v0-2
title: "Migrate the coordination profiles to OKF v0.2"
kind: exec-plan
created_at: 2026-08-01T23:39:57Z
master_plan: "docs/masterplans/1-bring-okf-profiles-to-okf-v0-2-and-ship-bundle-migrations.md"
---

# Migrate the coordination profiles to OKF v0.2

This ExecPlan is a living document. The sections Progress, Surprises & Discoveries,
Decision Log, and Outcomes & Retrospective must be kept up to date as work proceeds.
If durable project context changes, update or create ADRs in docs/adr/ in the same change.


## Purpose / Big Picture

Two of this repository's seven published profiles coordinate work across repository
boundaries: `coordination.improvementRequests`, which models a request whose implementation
may span several projects, and `coordination.useCases`, which models a Jobs-to-be-Done use
case and the typed features that deliver it. Both are written for Open Knowledge Format v0.1.
Both demand the `timestamp` key that OKF v0.2 retired, and neither records who produced a
document — the question v0.2 exists to answer, because it assumes a corpus written and
maintained by agents.

After this plan, a team pinning either profile gets a check that every request and every use
case records its producer in the v0.2 `generated` family, with the producer's identity checked
against OKF's actor convention — so `human:nadeem` and `process:okf-authoring` pass and a bare
`nadeem` does not. Legacy corpora keep validating, because `timestamp` moves to the `optional`
presence class where its format is still checked but its absence is never reported. And both
profiles now require the bundle to declare which dialect it targets, so a half-migrated corpus
becomes visible instead of silently opting out of every v0.2 check.

You can see it working by running `bash scripts/test-improvement-requests-profile.sh` and
`bash scripts/test-use-cases-profile.sh`, which after this plan run under `--strict` — a flag
no script in this repository passes today.


## Progress

- [ ] Confirm EP-2 has landed and `Profile/V02.dhall` exists
- [ ] Read EP-3's Outcomes section for the established fixture and script pattern
- [ ] Record the baseline: run all scripts and save the output
- [ ] Migrate `profiles/coordination/improvement-requests.dhall`
- [ ] Update `fixtures/improvement-requests` and its invalid siblings
- [ ] Add `bad-actor` and `missing-generated` invalid fixtures for improvement requests
- [ ] Extend `scripts/test-improvement-requests-profile.sh` with `--strict`
- [ ] Migrate `profiles/coordination/use-cases.dhall`
- [ ] Update `fixtures/use-cases` and its invalid siblings
- [ ] Add `bad-actor` and `missing-generated` invalid fixtures for use cases
- [ ] Extend `scripts/test-use-cases-profile.sh` with `--strict`
- [ ] Decide and record the presence class of each currently-recommended field
- [ ] Re-run every script and confirm all pass
- [ ] Commit with the required git trailers


## Surprises & Discoveries

(None yet.)


## Decision Log

- Decision: Add `v02.verified` to both profiles' `optional` lists while leaving the shared
  `reviewRule` exactly as it is.
  Rationale: `Profile/ReviewRule.dhall` records reviewer identity, review scope, outcome,
  serving provider, model identifier, reasoning effort, and evidence context. OKF `verified`
  records `by` and `at`. Neither is a superset of the other, so replacing one with the other
  loses information. Declaring both lets `okf trust` derive an accurate tier while the house
  record keeps the detail a coordination corpus actually needs.
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

Read `Profile/V02.dhall`'s header comment before you start. It states two house policies you
must apply and cannot infer from the code.

This plan also carries a **soft** dependency on
`docs/plans/3-migrate-the-documentation-profiles-to-okf-v0-2.md`. That plan migrates three
profiles first and, in doing so, establishes the pattern for adding fixture index files,
naming the new invalid fixtures, and extending a test script with `--strict`. If EP-3 is
complete, read its Outcomes & Retrospective section and copy what it did. If EP-3 is not
complete, proceed anyway — nothing here depends on its output — and record in the parent
MasterPlan's Surprises & Discoveries that you went first, so EP-3 follows *your* pattern.

Two sibling plans may be running concurrently on disjoint files. **Do not edit
`Profile/V02.dhall`, `Profile/ReviewRule.dhall`, the root `package.dhall`, anything under
`profiles/documentation/`, `profiles/postgresql.dhall`, or `profiles/tan-postgresql.dhall`.**
`Profile/ReviewRule.dhall` in particular is shared with `documentation.researchDocuments`; if
you believe it needs changing, stop and record it in the MasterPlan rather than editing it.

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
  never demands one. A profile may, through `requireBundleVersion`.

### The two profiles you are changing

**`profiles/coordination/improvement-requests.dhall`** — `name = "cross-repository-improvement-requests"`,
one concept type `Improvement Request` at `pathPattern = Some "*"`, stable `IR-N` handles in
the `requestId` key, `allowUnknownTypes = False`. Required today: `type`, `title`,
`description`, `timestamp` (RFC3339 UTC), `requestId` (format `DocumentHandle "IR"`), `status`
(closed vocabulary `proposed`/`accepted`/`in-progress`/`completed`/`rejected`/`withdrawn`/`superseded`),
`origin` (URI with scheme `mori`), plus two **conditional** rules: `completedAt` becomes
required when `status` is `completed`, and `supersededBy` becomes required when `status` is
`superseded`. Recommended today: the shared `reviewRule`, `targetPlan`, and a conditional
`resolution` that applies when `status` is one of the four terminal values.

A conditional rule is expressed as `when = Some { field = "status", hasValue = [ … ] }`. The
file declares a local `condition` helper for this. Now that EP-1 exports `FieldCondition` from
the root `package.dhall`, you may replace the helper with the exported type — but that is
optional tidying, not part of the migration, and if you do it, do it in a separate commit so
the migration diff stays readable.

**`profiles/coordination/use-cases.dhall`** — `name = "jtbd-use-cases"`, two concept types
(`Use Case` at `pathPattern = Some "*"` with `UC-N` handles in `useCaseId`, and
`Use Case Theme` at `themes/*`), `allowUnknownTypes = False`. Profile-wide required today:
`type`, `title`, `description`, `timestamp`. Profile-wide recommended: the shared `reviewRule`.
Profile-wide optional: `tags`, `links`. The `Use Case` type rule adds its own required list —
`useCaseId`, `status`, `origin`, and two large nested-record rules, `jobs` and `features` —
plus a recommended `themes` and optional `improvementRequests` and `relatedUseCases`.

Presence rules at profile scope and type scope **accumulate**: a type rule can narrow what the
profile demands but never silently weaken it. So moving a key out of the profile-wide
`recommended` list is the only way to stop demanding it, and doing so does not affect any type
rule's own lists.

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

A Dhall type-check cannot catch this — okf enforces it when it *loads* the profile. That is
why every verification step below uses `okf profile show` or `okf validate` rather than
`dhall type` alone.

`Profile/V02.dhall` exports `legacyTimestamp` for the demoted rule; use it rather than
re-authoring the RFC3339 rule.

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
okf index fixtures/improvement-requests --write --okf-version 0.2
```

It generates an `index.md` per directory, writes `okf_version: "0.2"` into the frontmatter of
the **root** one only, overwrites exactly what it generates, never deletes, and preserves an
existing declaration on a re-run. Do this for the valid bundle **and every invalid sibling
bundle**, so an invalid fixture fails for the reason it was written for rather than for a
missing index.

Note that `fixtures/improvement-requests-invalid/empty-reviews/` and
`fixtures/improvement-requests-invalid/missing-reviews/` are **empty directories** on disk —
they contain no files at all. They are *not* named in
`scripts/test-improvement-requests-profile.sh`'s rejection loop, which lists `missing-id`,
`wrong-prefix`, `duplicate-id`, `missing-required`, `unknown-type`, `nested-path`,
`invalid-policy`, `missing-completed-at`, and `missing-superseded-by`. So they are inert
leftovers. Leave them alone: do not delete them, do not populate them, and skip them when
generating indexes. Do not add to the empty-directory pattern with your own new fixtures.

### The house `status` key stays as it is

Both profiles use `status` for a house lifecycle vocabulary that collides with OKF v0.2
§5.4's `draft`/`stable`/`deprecated`. Per the policy recorded in `Profile/V02.dhall` and in
the parent MasterPlan's Decision Log, **the house key wins**: do not splice `v02.status` or
`v02.staleAfter` into either profile, and do not change any existing `allowedValues` list.
okf sanctions this — a profile key name does not imply the OKF core key of that name — and
the accepted consequence is that `okf trust` prints the house value verbatim as a status it
does not recognise.

Note the near-miss in `use-cases.dhall`: its `Use Case` type rule already allows `draft` as a
status value, alongside `validated`, `planned`, `in-progress`, `delivered`, and `retired`.
That overlap is coincidental. Do not read it as partial OKF conformance and do not extend the
vocabulary toward OKF's.

### `reviews` and `verified` coexist

Both profiles import the shared `reviewRule` from `Profile/ReviewRule.dhall`. Keep it exactly
as it is, add `v02.verified` to each profile's `optional` list, and extend each profile's
top-level `description` to say that an approving `reviews` entry should be mirrored into
`verified` so the derived trust tier is accurate. Do **not** edit `Profile/ReviewRule.dhall`.


## Plan of Work

Two milestones, one per profile, each independently verifiable through its own test script.
Commit at the end of each.

Do the improvement-request profile first: it is the simpler of the two, and its conditional
rules make it the better place to discover any interaction between `when` conditions and the
new presence classes before you meet the much larger use-case profile.

### Milestone 1 — improvement requests

Scope: `profiles/coordination/improvement-requests.dhall`, `fixtures/improvement-requests/`,
`fixtures/improvement-requests-invalid/*`, and `scripts/test-improvement-requests-profile.sh`.

Make these changes to the profile, all in one edit:

1. Set `okfVersion = "0.2"`.
2. Set `requireBundleVersion = Some "0.2"`.
3. Remove the hand-written `timestamp` rule from `required` and add `v02.legacyTimestamp` to
   `optional`.
4. Add `v02.generated` to `required` and `v02.verified` to `optional`.
5. Decide the presence class of every field currently in `recommended`, because adding
   `--strict` to the script turns each absent recommended field into an error. `targetPlan` is
   provenance whose absence is ordinary — a request that has not yet been planned has no
   target plan — so move it to `optional`. `resolution` is already conditional on a terminal
   status; leaving it `recommended` means a *completed* request without a resolution is
   reported under `--strict`, which is a useful check, so leave it. `reviewRule` is a
   judgement call: leaving it `recommended` nudges a coordination corpus toward recording
   review provenance, and the fixture does not currently carry `reviews` — so either move it
   to `optional` or add `reviews` to the fixture. Prefer adding it to the fixture, since the
   research-document fixture already demonstrates the shape and a coordination corpus benefits
   from the same nudge. Record whichever you choose, and why, in this plan's Decision Log.
6. Extend the profile `description` with the `reviews`/`verified` mirroring note.

Then bring the fixtures up. `fixtures/improvement-requests/` has two concepts and a `log.md`.
Add `generated` to both, reusing each document's existing `timestamp` value as the `at` — that
is what `generated.at` supersedes, and inventing a new instant would break any log-coverage
check, which now reads `generated.at` in preference to `timestamp`:

```yaml
generated:
  by: human:nadeem
  at: 2026-07-26T00:00:00Z
```

Note the existing fixtures quote their timestamps (`timestamp: "2026-07-26T00:00:00Z"`).
Quoting is fine for a timestamp — it is text either way. Keep `timestamp` on one of the two
concepts and drop it from the other, so the fixture proves both that the legacy key is still
accepted and that its absence is not reported.

Give one concept a `verified` entry, using the bare-mapping spelling so the `recordOrList`
shape is exercised:

```yaml
verified:
  by: human:nadeem
  at: 2026-07-27T00:00:00Z
```

Generate index files for the valid bundle and every non-empty invalid sibling, then add two
new invalid fixtures under `fixtures/improvement-requests-invalid/`:

- `bad-actor/` — an otherwise-valid request whose `generated.by` is `nadeem`, matching none of
  the three actor shapes.
- `missing-generated/` — an otherwise-valid request with no `generated` key.

Finally extend the script: add `--strict` to the accepting `okf validate` invocation and add
the two new names to the rejection loop.

### Milestone 2 — use cases

Scope: `profiles/coordination/use-cases.dhall`, `fixtures/use-cases/`,
`fixtures/use-cases-invalid/*`, and `scripts/test-use-cases-profile.sh`.

The same six changes as Milestone 1. Three additional things to watch, all consequences of
this being the larger profile:

**Profile-scope versus type-scope.** Put `v02.generated` in the **profile-wide** required
list, not inside the `Use Case` type rule. Both concept types — `Use Case` and
`Use Case Theme` — should record their producer, and a theme concept is a document like any
other. Similarly `v02.verified` and `v02.legacyTimestamp` go in the profile-wide lists.

**The `themes` recommendation.** The `Use Case` type rule declares `themes` as recommended.
The fixture carries it, so `--strict` should pass. Verify rather than assume: run the strict
command before you edit anything and note what it reports.

**The theme fixture.** `fixtures/use-cases/` holds two concepts:
`001-investigate-alert.md` at the root and `themes/operations.md` in a subdirectory. The
theme concept needs `generated` too — it is a document like any other, and the profile-wide
required list applies to both types. Because there is a subdirectory, `okf index --write`
generates two index files; only the root one carries the version declaration, which is
correct.

The existing invalid fixtures are `missing-jobs`, `invalid-feature-status`,
`invalid-owner-uri`, `invalid-request-uri`, and `duplicate-id`. Add `bad-actor` and
`missing-generated` alongside them and extend the loop.


## Concrete Steps

All commands run from `/Users/shinzui/Keikaku/bokuno/okf-profiles`.

**Step 1 — verify prerequisites and capture the baseline.**

```bash
okf --version
test -f Profile/V02.dhall && echo "EP-2 present"
mkdir -p /tmp/ep4
for s in scripts/*.sh; do echo "--- $s"; bash "$s" 2>&1; done > /tmp/ep4/before.txt
grep -c '^OK:' /tmp/ep4/before.txt
```

Every script must pass before you start.

**Step 2 — capture what `--strict` reports today**, so you know which failures you inherited
rather than caused:

```bash
okf validate fixtures/improvement-requests --strict \
  --profile profiles/coordination/improvement-requests.dhall \
  --profile-enforce 2>&1 | tee /tmp/ep4/ir-strict-before.txt
okf validate fixtures/use-cases --strict \
  --profile profiles/coordination/use-cases.dhall \
  --profile-enforce 2>&1 | tee /tmp/ep4/uc-strict-before.txt
```

Read both files. Each `missing profile-recommended field:` line is a decision you must make in
step 5 of the milestone: move the field to `optional`, or add it to the fixture.

**Step 3 — read the script you are about to change**, so you know exactly what its rejection
loop currently lists:

```bash
cat scripts/test-improvement-requests-profile.sh
```

**Step 4 — edit `profiles/coordination/improvement-requests.dhall`**, then check it compiles
inside okf, which is where the `okfVersion` rules are enforced:

```bash
dhall type --file profiles/coordination/improvement-requests.dhall > /dev/null && echo "type-checks"
okf profile show --registry ./package.dhall coordination.improvementRequests 2>&1 | head -40
```

If you see `Failed to load profile: invalid profile definition:` followed by a line about
`okfVersion 0.2 supersedes the frontmatter key timestamp`, the demoted rule is still in
`required` or `recommended`; move it to `optional`.

**Step 5 — update the fixtures and generate indexes.**

```bash
okf index fixtures/improvement-requests --write --okf-version 0.2
for d in fixtures/improvement-requests-invalid/*/; do
  [ -n "$(ls -A "$d" 2>/dev/null)" ] && okf index "$d" --write --okf-version 0.2
done
head -3 fixtures/improvement-requests/index.md
```

Expected head of the generated root index:

```text
---
okf_version: "0.2"
---
```

**Step 6 — validate the migrated bundle strictly.**

```bash
okf validate fixtures/improvement-requests --strict \
  --profile profiles/coordination/improvement-requests.dhall \
  --profile-enforce
```

Expected:

```text
OK: 2 concepts (okf_version 0.2)
```

with no `profile:` lines. The `(okf_version 0.2)` suffix is new and is how you know the
declaration took effect.

**Step 7 — confirm the new invalid fixtures reject for the right reason.** Run each without
`--profile-enforce` so you can read the advisory:

```bash
okf validate fixtures/improvement-requests-invalid/bad-actor \
  --profile profiles/coordination/improvement-requests.dhall
okf validate fixtures/improvement-requests-invalid/missing-generated \
  --profile profiles/coordination/improvement-requests.dhall
```

The first must name `generated.by` and the `actor` format; the second must name a missing
`generated` field. If either names something else, the fixture is broken in more ways than
intended — fix the fixture, do not loosen the profile.

**Step 8 — extend and run the script.**

```bash
bash scripts/test-improvement-requests-profile.sh
```

Expected:

```text
OK: 2 concepts (okf_version 0.2)
OK: improvement-request profile acceptance and rejection fixtures
```

**Step 9 — commit Milestone 1.**

```bash
git add profiles/coordination/improvement-requests.dhall fixtures/improvement-requests fixtures/improvement-requests-invalid scripts/test-improvement-requests-profile.sh
git commit -F - <<'MSG'
feat(coordination)!: move the improvement-request profile to OKF v0.2

Declare okfVersion 0.2, require the generated provenance family with an
actor-checked by member, and demote timestamp to the optional list where
its RFC3339-UTC format is still checked but its absence never reported.
Require the bundle to declare okf_version 0.2 in its root index.

Declare OKF verified alongside the house reviews family rather than in
place of it: reviews carries scope, outcome, provider, model, and effort
that verified cannot, and verified is what okf derives a trust tier from.

The acceptance fixture validates under --strict for the first time.

MasterPlan: docs/masterplans/1-bring-okf-profiles-to-okf-v0-2-and-ship-bundle-migrations.md
ExecPlan: docs/plans/4-migrate-the-coordination-profiles-to-okf-v0-2.md
MSG
```

**Steps 10 through 16 — repeat for use cases**, following the same sequence: read the script,
edit the profile, check it loads in okf with `okf profile show --registry ./package.dhall coordination.useCases`,
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

All scripts pass, no `FAILED:` lines, and `git status` shows nothing outside the two
coordination profiles, their fixtures, and their scripts.


## Validation and Acceptance

**Both profiles compile inside okf with `okfVersion = "0.2"`.**
`okf profile show --registry ./package.dhall coordination.improvementRequests` and
`… coordination.useCases` each render without a `Failed to load profile` line and show
`generated` under required with its `objectFields` members displayed.

**Each acceptance fixture validates under `--strict --profile-enforce`** and reports the
version declaration:

```text
OK: 2 concepts (okf_version 0.2)
```

Compare against `/tmp/ep4/ir-strict-before.txt` and `/tmp/ep4/uc-strict-before.txt` and quote
the before-and-after in this plan's Outcomes & Retrospective.

**The demoted `timestamp` rule behaves as intended.** Both improvement-request fixture
concepts carry `generated`; one *also* carries `timestamp`, proving the demoted rule still
accepts and format-checks the key, and the other has no `timestamp` at all, proving its
absence is never reported in any mode:

```bash
grep -L '^timestamp:' fixtures/improvement-requests/*.md
```

must list one of the two concept files (excluding `log.md` and `index.md`, which are reserved
and carry no concept frontmatter).

**The conditional rules still fire.** The pre-existing invalid fixtures
`missing-completed-at` and `missing-superseded-by` must still be rejected. This is the check
that proves adding `okfVersion = "0.2"` did not disturb the `when` conditions:

```bash
okf validate fixtures/improvement-requests-invalid/missing-completed-at \
  --profile profiles/coordination/improvement-requests.dhall
```

must still report the missing `completedAt`.

**Every new invalid fixture rejects, for the right reason.** Four new bundles in total (two per
profile) each produce an advisory naming `generated` or `generated.by`, and each makes its
script's rejection loop pass.

**A bundle without the version declaration is now reported.** Prove `requireBundleVersion` is
live:

```bash
cp -r fixtures/use-cases /tmp/ep4/noindex && rm /tmp/ep4/noindex/index.md
okf validate /tmp/ep4/noindex --profile profiles/coordination/use-cases.dhall
```

Expected:

```text
profile: bundle does not declare okf_version; this profile requires 0.2 or later
OK: 2 concepts
```

Then `rm -rf /tmp/ep4/noindex`.

**Nothing outside this plan's scope changed.** `git status --short` lists only files under
`profiles/coordination/`, `fixtures/improvement-requests*`, `fixtures/use-cases*`, `scripts/`,
and this plan file. In particular `Profile/V02.dhall`, `Profile/ReviewRule.dhall`, and the root
`package.dhall` are untouched.

**The other five scripts still pass**, proving the sibling plans' territory is undisturbed.


## Idempotence and Recovery

`okf index --write` is idempotent: it overwrites exactly the index files it generates, never
deletes, and preserves an existing `okf_version` declaration on a re-run. Running it twice on
the same bundle produces no diff.

`okf validate`, `okf profile show`, and `dhall type` are read-only. Editing Dhall and Markdown
is ordinary authoring.

Commit at the end of each milestone. That gives two clean rollback points and means a mistake
in the large use-case profile cannot cost you the improvement-request work. Before a commit,
recovery is `git checkout -- <paths>`; after, `git revert`.

The riskiest step is deciding presence classes in step 5 of each milestone, because it is the
one place where a wrong choice makes a profile permanently weaker rather than merely broken.
If a `--strict` run produces failures you did not anticipate, do not delete rules to make it
green. Run without `--profile-enforce` first, read the advisories, and decide per field whether
its absence is *ordinary* (move to `optional`) or *deficient* (fix the fixture). Record each
such decision in this plan's Decision Log with the reasoning, because EP-6 turns those
decisions into consumer-facing migration instructions.

If `okf index --write` misbehaves on the two empty invalid-fixture directories, skip them:
they contain no concepts, so no profile check reaches them, and their presence in a rejection
loop (if any) is pre-existing behaviour this plan does not own.


## Interfaces and Dependencies

**Hard dependency on EP-2**
(`docs/plans/2-ship-the-shared-okf-v0-2-field-family-module-and-the-okfv02-reference-profile.md`),
which owns `Profile/V02.dhall`. This plan consumes these names from it and must not redefine
them: `generated`, `verified`, `legacyTimestamp`. It must **not** consume `status` or
`staleAfter` — see the house-`status` policy above. It does not need `sources` or
`usageWindow`, because neither coordination profile records document-level provenance sources
today and inventing that convention is out of scope.

**Soft dependency on EP-3**
(`docs/plans/3-migrate-the-documentation-profiles-to-okf-v0-2.md`), for the established
pattern only. Read its Outcomes & Retrospective if it is complete; proceed without it if not.

**`okf` 0.5.0.0 or later** and **`dhall` ≥ 1.42**.

**Files this plan owns for its duration** (no other plan may edit them):

```text
profiles/coordination/improvement-requests.dhall
profiles/coordination/use-cases.dhall
fixtures/improvement-requests/**
fixtures/improvement-requests-invalid/**
fixtures/use-cases/**
fixtures/use-cases-invalid/**
scripts/test-improvement-requests-profile.sh
scripts/test-use-cases-profile.sh
```

**Files this plan must not edit**: `Profile/V02.dhall`, `Profile/okf.dhall`,
`Profile/ReviewRule.dhall`, the root `package.dhall`, `profiles/coordination/package.dhall`
(no new exports here), anything under `profiles/documentation/`, `profiles/postgresql.dhall`,
`profiles/tan-postgresql.dhall`, and anything under `blueprints/`.

**What EP-6 needs from this plan.**
`docs/plans/6-ship-seihou-blueprint-migrations-for-consumer-okf-bundles.md` writes migration
instructions for consumers and reads this plan's record of what changed. State explicitly in
Outcomes & Retrospective, for each of the two profiles, the exact list of frontmatter changes
a consumer corpus must make: which key was added, which was demoted, which fields moved
presence class, and any field whose absence now fails under `--strict` that did not before.
That list becomes the migration blueprint's prose.
