---
id: 12
slug: add-jobs-and-product-research-profiles-linked-to-use-cases
title: "Add jobs and product research profiles linked to use cases"
kind: exec-plan
intention: "intention_01m528193teth8eq0adthgtpvv"
created_at: 2026-10-16T11:36:46Z
provenance:
  created_by:
    model: "gpt-6-astra"
    harness: "codex-cli"
    at: 2026-10-16T11:36:46Z
  revisions:
    - model: "gpt-6-astra"
      harness: "codex-cli"
      at: 2026-10-16T11:42:51Z
      mode: "other"
      note: "Complete initial plan with separate product research, standalone features, and the requested intention"
---

# Add jobs, product research, and features linked to use cases


This ExecPlan is a living document. Keep Progress, Surprises & Discoveries, Decision Log, and Outcomes & Retrospective current during implementation. Promote durable decisions into `docs/adr/`. The scope includes independently addressable features following the user's additional requirement for a future product-management UI. This plan delivers the data contracts and checks; building that UI is separate work.

## Purpose / Big Picture


A product team should be able to record what progress customers seek, collect evidence supporting or challenging that understanding, describe proposed features, and connect those features to product scenarios and repository-owned delivery requests. Today jobs and features exist only as records embedded in use cases. Research documents in this repository serve technical investigations about building software, rather than customer discovery.

Create three profiles: `coordination.jobs`, `documentation.productResearch`, and `coordination.features`. Extend `coordination.useCases` with optional canonical references and a discovery-friendly representation. Preserve `documentation.researchDocuments` and all existing valid use-case bundles. Demonstrate a customer job supported by one finding and challenged by another, a reusable feature appearing in two use cases, and an early scenario with no selected solution. These are inspectable OKF concepts with stable identities suitable for later UI development.

## Progress


Implementation has not started. Populate this section with timestamped checkboxes at the first implementation step, tracking the five milestones below.

## Surprises & Discoveries


None recorded during implementation yet. Constraints discovered during authoring are incorporated into Context and Orientation and the design below.

## Decision Log


Decision (2026-10-16): Introduce a separate product-research profile. The user explicitly distinguished customer/product discovery from the technical investigations captured by `documentation.researchDocuments`. Leave that profile, its fixtures, and its generated documentation unchanged.

Decision (2026-10-16): Introduce a feature profile as well as a job profile. The user wants features available to a future UI. A feature has an identity and delivery lifecycle independent of the use cases that reference it. A capability remains a producer's claim about behavior already available; an improvement request remains work proposed to close a repository-owned gap.

Decision (2026-10-16): Model product studies and findings as separate concepts under one profile, sharing a `PR-N` identity namespace. Findings need durable references and must distinguish observation from interpretation. This also avoids unsupported recursively nested metadata.

Decision (2026-10-16): Keep research support separate from document lifecycle and feature delivery. Neither a document review nor a delivered feature proves that a customer job is satisfied. Store explicit assessments with evidence and rationale.

Decision (2026-10-16): Use the currently pinned schema without a dependency upgrade. It supports one level of structured records, conditional presence, nested reference rules, and uniqueness of a top-level list's member. Flatten measurement metadata accordingly. A required list treats an empty list as absent; discovery examples omit absent features instead of promising that a required `features: []` is valid.

Decision (2026-10-16): Preserve inline use-case jobs and features for compatibility, while adding canonical references and a separate opt-in semantic checker for relationships. Do not make a new whole-corpus check an implicit requirement for old consumers. New canonical corpora adopt both profile validation and that checker.

Decision (2026-10-16): Link this work to intention `intention_01m528193teth8eq0adthgtpvv`, created with the user-requested `mina ci --json` command. Publication, release tags, adoption blueprints, consumer migrations, and a frontend implementation are outside this plan.

## Outcomes & Retrospective


To be filled during implementation. No profile, fixture, or application behavior has been changed by creating this plan.

## Context and Orientation


