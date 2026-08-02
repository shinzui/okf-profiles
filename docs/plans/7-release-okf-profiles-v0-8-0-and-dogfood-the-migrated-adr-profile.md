---
id: 7
slug: release-okf-profiles-v0-8-0-and-dogfood-the-migrated-adr-profile
title: "Release okf-profiles v0.8.0 and dogfood the migrated ADR profile"
kind: exec-plan
created_at: 2026-08-01T23:39:57Z
master_plan: "docs/masterplans/1-bring-okf-profiles-to-okf-v0-2-and-ship-bundle-migrations.md"
---

# Release okf-profiles v0.8.0 and dogfood the migrated ADR profile

This ExecPlan is a living document. The sections Progress, Surprises & Discoveries,
Decision Log, and Outcomes & Retrospective must be kept up to date as work proceeds.
If durable project context changes, update or create ADRs in docs/adr/ in the same change.


## Purpose / Big Picture

Six plans before this one moved every profile in this catalog to Open Knowledge Format v0.2
and built two Seihou blueprints so consumers can migrate their own bundles. None of that is
reachable by a consumer yet. This repository is imported by pinned URL — a downstream project
writes

```dhall
https://raw.githubusercontent.com/shinzui/okf-profiles/v0.8.0/package.dhall
  sha256:…
```

— and that URL resolves nothing until a `v0.8.0` tag exists. The README still describes a
catalog written for okf 0.4.0.0 and v0.1 rules. `mori.dhall` and `seihou-registry.dhall`
disagree with each other about the blueprint version, and neither knows the new blueprint
exists. And two blueprint files ship a `v0.8.0` pinned import whose integrity hash is a
placeholder, because the tag they point at did not exist when they were written.

This plan closes all of that, and does one more thing that matters more than the paperwork:
**it makes this repository use its own architecture-decision profile.** Today
`okf-profiles` publishes the profile that other repositories use to govern their decision
records, and has no decision records of its own — no `docs/adr/` directory at all. Every
durable judgement made across this initiative lives only in plan files that will be archived.
Turning `docs/adr/` into a profile-governed OKF bundle fixes that, and proves the migrated
profile works against a real corpus written by someone who was not looking at the profile
while writing it.

After this plan a consumer can pin `v0.8.0`, get a catalog whose README truthfully describes
it, install either blueprint by name, and read why each design decision was made.


## Progress

- [ ] Confirm EP-6 is complete and read its Outcomes section
- [ ] Collect the placeholder-hash file list from EP-6's Outcomes
- [ ] Create `docs/adr/` as a profile-governed OKF bundle
- [ ] Write the initiative's ADRs and allocate their `ADR-N` handles
- [ ] Add `scripts/test-adr-bundle.sh` wiring the ADR bundle into the checks
- [ ] Rewrite the README's Compatibility and Schema evolution sections
- [ ] Update the README's Profile catalog table, including a v0.2 column
- [ ] Update the README's Validating this repo section with every script
- [ ] Document the two blueprints in the README
- [ ] Reconcile `mori.dhall` and `seihou-registry.dhall` blueprint versions
- [ ] Register the new blueprint in both files
- [ ] Add `DocRef` entries for the new documentation
- [ ] Add a bundle declaration for `docs/adr` to `mori.dhall`
- [ ] Write the v0.8.0 release notes
- [ ] Run the full check sweep
- [ ] Cut the `v0.8.0` tag and push it
- [ ] Freeze every placeholder hash against the real tag
- [ ] Verify a pinned remote import resolves end to end
- [ ] Distil the initiative's ADRs and close the MasterPlan


## Surprises & Discoveries

(None yet.)


## Decision Log

- Decision: Create `docs/adr/` as a profile-governed OKF bundle rather than as plain Markdown.
  Rationale: This repository publishes the architecture-decision profile. A publisher whose own
  decisions are not governed by its own profile has no evidence the profile is usable, and the
  shared `agents/skills/exec-plan/ADR.md` contract that every plan in this repository follows
  is written around a profiled bundle. Dogfooding also gives the catalog a real corpus to
  regression-test the profile against, which the two-concept `fixtures/architecture-decisions`
  bundle does not.
  Date: 2026-08-01

