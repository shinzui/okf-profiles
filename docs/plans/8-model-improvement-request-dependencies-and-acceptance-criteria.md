---
id: 8
slug: model-improvement-request-dependencies-and-acceptance-criteria
title: "Model improvement-request dependencies and acceptance criteria"
kind: exec-plan
created_at: 2026-08-19T18:18:08Z
---

# Model improvement-request dependencies and acceptance criteria

This ExecPlan is a living document. The sections Progress, Surprises & Discoveries,
Decision Log, and Outcomes & Retrospective must be kept up to date as work proceeds.
If durable project context changes, update or create ADRs in docs/adr/ in the same change.


## Purpose / Big Picture

After this change, an improvement request can state its source dependencies and completion
contract in validated frontmatter rather than only in prose. An author can distinguish a hard
prerequisite from a non-blocking soft relationship and from an integration relationship that
requires joint verification. Each acceptance criterion has a stable request-local `AC-N` handle,
so later evidence can name the condition it proves without copying or rewriting that condition.

The behavior is visible by validating `fixtures/improvement-requests/` with the shared
`coordination.improvementRequests` profile. One valid fixture will carry all three dependency
kinds and two acceptance criteria, while the older valid fixture will carry neither new field and
will continue to pass. Focused invalid fixtures will prove that ambiguous bare `IR-N` references,
wrong or malformed URIs, invalid dependency records, duplicate criterion handles, and incomplete
criteria are rejected. Generated profile documentation will show the same nested rule and
reference metadata that a registry consumer such as Mori can inspect.

The full acceptance contract cannot be expressed by the currently released dependency. As of
2026-08-19, the authoritative upstream tag and Hackage release are `okf-core` 0.7.0.0, while this
repository still pins the 0.5.0.0 schema in `Profile/okf.dhall`. Upstream 0.7.0.0 has neither a
`reference` member on `NestedFieldRule` nor a way to prohibit local handles, constrain the path of
an external reference, or require unique values for one member across a list of records. The first
milestone is therefore a release gate: do not approximate away any IR-2 acceptance criterion and
do not pin an unreleased checkout.


## Progress

- [x] (2026-08-19 18:52Z) Verified the Milestone 1 release baseline through Mori, Hackage, and
      upstream Git: `okf-core` 0.7.0.0 at commit
      `fb5b1811b359db7aa295aa4f3d3f81ed319905d5` remains the newest release and does not supply
      the required nested-reference or nested-uniqueness contract. No dependency pin was edited.
- [ ] Milestone 1 remaining: wait for one qualifying `okf-core` version to be published on
      Hackage and under a matching immutable upstream tag, then repin `Profile/okf.dhall` and
      prove old catalog fixtures still validate. This is the current release-gate blocker.
- [ ] Milestone 2: add optional `dependencies` and `acceptanceCriteria` rules, one rich valid
      fixture, and focused single-reason rejection fixtures.
- [ ] Milestone 3: regenerate the public profile documentation, update the catalog guidance and
      changelog, and prove compiled reference metadata is visible.
- [ ] Milestone 4: dogfood the new fields in IR-2, pass all repository gates, release
      `okf-profiles` v0.12.0 with a reproducible semantic hash, and distill durable decisions.


## Surprises & Discoveries

- Observation: `cabal info okf-core` rendered versions through 0.7.0.0 followed by “and 1 other,”
  but the hidden entry is the older 0.1.0.0 release, not a newer candidate. The authoritative
  Hackage version document and preferred-version document both end at 0.7.0.0, and upstream Git
  likewise ends at `v0.7.0.0`.
  Evidence:

  ```text
  Hackage versions: 0.1.0.0 through 0.7.0.0
  Upstream tag:      v0.7.0.0 -> fb5b1811b359db7aa295aa4f3d3f81ed319905d5
  Newer tag:         none
  ```

- Observation: the released `NestedFieldRule` intentionally omits `reference`, the released
  `HandleReferenceRule` has only `localPrefix`, `externalUriSchemes`, and `allowSelf`, and the
  compiled nested rule assigns `reference = Nothing`. The released top-level `FieldRule` has no
  member for a record-list uniqueness key. These source facts independently confirm that 0.7.0.0
  cannot express the contract required here.


