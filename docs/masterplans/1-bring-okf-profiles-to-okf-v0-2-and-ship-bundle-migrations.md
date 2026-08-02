---
id: 1
slug: bring-okf-profiles-to-okf-v0-2-and-ship-bundle-migrations
title: "Bring okf-profiles to OKF v0.2 and ship bundle migrations"
kind: master-plan
created_at: 2026-08-01T23:39:44Z
---

# Bring okf-profiles to OKF v0.2 and ship bundle migrations

This MasterPlan is a living document. The sections Progress, Surprises & Discoveries,
Decision Log, and Outcomes & Retrospective must be kept up to date as work proceeds.
If durable project context changes, update or create ADRs in docs/adr/ in the same change.


## Vision & Scope

This repository publishes seven Dhall "profiles". A profile is a declarative description of
how one team uses the Open Knowledge Format (OKF): which `type:` strings are allowed, which
frontmatter keys every concept must carry, what shape each key's value must have, and where
each type's files live. Downstream repositories import a profile by pinned URL and check
their documentation bundles against it with `okf validate --profile`.

The upstream `okf` tool released 0.5.0.0 on 2026-08-01, and that release implements **OKF
v0.2**. OKF v0.2 assumes a corpus written and maintained by agents, and it adds the
frontmatter a reader needs to judge machine-written knowledge: provenance (`sources`,
`usage_window`), trust (`generated`, `verified`), and lifecycle (`status`, `stale_after`),
plus an actor naming convention (`human:<id>`, `process:<id>`, `<producer>/<version>`). It
also supersedes the v0.1 `timestamp` key with `generated.at`.

Every profile in this repository is still written for OKF v0.1. All seven declare
`okfVersion = "0.1"` (by taking the schema default), and all seven ask for a `timestamp` key
that v0.2 retired — five as a required field, and `postgresql` plus the `tanPostgresql` that
inherits from it as a recommended one. None of them describes a single v0.2 family. Meanwhile
`Profile/okf.dhall` — the one place this repository pins upstream's schema — points at okf
0.4.0.0, so the v0.2 descriptor features (`objectFields`, `path` rules, the `actor` format,
`requireBundleVersion`) are not even expressible here yet.

**After this initiative is complete:**

- `Profile/okf.dhall` pins okf 0.5.0.0, and the root `package.dhall` exports the full v0.2
  descriptor vocabulary, so a downstream author can write a v0.2 rule without reaching past
  this package into okf.
- All seven profiles declare `okfVersion = "0.2"`, require the `generated` provenance
  family with an `actor`-checked `by` member, demote `timestamp` to the `optional` list so
  legacy corpora keep validating, and set `requireBundleVersion = Some "0.2"` so an adopting
  bundle is pushed to declare the dialect it targets.
- A new export, `okfV02`, ships a format-level reference profile for the v0.2 families,
  mirroring okf's own `docs/profiles/okf-v0-2.dhall`, so a team with no house conventions can
  still check that its v0.2 frontmatter is well formed.
- Every fixture bundle under `fixtures/` carries a root `index.md` declaring
  `okf_version: "0.2"` and v0.2 provenance frontmatter, and every script under `scripts/`
  runs `--strict` in addition to `--profile-enforce`, so the repository proves the new rules
  rather than asserting them.
- Two Seihou blueprints let a consumer repository migrate its own bundles: a new
  `0.7.0 -> 0.8.0` edge on the existing `adopt-architecture-decisions` blueprint, and a new
  cross-family `migrate-okf-bundles-to-v0-2` blueprint that detects whichever profiled
  bundles a repository has and migrates them all.
- The repository dogfoods its own architecture-decision profile: `docs/adr/` becomes a
  profile-governed OKF bundle holding this initiative's decision records.

**Explicitly out of scope:**

- **OKF v0.2's `Attested Computation` concept type (§10).** okf 0.5.0.0 reads it, but no
  profile in this catalog documents computations, and inventing a house convention for a
  concept type nobody here produces would be speculative. A future release adds it when a
  consumer needs it. See the Decision Log.
- **Renaming the house `status` key.** Five profiles use `status` for a house lifecycle
  vocabulary (`Accepted`, `proposed`, `active`, `current`, `validated`) that collides with
  OKF v0.2 §5.4's `draft`/`stable`/`deprecated`. The user chose to keep the house key. See
  the Decision Log for the rationale and the consequence.