This repository publishes Dhall values describing house conventions for Open Knowledge Format (OKF) Markdown bundles. A bundle has an `index.md` declaring `okf_version: "0.2"`, concept documents with YAML frontmatter, and a `log.md` tracking revisions. A profile describes concept types and field constraints. It does not itself implement an application, perform research, or verify that a claim is true. A stable handle such as `UC-1` identifies a concept within its bundle; references crossing bundles need the project-and-bundle-scoped Mori URI.

`package.dhall` exports `coordination` from `profiles/coordination/package.dhall` and `documentation` from `profiles/documentation/package.dhall`. Add the new exports in those family files. `mori.dhall` separately advertises published profiles. `scripts/test-profile-docs.sh` explicitly enumerates export-to-directory pairs and generates `docs/profiles/`. `just docs` regenerates them; `just check` runs Dhall type checks and every shell test under `scripts/`. Python checks need a shell wrapper to enter this gate.

`profiles/coordination/use-cases.dhall` defines `Use Case` with `useCaseId: UC-N` and `Use Case Theme`. A use case currently requires `jobs`, whose entries contain `name`, `actor`, `situation`, `motivation`, and `outcome`, and `features`, whose entries contain `name`, `description`, `status`, `owners`, and `acceptance`. Optional feature `jobs` names point to inline job names. Feature and use-case improvement requests are canonical external references. The use-case status vocabulary is `draft`, `validated`, `planned`, `in-progress`, `delivered`, `retired`. Existing consumers must retain these fields and meanings. `fixtures/use-cases/001-investigate-alert.md` and `scripts/test-use-cases-profile.sh` establish compatibility examples.

`profiles/documentation/research-documents.dhall` provides technical `Research Document` records with `RES-N` identifiers and `active`, `complete`, `superseded` lifecycle states. Product research gets its own type names, namespace, and required customer context. `profiles/coordination/capabilities.dhall` deliberately excludes planned behavior from capability catalogs. `profiles/assurance/verification-evidence.dhall` concerns reproducible technical verification and is not a customer-study repository. Neither is repurposed here.

Dependency sources were discovered using `mori registry list`, `mori registry search okf`, `mori registry show shinzui/okf --full`, and `mori registry docs shinzui/okf`. The dependency's canonical project identity is `mori://shinzui/okf`. At authoring time curated documentation was absent from its registry entry. Relevant source locations are that project's `okf-core/dhall/Profile.dhall`, `okf-core/dhall/FieldRule.dhall`, `okf-core/dhall/NestedFieldRule.dhall`, and `okf-core/src/Okf/Profile.hs` (artifact-level source URIs pending). Resolve the project using Mori rather than hard-coding a checkout path. `Profile/okf.dhall` pins commit `bdf8893ccf0dfbd77fd68fe3c58348b5e49809c7`; inspect that revision when making descriptor decisions.

That schema bounds structured metadata to one level. `NestedFieldRule` cannot describe a further object or list of structured objects. `uniqueBy` exists on top-level `FieldRule`, not nested rules. Conditional `when` controls whether absence is an error; present values still receive shape and value checking. An empty list counts as absent, so it fails a required-list rule and can be accepted when presence is optional. External reference validation checks syntax and policy, not the existence or type of a target in another bundle. `okf concepts BUNDLE --json` returns a JSON array containing frontmatter, including structured values, but paths cannot be assumed to appear in those rows.

Relevant local decisions are [ADR-1](../adr/0001-house-status-diverges-from-okf-v0-2.md), which permits deliberate house lifecycle vocabularies; [ADR-4](../adr/0004-reviews-and-verified-coexist.md), which distinguishes detailed reviews from OKF confirmations; [ADR-5](../adr/0005-v0-2-field-families-are-defined-once.md), which requires reuse of `Profile/V02.dhall`; [ADR-8](../adr/0008-recommended-means-a-well-run-corpus-carries-it.md), which reserves recommendations for actual deficiencies; [ADR-9](../adr/0009-a-rejection-fixture-must-fail-for-exactly-one-reason.md), which requires focused diagnostics and negative controls; and [ADR-13](../adr/0013-a-specification-is-not-a-decision-or-a-reference.md), which separates document classes by the questions they answer. No existing ADR decides the product-discovery boundary introduced here. Create one during implementation, allocating its handle with OKF rather than guessing it.