## Decision Log

- Decision: Preserve every acceptance criterion in IR-2 and gate implementation on a released
  upstream schema rather than shipping a partially validated profile.
  Rationale: `UriWithScheme "mori"` would accept a Mori URI for the wrong bundle or handle kind,
  current nested fields cannot carry reference metadata, and current validation cannot reject a
  duplicate `AC-N` inside one request. Claiming completion with those gaps would make the prose
  stronger than the executable contract.
  Date: 2026-08-19.

- Decision: Require the upstream reference policy to combine external-only selection and the
  canonical target pattern within one reference rule.
  Rationale: A separate URI-format rule and reference rule would double-report a wrong-scheme
  value, defeating the repository's single-reason rejection-fixture discipline. One reference
  policy can short-circuit from local-handle rejection, through scheme rejection, to path-pattern
  rejection while also exposing one compiled reference relation to consumers.
  Date: 2026-08-19.

- Decision: Put both new top-level fields in the profile's `optional` presence class.
  Rationale: A complete request may have no source dependency, and older requests may keep prose
  acceptance sections. Under [ADR-8](../adr/0008-recommended-means-a-well-run-corpus-carries-it.md),
  absence that is ordinary must not fail `--strict`; the nested constraints still apply whenever
  the field is present.
  Date: 2026-08-19.

- Decision: Use separate rejection fixtures for a missing acceptance statement and a missing
  verification procedure, yielding eight requested fixture cases rather than combining the last
  two defects.
  Rationale: [ADR-9](../adr/0009-a-rejection-fixture-must-fail-for-exactly-one-reason.md)
  requires a rejection fixture to isolate the rule it proves. A criterion missing both members
  would remain red if either rule disappeared.
  Date: 2026-08-19.

- Decision: Dependency kinds describe source relationships, not live operational readiness.
  Rationale: A hard dependency is a completion-order constraint, a soft dependency is advisory,
  and an integration dependency requires joint verification. Computing a transitive graph,
  checking target existence, detecting cycles, and deciding whether work is currently blocked
  belong to Mori and Rei, not to this shape-validating profile.
  Date: 2026-08-19.

- Decision: Target `okf-profiles` v0.12.0, but require the already-authored v0.11.0 release to be
  tagged first.
  Rationale: The remote currently ends at v0.10.0 while `master` already contains a v0.11.0
  changelog entry and profile metadata. Reusing or skipping that version would make release
  history disagree with the checked-in catalog. IR-2 adds a backward-compatible document shape
  but raises the minimum decoder version, which merits the next minor release.
  Date: 2026-08-19.

- Decision: Stop this implementation session at Milestone 1 without changing
  `Profile/okf.dhall` or approximating the requested validation rules.
  Rationale: the newest Hackage release and matching upstream tag are still 0.7.0.0, and direct
  inspection proves that release lacks every schema extension named by the release gate. The plan
  explicitly forbids an unreleased pin and a partial executable contract.
  Date: 2026-08-19.


## Outcomes & Retrospective

Implementation reached the dependency release gate and stopped as designed. Mori located the
authoritative upstream checkout, Hackage and Git established 0.7.0.0 as the newest jointly
published version, and direct source inspection proved that it cannot model the requested nested
reference policy or request-local acceptance-criterion uniqueness. No schema, profile, fixture,
documentation, request, or release state was changed. Work can resume from the second Progress
item after the required additive upstream contract is released on Hackage and under a matching
Git tag.


## Context and Orientation

The source request is
[`docs/improvement-requests/model-improvement-request-dependencies-and-acceptance-criteria.md`](../improvement-requests/model-improvement-request-dependencies-and-acceptance-criteria.md),
with the bundle-scoped stable handle `IR-2`. An Open Knowledge Format (OKF) bundle is a directory
of Markdown concepts with YAML frontmatter. A profile is a Dhall value that declares which
frontmatter keys may appear, their presence class, their value shape, and any reference policy.
`--profile-enforce` changes profile deviations from advisory output into a failing command;
`--strict` additionally demands fields classified as recommended.

