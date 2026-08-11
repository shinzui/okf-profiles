# Changelog

All notable changes to this project are documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Consumers pin a tag, so every entry states what breaks for a corpus governed by
these profiles and how to migrate it.

## [0.10.0] — 2026-08-11

**Adds `coordination.bugReports`: defects in behavior a repository already
provides.** Nothing existing changes — this release is purely additive, so a
corpus governed by 0.9.x needs no migration and can repin at leisure.

### Added

- **`coordination.bugReports`** — one concept per defect, with a bundle-scoped
  `BUG-N` handle, the `mori://` projects that observed it and that own it, the
  version it was seen in, an `observed` / `expected` pair, and **required
  `reproduction`**: ordered steps a reader can follow. It is the fourth corner of
  the coordination family — a use case states what a consumer needs, a capability
  states what a producer provides, an improvement request states the gap, and a
  bug report states that a capability which is claimed does not hold.

  Four decisions are load-bearing and worth knowing before adopting it:

  - **Behavior that was never provided is not a bug.** It is an improvement
    request. This is the line that keeps the two profiles apart, and it is why
    `expected` asks on whose authority the expectation rests — a guide, a
    capability, a test.
  - **`severity` is an observable consequence, not a priority.** `data-loss` /
    `unusable` / `degraded` / `cosmetic`, assigned by what happens to a consumer
    rather than by how much the reporter minds. `data-loss` outranks `unusable`
    deliberately: an outage is visible and a silently wrong number is not.
    Priority weighs severity against reach and schedule, differs per consumer,
    and has no place in a cross-repository record.
  - **Every terminal status demands `resolution` under `--strict`**, and
    `status: fixed` additionally demands `fixedVersion` via a `when` condition. A
    report whose closing reason lives only in a chat log is the failure mode
    worth catching; `duplicate` likewise demands `duplicateOf`, which resolves as
    a local `BUG-N` handle or an external `mori://` URI.
  - **`workaround` is demanded once `severity` is `degraded`**, because
    `degraded` is *defined* as the grade where one exists. A degraded report that
    names none is either incomplete or mis-graded.

  Two notes for authors. `origin` and `affects` are separate keys and differ in
  exactly the case this family exists for — a consumer reporting a defect in a
  dependency — so a corpus can be read from either end. And `capability` takes a
  Mori URI rather than a `CAP-N` handle reference: okf resolves a local handle
  against the bundle's own ID index and ties every reference prefix to a type the
  profile declares, so a catalog in another repository is only ever addressable
  externally.

- `scripts/test-bug-reports-profile.sh` plus `fixtures/bug-reports/` and
  twenty-six single-reason rejection fixtures.

- **`docs/profiles/`** — one OKF bundle per published profile, generated from
  the profile itself by `okf profile document`: the settings, the profile-wide
  frontmatter rules, and a page per concept type showing that type's rules
  merged with the profile-wide ones, which is the form that actually applies.
  Every field description comes from the `description` on the rule, so these are
  regenerated rather than edited.

  `scripts/test-profile-docs.sh` joins the `scripts/` loop as a staleness gate:
  it regenerates into a temporary directory and diffs, so a profile change that
  lands without regenerated documentation goes red. Generation reads no clock —
  `generated.at` is omitted and `generated.by` is the tool's stable `process:`
  actor — which is what makes the diff meaningful.

- **A `justfile`** as a front door onto the existing checks: `just check` is what
  a release has to pass, `just docs` regenerates the documentation, and
  `just types` / `just test` are the two halves. Nothing is only runnable through
  `just`.

### Migration

None. `coordination.bugReports` is a new export; every existing export is
untouched.

## [0.9.3] — 2026-08-08

### Changed

- **`adopt-capabilities`: a decidable test for when growth earns a new record.**
  0.9.1 said to record material growth as a new capability but never said where
  minor growth ends and material growth begins, so two runs answered
  differently: one split a reintroduced feature into its own record, another kept
  `since` at the earliest form and described the evolution in the body.

  The test is now one question — *could a consumer pinned to the older release
  still do the thing this record describes?* If the thing is impossible for them,
  split; if they can do it just less well, keep one record and describe the
  evolution in the body. Ties go to the same record: an over-split catalog reads
  as a changelog with handles.

  Both earlier judgments are defensible under this test, so no existing corpus is
  invalidated. Blueprint-only; the profile is unchanged from 0.9.0 and no bundle
  needs repinning.

## [0.9.2] — 2026-08-08

### Changed