- Decision: Tag `v0.8.0`.
  Rationale: The current tag is v0.7.0. Moving the schema pin, promoting `generated` to
  required on five profiles, and changing the `sources` value shape on two of them are all
  breaking for a consumer corpus. This repository's README already treats any change to the
  schema types under `Profile/` as breaking. The blueprints are versioned in lockstep with the
  catalog tag, because that tag is the only version a consumer can read off their own
  repository.
  Date: 2026-08-01


## Outcomes & Retrospective

(To be filled during and after implementation.)


## Context and Orientation

### Where you are

The repository root is `/Users/shinzui/Keikaku/bokuno/okf-profiles`. Run every command from
there. Commit directly to `master`; do not create a branch. `okf --version` must report
`v0.5.0.0` or later, `seihou --version` `v0.6.0.0` or later, and `dhall --version` `1.42` or
later.

### Prerequisites

This plan hard-depends on
`docs/plans/6-ship-seihou-blueprint-migrations-for-consumer-okf-bundles.md`, which in turn
depends on the three migration plans. Confirm the whole chain from the parent MasterPlan's
Exec-Plan Registry, and then directly:

```bash
for s in scripts/*.sh; do bash "$s" >/dev/null 2>&1 || echo "FAILING: $s"; done; echo "scripts checked"
seihou validate-blueprint blueprints/adopt-architecture-decisions --lint
seihou validate-blueprint blueprints/migrate-okf-bundles-to-v0-2 --lint
```

**Read EP-6's Outcomes & Retrospective section before doing anything.** It records three things
this plan needs and cannot derive: the new blueprint's exact `name`, `version`, `description`,
and `tags`; the full list of files shipping a `v0.8.0` pinned import with a placeholder hash;
and whether the ADR blueprint's shipped descriptor still carries its presence-class override.
The second of those is load-bearing — missing a file there ships a blueprint that cannot
resolve its own descriptor.

Also read the three migration plans' Outcomes sections. The README's catalog table needs a
truthful per-profile summary, and those plans recorded what each profile now demands.

### The ADR contract this repository follows

`agents/skills/exec-plan/ADR.md` is the shared operational contract for decision records in
this repository, installed as a dependency of the exec-plan skill. Read it in full before
creating `docs/adr/`. Its requirements, summarized so you know what you are aiming at:

A profiled ADR bundle holds one decision per Markdown file at the bundle root — the profile is
deliberately flat, so no subdirectories of decisions. `index.md` and `log.md` are reserved OKF
files and are not concepts. Each decision's frontmatter carries `type`
(`Architecture Decision Record`), `title`, `docId`, `status`, `date`, and `description`, plus —
after this initiative — the v0.2 `generated` family. The stable handle is a unique, positive,
**unpadded** `ADR-N`: `ADR-7`, never `ADR-007`.

Handles are allocated by asking okf, never by counting files:

```bash
okf id list docs/adr --profile docs/adr/profile.dhall
okf id next docs/adr --profile docs/adr/profile.dhall ADR
```

Do not fill a numbering gap, recycle a retired handle, or guess from a filename. Within this
repository, cite a decision by repository-relative Markdown link; across repositories, use the
exact handle-form Mori URI.

The contract also says the check to run after creating or changing ADRs:

```bash
okf validate docs/adr --strict --profile docs/adr/profile.dhall --profile-enforce --log-enforce
```

### What `docs/adr/profile.dhall` should import

Every other repository installs the ADR descriptor as a pinned remote import of this package.
This repository is that package, so a remote import would be circular and would pin the
previous release. Import by **relative path** instead:

```dhall
let Profiles = ../../package.dhall

in  Profiles.documentation.architectureDecisions
```

That is the correct form here and only here, and the file's doc comment must say why, so a
future reader does not "fix" it into a remote pin. It also means this repository's ADR bundle
validates against the *working tree's* profile rather than a released one — which is exactly
what makes it a regression test.

### The two registry files that disagree

`seihou-registry.dhall` declares the blueprint catalog that `seihou install` reads. It lists
`adopt-architecture-decisions` at version `0.7.0`.