`profiles/coordination/improvement-requests.dhall` is the behavioral source. It currently requires
the `Improvement Request` type, an `IR-N` request handle, lifecycle status, origin, and provenance;
it optionally accepts an implementation plan and legacy timestamp. Its profile-wide `optional`
list is where both IR-2 fields belong. `profiles/coordination/package.dhall` already exports the
profile as `coordination.improvementRequests`, and root `package.dhall` already exposes that
package, so no second profile or new top-level export is needed.

`Profile/okf.dhall` is the catalog's single pinned import of the public `okf-core` profile schema.
`Profile/Type.dhall`, `Profile/FrontmatterRules.dhall`, and `Profile/TypeRule.dhall` derive their
types from that pin, and `package.dhall` re-exports the profile-authoring types. A schema bump here
therefore affects every catalog export even though only the improvement-request profile exercises
the new rules. Keep one pin; do not create a private one-profile schema fork.

The upstream owner is `mori://shinzui/okf`. Discover its checkout and releases through Mori before
reading source. In that project, the 0.7.0.0 source at project-relative path
`okf-core/dhall/NestedFieldRule.dhall` explicitly omits `reference`; project-relative path
`okf-core/src/Okf/Profile.hs` consequently hard-codes nested references to `Nothing`, and its
nested validation walk checks vocabulary, format, and path only. The same module checks
bundle-wide top-level document IDs but has no uniqueness rule over sibling records in a list. No
registered upstream improvement request currently owns these additions. If the needed upstream
release still does not exist when implementation begins, stop after recording the missing
capability in Progress. Create and execute separately governed upstream work in
`mori://shinzui/okf`; the artifact-level URI is pending until that project allocates its own
request or plan handle.

The minimum upstream behavioral contract is one additive profile-schema generation with these
capabilities. `NestedFieldRule` can carry the existing `HandleReferenceRule`. That policy can
reject local handles while accepting selected external schemes, and can constrain an external URI
with a full-value pattern. The default behavior remains today's behavior: local handles allowed
and no external pattern. A top-level list-of-records rule can name one required scalar nested
member as its uniqueness key. Compiled effective rules retain the nested reference policy so
`fieldRuleElementFields` followed by `fieldRuleReference` exposes `dependencies.ref`. Malformed
patterns and invalid uniqueness targets fail profile compilation; duplicate authored values fail
bundle validation. Exact upstream field names may differ, but all of these behaviors must be
present in one released tag and Hackage version before the pin moves.

`fixtures/improvement-requests/` is the passing bundle. `first.md` deliberately proves that a
valid request may omit optional data. Extend `second.md` rather than adding another concept: it
already demonstrates the richer completed-request branch and can now demonstrate three source
relationships plus two acceptance criteria. `scripts/test-improvement-requests-profile.sh` first
validates that bundle strictly, then loops over named directories below
`fixtures/improvement-requests-invalid/` and requires each to fail. The loop checks exit status;
ADR-9 additionally requires reading each advisory and proving that deletion of the intended rule
makes its fixture pass.

`scripts/test-profile-docs.sh` owns the generated material below `docs/profiles/`. `just docs`
runs it in regeneration mode; `just check` type-checks every Dhall descriptor, runs every script,
regenerates profile documentation into a temporary directory, compares it byte-for-byte, and
validates every generated bundle. Never hand-edit
`docs/profiles/improvement-requests/profile.md` or its generated type page.

`mori.dhall` advertises each published profile and the release in which its behavior last changed.
The improvement-request entry still says v0.8.0. Update that entry to v0.12.0 when the release is
prepared. `README.md` describes the catalog-wide minimum `okf` version and the profile's public
purpose. `CHANGELOG.md` uses Keep a Changelog sections and must explain both document migration
(`none`, because the new fields are optional) and tool migration (a consumer repinning to v0.12.0
must use the newly released decoder).

