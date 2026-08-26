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

The catalog will also publish an `adopt-user-documentation` Seihou blueprint. A maintainer can run
one adaptive playbook in another repository to discover existing `docs/user/` and `docs/guides/`
corpora, preserve their prose, install the published profile, assign stable metadata, register
separate bundles, and add repository-native validation without copying Keiro-specific choices.

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
- [x] (2026-08-26T13:09Z) Publish the v0.13.0 okf-profiles release containing the new export and
  verify its remote Dhall semantic hash.
- [x] (2026-08-26T13:26Z) Add, register, document, lint, and fully catalog-check the
  `adopt-user-documentation` Seihou blueprint and prepare v0.13.1 release notes.
- [ ] Publish the immutable v0.13.1 follow-up, verify the shipped descriptor and an isolated
  installed-blueprint descriptor, and remote catalog availability. The isolated installed-copy
  rendering already succeeds from local commit `c108cab`.
- [x] (2026-08-26T13:35Z) Migrate Keiro's `docs/user/` and `docs/guides/` corpora, install their
  shared v0.13.0 pinned descriptor, register both bundles, wire strict validation into `just
  verify`, and commit the first consumer as `acb9ee6c`.
- [x] (2026-08-26T13:38Z) Register Keiro locally and prove stable-ID lookup, cross-document links,
  fleet search, producer metadata, typed profile provenance, and strict validation end to end.
- [ ] Complete the ADR distillation pass and record outcomes.


## Surprises & Discoveries

Document unexpected behaviors, bugs, optimizations, or insights discovered during
implementation. Provide concise evidence.

- Observation: Keiro's two target directories contain 52 existing Markdown pages, including two
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
- Observation: the user requested the reusable Seihou adoption path immediately after v0.13.0 was
  published, so the immutable v0.13.0 tag cannot be amended to contain it.
  Evidence: upstream `refs/tags/v0.13.0^{}` resolves to catalog commit `f0332df`, and its frozen
  `package.dhall` hash is
  `sha256:3be4c39d128ef8a21e39d7ae4eaef29097801b343ab5672caaf7e30186a8f91a`.
- Observation: adding a Seihou blueprint, registry entries, and operator documentation does not
  change the public Dhall package value, so v0.13.1 deliberately has the same semantic import hash
  as v0.13.0.
  Evidence: `dhall hash --file package.dhall` remains
  `sha256:3be4c39d128ef8a21e39d7ae4eaef29097801b343ab5672caaf7e30186a8f91a` after the blueprint work.
- Observation: Mori indexes and resolves the two new bundles even though `mori registry show
  shinzui/keiro --full` currently prints `Bundles (0)` in its summary section.
  Evidence: bundle-scoped concept queries return 25 and 27 concepts, exact handle URIs resolve to
  the correct files, and both typed pins appear as `current (observed)`. This presentation mismatch
  does not block concept queries or profile provenance.


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
- Decision: Publish a standalone Seihou blueprint named `adopt-user-documentation`, with no
  version-window migration edges.
  Rationale: repositories have not adopted an older version of this profile, so there is no prior
  installed contract to migrate. The playbook must adapt an existing corpus once, reconcile an
  already-adopted corpus idempotently, and succeed without changes when neither target corpus
  exists.
  Date: 2026-08-26
- Decision: Version the new blueprint as 0.13.1 and ship a v0.13.1 patch release whose descriptor
  imports that same catalog tag.
  Rationale: [ADR-7](../adr/0007-blueprint-versions-track-the-catalog-tag.md) requires blueprint
  versions to identify the catalog release they target. The already-published v0.13.0 tag is
  immutable and does not contain the requested blueprint.
  Date: 2026-08-26
- Decision: Keep Keiro pinned to v0.13.0 while the blueprint and later adopters use v0.13.1.
  Rationale: v0.13.0 is the immutable release that first published the profile and is already
  verified remotely. v0.13.1 adds only adoption tooling; both tags expose the same semantic Dhall
  value, so repinning the completed first consumer would create churn without changing policy.
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

Milestone 2 published annotated tag v0.13.0 at commit `f0332df`. Fetching the tag through GitHub
and freezing its public `package.dhall` produced the same semantic hash recorded in the release
notes, proving that consumers can resolve the new export without a sibling checkout.

Milestone 3's local artifact is complete. `adopt-user-documentation` version 0.13.1 ships an exact
profile selector and migration reference, handles first adoption, reconciliation, conflicting
profiles, provenance uncertainty, bundle-local identity, Mori schema variation, check integration,
and no-applicable-corpus behavior. `seihou validate-blueprint --lint`, catalog registry validation,
and the complete `just check` suite pass with five registered blueprints. Remote descriptor and
catalog checks necessarily wait for the immutable v0.13.1 tag; an isolated install from local
commit `c108cab` renders the expected version, references, prompt, and safety rules.

Milestone 4 completed the first consumer without changing any original documentation body.
Keiro commit `acb9ee6c` adds 25 `docs/user` concepts, 27 `docs/guides` concepts, two deterministic
indexes, two migration logs, a frozen v0.13.0 selector, typed Mori bindings, and a strict
`user-documentation-validate` target in `just verify`. Both bundle validations pass, 52 body
comparisons against pre-migration Git content are identical, and regenerating both indexes changes
nothing.

