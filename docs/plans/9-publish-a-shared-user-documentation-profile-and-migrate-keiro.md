---
id: 9
slug: publish-a-shared-user-documentation-profile-and-migrate-keiro
title: "Publish a shared user-documentation profile and migrate Keiro"
kind: exec-plan
created_at: 2026-08-26T12:35:15Z
---

# Publish a shared user-documentation profile and migrate Keiro

This ExecPlan is a living document. The sections Progress, Surprises & Discoveries,
Decision Log, and Outcomes & Retrospective must be kept up to date as work proceeds.
If durable project context changes, update or create ADRs in docs/adr/ in the same change.


## Purpose / Big Picture

Projects currently keep user-facing reference pages under `docs/user/` and task-oriented
guides under `docs/guides/`, but those files have no shared identity, taxonomy, lifecycle, or
validation contract. After this change, any project can consume one published
`documentation.userDocumentation` profile from `mori://shinzui/okf-profiles`, and every adopted
page can be found and linked through a stable bundle-scoped `DOC-N` handle even when its file is
renamed or its documentation category changes.

Keiro, the first consumer at `mori://shinzui/keiro`, will expose `docs/user/` and `docs/guides/`
as two OKF bundles governed by that profile. A maintainer can run strict checks locally, use
`mori registry concepts` after observation to search the corpus and traverse links, and resolve
canonical concept URIs such as
`mori://shinzui/keiro/okf/user-documentation/concepts/DOC-1` without guessing a path.


## Progress

Use a checklist to summarize granular steps. Every stopping point must be documented here,
even if it requires splitting a partially completed task into two ("done" vs. "remaining").
This section must always reflect the actual current state of the work.

- [x] (2026-08-26T12:35Z) Research the current profile schema, catalog conventions, Keiro corpus,
  Mori profile bindings, and relevant ADRs.
- [x] (2026-08-26T12:35Z) Create this ExecPlan without an Intention link, as the user requested.
- [x] (2026-08-26T12:48Z) Add and fully test the shared
  `documentation.userDocumentation` profile, publish its
  generated documentation, register it in Mori metadata, and record its durable taxonomy in an ADR.
- [ ] Publish a tagged okf-profiles release containing the new export so consumers can use a
  reproducible remote import.
- [ ] Migrate Keiro's `docs/user/` and `docs/guides/` corpora, add their shared pinned descriptor,
  register both bundles, and wire strict validation into `just verify`.
- [ ] Observe Keiro and prove stable-ID lookup, cross-document links, search, trust metadata, and
  strict validation end to end.
- [ ] Complete the ADR distillation pass and record outcomes.


## Surprises & Discoveries

Document unexpected behaviors, bugs, optimizations, or insights discovered during
implementation. Provide concise evidence.

- Observation: Keiro's two target directories contain 50 existing Markdown pages, including two
  hand-curated `README.md` navigation pages and no YAML frontmatter. They are cleanly separable as
  two bundle roots; registering `docs/` itself would also ingest unrelated plans, ADRs, reviews,
  and research.
  Evidence: `rg --files docs/user docs/guides -g '*.md'` reports 25 user pages and 27 guide paths,
  of which the two `README.md` files are navigation pages, for 52 total concept candidates.
- Observation: the current released catalog stops at v0.12.0 both locally and in upstream Git
  tags, while the registry's published-profile projection lags some newer releases. The new
  profile therefore cannot be consumed reproducibly until a new tag is published.
  Evidence: `git describe --tags --abbrev=0` and `git ls-remote --tags
  https://github.com/shinzui/okf-profiles.git` both identify v0.12.0 as the newest tag.
- Observation: Keiro's pinned Mori schema already includes typed `profileBinding`, despite being
  older than the schema currently registered for Mori. The first consumer can therefore record a
  typed published-profile pin without upgrading its whole manifest schema.
  Evidence: `records/OkfBundle.dhall` at commit
  `e4899c15b6a7c36f5d6f2619c8a36ceabe58fc41` contains both `profile` and `profileBinding`.
- Observation: Stable ID validation deliberately emits two diagnostics for a missing or malformed
  `docId`: the profile-wide required/format rule and the per-type DOC ownership rule. Removing only
  the ID field and prefix makes the supersession rules invalid because reference prefixes must be
  owned by a declared ID family.
  Evidence: the negative-control profile failed compilation until `docId`, every type's `DOC`
  prefix, `idField`, and both DOC reference rules were removed as one composite policy unit. With
  that whole unit removed, `missing-doc-id` stopped rejecting as expected.