## Plan of Work


### Milestone 1: Publish jobs and product-research contracts


Add `profiles/coordination/jobs.dhall` and `profiles/documentation/product-research.dhall`. Export them as `coordination.jobs` and `documentation.productResearch`, with profile names `jobs` and `product-research`. The new profiles declare OKF 0.2, require bundle version 0.2, reject unknown concept types, and retain the default open extension-field policy. Require `type`, `title`, `description`, and shared `v02.generated` on every concept. Make `reviews` and shared `v02.verified` optional, following ADR-8: a hypothesis or observation can legitimately exist before anyone reviews the document. Mirror approvals without inventing human provenance. Do not declare legacy timestamps on new profiles. Use house lifecycle statuses and do not splice the standard status/staleness pair. Add guidance explaining authorship, research support, and observation versus interpretation.

The jobs profile contains one type, `Job`, with `jobId: JOB-N`, `idField = Some "jobId"`, prefix `JOB`, and root-level concept paths (`pathPattern = Some "*"`). Require `actor`, `situation`, `motivation`, `status`, `validationStatus`, and `outcomes`. `status` is `draft`, `active`, or `retired`. `validationStatus` is `untested`, `supported`, `mixed`, or `challenged`. A job states desired customer progress independently of a particular UI or implementation. It remains active even if one attempted solution fails.

`outcomes` is a non-empty list unique by required scalar `name`. Each entry also requires scalar `description`. Optional flat members are `metric`, `unit`, `direction`, `method`, `baseline`, `target`, `population`, and `period`. `direction` is `increase`, `decrease`, or `maintain`. A qualitative outcome may omit all measurement members. If any measurement member exists, the semantic checker requires `metric`, `unit`, `direction`, and `method` together. `baseline` and `target` are finite numbers in the declared unit, enforced by the checker because the current descriptor has no general numeric-scalar rule. A stated baseline additionally requires population/period context and a top-level `sources` entry documenting its evidence. A target is an aspiration, never an observation. Do not require metric definitions for every job.

Optional job fields are `functionalContext`, `emotionalContext`, `socialContext`, `relatedJobs`, `sources` using the shared family, and `assessment`. `relatedJobs` accepts local JOB handles or canonical external job concept URIs. `assessment` is a top-level object with required `rationale`, `assessedAt` (RFC3339 UTC), and non-empty `findingRefs` (canonical product-research concept URIs). Its presence is required whenever `validationStatus` is `supported`, `mixed`, or `challenged`. An `untested` job may omit it. The checker ensures cited concepts are findings about this job; support is an explicit synthesis, not a vote or count of findings. Do not infer it from `verified`.

The product-research profile has `idField = Some "productResearchId"`. Both `Product Research Study` and `Product Research Finding` use unique `PR-N` identifiers, prefix `PR`, and root-level documents. Sharing the prefix enables one bundle-wide allocator while type checking stays explicit. The study is the bounded research activity; the finding is a separately citable observation and interpretation. There is no automatically stored inverse list of findings on a study.

A study requires `question`, `method`, `population`, `context`, and `status`. Methods are `interview`, `observation`, `survey`, `experiment`, `analytics`, `desk-research`, or `mixed`; mixed methods must be explained in the body. Status is `planned`, `active`, `complete`, or `cancelled`. Optional fields are `jobRefs`, shared `sources`, `startedAt`, `completedAt`, and `limitations`; timestamps use RFC3339 UTC. `completedAt` and `limitations` become required at `complete`; `cancellationReason` becomes required at `cancelled`. A completed study may conclude that it found nothing conclusive. A study can precede identification of a job, so `jobRefs` stays optional.