Two local ADRs constrain this work. ADR-8, linked in the Decision Log, defines the distinction
between optional and recommended fields. ADR-9 defines rejection-fixture isolation and the
load-bearing rule sweep. The filename-and-heading scan found no other local ADR that governs
dependency-kind semantics, nested uniqueness, or release numbering. The upstream schema-growth
rules were inspected directly in the Mori-located dependency source because
`mori://shinzui/okf` currently publishes no addressable ADR bundle.

IR-2 names two downstream consumers. `mori://shinzui/mori/okf/improvement-requests/concepts/IR-18`
resolved successfully during planning and owns projection of profile-declared references as typed
concept edges. `mori://shinzui/kikan/okf/improvement-requests/concepts/IR-11` and
`mori://shinzui/kikan/okf/use-cases/concepts/UC-23` are the request's integration and source-use-case
references; the current local registry did not resolve them. Preserve the exact canonical URIs
rather than replacing them with checkout paths or bare handles.


## Plan of Work

### Milestone 1: adopt a released dependency contract

This milestone changes only the schema pin and compatibility documentation. First compare Mori's
registered checkout with the authoritative Hackage release and upstream Git tags. Inspect the
released source directly and confirm the behavioral contract described above, including compiled
nested reference inspection and duplicate-key validation. An untagged commit, a sibling working
tree, or a local executable newer than Hackage is evidence for planning, not a version this catalog
may pin.

Once a qualifying release exists, update the URL, commit, version comment, and tool-version prose
in `Profile/okf.dhall`, delete only its old semantic hash, and run `dhall freeze --inplace
Profile/okf.dhall` to compute the new hash. If the release adds a named rule record or constructor
that profile authors need, re-export it from `package.dhall` alongside `HandleReferenceRule`; do
not re-author the upstream type locally. Update the blanket minimum-version language in
`README.md`, but leave the v0.12.0 release note until Milestone 3.

At the end, `just types` and every pre-existing script pass before IR-2 fields exist. This isolates
schema adoption from profile behavior and proves the upstream compatibility decoder still accepts
the catalog's existing descriptors.

### Milestone 2: make the IR-2 shape executable

Extend `profiles/coordination/improvement-requests.dhall` with the upstream nested-rule binding and
two optional list-of-record rules. `dependencies` has required scalar members `ref`, `kind`, and
`reason`. `ref` uses a single external-only reference policy: scheme `mori`, no local `IR-N`
alternative, and the full canonical shape
`mori://<namespace>/<project>/okf/improvement-requests/concepts/IR-N`, with a positive unpadded
number. `kind` accepts exactly `hard`, `soft`, or `integration`. `reason` is a non-empty scalar.
The parent and member descriptions must say that hard gates source fulfillment, soft never blocks
by itself, and integration permits independent implementation but gates completion on named joint
verification. They must also say these are source relationships, not live blockers.

`acceptanceCriteria` has required scalar members `id`, `statement`, and `verification`. Format
`id` as `DocumentHandle "AC"`, and configure the parent list to require uniqueness by `id`.
`statement` describes an observable completion condition; `verification` describes the expected
procedure or evidence without claiming that evidence already exists. The parent description must
distinguish criteria from tasks, dependencies, and evidence.

Add all three dependency kinds and `AC-1` / `AC-2` to
`fixtures/improvement-requests/second.md`. Keep `fixtures/improvement-requests/first.md` unchanged
so absence remains part of the acceptance proof. Add these focused invalid fixture directories,
each otherwise copied from a minimal valid request and each with its own valid `index.md`:
`bare-dependency-handle`, `wrong-dependency-scheme`, `malformed-dependency-uri`,
`unknown-dependency-kind`, `missing-dependency-reason`, `duplicate-acceptance-criterion`,
`missing-acceptance-statement`, and `missing-acceptance-verification`. Register all eight in
`scripts/test-improvement-requests-profile.sh`.

Read each new fixture's advisory without `--profile-enforce`; it must report exactly one primary
profile deviation. Then temporarily remove its intended rule, run only that fixture, and confirm
it passes. Restore the profile after every negative control and keep those temporary deletions out
of Git. The milestone is complete when the valid bundle passes strict enforcement, every focused
invalid bundle fails for its named reason, and all older improvement-request fixtures still behave
as before.