## Decision Log

Record every decision made while working on the plan.

- Decision: Publish one fleet-wide `documentation.userDocumentation` profile rather than a local
  profile for Keiro or one profile per repository.
  Rationale: Shared vocabulary is what makes cross-project search and agent authoring predictable;
  per-project copies would create profile drift and defeat Mori's published-pin tracking.
  Date: 2026-08-26
- Decision: Use the six reader-intent types `Navigation`, `Tutorial`, `Guide`, `Explanation`,
  `Reference`, and `Runbook`, all with the same `DOC-N` identifier prefix.
  Rationale: The categories distinguish routing, learning, task completion, conceptual
  understanding, lookup, and operational execution. A common prefix lets a document change type
  without changing its stable identity.
  Date: 2026-08-26
- Decision: Treat `generated`, `title`, `description`, `tags`, `docId`, and `type` as required;
  keep `sources`, `verified`, `status`, `stale_after`, `supersedes`, `supersededBy`, and the legacy
  `timestamp` optional.
  Rationale: Every well-run user-documentation page needs identity and search metadata, while
  provenance beyond authorship, independent confirmation, expiry, and replacement are meaningful
  only for some pages. The presence classes follow
  [ADR-8](../adr/0008-recommended-means-a-well-run-corpus-carries-it.md).
  Date: 2026-08-26
- Decision: Keep `docs/user/README.md` and `docs/guides/README.md` as `Navigation` concepts rather
  than replacing them with generated `index.md` prose.
  Rationale: Those pages contain curated reading routes and explanatory content. OKF's generated
  `index.md` remains a machine-maintained inventory alongside them.
  Date: 2026-08-26
- Decision: Register two Keiro bundles, `user-documentation` and `guides`, against one descriptor.
  Rationale: OKF bundle traversal has no include/exclude filter. Using `docs/` as the root would
  incorrectly absorb unrelated documentation corpora, while moving 52 public pages would create
  needless link churn.
  Date: 2026-08-26


## Outcomes & Retrospective

Summarize outcomes, gaps, and lessons learned at major milestones or at completion.
Compare the result against the original purpose. Before marking the plan complete,
distill durable project context from the Decision Log, Surprises & Discoveries, and
this section into docs/adr/. Keep task-local execution details here.

Milestone 1 produced the public `documentation.userDocumentation` export, six reader-intent types,
stable `DOC-N` identity, twenty focused rejection fixtures, a conforming six-page example, generated
profile documentation, Mori publisher metadata, changelog and catalog guidance, and
[ADR-11](../adr/0011-user-documentation-shares-reader-intent-types-and-doc-handles.md). `just check`
completed successfully, including `OK: 6 concepts (okf_version 0.2)` and
`OK: user-documentation profile acceptance and rejection fixtures`. Negative controls confirmed
that every authored policy unit is load-bearing; the stable identity plus supersession contract is
one composite unit rather than separable rules.


## Context and Orientation

This repository is the authoritative profile catalog. `package.dhall` exports its public Dhall
API; `profiles/documentation/package.dhall` groups documentation profiles; and
`profiles/documentation/pattern-catalog.dhall` is the nearest existing profile, but it governs
implementation-pattern catalogs rather than product user manuals. A profile is a Dhall value
decoded by okf-core. It declares allowed concept types, required and optional frontmatter,
stable document-handle rules, and path constraints. Projects import a tagged and semantic-hash-
pinned `package.dhall` value rather than copying profile source.

Every profile has a conforming fixture, focused rejection fixtures, a shell test under `scripts/`,
and reproducibly generated documentation under `docs/profiles/`. `scripts/test-profile-docs.sh`
contains the list of public exports to render. `mori.dhall` publishes profile identities and their
versions. `README.md` and `CHANGELOG.md` are the human-facing catalog and release contract.

Three local decisions constrain this work. [ADR-1](../adr/0001-house-status-diverges-from-okf-v0-2.md)
says a new profile with no pre-existing house lifecycle must adopt OKF v0.2 `status` and
`stale_after`. [ADR-8](../adr/0008-recommended-means-a-well-run-corpus-carries-it.md) reserves
`recommended` for fields whose absence is genuinely deficient. [ADR-9](../adr/0009-a-rejection-fixture-must-fail-for-exactly-one-reason.md)
requires focused rejection evidence and a load-bearing-rule sweep. No existing ADR chooses a
taxonomy or stable-identity policy for ordinary user documentation, so this plan must create one.

