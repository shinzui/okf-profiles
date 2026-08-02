---
id: 6
slug: ship-seihou-blueprint-migrations-for-consumer-okf-bundles
title: "Ship Seihou blueprint migrations for consumer OKF bundles"
kind: exec-plan
created_at: 2026-08-01T23:39:57Z
master_plan: "docs/masterplans/1-bring-okf-profiles-to-okf-v0-2-and-ship-bundle-migrations.md"
---

# Ship Seihou blueprint migrations for consumer OKF bundles

This ExecPlan is a living document. The sections Progress, Surprises & Discoveries,
Decision Log, and Outcomes & Retrospective must be kept up to date as work proceeds.
If durable project context changes, update or create ADRs in docs/adr/ in the same change.


## Purpose / Big Picture

By the time this plan starts, all seven profiles in this repository demand the Open Knowledge
Format v0.2 `generated` provenance family and require their bundles to declare
`okf_version: "0.2"`. That is a breaking change for every repository that pins one of these
profiles: their documentation bundles will start reporting deviations they never reported
before, and under `--profile-enforce` — which is how a real project wires this into CI — their
builds go red.

This plan gives those repositories a way out that is not "read a changelog and edit two hundred
Markdown files by hand". It ships two **Seihou blueprints**. A blueprint is an agent-driven
migration: a Markdown prompt plus reference files, packaged with a version, which `seihou`
runs inside the target repository with a tool-capable model that reads the actual corpus and
repairs it.

Concretely, after this plan a maintainer of a consuming repository can run

```bash
seihou agent migrate adopt-architecture-decisions --from 0.7.0 --to 0.8.0
```

to move an adopted ADR bundle onto the v0.2 profile, and

```bash
seihou agent run migrate-okf-bundles-to-v0-2
```

to have an agent detect whichever profiled OKF bundles the repository has — improvement
requests, use cases, a pattern catalog, research documents, a PostgreSQL description — and
migrate all of them in one pass. Both are dry-runnable with `--debug`, which renders the
prompt and contacts no provider.

The observable outcome is a consumer repository whose `okf validate … --strict
--profile-enforce` command passes again, with every concept carrying `generated` and every
bundle root declaring its dialect.


## Progress

- [ ] Confirm EP-3, EP-4, and EP-5 are all complete
- [ ] Read all three plans' Outcomes sections and build the change inventory
- [ ] Build a deliberately-unmigrated test corpus and capture real diagnostics
- [ ] Write `blueprints/adopt-architecture-decisions/migrations/0-7-to-0-8.md`
- [ ] Update the blueprint's shipped `files/architecture-decisions-profile.dhall` to v0.8.0
- [ ] Declare the new edge in `blueprints/adopt-architecture-decisions/blueprint.dhall`
- [ ] Bump that blueprint's version to 0.8.0
- [ ] Update `blueprints/adopt-architecture-decisions/README.md` with the new edge
- [ ] Scaffold `blueprints/migrate-okf-bundles-to-v0-2/`
- [ ] Write its detection-and-migration prompt
- [ ] Write its reference files
- [ ] Write its README
- [ ] Validate both blueprints with `seihou validate-blueprint --lint`
- [ ] Dry-run both with `seihou agent --debug`
- [ ] Commit with the required git trailers


## Surprises & Discoveries

(None yet.)


## Decision Log

- Decision: Ship one cross-family blueprint plus one edge on the existing blueprint, rather
  than seven per-family blueprints.
  Rationale: Chosen by the user on 2026-08-01. Only `adopt-architecture-decisions` exists
  today; the other six profiles have no blueprint at all. Seven blueprints would multiply the
  authoring and version-maintenance surface roughly sixfold to express one shared migration —
  every family makes the same three changes. One detecting blueprint plus one edge on the path
  a consumer already knows keeps the established entry point working and gives the six
  unblueprinted families a first-class route.
  Date: 2026-08-01

- Decision: The new blueprint's entry point is `seihou agent run`, not `seihou agent migrate`.
  Rationale: `seihou agent migrate` selects declared edges by a version window read from the
  consumer's own pinned tag. Six of the seven profiles have never been distributed through a
  blueprint, so a consuming repository has no recorded version to migrate *from* — there is no
  `.seihou` receipt and often no pinned descriptor at all. `run` is the correct verb for
  "inspect this repository and bring it to a known state", which is exactly the job. The
  blueprint may still declare migration edges for its *own* future versions.
  Date: 2026-08-01


## Outcomes & Retrospective

(To be filled during and after implementation.)


## Context and Orientation