- **Replacing the house `reviews` family with v0.2 `verified`.** `reviews` records far more
  than `verified` can (scope, outcome, provider, model, reasoning effort, evidence context).
  Both are declared; neither replaces the other.
- **Changes to okf itself.** okf owns the schema; this repository consumes it. The import is
  one-way and stays that way.


## Decomposition Strategy

### ADRs consulted

`docs/adr/` does not exist in this repository, and no ADR corpus of any kind is present —
verified by listing the repository root, which holds no `docs/` directory at all. **There
are therefore no local ADRs to carry into this MasterPlan.** Creating that corpus is a
deliverable of EP-7, which dogfoods the migrated architecture-decision profile by turning
`docs/adr/` into a profile-governed OKF bundle holding this initiative's decisions.

Two cross-repository decision corpora were checked through Mori. The owning project of the
schema this repository consumes is `mori://shinzui/okf`, whose ADRs live at
`docs/adr/` in that checkout. Four are directly relevant and are summarized here so child
plans do not have to re-derive them:

- **okf ADR 7, the v0.1 legacy fallback policy** (`mori://shinzui/okf` at
  `docs/adr/7-okf-v0-1-legacy-fallback-policy.md`; artifact-level URI pending). okf reads
  `timestamp` whenever `generated` is absent, silently, with no removal horizon. This is why
  demoting `timestamp` to `optional` rather than deleting the rule is safe: an unmigrated
  corpus keeps validating.
- **okf ADR 8, derived-not-stored trust and credibility** (`mori://shinzui/okf` at
  `docs/adr/8-derived-not-stored-trust-and-credibility.md`; artifact-level URI pending).
  Trust tiers are computed on every read from `verified` and are never written into a
  bundle. No profile here should declare a `trust` key.
- **okf ADR 10, OKF version declaration and best-effort reading** (`mori://shinzui/okf` at
  `docs/adr/10-okf-version-declaration-and-best-effort-reading.md`; artifact-level URI
  pending). A bundle's `okf_version` declaration is optional per specification §12, so okf
  never demands one; a profile may, through `requireBundleVersion`. This is the mechanism
  EP-3 through EP-5 use.
- **okf ADR 13, the references convention and non-Markdown files** (`mori://shinzui/okf` at
  `docs/adr/13-the-references-convention-and-non-markdown-files.md`; artifact-level URI
  pending). A `.md` file under `references/` is an ordinary concept needing a `type`; other
  files are only ever the target of a path. Relevant only if a future profile adopts path
  rules against a `references/` tree.

The second corpus is `mori://shinzui/seihou`, which owns the blueprint and migration
machinery EP-6 uses. Its `IR-1` — recorded in this repository's own
`blueprints/adopt-architecture-decisions/README.md` — asks for a "not applicable" migration
outcome distinct from success and provider failure. EP-6 must work within its absence: a
blueprint edge that deliberately refuses still records a completion receipt, so a consumer
needs `--rerun` to apply it later.

### How the work was split

The decomposition follows the dependency structure the Dhall type system imposes, not the
file layout. Three facts drive it, each verified empirically against okf 0.5.0.0 before this
plan was written:

**Fact one: the schema pin gates everything.** `Profile/okf.dhall` is the single URL and
integrity hash in this repository; every other Dhall file takes its record *types* from
there. The v0.2 descriptor features do not exist in the pinned 0.4.0.0 schema, so no profile
can express a v0.2 rule until the pin moves. That is one indivisible change with a clean
acceptance test (every existing profile still type-checks, every existing script still
passes), and it becomes **EP-1**.

**Fact two: `okfVersion` is now compile-checked against the rules a profile declares, and
the check is bidirectional.** This is new in okf 0.5.0.0 and is the single most consequential
constraint in the initiative. Probing the installed binary confirms both directions:

```text
$ okf validate ./bundle --profile probe.dhall
Failed to load profile probe.dhall: invalid profile definition:
  - profile frontmatter: declared okfVersion 0.2 supersedes the frontmatter key timestamp
    (OKF 0.2); move it to the optional list or replace it with generated
```

```text
$ okf validate ./bundle --profile probe2.dhall
Failed to load profile probe2.dhall: invalid profile definition:
  - profile frontmatter: declared okfVersion 0.1 does not support the format actor at
    generated.by, which OKF 0.2 introduced
```