A finding requires `studyRef`, `observation`, `interpretation`, `context`, `observedAt`, `limitations`, shared `sources`, and `status`. `studyRef` accepts a local `PR-N` or a canonical product-research concept URI; the semantic checker requires a study target. `observation` states what was seen; `interpretation` states the conclusion drawn. `observedAt` records the observation time, independently of `generated.at`. `status` is `current`, `superseded`, or `withdrawn`; require `supersededBy` for a superseded finding and `withdrawalReason` for a withdrawn one. `supersededBy` must target another finding. Raw material may live outside the bundle and is referenced through `sources`; do not copy sensitive transcripts into examples.

Optional `jobAssessments` is a non-empty list of flat records with required `jobRef`, `claim`, `stance`, and `rationale`, and optional `outcomeName`. `stance` is `supports`, `challenges`, or `inconclusive`. Assess the named claim, not every possible assertion about the job. Optional `measurements` is a non-empty list of flat records requiring `name`, `jobRef`, `outcomeName`, `value`, `unit`, `method`, `population`, `periodStart`, and `periodEnd`; use `uniqueBy = Some "name"`. The value must be finite numeric data; periods are RFC3339 UTC and must be ordered. A measurement refers to a defined measurable outcome and uses its unit; conversions must be explicit in the finding before reporting a compatible value. Both findings and jobs can exist without quantitative measurements.

Add `fixtures/jobs`, `fixtures/jobs-invalid`, `fixtures/product-research`, and `fixtures/product-research-invalid`, each acceptance bundle carrying valid index and log files. Demonstrate a draft untested job, a supported job, a qualitative outcome, a measured outcome, a planned study with no findings yet, and two findings with opposed assessments of a job. Test wrappers are `scripts/test-jobs-profile.sh` and `scripts/test-product-research-profile.sh`; each supports `OKF_BIN`, accepts an optional `PROFILE` override for mutation testing, checks strict acceptance, and asserts focused rejection diagnostics. This milestone is complete when both profiles type-check and their scripts pass independently. Cross-bundle semantic checks arrive in milestone 3.

### Milestone 2: Publish independently addressable features


Add `profiles/coordination/features.dhall`, exported as `coordination.features`, profile name `features`, with a single `Feature` type. Apply the same common metadata and lifecycle conventions as the new profiles above. Set `idField = Some "featureId"`, prefix `FEAT`, and root-level paths. A stable `FEAT-N` concept describes a coherent product behavior that can advance through discovery and delivery and can appear in more than one use case. Its identity does not depend on its title, owning repository, or a screen layout.

Require `featureId`, `status`, and `behavior` in addition to common metadata. `status` is `discovered`, `planned`, `in-progress`, `delivered`, `blocked`, `deferred`, or `retired`. `behavior` states the proposed or actual customer-visible behavior. Optional fields are `jobRefs`, `outcomeRefs`, `owners`, `acceptanceCriteria`, `improvementRequests`, `deliveredAt`, `deliveryEvidence`, and `priority`. All cross-bundle artifact references are canonical Mori URIs. `owners` is a list of canonical Mori project URIs. `jobRefs` can be absent for technical enabling features; do not invent customer jobs merely to populate it. `outcomeRefs` contains flat `{ jobRef, outcomeName }` records, whose jobs must also appear in `jobRefs`.

`acceptanceCriteria` is a non-empty list unique by required scalar `name`, with required scalar `statement`. `owners` and `acceptanceCriteria` are conditionally required for `planned`, `in-progress`, `blocked`, and `delivered`. A discovered feature may have neither. `deliveryEvidence` reuses the structure of the shared source rule under the house field name, with its purpose clearly described; it names evidence of delivered behavior. `deliveredAt` (RFC3339 UTC) and `deliveryEvidence` become required when delivered. Retiring a feature preserves its handle and history. Delivery evidence demonstrates implementation acceptance, not customer outcome improvement.

`priority`, when present, is `low`, `medium`, `high`, or `critical`. It is a producer's declared ordering signal for a future UI, not a computed score. Do not add frontend component names, routes, CSS properties, UI framework details, or an invented scoring algorithm. Do not store inverse `useCaseRefs`: derive where a feature is used from the use-case references. Improvement-request links remain optional external IR concept URIs; no changes to the improvement-request profile are needed.