### Where you are

The repository root is `/Users/shinzui/Keikaku/bokuno/okf-profiles`. Run every command from
there. Commit directly to `master`; do not create a branch.

`seihou --version` must report `v0.6.0.0` or later, and `okf --version` must report
`v0.5.0.0` or later.

### Prerequisites

This plan hard-depends on all three migration plans being **complete**:

- `docs/plans/3-migrate-the-documentation-profiles-to-okf-v0-2.md`
- `docs/plans/4-migrate-the-coordination-profiles-to-okf-v0-2.md`
- `docs/plans/5-migrate-the-postgresql-profiles-to-okf-v0-2.md`

Confirm with the parent MasterPlan's Exec-Plan Registry, which must show all three as
Complete, and then directly:

```bash
for p in profiles/documentation/*.dhall profiles/coordination/*.dhall profiles/postgresql.dhall profiles/tan-postgresql.dhall; do
  case "$p" in */package.dhall) continue ;; esac
  printf '%-56s ' "$p"; dhall <<< "($p).okfVersion"
done
```

Every line must print `"0.2"`. If any prints `"0.1"`, that profile has not migrated and any
migration prose you write about it will be wrong.

**Read all three plans' Outcomes & Retrospective sections before writing a word of prompt.**
Each was asked to record the exact list of frontmatter changes a consumer corpus must make per
profile — which key was added, which was demoted, which changed shape, which fields moved
presence class. That list *is* the content of the migration prompts. Do not reconstruct it
from the profile diffs; the plans recorded judgement calls (which recommended fields became
optional, and why) that a diff does not show.

### What a Seihou blueprint is

A blueprint is a directory under `blueprints/` with four parts:

- **`blueprint.dhall`** — the blueprint record. It imports the Seihou schema by pinned URL,
  and declares `name`, `version`, `description`, `prompt` (loaded from `./prompt.md as Text`),
  a `files` list naming reference files under `files/`, a `migrations` list of
  `{ from, to, prompt }` edges, an `allowedTools` list, and `tags`.
- **`prompt.md`** — the Markdown the agent runner consumes for a `seihou agent run`.
- **`files/`** — reference material handed to the agent, such as a descriptor to install
  byte-for-byte and a contract document.
- **`migrations/*.md`** — one prompt per declared edge, consumed by `seihou agent migrate`.

A blueprint is also registered in two repository-level files: `seihou-registry.dhall`, which
is what `seihou install` reads, and `mori.dhall`'s `templates` list, which is what Mori
indexes. **This plan does not touch those two files** — `docs/plans/7-release-okf-profiles-v0-8-0-and-dogfood-the-migrated-adr-profile.md`
owns them, because they also carry the release version and the two currently disagree with
each other.

### The blueprint that already exists

`blueprints/adopt-architecture-decisions/` is at version `0.7.0` and serves two distinct jobs,
documented in its own README:

| Target state | Command | What it does |
|--------------|---------|--------------|
| No `docs/adr/profile.dhall` | `seihou agent run` | Adoption: inventory the legacy corpus, assign `ADR-N` handles, install the descriptor |
| `docs/adr/profile.dhall` pins an older tag | `seihou agent migrate` | Upgrade: move the pin forward and repair the corpus |

It declares exactly one edge today, `0.6.0 -> 0.7.0`, whose prompt lives at
`migrations/0-6-to-0-7.md`. **Read that file in full before writing yours.** It is 173 lines
and is the house style for a migration edge: it opens by telling the agent not to trust the
`--from` version and to read the installed descriptor instead, it names the exact constraints
that changed with rejected-example tables, it says which relaxations are sanctioned and which
are forbidden, it bounds the scope to one bundle, and it ends with the exact validation command
that must pass. Match that structure.

Note its key edge-selection rule, stated in its own prose and worth repeating: an edge is
declared **keyed at the last release before the change**, not at the oldest version still in
the wild, because an edge is selected only when it falls inside the requested window. Your new
edge is therefore `0.7.0 -> 0.8.0`.

The blueprint also ships `files/architecture-decisions-profile.dhall`, which imports
`https://raw.githubusercontent.com/shinzui/okf-profiles/v0.7.0/package.dhall` and then layers
an override:

```dhall
in  base
    //  { frontmatter =
            base.frontmatter
        //  { recommended = [] : List Profiles.FieldRule.Type
            , optional = base.frontmatter.recommended
            }
        }
```

That override moves `supersedes`, `supersededBy`, and `originatingPlan` from `recommended` to
`optional`, because under `--strict` a recommended-and-absent field is an error and essentially
every real ADR corpus lacks all three.