`mori.dhall` declares this project to Mori: identity, packages, dependencies, docs, and a
`templates` list of Seihou templates. It lists the same blueprint at version `0.1.3`.

These disagree, and the blueprint's own README settles it: "Bump the blueprint `version` in
both `blueprint.dhall` and `seihou-registry.dhall` to match the `okf-profiles` tag. The
blueprint version is deliberately aligned with the profile tag, because that tag is the only
version a consumer can read off their own repository." So `0.7.0` was right, `mori.dhall`'s
`0.1.3` is stale, and both become `0.8.0`.

`mori.dhall` also carries a `docs` list of `DocRef` entries. Today it has two: the README and
the ADR blueprint's README. It needs entries for the new blueprint's README and — if you write
one — the release notes. And it currently declares **no bundles**, which is why
`mori registry show shinzui/okf-profiles` reports none; adding a bundle declaration for
`docs/adr` is what makes this repository's decisions addressable as
`mori://shinzui/okf-profiles/okf/adrs/concepts/ADR-N` from other repositories.

Read the file before editing; the schema is a pinned remote import of `shinzui/mori-schema`,
and a field you invent will fail to type-check.

### What the README currently gets wrong

`README.md` is roughly 450 lines. Four sections are now false:

- **Compatibility** says "The `okfVersion` field declares the OKF spec version a profile
  targets (currently `"0.1"`)" and "The schema is pinned to the `okf` 0.4.0.0 release commit.
  Every profile in this checkout uses 0.4 rules … so the catalog must be decoded with okf-core
  0.4.0.0 or later." EP-1 updated the version numbers in that paragraph; the `okfVersion`
  sentence and the "0.4 rules" framing still need rewriting.
- **Schema evolution** is largely still correct — the record-completion explanation and the
  Haskell-boundary caveat both hold — but it should now name the v0.2 descriptor vocabulary as
  the concrete example of a coordinated change.
- **Validating this repo** lists five `dhall type` commands and a handful of `okf validate`
  invocations. The repository now has eight test scripts (EP-2 and EP-5 each added one), and
  the section should point at them rather than duplicating their contents.
- **Profile catalog** is a table with a *Minimum `okf`* column reading `0.4.0.0` for every row.
  Every row is now `0.5.0.0`, and each row's purpose sentence should say what the profile now
  demands.

There is also a paragraph about the `adopt-architecture-decisions` blueprint that must become a
section covering both blueprints.

### The sequencing hazard

Two things depend on each other in a way that cannot be resolved inside one commit.

Blueprint files ship `https://raw.githubusercontent.com/shinzui/okf-profiles/v0.8.0/package.dhall`
with an integrity hash. `dhall freeze` computes that hash by fetching the URL, and the URL does
not resolve until the `v0.8.0` tag is pushed. So: **tag first, freeze second, then amend or
follow up with a second commit.** The tag therefore points at a commit whose blueprint hashes
are placeholders, and the released blueprints are the ones in the follow-up commit.

Two ways to handle this, and you must pick one and record it:

1. **Tag, freeze, re-tag.** Cut `v0.8.0`, freeze the hashes, commit, delete and re-cut the tag
   at the new commit. Clean result; requires force-pushing a tag, which is only acceptable
   because nothing has consumed it yet. Verify nothing has: `git ls-remote --tags origin | grep v0.8.0`
   must return nothing before you start.
2. **Tag `v0.8.0`, freeze, release `v0.8.1`.** No tag is ever moved. Costs a version number and
   leaves a tag in the wild whose blueprints do not resolve.

Prefer (1), and confirm the tag is unconsumed before moving it. Whichever you choose, **never
hand-write a `sha256:` value and never delete a hash line to make an import resolve.**


## Plan of Work

Four milestones. The first three can be done in any order; the fourth must be last because it
is the release itself.

### Milestone 1 — dogfood the ADR profile

Scope: a new `docs/adr/` bundle, and a new `scripts/test-adr-bundle.sh`.

Create `docs/adr/profile.dhall` importing `../../package.dhall` by relative path, as described
above, with a doc comment explaining why this repository's descriptor is the one place a
relative import is correct.