- **`adopt-capabilities`: `since` now has a fixed three-value vocabulary** —
  a bare version, `unreleased`, or `unknown` with the reason explained in the
  record body. The profile cannot constrain the field (it is free text), and the
  first two independent authors produced two different spellings for the same
  situation: one wrote `undetermined`, the other picked a conservative release
  and explained it in prose. Neither is wrong; having both is.

  The reference now also forbids commentary appended to a version — a value like
  `"0.10.0.0 (reintroduced; removed in 0.9.0.0)"` is accurate but destroys the one
  field a consumer compares mechanically. That history belongs in the body, and a
  reintroduced capability takes its own record with the reintroducing release as
  `since`.

  Blueprint-only; the profile is unchanged from 0.9.0 and no bundle needs
  repinning.

## [0.9.1] — 2026-08-08

### Added

- **`adopt-capabilities` blueprint** — agent-driven adoption of
  `coordination.capabilities` in a target repository:

  ```bash
  seihou agent run adopt-capabilities
  ```

  Unlike `adopt-architecture-decisions`, which adapts an existing corpus, this
  blueprint **authors** from repository evidence — source, tests, docs, release
  history. Fabrication is therefore the central risk, and the prompt is built
  around three containment rules: evidence or it does not exist; provision, not
  composition; and one capability is one thing a consumer adopts *and* verifies
  independently.

  A repository with no consumer-facing surface finishes successfully without
  creating a bundle, so plan-module upgrades can invoke it across a fleet.
  Re-running against an adopted repository is an idempotent reconciliation.

  The profile itself is unchanged from 0.9.0; the pinned descriptor the blueprint
  installs points at the 0.9.0 profile.

## [0.9.0] — 2026-08-08

**Adds `coordination.capabilities`: a catalog of what a repository provides
today.** Nothing existing changes — this release is purely additive, so a corpus
governed by 0.8.0 needs no migration and can repin at leisure.

### Added

- **`coordination.capabilities`** — one concept per capability, with a
  bundle-scoped `CAP-N` handle, the `mori://` project that provides it, the
  release it arrived in, and **required `evidence`**: artifacts a reader can open
  to check the claim. It completes the coordination family's triangle — a use
  case states what a consumer needs, a capability states what a producer
  provides, and an improvement request states the gap between them.

  Three decisions are load-bearing and worth knowing before adopting it:

  - **There is no `planned` status.** `status` is `shipped` / `deprecated` /
    `withdrawn` only. A capability that does not exist yet is an improvement
    request, not a capability record with a hopeful label. Combined with required
    `evidence`, this is what stops the catalog drifting into a roadmap.
  - **`stability` is separate from `status`.** Availability and compatibility are
    different questions: a shipped capability in a pre-1.0 project is usable
    *and* unstable, and a consumer choosing a dependency needs both answers.
  - **`replacedBy` is required once `status` is `deprecated` or `withdrawn`**,
    via a `when` condition. A retirement with no forward path is the failure mode
    worth catching; a live capability has nothing to say there.

  Two notes for authors. `evidence[].resource` is an unchecked scalar rather than
  an okf `path` rule, because a path rule resolves against the bundle's own
  concept tree and capability evidence is inherently repository-wide — test
  modules, package targets, guides outside the bundle; resolve them with a
  repository-local check. And `requires` produces no graph edge on its own, since
  okf derives edges from Markdown body links only, so mirror each entry as a body
  link.

  The profile was shaken out against three repositories before release — a
  standalone framework, a portfolio service, and a large multi-package CLI — and
  needed no new field across the three.

- `scripts/test-capabilities-profile.sh` plus `fixtures/capabilities/` and
  thirteen single-reason rejection fixtures, one per load-bearing rule.

### Migration

None. `coordination.capabilities` is a new export; every existing export is
untouched.

## [0.8.0] — 2026-08-02

**The catalog moves from Open Knowledge Format v0.1 to v0.2 and now requires
okf 0.5.0.0 or later.** OKF v0.2 assumes a corpus written and maintained by
agents and adds the frontmatter a reader needs to judge machine-written
knowledge: provenance, trust, and an explicit bundle dialect declaration.

### Changed

**Migrate with one of the two blueprints below; do not hand-edit a large
corpus.** Both are agent-driven and detect what your repository actually has:

```bash
seihou agent migrate adopt-architecture-decisions --from 0.7.0 --to 0.8.0
seihou agent run migrate-okf-bundles-to-v0-2
```

Breaking, in the order you will meet them:

- **`generated` is now demanded on every profile** — required on the five
  documentation and coordination profiles, recommended on the two PostgreSQL
  ones. It is a mapping whose `by` member must match OKF v0.2 §7's actor
  convention (`human:<id>`, `process:<id>`, or `<producer>/<version>`) and whose
  `at` is an RFC3339 UTC instant. Derive `at` from the document's existing
  `timestamp` rather than restamping to now — `generated.at` is what supersedes
  it, and `okf log` coverage now reads it in preference.