**EP-3 was asked to fold that reclassification upstream.** Check whether it did:

```bash
dhall <<< '(./profiles/documentation/architecture-decisions.dhall).frontmatter.recommended'
```

If that prints an empty list, EP-3 folded it and the shipped file's override is now a no-op
that should be deleted — your updated `files/architecture-decisions-profile.dhall` becomes a
plain pinned import with no `//` at all, and the edge prompt should tell adopters that the
local override can go. If it still lists the three fields, EP-3 chose not to; keep the
override, and say so in this plan's Decision Log.

### The six profiles with no blueprint

`coordination.improvementRequests`, `coordination.useCases`,
`documentation.patternCatalog`, `documentation.researchDocuments`, `postgresql`, and
`tanPostgresql` have never been distributed through a blueprint. A consuming repository has no
`.seihou` receipt for them and often no local descriptor either — it may import the profile
directly by pinned URL from a check script. That is why the new blueprint's entry point is
`seihou agent run` rather than `seihou agent migrate`; see the Decision Log.

### What actually changed, and what a consumer must do about it

This is the substance both prompts must convey. Confirm each item against the three plans'
Outcomes sections rather than trusting this summary, which was written before they ran.

**Every profile now declares `okfVersion = "0.2"`.** A consumer does not write that key — it
lives in the profile, not the bundle — but it is what makes the rest mandatory.

**`generated` is now demanded.** Required on the five documentation and coordination profiles;
recommended on the two PostgreSQL profiles (so it fails only under `--strict`). Its `by` member
is required within the record and must match OKF §7's actor convention:

```yaml
generated:
  by: human:nadeem
  at: 2026-07-26T00:00:00Z
```

An actor is `<producer>/<version>`, `human:<id>`, or `process:<id>`, case-sensitively. A bare
name is rejected. This is the single most common repair the agent will make, and the prompt
must be explicit about where `at` comes from: **reuse the document's existing `timestamp`
value**, because `generated.at` is what supersedes it. Restamping to the current time destroys
history and can break the `okf log` coverage gate, which now reads `generated.at` in preference
to `timestamp`. For a document with no `timestamp` at all, use the last commit that
meaningfully changed the file:

```bash
git log -1 --format=%cI -- <path>
```

converted to the `Z` form. Do not invent a timestamp and do not use the current time for a
document you did not just write.

**`timestamp` is demoted, not removed.** It moved to each profile's `optional` list. A
document may keep it; its RFC3339-UTC format is still checked; its absence is never reported.
The prompt must say this plainly, because the instinct on reading "v0.2 retires `timestamp`"
is to delete the key everywhere, which is unnecessary churn on a large corpus and loses
information where `generated.at` and `timestamp` genuinely differ.

**Every bundle must declare its dialect.** All seven profiles set
`requireBundleVersion = Some "0.2"`, so a bundle whose root `index.md` does not declare
`okf_version: "0.2"` produces a deviation that names no concept:

```text
profile: bundle does not declare okf_version; this profile requires 0.2 or later
```

The fix is one command, and the prompt should give it verbatim:

```bash
okf index <bundle> --write --okf-version 0.2
```

**`sources` changed shape on two profiles.** `documentation.patternCatalog` and
`documentation.researchDocuments` declared `sources` as a bare list of text; it is now the OKF
v0.2 list-of-records shape whose `resource` member is required. A corpus writing

```yaml
sources:
  - mori://example/runtime
```

must become

```yaml
sources:
  - resource: mori://example/runtime
```

The existing string becomes the entry's `resource`. Optionally add `id`, `title`, `author`,
`usage_count`, and `last_modified`, but do not invent them.

**`status` did not change on five profiles, and did change on two.** This is the item most
likely to be got wrong, so state it twice in the prompt, once as a "do" and once as a "do not".
`documentation.architectureDecisions`, `documentation.patternCatalog`,
`documentation.researchDocuments`, `coordination.improvementRequests`, and
`coordination.useCases` **keep their house `status` vocabulary unchanged** — do not rewrite an
ADR's `status: Accepted` to `status: stable`. Only `postgresql` and `tanPostgresql` adopt OKF
v0.2's `status` and `stale_after`, and there the values are `draft`/`stable`/`deprecated`.

**`verified` is newly available everywhere, and demanded nowhere.** It is `optional` on every
profile. The prompt should mention it as an opportunity rather than a task: a corpus that
records approvals in a house `reviews` family may mirror an approving entry into `verified` so
`okf trust` derives an accurate tier, but nothing fails if it does not.