### Milestone 3: publish the contract people and tools will read

Run `just docs`, which regenerates the complete documentation catalog. Inspect only the resulting
improvement-request pages closely, but commit every deterministic generated change. In
`docs/profiles/improvement-requests/profile.md` and
`docs/profiles/improvement-requests/types/improvement-request.md`, the `dependencies.ref` member
must render as a reference with Mori as its external scheme and with the canonical-target
constraint; this output is generated from a `CompiledProfile`, so it is the local proof that the
metadata survives compilation. The pages must render the uniqueness rule for
`acceptanceCriteria.id` and the exact kind semantics from the source descriptions.

Update the `coordination.improvementRequests` row in `README.md` to mention typed source
dependencies and stable acceptance criteria. Add a short author-facing paragraph explaining that
a consumer may layer stricter organizational policy while preserving the shared meanings: for
example, it may require every accepted request to carry criteria, but it must not redefine `soft`
as blocking. Explicitly distinguish these fields from live incident or scheduling blockers.

Prepend a v0.12.0 section to `CHANGELOG.md`. Describe the two optional fields, all three dependency
kinds, reference and uniqueness enforcement, generated documentation, and the raised minimum
`okf-core` decoder. State that existing bundles need no content migration and that a repin requires
the upstream version adopted in Milestone 1. Change only the improvement-request profile's version
in `mori.dhall` to v0.12.0. Run `just check`; the documentation staleness test and every generated
bundle must pass.

### Milestone 4: dogfood, release, and close the request

Before starting this milestone, confirm the remote contains v0.11.0 and does not contain v0.12.0.
Update IR-2's own frontmatter and log in two stages as work progresses. When implementation starts,
set `status: in-progress`, add
`targetPlan: docs/plans/8-model-improvement-request-dependencies-and-acceptance-criteria.md`,
advance `generated.at`, and use `okf log add` to record the change. Before the release commit, dogfood at
least the two dependencies and the numbered acceptance conditions already present in IR-2's prose
using the newly validated frontmatter shape. Do not invent completion evidence.

After all acceptance commands pass, compute a semantic hash from a scratch Dhall import of the
local `package.dhall` export and record the tool-produced value in the v0.12.0 changelog entry.
Commit the release state, create and push the annotated v0.12.0 tag, then freeze the equivalent
remote import and confirm its hash is byte-for-byte identical. By design, the tag contains the new
profile, fixtures, documentation, and dogfooded IR-2 fields while IR-2 still says `in-progress`.
If the remote proof passes, set
IR-2 to `completed`, add `completedAt` and a resolution naming the tag and validation evidence,
advance provenance, add the bundle-log entry, and commit the post-release closure. Never leave a
completion claim without a real published tag.

Run `mori registry reregister --namespace shinzui` only after the published tag and checked-in
`mori.dhall` agree. Verify that Mori reports
`mori://shinzui/okf-profiles/profiles/improvement-requests` at v0.12.0. The downstream IR-18 need
not be implemented here, but its future compiled-rule walk must be able to see
`dependencies.ref` as a reference and `dependencies.kind` as sibling metadata.

Finally, update every living section of this plan. Review the Decision Log, Surprises &
Discoveries, and Outcomes & Retrospective. Promote only durable project-level judgments into
`docs/adr/`, following `agents/skills/exec-plan/ADR.md`, allocating any new handle with `okf id
next`, updating `docs/adr/log.md`, and running strict profile validation. Leave release transcripts
and task-local fixture details in this plan.


## Concrete Steps

All local repository commands run from
`/Users/shinzui/Keikaku/bokuno/okf-profiles` unless a step says otherwise.

First establish the dependency and release baseline without relying on memory:

```bash
mori registry list
mori registry search okf-core
mori registry show shinzui/okf --full
mori registry docs shinzui/okf
mori registry dependents shinzui/okf --packages
cabal info okf-core
git ls-remote --tags https://github.com/shinzui/okf.git
git ls-remote --tags https://github.com/shinzui/okf-profiles.git
```