A profile therefore cannot adopt v0.2 halfway. Declaring `okfVersion = "0.2"` while
`timestamp` sits in `required` or `recommended` is a hard load failure; using the `actor`
format while still declaring `"0.1"` is equally fatal. Each profile flips atomically. That
makes a per-profile split natural and a per-feature split impossible.

**Fact three: the seven profiles share one description of the v0.2 families but nothing
else.** Writing `generated`, `verified`, `status`, `stale_after`, `sources`, and
`usage_window` seven times would guarantee drift between them. Those shared values become a
single module built once in **EP-2**, which also ships them as a standalone `okfV02`
reference profile so a consumer with no house conventions gets value from this release.

With the shared module in place, the remaining profile work splits cleanly along the
directory structure that already exists — `profiles/documentation/`,
`profiles/coordination/`, and the two flat PostgreSQL exports — because each group has its
own fixtures and its own test script and can be verified without the others. Those become
**EP-3**, **EP-4**, and **EP-5**, and they can run in parallel.

The consumer-facing migration work depends on knowing exactly what changed in each profile,
so it comes last as **EP-6**. The release surface — README, catalog table, `mori.dhall`,
`seihou-registry.dhall`, and the dogfooded `docs/adr` bundle — comes last of all as
**EP-7**, because a catalog table that lists minimum-okf versions can only be written once
the profiles are final.

### Alternatives considered and rejected

**One plan per profile (seven migration plans).** Rejected because the three documentation
profiles share fixtures conventions and one test-script pattern, and splitting them would
have produced seven plans that each repeat the same eight paragraphs of context for a
fifteen-minute edit. Grouping by directory keeps each plan independently verifiable — each
owns a complete `scripts/test-*.sh` run — without that repetition.

**One plan for all seven profiles.** Rejected because it serializes work that has no
dependency between its parts and because a single failure in, say, the `sources` shape
change would block unrelated PostgreSQL work.

**Folding EP-2's shared module into EP-1.** Rejected because EP-1 must prove that moving the
pin changes *nothing* observable — that is its whole acceptance criterion — and adding new
exported values in the same change destroys that signal.

**Skipping the `okfV02` reference profile.** Rejected because the shared field-family values
have to exist anyway for EP-3 through EP-5, and assembling them into a shipped profile costs
one small file plus one fixture while giving every consumer a zero-configuration way to check
v0.2 conformance.


## Exec-Plan Registry

| # | Title | Path | Hard Deps | Soft Deps | Status |
|---|-------|------|-----------|-----------|--------|
| 1 | Move the profile schema pin to okf 0.5.0.0 and widen the exported descriptor surface | docs/plans/1-move-the-profile-schema-pin-to-okf-0-5-0-0-and-widen-the-exported-descriptor-surface.md | None | None | Complete |
| 2 | Ship the shared OKF v0.2 field-family module and the okfV02 reference profile | docs/plans/2-ship-the-shared-okf-v0-2-field-family-module-and-the-okfv02-reference-profile.md | EP-1 | None | Complete |
| 3 | Migrate the documentation profiles to OKF v0.2 | docs/plans/3-migrate-the-documentation-profiles-to-okf-v0-2.md | EP-2 | None | Not Started |
| 4 | Migrate the coordination profiles to OKF v0.2 | docs/plans/4-migrate-the-coordination-profiles-to-okf-v0-2.md | EP-2 | EP-3 | Not Started |
| 5 | Migrate the PostgreSQL profiles to OKF v0.2 | docs/plans/5-migrate-the-postgresql-profiles-to-okf-v0-2.md | EP-2 | EP-3 | Not Started |
| 6 | Ship Seihou blueprint migrations for consumer OKF bundles | docs/plans/6-ship-seihou-blueprint-migrations-for-consumer-okf-bundles.md | EP-3, EP-4, EP-5 | None | Not Started |
| 7 | Release okf-profiles v0.8.0 and dogfood the migrated ADR profile | docs/plans/7-release-okf-profiles-v0-8-0-and-dogfood-the-migrated-adr-profile.md | EP-6 | None | Not Started |

Status values: Not Started, In Progress, Complete, Cancelled.
Hard Deps and Soft Deps reference other rows by their # prefix (e.g., EP-1, EP-3).


## Dependency Graph

```text
EP-1 ──▶ EP-2 ──┬──▶ EP-3 ──┐
                ├──▶ EP-4 ──┼──▶ EP-6 ──▶ EP-7
                └──▶ EP-5 ──┘
```