**Presence-class changes.** Each migration plan reclassified some previously-recommended
fields to `optional` so that `--strict` stops reporting fields whose absence is ordinary. Read
the exact list from the three plans' Outcomes sections. A consumer who has a local descriptor
overriding these may now be able to delete their override.


## Plan of Work

Three milestones. The first builds the evidence both prompts are written from; the second and
third write one blueprint each. Commit at the end of each.

### Milestone 1 — build the change inventory from real diagnostics

Scope: no repository files change. You produce a scratch document listing, per profile, the
exact `profile:` advisory lines an unmigrated corpus now produces.

A migration prompt is only useful if it names the diagnostic the reader is actually staring at.
Do not guess the wording. Produce it.

Take a copy of each acceptance fixture as it existed **before** the migration plans ran — the
easiest source is `git show`, since each migration plan committed the fixture changes:

```bash
mkdir -p /tmp/ep6/old
git log --oneline -- fixtures/architecture-decisions | tail -5
```

Find the commit before the v0.2 migration, extract that version of the fixture tree into
`/tmp/ep6/old/architecture-decisions/`, and run the **new** profile against the **old**
fixture:

```bash
okf validate /tmp/ep6/old/architecture-decisions --strict \
  --profile profiles/documentation/architecture-decisions.dhall 2>&1 | tee /tmp/ep6/adr-diagnostics.txt
```

That output is exactly what a consumer will see the first time they pull v0.8.0. Repeat for all
seven profiles. Keep every transcript; the prompts quote them and this plan's Outcomes section
records them.

Do the same for the missing-index case, which produces the one diagnostic that names no
concept:

```bash
cp -r /tmp/ep6/old/architecture-decisions /tmp/ep6/noindex && rm -f /tmp/ep6/noindex/index.md
okf validate /tmp/ep6/noindex --profile profiles/documentation/architecture-decisions.dhall
```

### Milestone 2 — the `0.7.0 -> 0.8.0` edge on the ADR blueprint

Scope: `blueprints/adopt-architecture-decisions/` only — a new `migrations/0-7-to-0-8.md`, an
updated `files/architecture-decisions-profile.dhall`, an updated `blueprint.dhall`, and an
updated `README.md`.

Write `migrations/0-7-to-0-8.md` following `migrations/0-6-to-0-7.md`'s structure section by
section:

*First: establish where this repository actually is.* Tell the agent not to trust the `--from`
version and to read the `okf-profiles` tag pinned in `docs/adr/profile.dhall` instead. Branch
three ways: pinned at v0.7.0 (proceed); pinned already at v0.8.0 (the pin needs no change, skip
to corpus repair, which may still be failing); no `docs/adr/profile.dhall` or it does not pin
`okf-profiles` (stop and report that `seihou agent run adopt-architecture-decisions` is the
correct entry point). Tell it to check for local customizations and preserve them.

*What v0.8.0 changes.* The `generated` family becomes required with an actor-checked `by`;
`timestamp` is demoted to optional and may stay; the bundle must declare `okf_version: "0.2"`;
`verified` becomes available and optional; and — if EP-3 folded the reclassification upstream —
the local `recommended`/`optional` override in the installed descriptor is now redundant and
can be deleted. Quote the real diagnostics from Milestone 1.

*Change the pin.* Set the import to the v0.8.0 tag and re-freeze:

```bash
dhall freeze --inplace docs/adr/profile.dhall
```

with the same warning the existing edge carries: never hand-write a `sha256:` value and never
delete the hash to make an import resolve.

*Bring the corpus up.* Work from the validator's output, not from assumption. For each ADR
lacking `generated`, add it, deriving `at` from the document's existing `timestamp` — and if
there is none, from `git log -1 --format=%cI -- docs/adr/<file>.md` converted to the `Z` form.
Derive `by` from evidence: the git author of the commit that created the file becomes
`human:<id>`, a document that names a generating tool becomes `<producer>/<version>`. Say
explicitly that the agent must not restamp `timestamp` and must not delete it.

*Declare the bundle version.* `okf index docs/adr --write --okf-version 0.2`. Note that
regenerating indexes preserves an existing declaration, and that this is what makes the
strict-mode report of remaining `timestamp`-only concepts start firing — which is how a team
ratchets the migration forward.

*Scope.* This edge covers `docs/adr` only. Other OKF bundles in the repository have their own
profiles and are explicitly out of scope — point at the new `migrate-okf-bundles-to-v0-2`
blueprint for those, by name.