- **Every bundle must declare its dialect.** All profiles set
  `requireBundleVersion = Some "0.2"`, so a bundle whose root `index.md` does not
  declare `okf_version: "0.2"` is a profile deviation. Fix with
  `okf index <bundle> --write --okf-version 0.2`.
- **`sources` changed shape on `documentation.patternCatalog` and
  `documentation.researchDocuments`.** It was a bare list of strings; it is now
  the OKF v0.2 list of records whose `resource` member is required.
  `sources: [X]` becomes `sources: [{resource: X}]`.
- **The minimum `okf` moves from 0.4.0.0 to 0.5.0.0.** `Profile/okf.dhall` pins
  the okf 0.5.0.0 release commit.

Not breaking, and in your favour:

- **`timestamp` is demoted to `optional`, not removed.** Keep it. Its
  RFC3339-UTC format is still checked; its absence is never reported, in any
  mode. Deleting the key across a corpus is unnecessary churn.
- **Several previously-`recommended` fields moved to `optional`**, so a corpus
  that omits them stops failing `--strict`: `supersedes`, `supersededBy`, and
  `originatingPlan` on `documentation.architectureDecisions`; `sources` and
  `supersedes` on `documentation.patternCatalog`; those plus `relatedPlans` and
  `relatedDecisions` on `documentation.researchDocuments`; `targetPlan` on
  `coordination.improvementRequests`; `timestamp` on both PostgreSQL profiles.
  If you carry a local descriptor override reclassifying any of them, you can
  now delete it.
- **The `adopt-architecture-decisions` blueprint's shipped descriptor is now a
  plain pinned import.** The presence-class override it installed at v0.7.0 was
  folded upstream and is a no-op; the migration edge deletes it for you.

**`status` did not change on five profiles, and this matters.**
`documentation.architectureDecisions`, `documentation.patternCatalog`,
`documentation.researchDocuments`, `coordination.improvementRequests`, and
`coordination.useCases` keep their own lifecycle vocabulary on the `status` key
and deliberately do **not** adopt OKF v0.2 §5.4's `draft`/`stable`/`deprecated`.
Do not rewrite an ADR's `status: Accepted` to `status: stable`. Only `postgresql`
and `tanPostgresql` take OKF's vocabulary, because neither declares a house
`status` key.

### Added

- **`okfV02`** — a format-level reference profile carrying the six v0.2 families
  and no house conventions, for a team with no established profile of its own.
- **`v02`** — the six v0.2 field families as reusable `FieldRule` values
  (`generated`, `verified`, `status`, `staleAfter`, `sources`, `usageWindow`,
  plus `legacyTimestamp`), so a profile author splices them rather than
  re-authoring them.
- **`verified`** as an `optional` family on every profile. It records independent
  confirmation and is what `okf trust` derives a tier from. Where a corpus uses
  the house `reviews` family, mirror an approving entry into it — a human review
  as `human:<id>`, a model review as `process:<agent>`.
- **OKF `status` and `stale_after`** on `postgresql` and `tanPostgresql` only.
- **`migrate-okf-bundles-to-v0-2`** — a new Seihou blueprint that detects
  whichever profiled OKF bundles a repository has and migrates them all.
- **The full v0.2 descriptor vocabulary** re-exported from `package.dhall`:
  `Profile.requireBundleVersion`, `FieldRule.objectFields`, `FieldRule.path`,
  the `PathReferenceRule` record, `FieldCondition`, and the `actor`,
  `human-actor`, `integer`, `non-negative-integer`, and `boolean` formats.
- **A fixture and a check for the base `postgresql` profile**, which had neither.
  The most-consumed export in this catalog was previously only validated against
  a sample bundle from a checkout of the `okf` repository.
- **`docs/adr/`** — this repository's own decisions, governed by its own
  architecture-decision profile. `scripts/test-adr-bundle.sh` validates them, so
  the profile is regression-tested against a real corpus and not only a fixture.

### Fixed

- **`mori.dhall` and `seihou-registry.dhall` disagreed about the
  `adopt-architecture-decisions` blueprint version** — `0.1.3` against `0.7.0`.
  Both now say `0.8.0`. A blueprint's version tracks the `okf-profiles` tag it
  targets, because that tag is the only version a consumer can read off their own
  repository.
- **Rejection fixtures that failed for more than one reason**, and rules with no
  rejection fixture at all. Sweeping every rule showed several could have been
  deleted from a profile with the whole test suite still green. Twenty-seven
  rejection fixtures were added or repaired so that each fails for exactly one
  reason and every rule is load-bearing.
- **The README** described a catalog written for okf 0.4.0.0 and v0.1 rules, and
  told consumers to pin `v0.1.0`.

[0.8.0]: https://github.com/shinzui/okf-profiles/releases/tag/v0.8.0