The first consumer is the separate project `mori://shinzui/keiro`. Its `docs/user/` tree has 25
Markdown files and its `docs/guides/` tree has 27. Both are flat, use an H1 title as the first
line, and have curated `README.md` entry points. `mori://shinzui/keiro` already registers five
other OKF bundles in `mori.dhall` and exposes strict gates from `Justfile`, but neither target
directory currently has frontmatter, reserved `index.md`/`log.md` files, a profile descriptor, or
a bundle declaration.

`DOC-N` means the literal prefix `DOC-` followed by one positive unpadded integer. It is stable
inside one bundle: moving or renaming the Markdown file does not change the value. Two bundles may
both own `DOC-1`; the canonical URI remains unambiguous because it includes project and bundle.


## Plan of Work

Milestone 1 adds the catalog contract. Create
`profiles/documentation/user-documentation.dhall` and export it as
`documentation.userDocumentation`. The profile targets and requires OKF 0.2, rejects unknown
types, uses `docId` as its ID field, leaves paths unconstrained so flat and nested corpora can share
the contract, and gives every type
the `DOC` prefix. Its profile-wide required rules are `type`, `title`, `description`, `docId`,
`tags`, and the shared `v02.generated` family. Optional rules splice `v02.sources`,
`v02.usageWindow`, `v02.verified`, `v02.status`, `v02.staleAfter`, and `v02.legacyTimestamp`, plus
typed `supersedes` and `supersededBy` references that accept local `DOC-N` handles or external
`mori://` URIs. Add a representative fixture and focused rejection fixtures, then add
`scripts/test-user-documentation-profile.sh`. Register the generated-doc export, publish its Mori
profile metadata, update `README.md` and `CHANGELOG.md`, regenerate `docs/profiles/`, and create a
profile-governed ADR describing the shared taxonomy and identity policy. The milestone is complete
when `just check` passes and removing any policy rule makes a targeted fixture fail to reject.

Milestone 2 publishes the profile. Prepare the next additive catalog release after v0.12.0,
commit it, tag it, push the commits and tag, and verify the remote `package.dhall` semantic hash.
Update the release metadata and generated documentation before tagging. Publishing is an external
state change and requires explicit user approval immediately before push/tag publication. The
milestone is complete when the immutable tag is visible upstream and a clean Dhall import of
`documentation.userDocumentation` resolves by tag and hash.

Milestone 3 migrates `mori://shinzui/keiro`. Add one frozen selector at
`mori/user-documentation-profile.dhall` importing the release from Milestone 2. Add frontmatter to
every target page without changing its body: preserve the H1 as `title`, assign one primary reader
intent, write a concise description, allocate stable `DOC-N` handles independently per bundle,
add useful search tags, and set `generated.by` to `human:nadeem`. Derive `generated.at` from each
file's most recent meaningful Git commit and normalize it to UTC rather than pretending the
metadata migration rewrote the prose. Generate `index.md` and add a scoped `log.md` to each
bundle. Extend `mori.dhall` with both bundles and typed published-profile bindings. Add
`user-documentation-validate` to `Justfile` and make `verify` depend on it. This milestone is
complete when both bundles pass strict profile and log enforcement and existing documentation
links still resolve.

Milestone 4 proves the registry behavior. Run Mori's non-mutating manifest checks, then observe
Keiro so the registry indexes the two new bundles. Demonstrate exact `DOC-N` lookup, search by a
public topic, link traversal between the user and guide bundles where applicable, and canonical
`mori path` resolution. Re-run the Keiro documentation gates and inspect the final diffs. Record
the evidence here and in Outcomes & Retrospective, then perform the final ADR distillation pass.


## Concrete Steps

From `/Users/shinzui/Keikaku/bokuno/okf-profiles`, implement and validate the profile:

```bash
dhall type --file profiles/documentation/user-documentation.dhall
okf profile show --no-local --registry ./package.dhall documentation.userDocumentation
bash scripts/test-user-documentation-profile.sh
just docs
just check
```

The focused test must finish with output shaped like:

```text
OK: 6 concepts (okf_version 0.2)
OK: user-documentation profile acceptance and rejection fixtures
```

Allocate and validate the catalog ADR using the repository's existing descriptor:

```bash
okf id next docs/adr --profile docs/adr/profile.dhall ADR
okf validate docs/adr --strict --profile docs/adr/profile.dhall --profile-enforce --log-enforce
```

After explicit publication approval, verify the new upstream tag rather than relying on the local
tag alone:

```bash
git ls-remote --tags https://github.com/shinzui/okf-profiles.git
dhall freeze --inplace /tmp/user-documentation-profile.dhall
dhall type --file /tmp/user-documentation-profile.dhall
```

From `/Users/shinzui/Keikaku/bokuno/keiro`, validate the migrated consumer:

```bash
dhall type --file mori/user-documentation-profile.dhall
okf validate docs/user --strict --profile mori/user-documentation-profile.dhall --profile-enforce --log-enforce
okf validate docs/guides --strict --profile mori/user-documentation-profile.dhall --profile-enforce --log-enforce
okf graph docs/user --json
okf graph docs/guides --json
just user-documentation-validate
dhall type --file mori.dhall
```

After observation, prove the registered behavior:

```bash
mori registry concepts shinzui/keiro --bundle user-documentation
mori registry concepts --id DOC-1
mori registry concepts --search 'durable workflow'
mori path mori://shinzui/keiro/okf/user-documentation/concepts/DOC-1
```


## Validation and Acceptance

The catalog is accepted when the Dhall value type-checks, okf can compile and display the export,
the conforming six-type fixture passes strict enforcement, every rejection fixture is rejected for
its intended single reason, generated profile documentation is current, the local ADR bundle
passes strict log enforcement, and the complete `just check` suite stays green.

The publication is accepted only when the tag is visible through upstream `git ls-remote`, its
semantic hash matches the consumer selector, and the selector type-checks without using a sibling
checkout or mutable branch.

Keiro is accepted when every one of the 52 existing Markdown pages retains its original body,
gains unique valid `DOC-N` metadata inside its bundle, both bundle indexes declare OKF 0.2, both
logs cover the metadata adoption, and strict profile plus log enforcement succeeds. The existing
`README.md` pages must remain readable curated navigation concepts, not be replaced by generated
indexes. `Justfile` must make these checks part of the standard verification path.

The end-to-end behavior is accepted when Mori lists both bundles, exact handle lookup returns the
expected concepts without path guessing, text search finds a Keiro user page by description or
tags, a canonical handle-form URI resolves to the underlying Markdown file, and graph output
contains existing cross-document Markdown links.


## Idempotence and Recovery

Profile documentation and bundle indexes are deterministic and may be regenerated repeatedly.
`okf id next` only reports an ID and does not write, so record allocated handles in the patch
before calling it again. Frontmatter migration must be additive: never regenerate document bodies
or replace the curated `README.md` content.

If the catalog tests fail, fix the profile or focused fixture before publishing; do not weaken
strict enforcement. If release publication is not approved, stop after a clean local catalog
commit and do not commit a Keiro selector that depends on an unreachable tag. If Keiro migration
fails midway, its two bundles are independent: finish and validate one directory before the
other. Existing Git history remains the recovery source for each unchanged body.

Mori observation replaces the stored project OKF snapshot atomically. Re-running observation is
the recovery path after correcting metadata; do not mutate registry tables directly.


## Interfaces and Dependencies

The profile uses the schema exported by `Profile/okf.dhall`, currently pinned to the okf-core
0.8.0.0 contract discovered through `mori://shinzui/okf/packages/okf-core`. Construct the value
with `Profile::{ ... }`, `FrontmatterRules::{ ... }`, `TypeRule::{ ... }`, and shared rules from
`Profile/V02.dhall`; do not reproduce upstream record types or v0.2 nested-field definitions.

The public catalog interface gains one field:

```dhall
documentation.userDocumentation : Profile.Type
```

Its stable-ID interface is:

```text
idField = docId
handle = DOC-<positive unpadded integer>
types = Navigation | Tutorial | Guide | Explanation | Reference | Runbook
```

Keiro's `mori.dhall` uses the already pinned Mori schema's
`Schema.ProfileBinding.Published` arm and a `Schema.PinnedImport` naming publisher
`shinzui/okf-profiles`, export `documentation.userDocumentation`, the published version, and the
semantic pin. The legacy `profile` path points at the frozen selector so okf and Mori can perform
local enforcement; the typed binding provides registry identity and stale-pin reporting.