Add `fixtures/features`, `fixtures/features-invalid`, and `scripts/test-features-profile.sh`. Include discovered and delivered features, a feature with multiple repository owners, and an enabling feature without a job. Isolated rejections cover missing required delivery information, invalid status/priority, duplicate criterion names, malformed owners, malformed artifact references, and core metadata. The profile must type-check and its tests pass before integrating use cases.

### Milestone 3: Connect use cases and validate the relationship graph


Extend `profiles/coordination/use-cases.dhall` additively. Keep its types, handles, lifecycle vocabulary, inline job structure, and existing feature-entry constraints. Add optional `jobs[].jobRef`, a canonical job concept URI, and optional `jobs[].outcomeNames`, a list of outcome names. A linked inline job supplies this scenario's actor, circumstances, motivation, and desired outcome; it does not replace the canonical job. An `outcomeNames` member requires `jobRef` in the semantic checker and must name actual outcomes.

Add top-level optional `featureRefs`, a non-empty list of canonical feature concept URIs. A use case adopting standalone features uses this list and omits inline `features`. Keep inline `features` available for existing corpora, but move its presence from required to optional. Add optional `features[].featureRef` for a transitional inline record connected to a standalone feature. Every existing inline child constraint still applies when present. A linked inline record is a retained scenario snapshot; the standalone feature owns current delivery status, ownership, and shared acceptance. A UI must not overwrite canonical values from the snapshot. New authoring guidance prefers `featureRefs` and avoids duplicate inline records.

Both representations may occur during migration, but the semantic checker rejects referencing the same canonical feature twice, whether within `featureRefs`, through inline `featureRef`, or across the two. It checks uniqueness of inline job and feature names and resolves `features[].jobs` against this use case's inline job names. Keep these extra semantic constraints opt-in for existing corpora rather than adding new unconditional descriptor constraints to legacy lists.

A `draft` or `validated` scenario can have no features. `planned`, `in-progress`, and `delivered` scenarios require at least one inline feature or canonical feature reference in the semantic checker. A retired scenario can omit features. This alternative-presence condition cannot be expressed by the current descriptor; document explicitly that profile-only validation now checks feature shape but the additional checker enforces delivery readiness. Do not add an upstream validator extension or require a new discriminator field on all existing use cases. Empty optional lists are treated as absent, never as evidence that a delivery condition is met. `validated` remains a scenario lifecycle state and makes no automatic claim about the job's research support.

Implement `scripts/check-product-discovery.py` using Python's standard library, subprocess calls to `okf`, and a required JSON manifest. The command is `python3 scripts/check-product-discovery.py --manifest PATH`; it respects `OKF_BIN`. The manifest has `bundles`, a list of `{ uri, path, profile }` objects. `uri` is a canonical bundle URI, `path` is a local bundle directory, and `profile` is its descriptor. Resolve paths relative to the manifest file. Validate the manifest, run strict profile and log enforcement for each supplied bundle, and read concepts with `okf concepts BUNDLE --json`. Index by bundle URI plus the correct ID field for each concept type. Use argv arrays, never shell interpolation, and never fetch a URI from the network.

Resolve local `PR-N` references inside the finding's product-research bundle and local JOB references inside a jobs bundle. All cross-bundle links in this design are canonical concept URIs. Use handle patterns `JOB-[1-9][0-9]*`, `PR-[1-9][0-9]*`, and `FEAT-[1-9][0-9]*`; bundle names are producer-selected, so URI patterns must not hard-code `jobs` or `product-research` as the only permitted bundle names. Project owner references have project scope rather than concept scope. Imported jobs, studies, findings, and features must be supplied through manifest mappings. Missing mappings or missing/wrong-type targets are errors, not silent successes. Owners and improvement requests are outside this checker's resolution domain: validate their shape in the profiles, and report them as externally unchecked in the checker's success summary. Do not present this as global Mori resolution.