Milestone 5's local registry proof resolves
`mori://shinzui/keiro/okf/user-documentation/concepts/DOC-1` to `docs/user/README.md` and
`mori://shinzui/keiro/okf/guides/concepts/DOC-17` to `docs/guides/durable-workflows.md`. Exact
`DOC-1` lookup returns both bundle-qualified navigation pages; fleet search for `durable workflow`
returns the tutorial, reference, related reviews, and cross-project runtime-pattern entries; a
producer query returns all 52 adopted pages. OKF graph output contains 84 user-documentation edges
and 78 guide edges. Mori reports both v0.13.0 profile pins as current.


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

This repository already distributes adaptive Seihou blueprints under `blueprints/`, registers
them in `seihou-registry.dhall` and `mori.dhall`, and lints every blueprint from
`scripts/test-blueprints.sh`. A blueprint is a prompt plus declared reference files that a
tool-capable coding agent runs inside a consumer repository. The nearest adoption pattern is
`blueprints/adopt-improvement-request-contracts/`: it is a standalone, idempotent playbook with no
migration edges, has an operator README and a concise contract reference, and treats absence of an
applicable corpus as a successful no-op. [ADR-7](../adr/0007-blueprint-versions-track-the-catalog-tag.md)
requires its version in `blueprint.dhall`, `seihou-registry.dhall`, and `mori.dhall` to match the
catalog tag it targets.


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

Milestone 3 adds the reusable migration path. Create
`blueprints/adopt-user-documentation/blueprint.dhall`, `prompt.md`, `README.md`, and reference files
for the pinned v0.13.1 descriptor and exact profile contract. The prompt must discover
`docs/user/` and `docs/guides/` independently, preserve bodies and existing valid handles, derive
truthful authorship timestamps from Git evidence, classify by primary reader intent, allocate
handles with `okf id next`, generate reserved indexes and logs, register one Mori bundle per
corpus, and integrate strict validation into the repository's existing check system. It must never
guess provenance, consume all of `docs/`, renumber a valid handle, or overwrite a locally authored
profile. Register the blueprint and README in both catalogs, document it in the root README and
CHANGELOG, rehearse it against a disposable legacy corpus and an already-conforming corpus, and
prepare v0.13.1. The milestone is complete when blueprint lint, registry validation, the isolated
preview, rehearsals, and `just check` pass.

Milestone 4 migrates `mori://shinzui/keiro`. Add one frozen selector at
`mori/user-documentation-profile.dhall` importing the verified v0.13.0 profile release. Add
frontmatter to every target page without changing its body: preserve the H1 as `title`, assign one
primary reader intent, write a concise description, allocate stable `DOC-N` handles independently
per bundle, add useful search tags, and set `generated.by` to `human:nadeem`. Derive
`generated.at` from each file's most recent meaningful Git commit and normalize it to UTC rather
than pretending the metadata migration rewrote the prose. Generate `index.md` and add a scoped
`log.md` to each bundle. Extend `mori.dhall` with both bundles and typed published-profile bindings.
Add `user-documentation-validate` to `Justfile` and make `verify` depend on it. This milestone is
complete when both bundles pass strict profile and log enforcement and existing documentation
links still resolve.

Milestone 5 proves the registry behavior. Run Mori's non-mutating manifest checks, then observe
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

Author, register, and validate the reusable migration blueprint:

```bash
seihou validate-blueprint blueprints/adopt-user-documentation --lint
seihou registry validate
bash scripts/test-blueprints.sh
seihou agent --debug run adopt-user-documentation
just check
```

The blueprint rehearsal uses a disposable Git repository with `docs/user/` and `docs/guides/`
pages lacking frontmatter. Following the rendered prompt must produce two independently valid
bundles, preserve the original Markdown bodies byte-for-byte below inserted frontmatter, and make
a second pass produce no content changes.

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

The blueprint is accepted when its Dhall evaluates and lints, both catalogs agree on name,
version, path, description, and tags, its shipped descriptor resolves through v0.13.1 and the
recorded semantic hash, and an isolated rehearsal proves first-run migration, no-applicable-corpus
success, and second-run idempotence. The rendered playbook must direct an agent to preserve bodies,
valid handles, local profile customizations, unrelated changes, and repository-native checks.

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

The blueprint is also idempotent: it validates an already-governed corpus before editing,
preserves every conforming field, allocates only after the largest existing handle, and reports a
repository without an applicable corpus as a successful no-op. Rehearsals live in a disposable
directory and must never run against a user's uncommitted repository.

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

The Seihou artifact interface is a standalone blueprint named `adopt-user-documentation`, version
`0.13.1`, with no migration edges. It ships two readable references:

```text
user-documentation-profile.dhall
migration-reference.md
```

Its canonical cross-repository reference is
`mori://shinzui/okf-profiles/templates/adopt-user-documentation`. Consumers run it with
`seihou agent run adopt-user-documentation`; it does not participate in `seihou agent migrate`
because no earlier user-documentation profile contract exists.

Revision note (2026-08-26): Expanded the plan after the user requested a reusable Seihou blueprint
for migrating subsequent repositories. Added the adaptive blueprint milestone, v0.13.1 release
decision, registration and rehearsal acceptance, and kept Keiro on the semantically identical
v0.13.0 profile release that was already published and remotely verified.