*Do not.* Do not weaken the profile to make the corpus pass. Do not rewrite ADR prose. Do not
renumber ADRs. **Do not rewrite `status` values** — an ADR's `status: Accepted` is the house
lifecycle and stays exactly as it is; OKF v0.2's `draft`/`stable`/`deprecated` vocabulary is a
different key's meaning that this profile deliberately does not adopt.

*Before you finish.* The exact command that must pass, and instructions to append a dated
`log.md` entry with `okf log add` if the log gate reports stale coverage.

Then update the shipped descriptor. Change the pinned tag from `v0.7.0` to `v0.8.0`, re-freeze
its hash, and — per the check in Context and Orientation — delete the presence-class override
if EP-3 folded it upstream. Note that `dhall freeze` on this file requires the v0.8.0 tag to
**exist on the remote**, which it does not yet: EP-7 cuts it. Handle this the way the sequencing
requires — write the file with the v0.8.0 URL and a placeholder that EP-7 replaces by running
`dhall freeze`, and say so explicitly in this plan's Outcomes section and in EP-7's inputs. Do
not invent a hash. If leaving a placeholder is unacceptable, the alternative is for EP-7 to own
this one file entirely; decide, and record the decision.

Declare the edge in `blueprint.dhall`:

```dhall
, S.BlueprintMigration::{
  , from = "0.7.0"
  , to = "0.8.0"
  , prompt = ./migrations/0-7-to-0-8.md as Text
  }
```

alongside the existing `0.6.0 -> 0.7.0` entry, and bump the blueprint's `version` from
`Some "0.7.0"` to `Some "0.8.0"`. The blueprint version is deliberately aligned with the
`okf-profiles` tag, because that tag is the only version a consumer can read off their own
repository.

Finally update `README.md`: add a row to the "Declared edges" table, update the "What the edge
changes" section, and update the sentence stating which tag a freshly adopted bundle lands on.

### Milestone 3 — the `migrate-okf-bundles-to-v0-2` blueprint

Scope: a new `blueprints/migrate-okf-bundles-to-v0-2/` directory.

Scaffold it rather than copying by hand, so the schema pin and record shape are whatever the
installed Seihou expects:

```bash
seihou new-blueprint migrate-okf-bundles-to-v0-2 --path blueprints/migrate-okf-bundles-to-v0-2
```

Then write `prompt.md`. Its job is different from the ADR blueprint's: it must **detect** what
the repository has before it can migrate anything.

*Phase 1 — inventory.* Find every OKF bundle in the repository and work out which profile
governs it. Three sources of evidence, in order of reliability: `mori.dhall`'s bundle
declarations, read with `mori show --full`; a local `profile.dhall` beside a bundle, whose
import names the profile; and a check script or CI target invoking `okf validate --profile`.
Give the agent the exact greps. If a bundle's profile cannot be determined, report it and leave
it alone — migrating a bundle against a guessed profile is worse than not migrating it.

Then, crucially: **if the repository has no profiled OKF bundle at all, report that the
migration is not applicable and finish successfully without creating anything.** The existing
ADR blueprint has the same no-op branch and explains why — this blueprint will be invoked
across repositories whether or not they use OKF.

*Phase 2 — per-bundle migration.* For each detected bundle, in a fixed order so the run is
reproducible, apply the changes for its profile. The prompt needs a section per profile family
because the changes differ:

- The five house-`status` profiles: add `generated`, keep `status` untouched, keep or drop
  `timestamp` at the corpus's discretion, declare `okf_version`.
- `patternCatalog` and `researchDocuments` additionally: reshape `sources` from a list of
  strings to a list of records with `resource`.
- `postgresql` and `tanPostgresql`: add `generated` (recommended, so only strict mode demands
  it), and *optionally* adopt `status` and `stale_after`, which are newly available there and
  nowhere else.

Give each section the exact before-and-after YAML, and the exact command that proves it worked.

*Phase 3 — repin and validate.* If the repository has a local descriptor pinning
`okf-profiles`, move the pin to v0.8.0 and `dhall freeze --inplace` it. Then run each bundle's
own check and report. Tell the agent to use the repository's existing check target — a `just`,
`make`, or `npm` script wrapping `okf validate` — and to fall back to the direct command only
if none exists.

*Working rules and prohibitions.* Copy the house rules from the ADR blueprint's `prompt.md`:
read repository-local instruction files first, preserve unrelated changes, work on the current
branch, follow the repository's commit conventions, do not commit or push unless asked, use
Mori before guessing any API, never search `/nix/store` or traverse `/`. Add the ones specific
to this migration: do not restamp timestamps, do not delete `timestamp`, do not rewrite house
`status` values, do not weaken a profile to make a corpus pass, and do not touch a bundle whose
governing profile could not be determined.