Enforce all semantic constraints described above: target types; outcome existence; local-name references; numeric values excluding booleans and non-finite values; measurement field completeness; measurement period ordering; canonical feature reference duplication; and delivery-state feature presence. For a job assessment, at least one assessment in every cited current finding must target that job. Withdrawn or superseded findings cannot substantiate the current job assessment; authors must re-assess it or cite replacements. Do not derive `supported`, `mixed`, or `challenged` by counting stances. For `relatedJobs` and supersession references reject self-reference; for supersession also reject cycles. Document checks that remain editorial, including whether an observation truly supports an interpretation or whether study sampling is adequate.

Errors identify the source canonical concept URI and full field path, such as `jobs[0].outcomeNames[0]`. Exit 0 only when every scoped check passes, 1 on validation errors, and 2 on bad CLI usage or an unreadable/invalid manifest. Report a concise success summary with concept and checked-reference counts and the external-resolution boundary.

Create `fixtures/product-discovery/manifest.json`, with acceptance bundles under `fixtures/product-discovery/jobs`, `research`, `features`, and `use-cases`. Use synthetic project identity `mori://example/product` solely as fixture data. Include two use cases referring to one FEAT concept and one draft without features. Add `scripts/test-product-discovery.sh` with Python-based negative cases in a temporary directory, so each mutation leaves all unrelated checks passing. Update `scripts/test-use-cases-profile.sh` and add its new shape/reference fixtures while retaining existing fixtures unchanged. This milestone passes when both legacy use-case validation and the new complete graph work, and a wrong outcome, wrong study type, missing imported feature, and delivery-stage scenario without features each fail at the intended field.

### Milestone 4: Register and document the public contracts


Add profile declarations in `mori.dhall` for `jobs`, `product-research`, and `features`, with the correct exports and paths. Their canonical catalog references are `mori://shinzui/okf-profiles/profiles/jobs`, `mori://shinzui/okf-profiles/profiles/product-research`, and `mori://shinzui/okf-profiles/profiles/features`. These are intended artifact identities even if registry refresh has not made them resolvable. Do not advertise an unissued release tag: omit the optional version for new entries until release work assigns it.

Extend `scripts/test-profile-docs.sh` with `coordination.jobs:jobs`, `documentation.productResearch:product-research`, and `coordination.features:features`. Run `just docs` to generate new bundles and refresh use-case documentation. Update `README.md` with exports, concept responsibilities, the distinction between technical and product research, canonical authoring and migration examples, and both validation layers. Update `CHANGELOG.md` under Unreleased with the three additions, optional links, the relaxed inline-feature presence rule, and the need for the semantic checker when enforcing the alternative delivery representations. Explain that consumers refresh their package semantic hash when they eventually repin; this plan does not publish a version or change existing blueprint pins.

Create a profiled ADR recording the separation of jobs, product research, features, scenarios, capabilities, and repository requests, and why cross-bundle validation is separate from descriptor validation. Read and type-check `docs/adr/profile.dhall`; obtain the next handle with `okf id next`, preserve the established filename convention, update the index and bundle log, and validate strictly. Cite this plan locally. Existing technical-research documents retain their original contract. This milestone is observable through `okf profile list --no-local --registry ./package.dhall`, current generated docs, and a strictly valid ADR bundle.

### Milestone 5: Prove compatibility and complete the plan


Run every new profile suite, the existing use-case and technical-research suites, graph tests, generated-doc checks, and `just check`. Apply ADR-9 to all changed rules: inspect advisory diagnostics for one intended violation per isolated rejection and perform negative controls by relaxing the governing constraint in a temporary descriptor. Existing invalid use-case fixtures are included, not merely newly added ones. Keep relative imports resolvable in temporary descriptor copies; do not mutate the working profile with unsafe reset/restore loops. Composite format/prefix or nested-shape constraints may need to be relaxed together as the authored policy unit, as ADR-9 explains. Record a rule-to-fixture mapping and any known overlapping core diagnostics with specific reasons.