**EP-1 blocks everything.** It moves `Profile/okf.dhall` from okf 0.4.0.0 to okf 0.5.0.0 and
re-exports the schema types that release added. Until that lands, `objectFields`, `path`
rules, `PathReferenceRule`, the `actor` / `human-actor` / `integer` /
`non-negative-integer` / `boolean` formats, and `Profile.requireBundleVersion` are not in the
record types this repository imports, so a plan trying to use one gets a Dhall type error
rather than a validation result.

**EP-2 blocks EP-3, EP-4, and EP-5.** It creates `Profile/V02.dhall`, the single definition
of the six v0.2 frontmatter families. The three migration plans each import that module and
splice its values into their profiles' presence lists. Without it, each would author its own
`generated` rule, and the three would drift the first time one is corrected.

**EP-3, EP-4, and EP-5 are mutually independent and may run in parallel.** They touch
disjoint files: `profiles/documentation/*`, `profiles/coordination/*`, and
`profiles/postgresql.dhall` plus `profiles/tan-postgresql.dhall`. They touch disjoint
fixtures and disjoint scripts. The only file all three read is `Profile/V02.dhall`, which
EP-2 froze; none of them may edit it. If one must change a shared value, it stops, records
the need in this MasterPlan's Surprises & Discoveries, and the change is made in
`Profile/V02.dhall` and propagated to all three.

EP-4 and EP-5 carry a **soft** dependency on EP-3. EP-3 is the first plan to add a root
`index.md` to a fixture bundle, to add v0.2 provenance frontmatter to fixture concepts, and
to extend a `scripts/test-*.sh` with `--strict`. Doing EP-3 first means EP-4 and EP-5 copy an
established pattern rather than inventing three variants of it. This is a convenience, not a
correctness constraint: EP-4 or EP-5 can proceed first if EP-3 is blocked, and the plans say
so.

**EP-6 hard-depends on all three migration plans.** A migration edge tells a consumer exactly
which constraints changed and how to repair a corpus that now fails. That prose cannot be
written from a plan; it must be written from the finished profiles and from the actual
diagnostics the new rules produce. EP-6 runs each migrated profile against a deliberately
unmigrated fixture and quotes the real output.

**EP-7 hard-depends on EP-6.** The release notes and the README catalog table must describe
the blueprints as shipped, and the `seihou-registry.dhall` and `mori.dhall` template entries
must name blueprint versions that exist. EP-7 also creates `docs/adr/` as a profile-governed
bundle, which requires the architecture-decision profile in its final v0.8.0 form (EP-3) and
the migration guidance to be settled (EP-6).


## Integration Points

**`Profile/okf.dhall` — the upstream schema pin.** Owned by **EP-1**. It is the only file in
this repository containing a remote URL and a `sha256:` integrity hash. Every plan reads the
schema types through it, directly or through the sibling re-export files under `Profile/`.
No plan other than EP-1 may edit it. EP-1 sets it to okf commit
`2e34d3042f0a919ed4f2c9d2db5fb89a139e25ee`, which is the commit tag `v0.5.0.0` points at,
and re-freezes the hash with `dhall freeze --inplace`. A hand-written hash is never
acceptable.

**Root `package.dhall` — the public export surface.** Defined by **EP-1**, extended by
**EP-2**, read by every consumer of this repository. EP-1 adds the schema types okf 0.5.0.0
introduced that this package does not yet re-export: `PathReferenceRule` and
`FieldCondition`. EP-2 adds the `okfV02` profile export and the `v02` field-family module.
EP-3 through EP-5 must not change it. EP-7 verifies the final shape type-checks and matches
the README catalog. Existing flat exports (`postgresql`, `tanPostgresql`) and the two family
packages (`coordination`, `documentation`) keep their names and positions — a downstream
project pins this package by URL, and renaming an export breaks it silently at Dhall
evaluation time.

**`Profile/V02.dhall` — the shared v0.2 field-family module.** Owned by **EP-2**, consumed
read-only by **EP-3**, **EP-4**, and **EP-5**. It exports named `FieldRule` values for
`generated`, `verified`, `status`, `staleAfter`, `sources`, and `usageWindow`, plus the
`trustMembers` `NestedRules` value that `generated` and `verified` share. The three consuming
plans splice these into their own presence lists and may override a description with the
`//` operator, but must not redefine the constraint. If a consuming plan needs a different
constraint, that is a signal the shared value is wrong: stop, record it in this MasterPlan's
Surprises & Discoveries, fix `Profile/V02.dhall`, and re-verify all three.