Write two reference files under `files/`:

- **`v0-2-migration-reference.md`** — the per-profile change tables, the actor convention with
  its three shapes, the `sources` reshape, the `okf index --write --okf-version 0.2` command,
  and the full list of new diagnostics with their exact wording from Milestone 1. This is what
  the agent reads instead of reconstructing the contract from memory, and the prompt must say
  that if the references are unavailable it should stop rather than proceed.
- **`profile-pins.md`** — the v0.8.0 pinned-import line for each of the seven profile exports,
  so an agent installing or repinning a local descriptor copies rather than composes it. This
  file has the same v0.8.0-tag-does-not-exist-yet problem as the ADR descriptor; handle it the
  same way and record it.

Set `allowedTools` to the same list the ADR blueprint uses — `Read`, `Edit`, `Write`,
`Bash(dhall *)`, `Bash(git *)`, `Bash(find *)`, `Bash(make *)`, `Bash(mori *)`, `Bash(okf *)`,
`Bash(rg *)` — since the work is the same shape. Set `version = Some "0.8.0"` to align with the
`okf-profiles` tag, matching the ADR blueprint's stated convention. Set `migrations = []`: this
blueprint is new, so it has no earlier version to migrate from.

Write `README.md` following the ADR blueprint's, with the two-job table replaced by a single
`seihou agent run` entry, a section on what the blueprint detects and how, the no-op behaviour,
prerequisites (a tool-capable local CLI provider; a `.seihou/manifest.json` at the current
schema), and a maintainer section on adding an edge when a future release changes a profile.


## Concrete Steps

All commands run from `/Users/shinzui/Keikaku/bokuno/okf-profiles`.

**Step 1 — verify prerequisites.**

```bash
seihou --version
okf --version
for p in profiles/documentation/architecture-decisions.dhall \
         profiles/documentation/pattern-catalog.dhall \
         profiles/documentation/research-documents.dhall \
         profiles/coordination/improvement-requests.dhall \
         profiles/coordination/use-cases.dhall \
         profiles/postgresql.dhall \
         profiles/tan-postgresql.dhall; do
  printf '%-56s ' "$p"; dhall <<< "(./$p).okfVersion"
done
```

All seven must print `"0.2"`.

**Step 2 — check whether EP-3 folded the ADR presence-class override upstream.**

```bash
dhall <<< '(./profiles/documentation/architecture-decisions.dhall).frontmatter.recommended'
```

An empty list means it did. Record the answer here in the Decision Log before proceeding — it
changes what you write in two places.

**Step 3 — build the change inventory** as described in Milestone 1, saving each transcript
under `/tmp/ep6/`.

**Step 4 — read the existing edge in full.**

```bash
cat blueprints/adopt-architecture-decisions/migrations/0-6-to-0-7.md
cat blueprints/adopt-architecture-decisions/blueprint.dhall
cat blueprints/adopt-architecture-decisions/README.md
```

**Step 5 — write the new edge and update the ADR blueprint**, then validate:

```bash
seihou validate-blueprint blueprints/adopt-architecture-decisions --lint
```

Expected: a success line and no errors. Lint warnings are advisory; read them and fix what is
genuinely wrong.

**Step 6 — dry-run the new edge.** `--debug` renders every pending session in order, contacts
no provider, and writes nothing:

```bash
seihou agent --debug migrate adopt-architecture-decisions --from 0.7.0 --to 0.8.0
```

Confirm the rendered output contains your new edge's prose. Then confirm a wider window still
selects both edges, which is what a consumer pinned further back will pass:

```bash
seihou agent --debug migrate adopt-architecture-decisions --from 0.4.0 --to 0.8.0
```

Both `0.6.0 -> 0.7.0` and `0.7.0 -> 0.8.0` must appear, in that order.

**Step 7 — commit Milestone 2.**

```bash
git add blueprints/adopt-architecture-decisions
git commit -F - <<'MSG'
feat(blueprint): add the v0.7.0 -> v0.8.0 OKF v0.2 migration edge

Move an adopted docs/adr bundle onto the v0.2 architecture-decision
profile: add the generated provenance family with an actor-checked by
member derived from the document's existing timestamp or from git
history, declare okf_version 0.2 in the bundle root, and move the pin
to v0.8.0.

The edge is explicit that timestamp is demoted rather than removed and
may stay, and that an ADR's house status value is not OKF v0.2's status
vocabulary and must not be rewritten.

MasterPlan: docs/masterplans/1-bring-okf-profiles-to-okf-v0-2-and-ship-bundle-migrations.md
ExecPlan: docs/plans/6-ship-seihou-blueprint-migrations-for-consumer-okf-bundles.md
MSG
```