For semantic checks, show that the valid fixture passes, each single mutation fails at its intended source URI and field, and reverting that mutation restores success. Cover both declarative and semantic boundaries: profile validation can accept a well-formed external reference whose target is missing, but the manifest-based checker must reject it. No test claims to prove research truth. Record actual output summaries in this plan, distill any further durable lessons into the ADR, and mark work complete only after those gates pass.

## Concrete Steps


Run commands from the repository root, `/Users/shinzui/Keikaku/bokuno/okf-profiles` in the authoring environment. A different checkout uses its own root. The required tools are `bun` for plan provenance, `dhall`, `okf`, `just`, `python3`, and Mori for dependency discovery. They were available during authoring. Do not search the filesystem root or traverse `/nix/store`.

Before implementation, inspect current changes and the existing pin, then run the small baseline suites. These are expected to succeed on the starting tree; capture failures rather than claiming a baseline without running it.

```bash
pwd
git status --short
cat Profile/okf.dhall
bash scripts/test-use-cases-profile.sh
bash scripts/test-research-documents-profile.sh
```

After creating the three descriptors and exports, run these individually as their milestones become ready:

```bash
dhall type --file profiles/coordination/jobs.dhall
dhall type --file profiles/documentation/product-research.dhall
dhall type --file profiles/coordination/features.dhall
dhall type --file package.dhall
bash scripts/test-jobs-profile.sh
bash scripts/test-product-research-profile.sh
bash scripts/test-features-profile.sh
```

Each script must print its own concise `OK:` acceptance/rejection summary and exit zero. The standalone relationship checker and its suite then run as follows:

```bash
python3 scripts/check-product-discovery.py --manifest fixtures/product-discovery/manifest.json
bash scripts/test-product-discovery.sh
bash scripts/test-use-cases-profile.sh
bash scripts/test-research-documents-profile.sh
```

The manifest's path bases are explicit; for example the jobs bundle entry is:

```json
{
  "uri": "mori://example/product/okf/jobs",
  "path": "jobs",
  "profile": "../../profiles/coordination/jobs.dhall"
}
```

The complete manifest wraps this and the other three entries in `{ "bundles": [...] }`. The checker success summary must distinguish resolved discovery concepts from owners and IR references that were checked only syntactically. A negative mutation of a use-case outcome should include an error of this form, with actual identifiers and indexes from the fixture:

```text
mori://example/product/okf/use-cases/concepts/UC-1 jobs[0].outcomeNames[0]: unknown outcome missing-outcome on mori://example/product/okf/jobs/concepts/JOB-1
```

Before writing the new ADR, discover the unused handle rather than assuming its number:

```bash
dhall type --file docs/adr/profile.dhall
okf id list docs/adr --profile docs/adr/profile.dhall
okf id next docs/adr --profile docs/adr/profile.dhall ADR
okf log add --help
```

After the ADR and its log/index are updated, and after adding documentation registrations:

```bash
okf validate docs/adr --strict --profile docs/adr/profile.dhall --profile-enforce --log-enforce
okf profile list --no-local --registry ./package.dhall
just docs
bash scripts/test-profile-docs.sh
just check
git diff --check
git status --short
```

Expected results are zero exit codes, the three new exports in profile listing, current documentation, passing old corpora, and focused new rejection cases. Do not fabricate the precise success text of existing tools. Record observed summaries during execution. At the first implementation stopping point, record authorship using `.agents/skills/exec-plan/record-provenance.ts revision` with verified runtime identity, `--mode implement`, and this plan path. All implementation commits use Conventional Commits plus the `ExecPlan:` trailer naming this file and `Intention: intention_01m528193teth8eq0adthgtpvv`.

## Validation and Acceptance


The feature is accepted when a reader can independently allocate and query JOB, PR, and FEAT handles; keep a customer job untested without fabricating evidence; record a study before it produces findings; cite actual observations and opposed interpretations; and show one feature reused by two scenarios without duplicating its current delivery state. Moving a feature to delivered requires its implementation acceptance evidence, while the job's assessment remains an independent declaration. A qualitative job is valid without metrics.