**The `okfVersion` / `timestamp` / `actor` triangle.** A cross-cutting constraint every
migration plan must honour identically. Declaring `okfVersion = "0.2"` on a profile is only
legal when `timestamp` appears in the `optional` list or not at all; using the `actor` format
anywhere in a profile is only legal when that profile declares `"0.2"`. The two halves must
land in the same edit to a profile, and a profile is never left in an intermediate state
across a commit. This deserves an ADR — it is a durable constraint on how any future profile
in this catalog is written, not a fact about this initiative.

**`requireBundleVersion` and fixture `index.md` files.** Every migrated profile sets
`requireBundleVersion = Some "0.2"`, which makes a bundle without a root `index.md` declaring
`okf_version: "0.2"` a profile deviation — and therefore a hard failure under
`--profile-enforce`, which every `scripts/test-*.sh` passes. The fixtures under `fixtures/`
currently have **no `index.md` at any level**, verified by search. Every migration plan must
therefore run `okf index <fixture> --write --okf-version 0.2` on both its valid and its
invalid fixture bundles, or the pre-existing tests break. This is the single most likely
cause of a confusing red test during EP-3 through EP-5, and each plan states it explicitly.

**The house `status` key versus OKF v0.2 §5.4 `status`.** A deliberate, documented
divergence affecting `documentation.architectureDecisions`,
`documentation.patternCatalog`, `documentation.researchDocuments`,
`coordination.improvementRequests`, and `coordination.useCases`. Those five keep their house
vocabulary on the `status` key and do **not** declare OKF's `status` or `stale_after`. The
two PostgreSQL profiles and the `okfV02` reference profile have no collision and do declare
both. EP-2 owns writing this down; EP-3 and EP-4 apply it; EP-5 applies the non-colliding
branch. This is durable project context and becomes an ADR.

**The house `reviews` family versus OKF v0.2 `verified`.** `Profile/ReviewRule.dhall` is
shared by `coordination.improvementRequests`, `coordination.useCases`, and
`documentation.researchDocuments`. It is a rich human/model review record. OKF `verified` is
a two-member trust record. EP-3 and EP-4 both declare `verified` as `optional` alongside
`reviews` and must describe the relationship identically in their profile descriptions. This
is an ADR-worthy interface decision because a consumer has to know which to write.

**`blueprints/adopt-architecture-decisions/files/architecture-decisions-profile.dhall`.**
Currently pins `okf-profiles` v0.7.0 and layers an override that reclassifies `supersedes`,
`supersededBy`, and `originatingPlan` from `recommended` to `optional`. **EP-3 should fold
that reclassification upstream into the shipped profile**, because the override exists only
to work around a defect in this catalog: under `--strict` a recommended-and-absent field is
an error, and essentially no real ADR corpus records all three. EP-6 then updates the shipped
file to pin v0.8.0 and, if EP-3 folded the reclassification upstream, deletes the override
and says so in the migration edge. EP-3 records what it did; EP-6 reads that record.

**`mori.dhall` and `seihou-registry.dhall` — blueprint and template registration.** Both
carry a `version` for the `adopt-architecture-decisions` blueprint (`0.1.3` in `mori.dhall`'s
`templates`, `0.7.0` in `seihou-registry.dhall`'s `blueprints` — they disagree today, which
EP-7 must reconcile). EP-6 adds the new blueprint; EP-7 registers it in both files and adds
`DocRef` entries for the new documentation. Neither file is touched by EP-1 through EP-5.


## Progress