**Step 8 — scaffold and write the new blueprint**, then validate:

```bash
seihou new-blueprint migrate-okf-bundles-to-v0-2 --path blueprints/migrate-okf-bundles-to-v0-2
# … author prompt.md, files/, README.md, and blueprint.dhall …
seihou validate-blueprint blueprints/migrate-okf-bundles-to-v0-2 --lint
```

**Step 9 — dry-run the new blueprint.**

```bash
seihou agent --debug run migrate-okf-bundles-to-v0-2
```

Read the rendered prompt end to end as if you were the agent. Ask yourself the questions it
will ask: can I tell which profile governs this bundle? Do I know where `generated.at` comes
from? Do I know I must not touch `status`? If any answer is unclear, the prompt is not done.

**Step 10 — rehearse the new blueprint against a real corpus.** This is the acceptance test
that matters. Build a throwaway repository containing an unmigrated bundle:

```bash
mkdir -p /tmp/ep6/rehearsal && cp -r /tmp/ep6/old/research-documents /tmp/ep6/rehearsal/docs-research
cd /tmp/ep6/rehearsal && git init -q && git add -A && git commit -qm "unmigrated corpus"
```

Then, following the prompt's instructions **by hand**, migrate it and confirm the final
validation command passes:

```bash
okf index docs-research --write --okf-version 0.2
okf validate docs-research --strict \
  --profile /Users/shinzui/Keikaku/bokuno/okf-profiles/profiles/documentation/research-documents.dhall \
  --profile-enforce
```

If you cannot follow your own prompt to a passing result, neither can an agent. Every step you
had to improvise is a gap in the prompt — fix it and rehearse again. Record what you improvised
in Surprises & Discoveries.

**Step 11 — commit Milestone 3.**

```bash
cd /Users/shinzui/Keikaku/bokuno/okf-profiles
git add blueprints/migrate-okf-bundles-to-v0-2
git commit -F - <<'MSG'
feat(blueprint): migrate any profiled OKF bundle to v0.2

Six of the seven profiles in this catalog have never been distributed
through a blueprint, so a consuming repository has no recorded version to
migrate from. This blueprint detects whichever profiled bundles a
repository has -- from mori.dhall, a local profile.dhall, or a check
target invoking okf validate --profile -- and migrates each according to
its governing profile, or reports that the migration is not applicable
and finishes without creating anything.

MasterPlan: docs/masterplans/1-bring-okf-profiles-to-okf-v0-2-and-ship-bundle-migrations.md
ExecPlan: docs/plans/6-ship-seihou-blueprint-migrations-for-consumer-okf-bundles.md
MSG
```

**Step 12 — final sweep.**

```bash
seihou validate-blueprint blueprints/adopt-architecture-decisions --lint
seihou validate-blueprint blueprints/migrate-okf-bundles-to-v0-2 --lint
for s in scripts/*.sh; do bash "$s" >/dev/null 2>&1 || echo "FAILING: $s"; done; echo "scripts checked"
git status --short
```


## Validation and Acceptance

**Both blueprints validate.** `seihou validate-blueprint <path> --lint` succeeds for each,
confirming that `blueprint.dhall` evaluates, the name is valid, the prompt body is non-empty,
every entry in the `files` list resolves under `files/`, and prompts reference only declared
variables.

**The new edge is selectable from every version still plausibly in use.**

```bash
seihou agent --debug migrate adopt-architecture-decisions --from 0.7.0 --to 0.8.0
seihou agent --debug migrate adopt-architecture-decisions --from 0.4.0 --to 0.8.0
```

The first renders one session; the second renders two, in ascending order. Neither contacts a
provider and neither writes a file.

**The new blueprint renders.** `seihou agent --debug run migrate-okf-bundles-to-v0-2` prints
the resolved prompt, and reading it end to end answers every question an implementing agent
would have.

**The rehearsal passes.** Following the new blueprint's prompt by hand against an unmigrated
copy of a real fixture produces a bundle that passes

```text
OK: 2 concepts (okf_version 0.2)
```

under `--strict --profile-enforce`. Record in Outcomes & Retrospective exactly which steps you
had to improvise, and confirm the prompt was amended to cover each.