The last two sources must agree with Hackage about the selected upstream release and must show
v0.11.0, but not v0.12.0, for this repository before release work begins. If no released upstream
version satisfies the contract, record the block in Progress and stop. Do not edit the pin.

After inspecting the qualifying release source at the path returned by Mori, repin and freeze:

```bash
dhall freeze --inplace Profile/okf.dhall
just types
just test
git diff --check
```

Expected milestone result:

```text
OK: improvement-request profile acceptance and rejection fixtures
OK: profile documentation is current and validates
```

Implement the source profile and fixtures, then run the focused checks:

```bash
dhall type --file profiles/coordination/improvement-requests.dhall
bash scripts/test-improvement-requests-profile.sh
okf validate fixtures/improvement-requests \
  --strict \
  --profile profiles/coordination/improvement-requests.dhall \
  --profile-enforce \
  --log-enforce
```

The final command must end with this shape and no preceding `profile:` diagnostics:

```text
OK: 2 concepts (okf_version 0.2)
```

Audit every new rejection fixture individually. This loop deliberately omits
`--profile-enforce`, because the diagnostic text is the evidence:

```bash
for fixture in \
  bare-dependency-handle \
  wrong-dependency-scheme \
  malformed-dependency-uri \
  unknown-dependency-kind \
  missing-dependency-reason \
  duplicate-acceptance-criterion \
  missing-acceptance-statement \
  missing-acceptance-verification; do
  echo "--- ${fixture}"
  okf validate "fixtures/improvement-requests-invalid/${fixture}" \
    --profile profiles/coordination/improvement-requests.dhall 2>&1 \
    | sed -n '/^profile: /p'
done
```

Each heading must be followed by exactly one primary deviation naming the intended field path.
An advisory summary line is not a second primary deviation. Perform the ADR-9 deletion sweep
manually with `apply_patch`, one constraint at a time, run the corresponding single fixture, and
restore the source before continuing.

Regenerate and inspect the public contract:

```bash
just docs
rg -n 'dependencies|acceptanceCriteria|hard|soft|integration|live.*block|unique|Reference' \
  docs/profiles/improvement-requests
okf profile document \
  --registry package.dhall \
  coordination.improvementRequests \
  --out /tmp/okf-profiles-ir2-docs \
  --write \
  --okf-version 0.2
diff -r docs/profiles/improvement-requests /tmp/okf-profiles-ir2-docs
just check
```

The recursive diff prints nothing. The generated `dependencies.ref` entry reports reference
metadata, and the acceptance-criteria entry reports uniqueness by `id`.

Update and validate this repository's own improvement-request bundle whenever IR-2 frontmatter
or timestamp changes:

```bash
okf log add docs/improvement-requests \
  model-improvement-request-dependencies-and-acceptance-criteria \
  --kind Update \
  --message "IR-2 records implementation and release progress." \
  --date 2026-08-19
okf index docs/improvement-requests --write --okf-version 0.2
okf validate docs/improvement-requests \
  --strict \
  --profile docs/improvement-requests/profile.dhall \
  --profile-enforce \
  --log-enforce
```

Use a message that accurately describes each stage rather than copying the illustrative message
twice. The final validation currently has two concepts and must remain free of diagnostics.

Before release, run the complete gate and compute the local semantic hash in a temporary directory:

```bash
just check
git diff --check
git status --short
release_scratch="$(mktemp -d)"
printf '%s\n' '(./package.dhall).coordination.improvementRequests' \
  > "${release_scratch}/profile.dhall"
cp package.dhall "${release_scratch}/package.dhall"
cp -R Profile profiles "${release_scratch}/"
dhall freeze --inplace "${release_scratch}/profile.dhall"
sed -n '1,4p' "${release_scratch}/profile.dhall"
```

Copy only the hash produced by `dhall freeze` into the release note; do not invent or hand-edit a
hash. Because the local expression imports the same release commit, its normalized value must equal
the later remote import.

Every implementation commit includes the local plan trailer:

```text
ExecPlan: docs/plans/8-model-improvement-request-dependencies-and-acceptance-criteria.md
```

Use Conventional Commit subjects. Suitable milestone boundaries are a `chore(profile)` schema-pin
commit, a `feat(coordination)` profile-and-fixture commit, a `docs(profiles)` public-contract
commit, and a `chore(release)` release commit. Update this plan in the same commits rather than
letting Progress lag behind the tree.

Create and verify the tag only from a clean, fully validated release commit:

```bash
git ls-remote --tags origin | rg 'refs/tags/v0\.12\.0(\^\{\})?$' && exit 1 || true
git tag -a v0.12.0 -m "okf-profiles 0.12.0: typed improvement-request fulfillment contracts"
git push origin v0.12.0
remote_scratch="$(mktemp -d)"
printf '%s\n' \
  '(https://raw.githubusercontent.com/shinzui/okf-profiles/v0.12.0/package.dhall).coordination.improvementRequests' \
  > "${remote_scratch}/profile.dhall"
dhall freeze --inplace "${remote_scratch}/profile.dhall"
sed -n '1,4p' "${remote_scratch}/profile.dhall"
```

The remote hash must equal the local hash recorded in the changelog. Finally refresh and inspect
the registry:

```bash
mori registry reregister --namespace shinzui
mori registry show shinzui/okf-profiles --full
mori path mori://shinzui/mori/okf/improvement-requests/concepts/IR-18
```

The profile listing reports v0.12.0. The final command continues to resolve IR-18; the unresolved
Kikan references are not rewritten or silently dropped.


## Validation and Acceptance

The change is accepted only when all of the following behavior is observable.

The unchanged `fixtures/improvement-requests/first.md` passes strict validation without
`dependencies` or `acceptanceCriteria`. `fixtures/improvement-requests/second.md` passes with
exactly three dependencies—one hard, one soft, one integration—and at least two criteria whose
IDs are `AC-1` and `AC-2`.

Each of the eight new invalid fixture directories fails `okf validate --profile-enforce` for its
named defect. In advisory mode, each prints one primary deviation. A bare `IR-1` is rejected even
if an `IR-1` exists locally. `https://…/IR-1` is rejected for its scheme. A `mori://` URI whose
path names the wrong bundle, artifact kind, handle prefix, padded number, query, or fragment is
rejected by the canonical-target constraint. An unknown kind is rejected against the three-value
vocabulary. Missing reason, statement, or verification members are reported at indexed nested
paths. Reusing `AC-1` in one request is rejected as a duplicate uniqueness key.

`docs/profiles/improvement-requests/profile.md` and the generated type page describe the exact
three dependency meanings, explain that live operational blockers are outside this profile, show
the canonical external reference constraint on `dependencies.ref`, and show uniqueness by
`acceptanceCriteria.id`. Re-running `just docs` produces no diff.

`package.dhall` type-checks, and documenting `coordination.improvementRequests` through the root
registry succeeds. `just check` passes every Dhall type check, acceptance bundle, rejection loop,
ADR bundle check, profile-documentation staleness check, and strict generated-bundle validation.

The released v0.12.0 remote export evaluates, freezes, and yields the same semantic hash as the
pre-tag local export. `mori registry show shinzui/okf-profiles --full` reports the
improvement-request profile at v0.12.0. IR-2 records the target plan, its dogfooded dependency and
criterion data, the release tag, completion time, and a resolution only after those facts exist.

IR-18 itself is not implemented by this plan. Acceptance requires only that a compiled profile
consumer can traverse the effective `dependencies` rule, identify `dependencies.ref` as a
reference field, and read `kind` and `reason` from the surrounding record. Cross-project target
existence, cycles, transitive readiness, and live blockers remain explicitly out of scope.


## Idempotence and Recovery

Mori discovery, registry inspection, Hackage inspection, Dhall type checks, `okf validate`,
`just check`, `git diff --check`, and remote tag listing are read-only. `just docs` is deterministic
and safe to rerun; when the source profile has not changed it produces no diff. `okf index --write`
is likewise deterministic for a fixed bundle.