Then write the decision records. Every ADR must be a decision this initiative actually made and
whose rationale outlives the plans. Source them from the parent MasterPlan's Decision Log and
from the six child plans' Decision Logs, promoting only what is durable — leave task-local
execution notes in the plans. The candidates, in the order they are most likely to be needed by
a future reader:

- **The house `status` key diverges from OKF v0.2 §5.4.** Five profiles keep a house lifecycle
  vocabulary on `status` and do not declare OKF's; two adopt OKF's in full. The rationale, the
  alternative considered (renaming every house key), and the accepted consequence (`okf trust`
  reports the house value verbatim) all belong here. This is the decision most likely to be
  revisited and the one most expensive to get wrong.
- **A profile flips to OKF v0.2 atomically.** okf compile-checks `okfVersion` against the rules
  a profile declares, in both directions, so `generated` cannot be added without declaring
  `"0.2"` and `"0.2"` cannot be declared while `timestamp` is required or recommended. This is
  a durable constraint on how any future profile in this catalog is written, not a fact about
  this initiative.
- **`timestamp` is demoted to `optional`, not deleted.** With the reasoning from okf ADR 7's
  no-removal-horizon fallback, and what `optional` buys that deletion does not.
- **The house `reviews` family and OKF `verified` coexist.** Which to write, and why neither is
  a superset.
- **The v0.2 field families are defined once in `Profile/V02.dhall`.** The shared-ownership
  boundary: who may edit it, and what a consuming profile may override.
- **`Attested Computation` is deliberately excluded.** A deliberate exclusion is durable
  context — the next person to notice okf supports the type should find out why this catalog
  does not, without re-deriving it.
- **Blueprint versions are aligned with the catalog tag.** Already stated in a blueprint README;
  promote it, because it is a cross-cutting release rule and a README is not where a rule lives.

Seven is a reasonable number; fewer is fine if two collapse naturally. Do **not** write an ADR
per plan — a plan is not a decision.

Allocate each handle with `okf id next`, never by counting. Write `log.md` with a dated entry.
Generate the index with `okf index docs/adr --write --okf-version 0.2`.

Then wire it into the checks with `scripts/test-adr-bundle.sh`, matching the shape of the eight
existing scripts, running the contract's command from `ADR.md`. This script is different from
the others in kind — the others validate fixtures, this validates the repository's own corpus —
and its comment should say so.

### Milestone 2 — the README

Scope: `README.md` only.

Rewrite the four sections named in Context and Orientation, and add a blueprints section.

For the **Profile catalog** table, replace the *Minimum `okf`* column value on every row with
`0.5.0.0` and add a column or a sentence per row naming what the profile now demands. Add rows
for the two new exports, `okfV02` and `v02` — the first is a profile a consumer selects, the
second is a module a profile author imports, and the table should not pretend they are the same
kind of thing. Consider two tables rather than one if that reads better.

For **Validating this repo**, replace the hand-listed commands with a loop over `scripts/`:

```bash
for s in scripts/*.sh; do bash "$s"; done
```

and keep one worked example showing what a passing run looks like, including the
`(okf_version 0.2)` suffix that is new in this release. Keep the `dhall type` sweep, but write
it as a loop over the actual files rather than a list that goes stale.

For **Compatibility**, state plainly: the catalog targets OKF v0.2, every profile declares
`okfVersion = "0.2"`, the schema is pinned to okf 0.5.0.0, and the catalog must be decoded with
okf-core 0.5.0.0 or later. Explain the compile-time `okfVersion` consistency check, because it
is the thing most likely to surprise someone forking a profile.

Add a **Migrating an existing corpus** section pointing at the two blueprints by name, with the
two commands, and a short statement of what each covers. This is the section a consumer hitting
a red build will search for; make it findable.

### Milestone 3 — the registries

Scope: `mori.dhall` and `seihou-registry.dhall`.

In `seihou-registry.dhall`, bump `adopt-architecture-decisions` to `0.8.0` and add the new
blueprint with the exact name, version, path, description, and tags EP-6 recorded.

In `mori.dhall`:

- Bump the `adopt-architecture-decisions` template entry from `0.1.3` to `0.8.0`, reconciling
  the disagreement.