**The prompts quote real diagnostics.** Every `profile:` line quoted in either prompt appears
verbatim in a transcript under `/tmp/ep6/`. A migration prompt that paraphrases the error the
reader is looking at is a prompt they will not trust.

**The `status` prohibition is unmissable.** Both prompts state, in a "do not" list, that a
house `status` value must not be rewritten to OKF's vocabulary — and the new blueprint's
per-profile sections state the converse for `postgresql` and `tanPostgresql`, where `status`
and `stale_after` *are* newly available. This is the item most likely to cause silent damage to
a consumer corpus.

**Nothing outside `blueprints/` changed.** `git status --short` lists only files under
`blueprints/` and this plan file. In particular `seihou-registry.dhall`, `mori.dhall`, and
`README.md` are untouched — EP-7 owns them.

**All profile scripts still pass**, proving no profile was disturbed.


## Idempotence and Recovery

`seihou agent --debug` is a true dry run: it renders every pending session, contacts no
provider, and writes nothing. Run it as many times as you like.

`seihou validate-blueprint` is read-only. So is every `okf validate` and `dhall` invocation.

The rehearsal in Step 10 happens entirely under `/tmp/ep6/rehearsal`; delete it with
`rm -rf /tmp/ep6` when done. It never touches this repository or any consumer's.

Commit at the end of each milestone. The two blueprints are independent: a problem in the new
one cannot cost you the ADR edge.

One sequencing hazard has no clean recovery and must be handled deliberately rather than
discovered. Both blueprints ship files pinning `okf-profiles` **v0.8.0**, a tag that does not
exist on the remote until EP-7 cuts it. `dhall freeze` on such a file fails, and there is no
correct hash to write. Decide up front — and record the decision here — whether to leave a
clearly-marked placeholder for EP-7 to freeze, or to hand those two files to EP-7 entirely.
Never invent a `sha256:` value and never delete a hash line to make an import resolve; a
blueprint that ships an unverified remote import is worse than one that ships nothing.

If a `seihou agent migrate` run is ever performed for real and the edge deliberately refuses —
because the repository never adopted the profile — Seihou still records a completion receipt,
so the edge is marked done and skipped on the run that should have applied it. `--rerun`
executes it anyway. This is tracked upstream as `mori://shinzui/seihou`'s IR-1 and is
documented in the ADR blueprint's README; mention it in the new blueprint's README too.


## Interfaces and Dependencies

**Hard dependencies on EP-3, EP-4, and EP-5.** All three must be Complete. This plan reads
their Outcomes & Retrospective sections as its primary source and cannot be written from the
profile diffs alone.

**`seihou` 0.6.0.0 or later** for `new-blueprint`, `validate-blueprint`, and
`seihou agent --debug migrate` / `run`. **`okf` 0.5.0.0 or later** and **`dhall` ≥ 1.42** for
the rehearsal and the descriptor freezes.

**The Seihou blueprint schema**, imported by pinned URL in each `blueprint.dhall`. The existing
blueprint pins
`https://raw.githubusercontent.com/shinzui/seihou-schema/0e1b875efcf2b4e4b98d93595ea627290459e3ad/package.dhall`.
Use whatever pin `seihou new-blueprint` scaffolds for the new blueprint; if it differs from the
existing one, do **not** change the existing blueprint's pin as a side effect — note the
divergence in Surprises & Discoveries and let EP-7 decide whether to reconcile.

**Files this plan owns for its duration**:

```text
blueprints/adopt-architecture-decisions/**
blueprints/migrate-okf-bundles-to-v0-2/**   (new)
```

**Files this plan must not edit**: `seihou-registry.dhall`, `mori.dhall`, `README.md`,
anything under `profiles/`, `Profile/`, `fixtures/`, or `scripts/`.

**What EP-7 needs from this plan.**
`docs/plans/7-release-okf-profiles-v0-8-0-and-dogfood-the-migrated-adr-profile.md` registers
both blueprints and cuts the tag. State explicitly in Outcomes & Retrospective:

1. The new blueprint's exact `name`, `version`, `description`, and `tags`, so EP-7 can write
   the `seihou-registry.dhall` and `mori.dhall` entries without re-reading the Dhall.
2. Every file shipping a `v0.8.0` pinned import whose hash is still a placeholder, by full
   path, so EP-7 freezes each one immediately after cutting the tag. Getting this list wrong
   ships a blueprint that cannot resolve its own descriptor.
3. Whether the ADR blueprint's shipped descriptor still carries the presence-class override.