- [x] EP-1: `Profile/okf.dhall` pins okf 0.5.0.0 with a freshly frozen hash (2026-08-01)
- [x] EP-1: `PathReferenceRule` and `FieldCondition` re-exported from the root `package.dhall` (2026-08-01)
- [x] EP-1: all seven existing profiles type-check and all six `scripts/test-*.sh` pass unchanged (2026-08-01)
- [x] EP-2: `Profile/V02.dhall` defines the six shared v0.2 field families (2026-08-01)
- [x] EP-2: `okfV02` reference profile exported and covered by a fixture plus a test script (2026-08-01)
- [x] EP-2: `status`-collision and `reviews`-versus-`verified` policies written down (2026-08-01)
- [ ] EP-3: `documentation.architectureDecisions` declares `okfVersion = "0.2"` and passes `--strict`
- [ ] EP-3: `documentation.patternCatalog` migrated, including the `sources` shape change
- [ ] EP-3: `documentation.researchDocuments` migrated, including the `sources` shape change
- [ ] EP-3: documentation fixtures carry root `index.md` files and v0.2 provenance
- [ ] EP-4: `coordination.improvementRequests` migrated and passing `--strict`
- [ ] EP-4: `coordination.useCases` migrated and passing `--strict`
- [ ] EP-4: coordination fixtures carry root `index.md` files and v0.2 provenance
- [ ] EP-5: `postgresql` and `tanPostgresql` migrated, including OKF `status` and `stale_after`
- [ ] EP-5: PostgreSQL fixtures carry root `index.md` files and v0.2 provenance
- [ ] EP-6: `0.7.0 -> 0.8.0` migration edge added to `adopt-architecture-decisions`
- [ ] EP-6: `migrate-okf-bundles-to-v0-2` blueprint authored and validated
- [ ] EP-6: both blueprints dry-run cleanly with `seihou agent --debug`
- [ ] EP-7: `docs/adr/` exists as a profile-governed bundle holding this initiative's ADRs
- [ ] EP-7: README, catalog table, `mori.dhall`, and `seihou-registry.dhall` reconciled
- [ ] EP-7: v0.8.0 release notes written and the tag cut


## Surprises & Discoveries

- **`okfVersion` is compile-checked in both directions as of okf 0.5.0.0**, which was not
  true in 0.4.0.0 and is the constraint the whole decomposition is built around. Verified
  against the installed `okf v0.5.0.0 (2e34d30)` binary before this MasterPlan was written;
  both diagnostics are quoted verbatim in Decomposition Strategy. The practical consequence
  is that a profile flips to v0.2 atomically — there is no partial adoption.

- **No fixture bundle in this repository has an `index.md`.** A search across `fixtures/`
  returns nothing. Since every migrated profile will set `requireBundleVersion = Some "0.2"`,
  and every `scripts/test-*.sh` passes `--profile-enforce`, this turns into a hard test
  failure the moment a profile is migrated, with a diagnostic that names no concept:

  ```text
  profile: bundle does not declare okf_version; this profile requires 0.2 or later
  ```

  The fix is one command per bundle, `okf index <dir> --write --okf-version 0.2`, and it is
  called out in EP-3, EP-4, and EP-5.

- **All six test scripts already pass on okf 0.5.0.0 with the 0.4.0.0 schema pin.** Verified
  by running each one. The v0.5.0.0 schema additions are defaulted, so record completion
  absorbs them and no existing value breaks. EP-1 is therefore expected to be a
  behaviour-preserving change, which is exactly what makes it a usable dependency gate.

- **`okf validate --strict` fails on the architecture-decision fixture today**, before any
  migration, because `supersedes`, `supersededBy`, and `originatingPlan` are `recommended`
  and absent. The `adopt-architecture-decisions` blueprint already ships a consumer-side
  override to work around this. That override is evidence the shipped profile is wrong;
  EP-3 should fix it upstream.

- **EP-1 confirmed the pin move is behaviour-preserving, in practice and not only in theory.**
  The before/after diff across all six test scripts was empty on the first attempt and the
  type-check sweep was clean, with no field losing its upstream default. The gate EP-2 through
  EP-7 build on is therefore verified green, and the exact `package.dhall` export record
  promised in EP-1's Interfaces and Dependencies is the one that landed —
  `PathReferenceRule` as `okf.defaults.PathReferenceRule`, `FieldCondition` as the bare
  `okf.FieldCondition`. EP-2 adds `v02` and `okfV02` to that record and must not disturb the
  rest of it. Verified 2026-08-01.

- **The stash-based "prove the old schema fails" technique in EP-1 Step 8 does not work once
  the export addition has landed**, because stashing only `Profile/okf.dhall` leaves
  `package.dhall` referencing `okf.defaults.PathReferenceRule` and the resulting error names
  the export, not the feature under test. Any later plan wanting to demonstrate that a pin bump
  delivered new vocabulary should instead import the old frozen URL and hash directly in a
  standalone one-line probe per feature. EP-1 did this and got three clean
  `Missing record field` errors on `okf.mk.NestedFieldRule.actor`, `okf.mk.FieldRule.record`,
  and `okf.PathReferenceRule`. This leaves the working tree untouched. Discovered 2026-08-01.