`dhall freeze --inplace Profile/okf.dhall` is safe after the URL is correct. If fetching or hashing
fails, retain the last released pin and retry; never delete the old hash in a commit merely to make
network evaluation proceed. Scratch directories created by `mktemp -d` contain no source of truth
and may be removed after comparing hashes.

Every invalid fixture is additive. If one accidentally fails for more than its target rule, fix
the fixture's otherwise-valid frontmatter before trusting the loop. During a rule-deletion negative
control, restore only the intentional temporary hunk with `apply_patch`; do not use `git reset`,
`git checkout`, or another command that could discard unrelated user changes.

`okf log add` appends, so do not rerun the same command blindly. Inspect
`docs/improvement-requests/log.md` first and add one truthful entry per timestamp advance. `okf
index --write` can then be repeated safely.

An annotated tag is not moved after publication. If v0.12.0 already exists remotely, stop and
inspect what commit it names; allocate a new version through a documented plan revision rather
than deleting or retargeting it. If the tag push fails, keep the local tag, repair connectivity or
authorization, and retry the same push. If the remote hash differs from the pre-tag hash, do not
mark IR-2 complete or re-register Mori; identify whether the tag names the wrong commit, then
publish a new version rather than moving a consumed tag.

`mori registry reregister --namespace shinzui` changes the local registry observation but is
repeatable from the same manifests. Run it only after the tag exists, because publishing v0.12.0
metadata before the artifact exists creates a false current-version claim.


## Interfaces and Dependencies

The repository depends on `mori://shinzui/okf` for profile decoding, compilation, validation, and
generated documentation. Resolve the source with Mori and verify the chosen released version
against both Hackage and upstream tags. The research baseline is `okf-core` 0.7.0.0; it is
insufficient. Do not guess a future version bound. Once a qualifying release exists, record its
exact tag, commit, Hackage version, and semantic hash in this plan's Decision Log and update
`Profile/okf.dhall` to that immutable commit.

The required upstream data contract is additive. In Dhall terms, it is equivalent to extending
`NestedFieldRule` with an optional `HandleReferenceRule`, extending that reference policy with
defaulted local-handle permission and an optional full-value external URI pattern, and extending a
top-level list-of-records `FieldRule` with an optional uniqueness-member name. Existing rules
upgrade to local handles allowed, no external path restriction, and no uniqueness check. A
qualifying release may use different names, but it must expose equivalent data through compiled
effective rules and generated documentation.

The local profile's effective interface is:

```yaml
dependencies:
  - ref: mori://namespace/project/okf/improvement-requests/concepts/IR-1
    kind: hard
    reason: The target request supplies the contract this request consumes.
acceptanceCriteria:
  - id: AC-1
    statement: The observable behavior that must hold.
    verification: The command, inspection, or evidence that will prove it.
```

Both top-level fields are optional lists. Every listed record member is required and scalar.
`dependencies.ref` is external-only and matches this full shape:

```text
mori://<namespace>/<project>/okf/improvement-requests/concepts/IR-<positive-unpadded-integer>
```

`dependencies.kind` has the closed vocabulary `hard`, `soft`, and `integration`.
`acceptanceCriteria.id` has `DocumentHandle "AC"` format and is unique within its containing
request. The uniqueness scope is one `acceptanceCriteria` list, not the whole bundle; every request
may independently use `AC-1`.

Mori IR-18 is a downstream consumer, not a build dependency. It needs the compiled nested rule
accessors supplied by `okf-core`, but this repository does not change Mori's database, graph, CLI,
or event schemas. Kikan IR-11 and UC-23 are integration references only. Their exact canonical
URIs remain durable even while a local registry is behind and cannot resolve them.

No new Seihou blueprint is required because existing bundles remain valid and there is no
mechanical content migration. No new local profile export is required. The release changes the
existing `coordination.improvementRequests` behavior and the catalog-wide minimum decoder version.


Revision note (2026-08-19): Recorded the implementation preflight, the exact upstream release
blocker, and the deliberate no-edit stopping decision so the next session can resume from the
release gate without repeating or weakening the dependency check.