- Add a template entry for the new blueprint.
- Add `DocRef` entries for the new blueprint's README and, if written, the release notes.
- Add a bundle declaration for `docs/adr`, so this repository's decisions become addressable
  from other repositories. Check the schema for the exact field names — the pinned
  `mori-schema` import defines them, and `mori registry show shinzui/okf` displays what a
  populated one looks like. Note that `mori.dhall`'s pinned schema is currently reported as
  **stale** by `mori registry show`; if adding a bundle declaration requires a newer schema,
  bump the pin and re-freeze, and record it in Surprises & Discoveries.

Verify with:

```bash
dhall type --file mori.dhall > /dev/null && echo "mori.dhall type-checks"
dhall type --file seihou-registry.dhall > /dev/null && echo "registry type-checks"
mori registry show shinzui/okf-profiles --full
```

The last must list both blueprints, the new docs, and the `docs/adr` bundle.

### Milestone 4 — cut the release

Scope: release notes, the tag, and the placeholder-hash freeze.

Write the release notes. This repository has no `CHANGELOG.md`; adding one is the right move,
following the Keep a Changelog format that the upstream `okf` repository uses, with a single
`0.8.0` entry. Structure it as Added / Changed / Fixed, and be explicit about what breaks:
`generated` required on five profiles, `sources` reshaped on two, every bundle now expected to
declare `okf_version`, and the minimum okf moving to 0.5.0.0. State the migration path in the
first sentence of the Changed section, not the last.

Run the full sweep, cut the tag, then freeze:

```bash
for s in scripts/*.sh; do bash "$s" || exit 1; done
git ls-remote --tags origin | grep v0.8.0   # must return nothing
git tag -a v0.8.0 -m "okf-profiles 0.8.0: OKF v0.2 profiles and bundle migrations"
git push origin v0.8.0
```

Then freeze every placeholder from EP-6's list:

```bash
dhall freeze --inplace blueprints/adopt-architecture-decisions/files/architecture-decisions-profile.dhall
# … and every other file EP-6 recorded …
```

and re-cut the tag per whichever sequencing option you chose.

Finally, prove the released artifact resolves from outside the repository — this is the only
check that catches a wrong hash or a missing file:

```bash
cd /tmp && dhall type <<'DHALL'
  https://raw.githubusercontent.com/shinzui/okf-profiles/v0.8.0/package.dhall
DHALL
```

and validate a fixture against the *remote* profile rather than the local one:

```bash
okf validate /path/to/a/copy-of/fixtures/architecture-decisions --strict --profile <(cat <<'DHALL'
(https://raw.githubusercontent.com/shinzui/okf-profiles/v0.8.0/package.dhall).documentation.architectureDecisions
DHALL
) --profile-enforce
```

If your shell does not support process substitution, write the one-line profile to a temporary
file instead.

Then close out the initiative: fill in the MasterPlan's Outcomes & Retrospective, mark every
child plan Complete in its Exec-Plan Registry, and perform the ADR distillation pass across all
seven plans — reviewing each Decision Log, Surprises & Discoveries, and Outcomes section, and
promoting anything durable that Milestone 1 did not already capture.


## Concrete Steps

All commands run from `/Users/shinzui/Keikaku/bokuno/okf-profiles` unless stated otherwise.

**Step 1 — verify prerequisites and read the inputs.**

```bash
okf --version; seihou --version; dhall --version
for s in scripts/*.sh; do bash "$s" >/dev/null 2>&1 || echo "FAILING: $s"; done; echo "scripts checked"
seihou validate-blueprint blueprints/adopt-architecture-decisions --lint
seihou validate-blueprint blueprints/migrate-okf-bundles-to-v0-2 --lint
grep -rn 'okf-profiles/v0.8.0' blueprints/ || echo "no v0.8.0 pins found — check EP-6 Outcomes"
```

The `grep` cross-checks EP-6's placeholder list against reality. If it finds files EP-6 did not
record, or vice versa, resolve the discrepancy before proceeding and note it in Surprises &
Discoveries.

**Step 2 — read the ADR contract.**