- **`dhall freeze --inplace` is deprecated as of dhall 1.42.3** — freezing is in-place by
  default and the flag now prints a warning. Every plan in this initiative that re-freezes an
  import should use plain `dhall freeze <file>`. EP-1 corrected the instruction embedded in
  `Profile/okf.dhall`'s own doc comment. Discovered 2026-08-01.

- **A sampled teeth-check hides untested rules; sweep every rule instead.** EP-2's plan asked
  for a load-bearingness check on `status` "and one other rule of your choice". Running it
  against all six rules revealed that two — `verified` and `usage_window` — had no invalid
  fixture at all, so the profile could have lost either rule with the test script still green.
  Two fixtures were added and all six are now load-bearing. **EP-3, EP-4, and EP-5 must apply
  the same full sweep**: delete each rule from the profile in turn and confirm
  `scripts/test-*.sh` fails. The mechanical form is a loop that restores a backup copy of the
  profile between iterations. Discovered 2026-08-01.

- **A v0.2 `generated.at` date needs an enclosing `log.md` covering it under `--strict`.**
  Adding provenance to EP-2's new fixture produced one core strict advisory per concept —
  `log: <concept>: generated date 2026-07-30 has no enclosing log.md`. These are core authoring
  checks, not profile deviations, so `--profile-enforce` still exits `0` and they are easy to
  dismiss as unrelated noise. `okf log add <bundle> --kind Migration -m "…" --date <date>`
  writes the file. **EP-3 through EP-5 will hit this on every fixture bundle they add
  provenance to**, alongside the separately-recorded `index.md` requirement. Two of the three
  existing acceptance bundles already carry a `log.md`; the dates in it must cover the
  `generated.at` values the migration introduces. Discovered 2026-08-01.

- **`Profile/V02.dhall` shipped with all ten exports the three migration plans expect**, so the
  EP-2 → EP-3/EP-4/EP-5 integration point is satisfied as specified: `trustMembers`,
  `generated`, `verified`, `status`, `staleAfter`, `sourceMembers`, `sources`,
  `usageWindowMembers`, `usageWindow`, and `legacyTimestamp`. The module is frozen for those
  three plans — consume read-only, override a `description` with `//` if needed, and never
  redefine a constraint. Verified 2026-08-01.

- **The two catalog-wide policies are written in `Profile/V02.dhall`'s header, not yet in an
  ADR, and EP-7 must promote them.** The house-`status` collision policy and the
  `reviews`-versus-`verified` policy are durable project context that belongs in `docs/adr/`,
  but that corpus does not exist until EP-7 creates it under the *migrated* architecture-decision
  profile. Writing it earlier would either duplicate EP-7's work or create the bundle under the
  unmigrated v0.1 profile. Both policies are therefore recorded in full, with reasoning, in the
  module header where EP-3 through EP-5 will read them. **EP-7 must promote both into
  `docs/adr/` and may cite `Profile/V02.dhall` as the source.** Recorded 2026-08-01.

- **`[] : List Profile.Type.frontmatter.required` is not valid Dhall** — a field type cannot be
  projected out of a record type (`Not a record or a union`). An empty presence list needs
  `[] : List okf.defaults.FieldRule.Type` (or `NestedFieldRule.Type` for nested rules). The
  migration plans will write empty presence lists too. Discovered 2026-08-01.

- **`mori.dhall` and `seihou-registry.dhall` disagree about the blueprint version** —
  `0.1.3` versus `0.7.0` for the same `adopt-architecture-decisions` blueprint. The
  blueprint's own README states the version is deliberately aligned with the `okf-profiles`
  tag, so `0.7.0` is correct and `mori.dhall` is stale. EP-7 reconciles them.


## Decision Log