A canonical use case can omit inline features and reference a FEAT concept instead. An early use case may omit both representations. A delivery-stage use case lacking both is rejected by the documented graph check. Previously valid inline use-case and technical-research fixtures still pass. Feature owners and IR links retain their current Mori conventions. No real consumer repository is changed by the demonstration.

Malformed IDs, bad timestamps and actors, duplicate outcome or criterion names, unsupported vocabularies, missing conditional fields, malformed URI families, and wrong metadata shapes receive profile failures. Missing/wrong-type imported concepts, invalid local outcome names, partial measurement definitions, invalid numeric observations, reversed periods, unrelated assessment evidence, duplicate feature references, and missing delivery-stage features receive semantic-check failures. Error messages identify the failing concept and field; a nonzero exit alone is insufficient evidence.

The UI-facing deliverable is stable, queryable concept identity and explicit relations, observable through `okf concepts --json`. It does not promise a frontend API, interactive screens, automatic prioritization, synchronization into a remote service, or proof that a feature caused an outcome. Documentation explains these boundaries as part of the contract.

## Idempotence and Recovery


All adoption is additive and opt-in. Do not rewrite existing inline use cases or turn technical research into product findings. Preserve existing handles when authors later link records to canonical concepts. Canonical `featureRefs` is the preferred new representation; inline linked snapshots can be removed deliberately by consumers after preserving scenario-specific prose. A record's rename must not change its handle.

Tests create temporary copies for semantic mutations and negative controls. Clean up only temporary paths created by the test, preserve unrelated working-tree changes, and never use blanket reset/restore commands. Documentation generation is deterministic and can be rerun. Profile listing and graph validation are read-only. If a gate fails, fix the isolated change and rerun the affected gate before the final complete check.

If the existing descriptor cannot express a claimed constraint, retain that constraint in the documented semantic checker rather than silently weakening it or changing the schema dependency. If implementation discovers a necessary dependency upgrade, stop treating the pinned schema as sufficient: use Mori to discover sources, verify authoritative registry releases and upstream tags, and revise this plan with the actual compatibility evidence before changing any pin. No upgrade is selected by this plan.

## Interfaces and Dependencies


The new public exports are `coordination.jobs`, `documentation.productResearch`, and `coordination.features`. The existing `coordination.useCases` export adds `jobs[].jobRef`, `jobs[].outcomeNames`, `featureRefs`, and `features[].featureRef`, while making inline `features` optional. The unchanged `documentation.researchDocuments` export retains its technical-research purpose. Common source and provenance constraints are reused from `Profile/V02.dhall`; no new package dependency or changes to OKF core are required.

The checker is an explicitly invoked repository utility with the manifest and exit-status contract defined in milestone 3. It consumes `okf concepts --json` through `OKF_BIN`, validates through the same executable, resolves only declared local bundle mappings, and requires no YAML parser or network connection. Its stdlib tests and shell wrapper enter the existing `just test` loop. Consumers wanting the same semantic checks must adopt this utility and a manifest explicitly; merely importing the Dhall profiles does not execute it.

New durable cross-repository references use canonical `mori://` project/bundle/concept identities. In a producer whose registered bundle names are `jobs`, `product-research`, and `features`, the corresponding concept shapes are `mori://<namespace>/<project>/okf/jobs/concepts/JOB-N`, `mori://<namespace>/<project>/okf/product-research/concepts/PR-N`, and `mori://<namespace>/<project>/okf/features/concepts/FEAT-N`. Other registered bundle names remain valid. These are artifact URI patterns, not citations to artifacts that already exist. Resolution failure before registration does not justify replacing them with ambiguous bare handles.

Authoring note (2026-10-16): Created from the user's request for a precise implementation plan, incorporating the explicit separation of product research from technical research, the subsequent request for standalone features for future UI work, and the intention created through `mina ci --json`. The plan remains unimplemented.