```bash
cat agents/skills/exec-plan/ADR.md
```

**Step 3 — create the bundle skeleton.**

```bash
mkdir -p docs/adr
# author docs/adr/profile.dhall with the relative import
dhall type --file docs/adr/profile.dhall > /dev/null && echo "descriptor type-checks"
```

**Step 4 — allocate the first handle and write the ADRs.**

```bash
okf id next docs/adr --profile docs/adr/profile.dhall ADR
```

On an empty bundle this prints `ADR-1`. Write that decision, then ask again for the next. Do
not batch-assign handles by counting.

**Step 5 — write `log.md` and generate the index.**

```bash
okf index docs/adr --write --okf-version 0.2
head -3 docs/adr/index.md
```

Expected:

```text
---
okf_version: "0.2"
---
```

**Step 6 — validate the bundle under the contract's command.**

```bash
okf validate docs/adr --strict --profile docs/adr/profile.dhall --profile-enforce --log-enforce
```

Expected:

```text
OK: 7 concepts (okf_version 0.2)
```

with no `profile:` lines and the count matching however many ADRs you wrote. This is the
headline result of Milestone 1: the repository's own decisions validate against the profile it
publishes.

**Step 7 — wire it into the checks and commit Milestone 1.**

```bash
chmod +x scripts/test-adr-bundle.sh
bash scripts/test-adr-bundle.sh
git add docs/adr scripts/test-adr-bundle.sh
git commit -F - <<'MSG'
docs(adr): govern this repository's own decisions with its own profile

This repository publishes the architecture-decision profile and had no
decision records of its own, so every durable judgement from the OKF v0.2
migration lived only in plan files. Create docs/adr as a profile-governed
OKF bundle holding them, with a descriptor importing the working tree's
profile by relative path -- the one place that import form is correct,
since a remote pin here would be circular.

The bundle doubles as a regression test: it validates against the profile
under development rather than a released one.

MasterPlan: docs/masterplans/1-bring-okf-profiles-to-okf-v0-2-and-ship-bundle-migrations.md
ExecPlan: docs/plans/7-release-okf-profiles-v0-8-0-and-dogfood-the-migrated-adr-profile.md
MSG
```

**Step 8 — rewrite the README**, then commit Milestone 2 separately so the documentation diff
is reviewable on its own.

**Step 9 — update the registries and verify.**

```bash
dhall type --file mori.dhall > /dev/null && echo "mori.dhall type-checks"
dhall type --file seihou-registry.dhall > /dev/null && echo "registry type-checks"
mori registry show shinzui/okf-profiles --full
seihou list 2>&1 | head -20
```

`mori registry show` must list both blueprints, the new docs, and the `docs/adr` bundle. If it
shows stale data, the registry may need refreshing from `mori.dhall`; consult
`mori registry --help` rather than guessing. Commit Milestone 3.

**Step 10 — write the release notes and run the full sweep.**

```bash
for s in scripts/*.sh; do echo "--- $s"; bash "$s" 2>&1 | tail -1; done
for f in Profile/*.dhall profiles/*.dhall profiles/*/*.dhall package.dhall mori.dhall seihou-registry.dhall docs/adr/profile.dhall; do
  dhall type --file "$f" > /dev/null || echo "FAILED: $f"
done; echo "type-check sweep done"
git status --short
```

Nine `OK:` lines (seven fixture scripts plus the base-postgresql script plus the ADR bundle
script — confirm the count against what actually exists), no `FAILED:` lines, and a clean tree.

**Step 11 — cut the tag.**

```bash
git ls-remote --tags origin | grep v0.8.0 && echo "TAG ALREADY EXISTS — stop and reassess"
git tag -a v0.8.0 -m "okf-profiles 0.8.0: OKF v0.2 profiles and bundle migrations"
git push origin v0.8.0
```

**Step 12 — freeze the placeholders and re-tag.**