- Decision: Keep the house `status` key on the five profiles that already use it, and do not
  declare OKF v0.2's `status` or `stale_after` on those profiles.
  Rationale: Chosen by the user on 2026-08-01 after being shown both options. OKF v0.2 §5.4
  gives `status` the vocabulary `draft`/`stable`/`deprecated`, which collides with the ADR,
  improvement-request, research, use-case, and pattern-catalog lifecycles already in the
  wild. okf's own profile guide explicitly sanctions the house reading — "a v0.1 profile
  declaring `field.enum "status" [ "proposed", "accepted", "superseded" ]` means an ADR
  lifecycle, not OKF v0.2's `status`" — and specification §11 requires nothing of the key.
  Renaming would break every consumer corpus, every cross-repository citation, and every
  downstream query for no conformance gain. The accepted consequence is that `okf trust`
  reports the house value verbatim as a non-standard status. Profiles with no collision
  (`postgresql`, `tanPostgresql`, `okfV02`) do adopt both keys.
  Date: 2026-08-01

- Decision: Ship one new cross-family blueprint (`migrate-okf-bundles-to-v0-2`) plus a
  `0.7.0 -> 0.8.0` edge on the existing `adopt-architecture-decisions` blueprint, rather than
  one blueprint per profile family.
  Rationale: Chosen by the user on 2026-08-01. Only `adopt-architecture-decisions` exists
  today; the other six profiles have no blueprint at all. Seven blueprints would multiply the
  authoring and version-maintenance surface roughly sixfold to express one shared migration —
  every family makes the same three changes (`generated` adopted, `timestamp` demoted,
  `okf_version` declared). One detecting blueprint plus one edge on the established path
  keeps the entry point a consumer already knows working, and gives the six unblueprinted
  families a first-class migration route.
  Date: 2026-08-01

- Decision: Keep the house `reviews` family and declare OKF `verified` alongside it as
  `optional`, rather than replacing one with the other.
  Rationale: `Profile/ReviewRule.dhall` records reviewer identity, review scope, outcome,
  serving provider, model identifier, reasoning effort, and evidence context. OKF `verified`
  records `by` and `at`. Neither is a superset. Deleting `reviews` would destroy information
  three profiles already collect; omitting `verified` would leave `okf trust` reporting every
  concept as `unverified` even where a human approved it. Both are declared, and each
  profile's description states that an approving `reviews` entry should be mirrored into
  `verified` so the derived trust tier is accurate.
  Date: 2026-08-01

- Decision: Exclude OKF v0.2's `Attested Computation` concept type (§10) from this
  initiative.
  Rationale: okf 0.5.0.0 reads the five contract keys (`runtime`, `parameters`,
  `computation`, `executor`, `attester`) and enforces §10.2 and §10.3 in strict mode, and a
  profile could constrain them with the new `objectFields` and `path` rules. But no profile
  in this catalog documents computations and no consumer has asked for one, so any convention
  written now would be invented rather than observed. The schema surface EP-1 exports makes
  it a small additive change whenever a consumer needs it.
  Date: 2026-08-01

- Decision: Demote `timestamp` to the `optional` presence list on every migrated profile
  rather than deleting the rule.
  Rationale: okf ADR 7 (`mori://shinzui/okf` at `docs/adr/7-okf-v0-1-legacy-fallback-policy.md`)
  guarantees `timestamp` is read whenever `generated` is absent, silently and with no removal
  horizon, so an unmigrated corpus keeps validating. `optional` is precisely the presence
  class for this: never reported when absent, in any mode, while its RFC3339-UTC format is
  still checked whenever it is present. Deleting the rule would let a malformed legacy
  timestamp through unnoticed during the exact window when corpora are half-migrated.
  Date: 2026-08-01

- Decision: Decompose into seven child plans grouped as one schema-pin plan, one shared-module
  plan, three parallel per-directory migration plans, one blueprint plan, and one release
  plan.
  Rationale: Recorded in full under Decomposition Strategy. The grouping follows the
  dependency structure Dhall and okf's compile-time checks impose, keeps each plan
  independently verifiable through an existing `scripts/test-*.sh`, and allows the three
  migration plans to run concurrently on disjoint files.
  Date: 2026-08-01

- Decision: Target release tag v0.8.0 for this initiative.
  Rationale: The current tag is v0.7.0. Moving the schema pin, promoting `generated` to
  required on seven profiles, and changing the `sources` value shape on two of them are all
  breaking for a consumer corpus. The repository's own README treats any change to the
  schema types under `Profile/` as breaking. The blueprint version is deliberately aligned
  with the `okf-profiles` tag, so the blueprints also become 0.8.0.
  Date: 2026-08-01


## Outcomes & Retrospective

(To be filled during and after implementation.)