```bash
dhall freeze --inplace blueprints/adopt-architecture-decisions/files/architecture-decisions-profile.dhall
# … every other file from EP-6's list …
git diff --stat
git add blueprints && git commit -m "chore(blueprints): freeze the v0.8.0 descriptor pins

MasterPlan: docs/masterplans/1-bring-okf-profiles-to-okf-v0-2-and-ship-bundle-migrations.md
ExecPlan: docs/plans/7-release-okf-profiles-v0-8-0-and-dogfood-the-migrated-adr-profile.md"
git tag -d v0.8.0 && git push origin :refs/tags/v0.8.0
git tag -a v0.8.0 -m "okf-profiles 0.8.0: OKF v0.2 profiles and bundle migrations"
git push origin v0.8.0
```

This is the tag-move path. Only do it having confirmed in Step 11 that nothing had consumed the
tag. If you chose the `v0.8.1` path instead, skip the delete-and-re-cut and tag `v0.8.1` on the
freeze commit.

**Step 13 — prove the release resolves from outside.**

```bash
mkdir -p /tmp/ep7 && cd /tmp/ep7
cat > pinned.dhall <<'DHALL'
(https://raw.githubusercontent.com/shinzui/okf-profiles/v0.8.0/package.dhall).documentation.architectureDecisions
DHALL
dhall type --file pinned.dhall > /dev/null && echo "remote import resolves"
cp -r /Users/shinzui/Keikaku/bokuno/okf-profiles/fixtures/architecture-decisions ./bundle
okf validate ./bundle --strict --profile pinned.dhall --profile-enforce --log-enforce
```

Expected:

```text
remote import resolves
OK: 2 concepts (okf_version 0.2)
```

This is the acceptance test that matters most: it exercises the exact path every consumer
takes.

**Step 14 — close the initiative.** Fill in this plan's Outcomes & Retrospective, then the
MasterPlan's, mark all seven child plans Complete in the Exec-Plan Registry, and run the ADR
distillation pass across every plan's Decision Log, Surprises & Discoveries, and Outcomes
section. Anything durable that Milestone 1's ADRs did not capture becomes a new ADR or an
amendment to an existing one — allocated with `okf id next`, as always. Re-run
`bash scripts/test-adr-bundle.sh` afterwards.


## Validation and Acceptance

**The repository's own decisions validate against its own profile.**

```bash
okf validate docs/adr --strict --profile docs/adr/profile.dhall --profile-enforce --log-enforce
```

prints `OK: N concepts (okf_version 0.2)` with no `profile:` lines, and every ADR carries an
unpadded `ADR-N` handle allocated by `okf id next`. Confirm no duplicates and no padding:

```bash
okf id list docs/adr --profile docs/adr/profile.dhall
grep -h '^docId:' docs/adr/*.md | sort
```

**Every check passes.** Every script under `scripts/` prints its `OK:` line, and the `dhall
type` sweep reports no failures across `Profile/`, `profiles/`, `package.dhall`, `mori.dhall`,
`seihou-registry.dhall`, and `docs/adr/profile.dhall`.

**Both blueprints validate and are registered.**
`seihou validate-blueprint <path> --lint` succeeds for each, and
`mori registry show shinzui/okf-profiles --full` lists both templates at version `0.8.0`, the
new documentation entries, and the `docs/adr` bundle.

**The two registry files agree.** `grep -n '0\.8\.0' mori.dhall seihou-registry.dhall` shows the
same version for the same blueprint in both, resolving a disagreement that predates this
initiative.

**No placeholder hash survives.**

```bash
grep -rn 'sha256:0\{16,\}\|PLACEHOLDER\|TODO' blueprints/ Profile/ docs/adr/
```

returns nothing. Every `sha256:` in the repository was computed by `dhall freeze`, and running
`dhall freeze --inplace` again on any of them produces no diff — which is the check that proves
a hash was computed rather than typed.

**The released artifact resolves and works from outside the repository.** Step 13's transcript
shows `remote import resolves` followed by `OK: 2 concepts (okf_version 0.2)`. This proves the
tag exists, the package parses, the hash is right, and a consumer's exact workflow succeeds.

**The README is truthful.** Spot-check three claims against reality rather than reading for
plausibility: the *Minimum `okf`* column against `okf --version`, the catalog table's export
names against `dhall <<< './package.dhall'`, and the *Validating this repo* commands by running
them verbatim. A README that describes a catalog nobody can reproduce is worse than a short one.

**The initiative is closed.** The MasterPlan's Exec-Plan Registry shows all seven plans
Complete, its Outcomes & Retrospective is written, and the ADR distillation pass has run.


## Idempotence and Recovery

Most of this plan is ordinary authoring and is freely repeatable. `okf index --write` is
idempotent; `okf validate`, `okf id list`, `dhall type`, `seihou validate-blueprint`, and
`mori registry show` are read-only.

Three steps are not freely repeatable and need care.

**`okf id next` allocates a handle.** It reads the bundle and reports the next unused number; it
does not reserve anything. So calling it twice without writing a file in between returns the
same number, which is correct but easy to misread as two allocations. Write each ADR before
asking for the next handle.

**Pushing a tag is visible to consumers.** Step 11 checks the tag does not already exist before
creating it. Step 12's delete-and-re-cut moves a published tag, which is safe only because
nothing has consumed it — a condition you verified minutes earlier. If you are not certain, use
the `v0.8.1` path instead; a spare version number costs nothing and a moved tag that someone
already pinned costs a lot.

**`dhall freeze` needs the network and the tag.** If it fails, the file is left with the URL you
wrote and a hash that does not match, which will not load. Retry, or restore the file — never
"fix" it by deleting the hash, which silently disables integrity checking for every consumer.

Commit at the end of each milestone. The four are independent enough that a problem in the
registries cannot cost you the ADR bundle. Before a commit, recovery is `git checkout -- <paths>`;
after, `git revert`.

If Step 13 fails after the tag is pushed, do not delete the tag reflexively. Read the error
first: a Dhall hash mismatch means the freeze in Step 12 did not make it into the tagged commit,
which is fixed by re-cutting the tag; a `404` means the tag was not pushed; a profile load error
means something in the catalog is genuinely broken and the release should be withdrawn and
redone.


## Interfaces and Dependencies

**Hard dependency on EP-6**
(`docs/plans/6-ship-seihou-blueprint-migrations-for-consumer-okf-bundles.md`), and transitively
on EP-1 through EP-5. This plan reads EP-6's Outcomes & Retrospective for the blueprint
metadata and the placeholder-hash file list, and the three migration plans' Outcomes sections
for the README catalog table.

**`okf` 0.5.0.0 or later**, **`seihou` 0.6.0.0 or later**, **`dhall` ≥ 1.42**, **`mori`**, and
**`git` with push access to `origin`**.

**`agents/skills/exec-plan/ADR.md`** — the shared ADR contract this repository's plan skills
follow. Read it before creating `docs/adr/`; it is authoritative over anything summarized here.

**Files this plan owns**:

```text
docs/adr/**                        (new)
scripts/test-adr-bundle.sh         (new)
README.md
CHANGELOG.md                       (new)
mori.dhall
seihou-registry.dhall
blueprints/**/files/*.dhall        (freeze only — no prose changes)
```

**Files this plan must not change in substance**: anything under `profiles/`, `Profile/`,
`fixtures/`, or the blueprint prompts under `blueprints/**/prompt.md` and
`blueprints/**/migrations/`. If the README rewrite reveals that a profile is wrong, that is a
finding for the MasterPlan's Surprises & Discoveries and a follow-up plan, not a quiet edit
here — the release is not the place to change behaviour.

**What this plan delivers to consumers.** After it completes, the following resolves and is the
supported entry point for every downstream repository:

```dhall
let Profiles =
      https://raw.githubusercontent.com/shinzui/okf-profiles/v0.8.0/package.dhall
        sha256:<computed by dhall freeze>

in  Profiles.documentation.architectureDecisions
```

exporting `Profile`, `TypeRule`, `FrontmatterRules`, `FieldRule`, `NestedRules`,
`NestedFieldRule`, `HandleReferenceRule`, `PathReferenceRule`, `FieldCondition`, `Cardinality`,
`FieldFormat`, `mk`, `reviewRule`, `v02`, `coordination`, `documentation`, `okfV02`,
`postgresql`, and `tanPostgresql`. Verify that list against the actual `package.dhall` before
writing it into the README — it is assembled from three plans and this is the last chance to
catch an omission.
