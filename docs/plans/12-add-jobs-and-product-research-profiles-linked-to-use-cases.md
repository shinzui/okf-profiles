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
    - model: "gpt-6-astra"
      harness: "codex-cli"
      at: 2026-10-16T12:06:56Z
      mode: "update"
      note: "Integrate capability and specification references, reuse AC-N criteria, and cover existing profiles without widening their schemas"
    - model: "claude-opus-5-5"
      harness: "claude-code"
      at: 2026-10-16T12:43:01Z
      mode: "update"
      note: "Validate against pinned okf and ADRs: external-only reference encoding, no guidance (ADR-12), okf/mori-owned interim checker rules with upstream requests"
    - model: "claude-opus-5-5"
      harness: "claude-code"
      at: 2026-10-16T13:14:59Z
      mode: "implement"
      note: "Implement milestones: jobs, product research, features, use-case links, discovery checker, registration"
---

# Add jobs, product research, and features linked to use cases


This ExecPlan is a living document. Keep Progress, Surprises & Discoveries, Decision Log, and Outcomes & Retrospective current during implementation. Promote durable decisions into `docs/adr/`. The scope includes independently addressable features following the user's additional requirement for a future product-management UI. This plan delivers the data contracts and checks; building that UI is separate work.

## Purpose / Big Picture


A product team should be able to record what progress customers seek, collect evidence supporting or challenging that understanding, describe proposed features, and connect those features to product scenarios, repository-owned delivery requests, producer capabilities, and governing specifications. Today jobs and features exist only as records embedded in use cases. Research documents in this repository serve technical investigations about building software, rather than customer discovery.

Create three profiles: `coordination.jobs`, `documentation.productResearch`, and `coordination.features`. Extend `coordination.useCases` with optional canonical references and a discovery-friendly representation. Preserve `documentation.researchDocuments` and all existing valid use-case bundles. Demonstrate a customer job supported by one finding and challenged by another, a reusable feature appearing in two use cases, and an early scenario with no selected solution. These are inspectable OKF concepts with stable identities suitable for later UI development. The demonstration also connects a feature to a capability and a specification, an implementation request originating from the feature, and a bug affecting it, using existing fields wherever their meanings already fit.

## Progress


Implementation was completed on 2026-10-16, and all five milestones pass `just check`. Two upstream improvement requests were written into the okf and Mori checkouts and remain uncommitted for the user's review. The integration scope was revised earlier that day. A validation pass then checked the plan against the working tree and the pinned okf source. It fixed reference encoding, removed profile `guidance`, and assigned each semantic check an intended upstream owner.

- [x] (2026-10-16) Validate the plan against the working tree, the pinned okf schema, and the local ADRs; baseline use-case, research-document, and capability suites pass.
- [x] (2026-10-16) Publish jobs and product-research contracts and their profile tests. `coordination.jobs` and `documentation.productResearch` type-check and appear in `okf profile list`. `scripts/test-jobs-profile.sh` accepts 3 concepts and rejects 34 focused cases. `scripts/test-product-research-profile.sh` accepts 5 concepts and rejects 44. Both run through the shared harness `scripts/profile_fixture_cases.py`.
- [x] (2026-10-16) Publish features with capability/specification references and AC-N acceptance criteria. `coordination.features` is exported. `scripts/test-features-profile.sh` accepts 3 concepts (in-progress with two owners and CAP/SPEC/IR links, delivered enabling feature without a job, discovered feature) and rejects 31 focused cases.
- [x] (2026-10-16) Connect use cases, implement the interim relationship checker with owner-tagged rules, and demonstrate integration through existing profiles. `coordination.useCases` gained `jobs[].jobRef`, `jobs[].outcomeNames`, `featureRefs`, and `features[].featureRef`, and inline `features` is now optional. `scripts/check-product-discovery.py` lists 16 rules (10 `okf`, 6 `mori`) and passes on `fixtures/product-discovery/manifest.json`. `scripts/test-product-discovery.sh` runs 22 single-rule mutations, a profile-versus-checker boundary case, manifest and profile-failure exits, and 7 integration links with negative controls. `scripts/test-use-cases-profile.sh` moved onto the shared harness: 2 legacy concepts accepted, 16 focused rejections (9 legacy fixtures unchanged, 7 new). The three new export-to-directory pairs were added to `scripts/test-profile-docs.sh` and `just docs` was run here rather than in milestone 4, so this commit's documentation gate stays green.
- [x] (2026-10-16) Register profiles, update capability descriptions and the V02 house-status list, generate documentation, file the okf and Mori improvement requests, and record the architectural boundary. `mori.dhall` declares `jobs`, `features`, and `product-research` without a version; `mori show --full` prints `mori://shinzui/okf-profiles/profiles/jobs` and `.../features`. The capability header and description, the coordination family overview, and the Policy-one list in `Profile/V02.dhall` (now twelve profiles) were updated. README, CHANGELOG (Unreleased, with the `adopt-capabilities` wording follow-up), and regenerated docs are in place. ADR-17 was allocated with `okf id next` and validates strictly.
- [x] (2026-10-16) With the user's approval, wrote two upstream improvement requests and left them uncommitted in their repositories for review. The Mori request is `mori://shinzui/mori/okf/improvement-requests/concepts/IR-38`, in `docs/improvement-requests/resolve-profile-declared-references-against-registered-concepts.md` of the mori checkout, plus its index and log. The okf request is `mori://shinzui/okf/okf/improvement-requests/concepts/IR-9`, in `docs/improvement-requests/express-product-discovery-constraints-in-profile-descriptors.md` of the okf checkout, plus its log. Both cite the checker's rule IDs.
- [ ] The user commits the two upstream requests after review. For the okf request's URI to resolve, okf's `mori.dhall` must register its `docs/improvement-requests` bundle (see Surprises & Discoveries).
- [x] (2026-10-16) Prove compatibility, run focused negative controls and full checks, and complete the retrospective. `scripts/sweep-profile-rules.py` (ADR-9's second check, made mechanical) ran over jobs, product research, features, and use cases. It found 12 missing fixtures, which were then added: 2 in features and 10 in product research. On re-run, every remaining unprotected relaxation falls into the three expected classes recorded in Surprises & Discoveries. `just check` and `git diff --check` pass. ADR-9 was amended with the lesson.

## Surprises & Discoveries


During implementation (2026-10-16), `okf concepts --json` turned out to keep YAML numbers as JSON numbers, and a YAML `.inf` arrives as the string `".inf"`. The checker can therefore require a JSON number (excluding booleans) and needs no YAML parser. A missing `type` reports both `type not in profile vocabulary` and `missing profile-required field: type`. A missing or malformed ID field reports both the field rule and the core `document ID` rule. These are two diagnostics for one defect, so `expected.json` records `"diagnostics": 2` for exactly those cases rather than loosening the one-deviation assertion.

```text
$ just check   # final run, 2026-10-16, exit 0; new and changed suites:
OK: features profile accepts 3 concepts and rejects 33 focused cases
OK: jobs profile accepts 3 concepts and rejects 34 focused cases
OK: product-discovery graph passes; 22 single-rule mutations fail at their intended field across 16 owned rules; 7 integration links and their negative controls hold
OK: product-research profile accepts 5 concepts and rejects 54 focused cases
OK: profile documentation is current and validates
OK: use-case profile accepts 2 concepts and rejects 16 focused cases
$ python3 scripts/check-product-discovery.py --manifest fixtures/product-discovery/manifest.json
OK: 6 bundles, 18 concepts, 28 references resolved across jobs, product research, features, use cases, capabilities, and specifications
unchecked: 4 owner project URIs and 1 improvement-request URIs are outside this checker's resolution domain
untraversed: generic sources, related use cases, capability requires, specification supersession, and pointer destinations
$ bash scripts/test-product-discovery.sh
OK: product-discovery graph passes; 22 single-rule mutations fail at their intended field across 16 owned rules; 7 integration links and their negative controls hold
$ bash scripts/test-use-cases-profile.sh
OK: use-case profile accepts 2 concepts and rejects 16 focused cases
$ bash scripts/test-features-profile.sh
OK: features profile accepts 3 concepts and rejects 31 focused cases
$ bash scripts/test-jobs-profile.sh
OK: jobs profile accepts 3 concepts and rejects 34 focused cases
$ bash scripts/test-product-research-profile.sh
OK: product-research profile accepts 5 concepts and rejects 44 focused cases
```

A wrong-type target cannot occur for CAP, SPEC, JOB, or FEAT references in strictly valid bundles. Each reference's `externalUriPattern` fixes the target's handle prefix, and in every profile involved each prefix belongs to exactly one type, or to the two specification types that are both allowed. The `reference-target` rule's type check is therefore exercised through the PR namespace, which a study and a finding share (`study-ref-to-finding`, `finding-ref-to-study`). CAP and SPEC are exercised through missing targets and an unmapped bundle. The rule still checks type generally, so a future profile sharing a prefix cannot slip through.

The mutation errors match the plan's example form exactly, for instance:

```text
mori://example/product/okf/use-cases/concepts/UC-1 jobs[0].outcomeNames[0]: [outcome-exists] unknown outcome missing-outcome on mori://example/product/okf/jobs/concepts/JOB-1
```

A supersession cycle reports one error per finding in the cycle (PR-5 and PR-6 in the mutation). The integration test accepts this because every error carries the intended rule. `scripts/test-product-discovery.sh` takes about 35 seconds, mostly strict okf validation of six bundles per mutation. Reverting is proven once over the whole restored tree rather than once per mutation, because each mutation restores exact bytes.

The milestone-5 load-bearing sweep (2026-10-16) relaxed each rule of the four profiles in isolation, using copies normalized by `dhall --file`. It found that review had missed per-type coverage. `Product Research Study` and `Product Research Finding` share field names (`productResearchId`, `description`, `sources`, `jobRef`, `method`, `population`), and the finding's copies had no fixtures. Neither features nor product research had a fixture for the `reviews` family or for the list spelling of `verified`. Twelve fixtures were added. Final sweep totals of unprotected relaxations: jobs 31 of 60, product research 34 of 96, features 30 of 65, and use cases 42 of 60. The use-case figure includes pre-existing legacy gaps (`type`, `useCaseId`, `status`, `origin`, inline member deletions, and `features[].jobs`); none of the rules this plan added or changed are among them. The remaining entries fall into three expected classes:

- unconstrained optional fields (`tags`, the job context fields, outcome measurement members), whose deletion is unobservable because unknown fields are allowed;
- members of the spliced `reviews`, `generated`/`verified`, and `sources` families, which are protected at the family level here and tested member by member in their home profiles;
- `allowSelf` and `allowLocal` on external-only references, which only change behavior together with `localPrefix`, ADR-9's composite policy unit.

The legacy use-case gaps predate this plan and are left as a follow-up rather than widening its scope.

The plan's Concrete Steps name `.agents/skills/exec-plan/record-provenance.ts`, but that path does not exist. The script is at `agents/skills/exec-plan/record-provenance.ts`.

Filing the upstream requests (2026-10-16) found that okf's `docs/improvement-requests` directory is a legacy bundle. It has v0.1 `timestamp` frontmatter and no `index.md`, and okf's `mori.dhall` does not list it under `okfBundles`. A search with `mori registry concepts --search` therefore returns none of its requests, and okf has no profile to allocate handles with. IR-9 was chosen as the next number after its highest handle, IR-8, and the file follows the bundle's existing format. Its canonical URI is the intended `mori://shinzui/okf/okf/improvement-requests/concepts/IR-9`, which will resolve once that bundle is registered. Mori's bundle is profiled and registered, so `okf id next` allocated IR-38 there. Its strict validation reports 36 pre-existing deviations (`reviews` missing on older requests, and one terminal request without `resolution`). IR-38 adds none. `okf log add` reformats existing log entries, so the Mori and okf log edits were applied by hand to keep the diffs additive. No existing registry request covered either need: searches for "reference target existence", "numeric format", "descriptor", "any-of", and "typed edges" found only IR-18, which IR-38 builds on.

`inline-name-unique` turned out to be expressible today with `uniqueBy`, because use-case `jobs` and `features` are top-level record lists with a required scalar `name`. It stays in the checker, tagged `okf`, only because the plan forbids adding unconditional rejections to legacy lists. The okf request records that it retires through an okf-profiles release decision rather than an okf change.

During the 2026-10-16 plan revision, inspection of `profiles/coordination/improvement-requests.dhall` showed an existing `acceptanceCriteria` convention: record-local `id: AC-N`, `statement`, and `verification`, unique by `id`. The feature profile should reuse that shape. Inspection of `profiles/coordination/capabilities.dhall` also found guidance assigning cross-repository composition exclusively to use-case features; it must recognize standalone features while retaining the capability provision-claim boundary.

Plan validation (2026-10-16) found six facts that shaped the revision.

First, okf rejects a handle-reference rule whose `localPrefix` is not an `idPrefix` declared by a type in the same profile. The pinned `okf-core/src/Okf/Profile.hs` emits `ReferencePrefixNotDeclared` in `referenceDefinitionErrors`, and it emits `ReferenceWithFormat` when a rule carries both `reference` and `format`. `profiles/coordination/bug-reports.dhall` records the consequence: "declaring `CAP` here is a profile load failure". The working pattern for an external-only reference is in `profiles/coordination/pattern-applications.dhall` (its `externalOnly` helper) and in `profiles/documentation/terminology.dhall` (`sameAs`). The reference uses the profile's own prefix with `allowLocal = False`, plus an `externalUriPattern` naming the target prefix.

Second, [ADR-12](../adr/0012-guidance-is-an-evidence-backed-exception.md) keeps profile and type `guidance` absent unless there is observed evidence of an authoring failure. The earlier plan text asked for guidance on new profiles.

Third, okf's own ADR-1, `mori://shinzui/okf/okf/adrs/concepts/ADR-1`, says that external references are syntax- and pattern-checked only, and that "Mori owns any later cross-repository lookup". The transitions profile description likewise delegates its joins to `mori transitions validate`. okf's ADR-11, `mori://shinzui/okf/okf/adrs/concepts/ADR-11`, is the process for growing the descriptor language. Mori's completed IR-18, `mori://shinzui/mori/okf/improvement-requests/concepts/IR-18`, already projects profile-declared references as typed concept edges.

Fourth, `HandleReferenceRule.allowSelf` already exists in the pinned schema, so self-reference rejection does not need the checker.

Fifth, `blueprints/adopt-capabilities/README.md`, `blueprints/adopt-capabilities/prompt.md`, and `blueprints/adopt-capabilities/files/authoring-reference.md` repeat the "use-case feature" wording that this plan changes in the capability profile.

Sixth, the baseline suites pass on the starting tree, and the next unused ADR handle is ADR-17 as of this date. It must still be re-allocated at implementation time.

```text
$ bash scripts/test-use-cases-profile.sh
OK: 2 concepts (okf_version 0.2)
OK: use-case profile acceptance and rejection fixtures
$ bash scripts/test-research-documents-profile.sh
OK: research-document profile acceptance and rejection fixtures
$ bash scripts/test-capabilities-profile.sh
OK: capability profile acceptance and rejection fixtures
$ okf id next docs/adr --profile docs/adr/profile.dhall ADR
ADR-17
```

## Decision Log


Decision (2026-10-16): Introduce a separate product-research profile. The user explicitly distinguished customer/product discovery from the technical investigations captured by `documentation.researchDocuments`. Leave that profile, its fixtures, and its generated documentation unchanged.

Decision (2026-10-16): Introduce a feature profile as well as a job profile. The user wants features available to a future UI. A feature has an identity and delivery lifecycle independent of the use cases that reference it. A capability remains a producer's claim about behavior already available; an improvement request remains work proposed to close a repository-owned gap.

Decision (2026-10-16): Model product studies and findings as separate concepts under one profile, sharing a `PR-N` identity namespace. Findings need durable references and must distinguish observation from interpretation. This also avoids unsupported recursively nested metadata.

Decision (2026-10-16): Keep research support separate from document lifecycle and feature delivery. Neither a document review nor a delivered feature proves that a customer job is satisfied. Store explicit assessments with evidence and rationale.

Decision (2026-10-16): Use the currently pinned schema without a dependency upgrade. It supports one level of structured records, conditional presence, nested reference rules, and uniqueness of a top-level list's member. Flatten measurement metadata accordingly. A required list treats an empty list as absent; discovery examples omit absent features instead of promising that a required `features: []` is valid.

Decision (2026-10-16): Preserve inline use-case jobs and features for compatibility, while adding canonical references and a separate opt-in semantic checker for relationships. Do not make a new whole-corpus check an implicit requirement for old consumers. New canonical corpora adopt both profile validation and that checker.

Decision (2026-10-16, integration revision): Add optional `capabilityRefs` and `specificationRefs` to features. Capability links identify producer-provided behavior contributing to the feature; specification links identify its governing or proposed contracts. Neither link asserts completeness, conformance, or delivery. Resolve these new target types in the explicit manifest-based checker, while keeping generic source citations and unrelated artifact families outside its resolution scope.

Decision (2026-10-16, integration revision): Use feature-local `AC-N` criterion IDs with `statement` and `verification`, matching improvement requests. Feature criteria cover product acceptance; request criteria cover repository work. Identical AC-N text on different records does not identify the same criterion or imply that satisfying one satisfies the other.

Decision (2026-10-16, integration revision): Preserve the schemas of improvement requests, bugs, specifications, technical research, capabilities, transitions, runbooks, and standalone reviews. Reuse request `origin`, bug `affects`, and specification/research `sources` for appropriate links. Update capability descriptions and header comments only (no profile `guidance`; see the ADR-12 decision below). Defer widening `assurance.reviews.subjectKind`; the new concepts already support optional inline review provenance.

Decision (2026-10-16): Link this work to intention `intention_01m528193teth8eq0adthgtpvv`, created with the user-requested `mina ci --json` command. Publication, release tags, adoption blueprints, consumer migrations, and a frontend implementation are outside this plan.

Decision (2026-10-16, validation revision): Encode every reference that targets another profile's concepts as an external-only handle reference. The rule uses the declaring profile's own prefix (`JOB`, `PR`, `FEAT`, or `UC`) with `allowLocal = False`, `externalUriSchemes = [ "mori" ]`, and an `externalUriPattern` naming the target prefix. Declaring `CAP`, `SPEC`, or another foreign prefix is a profile load failure. This mirrors `pattern-applications.dhall` and `terminology.dhall`, and it lets Mori index the fields as typed edges. Project URIs such as `owners` keep `format = UriWithScheme "mori"` and carry no reference rule, because okf rejects `format` and `reference` on one rule.

Decision (2026-10-16, validation revision): Leave `guidance = None Text` on every new profile and type, per ADR-12. There is no observed authoring failure to correct yet. Explanations of authorship, research support, observation versus interpretation, and `featureRefs` preference go into short field and type descriptions, Dhall header comments, and `README.md`.

Decision (2026-10-16, validation revision, user decision): Ship the Python checker as an interim, opt-in consumer gate, consistent with ADR-14's rule that corpus-wide checks belong to a consumer gate rather than a profile. Give every semantic rule an intended long-term owner. A rule that reads only one concept's own frontmatter is owned by `okf`, as a descriptor-language extension under okf ADR-11. A rule that traverses a reference to another concept is owned by `mori`, as registry-backed resolution consistent with okf ADR-1. File one improvement request in each of those projects, and retire each checker rule as its owner ships support. The user chose this over three alternatives: keeping the checker as the permanent gate, deferring every check upstream with nothing enforcing in the meantime, and a version that omitted the upstream requests. Moving self-reference rejection into descriptors now with `allowSelf = False` follows from the same split.

Decision (2026-10-16, validation revision): Keep `reviews` optional on the three new profiles. ADR-8's text names `reviews` as the remaining recommended field on research documents, improvement requests, and use cases. However, `documentation.specifications` applies ADR-8's test to place `reviews` in `optional`, because a draft that nobody has reviewed yet is complete for what it is. An untested job, a planned study, or a discovered feature is in the same position. The older coordination profiles keep their recommendation unchanged.

Decision (2026-10-16, validation revision): Do not edit the `adopt-capabilities` blueprint in this plan. Its prose repeats the capability profile's "use-case feature" wording. ADR-7 ties blueprint changes to the catalog tag, and release work is out of scope. Record the three files as a release follow-up in `CHANGELOG.md` under Unreleased so the drift is visible.

Decision (2026-10-16, validation revision): Write new profile tests in the style of the newest suite: a shell wrapper calling a Python script with an `expected.json` that maps each rejection fixture to the field its diagnostic must name, as in `scripts/test-transitions-profile.py`. This makes ADR-9's one-reason rule mechanically asserted rather than inspected by eye.

Decision (2026-10-16, implementation): Make the profile acceptance bundles `fixtures/jobs`, `fixtures/product-research`, and `fixtures/features` the core of the product-discovery graph. `fixtures/product-discovery/manifest.json` points at them through `../jobs`, `../product-research`, and `../features`, and keeps use cases, capabilities, and specifications under `fixtures/product-discovery/`. The plan originally put six separate bundles under `fixtures/product-discovery/`. Sharing them means the examples documenting each profile are also proven graph-coherent, and the two copies cannot drift.

Decision (2026-10-16, implementation): Tighten the transitions-style harness in a shared module, `scripts/profile_fixture_cases.py`. Each rejection fixture's advisory run must report exactly one `profile:` deviation, and that deviation must name the expected field. An `expected.json` value of `{"field": ..., "diagnostics": N}` declares a known overlap of core diagnostics. Transitions only asserts that some line names the field. The stricter form makes ADR-9's one-reason rule mechanical. Fixtures were generated from one valid base concept by single text edits; each fixture's body states the one rule it violates.

Decision (2026-10-16, implementation): The checker splits the plan's semantic constraints into 16 named rules. Four go beyond the plan's two bulleted lists, all derived from constraints in milestones 1 and 3. `baseline-context` (`okf`) requires population, period, and sources whenever an outcome states a baseline. `measurement-matches-outcome` (`mori`) requires a measurement to name a measured outcome in its unit. `reference-target` (`mori`) covers existence and type for every JOB, PR, FEAT, CAP, and SPEC field. `cited-finding-current` (`mori`) is the plan's current-status check. A relationship to a bundle missing from the manifest is a `reference-target` error. `relatedUseCases`, capability `requires`, and specification supersession are left untraversed and named in the success summary, as the plan directs for unrelated relationship classes.

Decision (2026-10-16, implementation): `period-order` requires `periodStart` strictly before `periodEnd`, because a zero-length observation period cannot describe a measured value.

## Outcomes & Retrospective


Completed 2026-10-16. Three new profiles are exported, registered in `mori.dhall` without a version, documented, and tested: `coordination.jobs`, `documentation.productResearch`, and `coordination.features`. `coordination.useCases` links additively to canonical jobs and features; inline `features` is now optional, and its legacy fixtures are unchanged and passing. `scripts/check-product-discovery.py` enforces 16 owner-tagged relationship rules over a manifest. The fixture graph demonstrates everything the plan set out to show:

- a job supported by one finding and challenged by another (JOB-1, PR-2, PR-3);
- one feature reused by two use cases (FEAT-1 in UC-1 and UC-2);
- a draft scenario with no features (UC-3);
- a feature linked to a capability, a specification, and a pointer;
- a request originating from the feature, with its own unrelated `AC-1`;
- a bug affecting the feature;
- technical research and a specification citing product concepts through unchanged schemas.

ADR-17 records the boundary, and ADR-9 was amended with the sweep lesson.

Remaining work belongs to other owners. The user reviews and commits okf IR-9 and Mori IR-38. okf's improvement-request bundle needs registering for IR-9's URI to resolve. The next release aligns the `adopt-capabilities` blueprint wording (noted under Unreleased in `CHANGELOG.md`), and a later plan may close the legacy use-case fixture gaps the sweep surfaced.

Lessons: making ADR-9 mechanical paid off immediately. The one-deviation harness kept every new fixture honest, and the sweep found twelve gaps that careful authoring had missed, all caused by field names shared between types or by spliced families. Sharing the profile acceptance bundles with the discovery graph meant the documentation examples were proven coherent for free. Most of `scripts/test-product-discovery.sh`'s 35 seconds goes to strict okf validation of six bundles per mutation, which is acceptable for now.

## Context and Orientation


This repository publishes Dhall values describing house conventions for Open Knowledge Format (OKF) Markdown bundles. A bundle has an `index.md` declaring `okf_version: "0.2"`, concept documents with YAML frontmatter, and a `log.md` tracking revisions. A profile describes concept types and field constraints. It does not itself implement an application, perform research, or verify that a claim is true. A stable handle such as `UC-1` identifies a concept within its bundle; references crossing bundles need the project-and-bundle-scoped Mori URI. Mori is the project registry used across these repositories, run through the `mori` command. It gives each registered project and artifact a canonical URI such as `mori://shinzui/okf-profiles` or `mori://<namespace>/<project>/okf/<bundle>/concepts/<HANDLE>`. A "job", in the Jobs-to-be-Done (JTBD) sense used by the existing use-case profile, is the progress a person is trying to make in a particular situation, stated independently of any product feature.

`package.dhall` exports `coordination` from `profiles/coordination/package.dhall` and `documentation` from `profiles/documentation/package.dhall`. Add the new exports in those family files. `mori.dhall` separately advertises published profiles. `scripts/test-profile-docs.sh` explicitly enumerates export-to-directory pairs and generates `docs/profiles/`. `just docs` regenerates them; `just check` runs Dhall type checks and every shell test under `scripts/`. Python checks need a shell wrapper to enter this gate.

`profiles/coordination/use-cases.dhall` defines `Use Case` with `useCaseId: UC-N` and `Use Case Theme`. A use case currently requires `jobs`, whose entries contain `name`, `actor`, `situation`, `motivation`, and `outcome`, and `features`, whose entries contain `name`, `description`, `status`, `owners`, and `acceptance`. Optional feature `jobs` names point to inline job names. Feature and use-case improvement requests are canonical external references. The use-case status vocabulary is `draft`, `validated`, `planned`, `in-progress`, `delivered`, `retired`. Existing consumers must retain these fields and meanings. `fixtures/use-cases/001-investigate-alert.md` and `scripts/test-use-cases-profile.sh` establish compatibility examples.

`profiles/documentation/research-documents.dhall` provides technical `Research Document` records with `RES-N` identifiers and `active`, `complete`, `superseded` lifecycle states. Product research gets its own type names, namespace, and required customer context. `profiles/coordination/capabilities.dhall` deliberately excludes planned behavior from capability catalogs. `profiles/assurance/verification-evidence.dhall` concerns reproducible technical verification and is not a customer-study repository. Neither is repurposed here.

Existing integration points are already explicit. `profiles/coordination/improvement-requests.dhall` accepts an artifact URI in `origin` and defines `acceptanceCriteria` as `{ id, statement, verification }`, with `id` formatted as `AC-N` and unique within the record. `profiles/coordination/bug-reports.dhall` accepts an artifact URI in `affects`; its separate `capability` field identifies the provision claim contradicted by a defect. `profiles/documentation/specifications.dhall` and the technical-research profile expose shared `sources`, allowing them to cite the customer needs, findings, or features that motivated their work. Sources are derivation links; feature `specificationRefs` states a governing relationship and must not be replaced by a source citation with a different meaning.

The capability profile's header and description currently say that behavior composed across repositories belongs to a use-case feature. The new standalone Feature is another home for that product behavior, but a capability remains an independently adoptable, evidence-backed producer claim. Update that wording (header comment and `description`, not a `guidance` field) and the family overview in `profiles/coordination/package.dhall`; do not add planned capability states or feature backlinks. The `adopt-capabilities` blueprint repeats the same wording in `blueprints/adopt-capabilities/README.md`, `blueprints/adopt-capabilities/prompt.md`, and `blueprints/adopt-capabilities/files/authoring-reference.md`, and installs a v0.19.0-pinned profile snapshot. Those files are left alone here and listed as a release follow-up (see the Decision Log). Transitions already carry `useCaseRefs`, and runbooks have general `related` references; neither needs a new feature-specific field for this scope. `profiles/assurance/reviews.dhall` limits `subjectKind` to `project`, `component`, `aggregate`, `migration`, and `plan`. Do not mislabel product concepts to fit those values; optional inline `reviews` metadata provides the supported review path in this plan.

Dependency sources were discovered using `mori registry list`, `mori registry search okf`, `mori registry show shinzui/okf --full`, and `mori registry docs shinzui/okf`. The dependency's canonical project identity is `mori://shinzui/okf`. At authoring time curated documentation was absent from its registry entry. Relevant source locations are that project's `okf-core/dhall/Profile.dhall`, `okf-core/dhall/FieldRule.dhall`, `okf-core/dhall/NestedFieldRule.dhall`, and `okf-core/src/Okf/Profile.hs` (artifact-level source URIs pending). Resolve the project using Mori rather than hard-coding a checkout path. `Profile/okf.dhall` pins commit `bdf8893ccf0dfbd77fd68fe3c58348b5e49809c7`; inspect that revision when making descriptor decisions.

That schema bounds structured metadata to one level. `NestedFieldRule` cannot describe a further object or list of structured objects. `uniqueBy` exists on top-level `FieldRule`, not nested rules. Conditional `when` controls whether absence is an error; present values still receive shape and value checking. An empty list counts as absent, so it fails a required-list rule and can be accepted when presence is optional. External reference validation checks syntax and policy, not the existence or type of a target in another bundle. `okf concepts BUNDLE --json` returns a JSON array containing frontmatter, including structured values, but paths cannot be assumed to appear in those rows.

Four further schema rules decide how the descriptors must be written.

A `HandleReferenceRule` is `{ localPrefix, externalUriSchemes, allowSelf, allowLocal, externalUriPattern }`. Its `localPrefix` must equal an `idPrefix` declared by some type in the same profile, and the profile must set `idField`. A rule may not carry both `reference` and `format`. Local handle references are resolved by okf against the bundle's own ID index. External ones are only matched against the whole-value `externalUriPattern`.

To reference another profile's concepts, use the declaring profile's own prefix with `allowLocal = False` and a pattern such as `mori://[^/]+/[^/]+/okf/[^/]+/concepts/CAP-[1-9][0-9]*`. `profiles/coordination/pattern-applications.dhall` (the `externalOnly` helper) and `profiles/documentation/terminology.dhall` (`sameAs`) do this today. `allowSelf = False` rejects a concept referring to itself.

A `when` condition (`FieldCondition { field, hasValue }`) must name a scalar field with a closed `allowedValues` vocabulary in the same scope, such as a type's `status`. It controls only whether the field's absence is reported.

`uniqueBy` names a nested member that must be an unconditionally required scalar.

Two types in one profile may share an `idPrefix` and the profile's single `idField`. `profiles/documentation/specifications.dhall` does this for `Specification` and `Specification Pointer`, which share `SPEC-N`.

okf's boundaries are explicit upstream. Its ADR-1, `mori://shinzui/okf/okf/adrs/concepts/ADR-1`, keeps okf offline: "Mori owns any later cross-repository lookup", and external target existence, inverse references, and graph cycles are outside okf. Its ADR-11, `mori://shinzui/okf/okf/adrs/concepts/ADR-11`, defines how new descriptor features are added: a frozen-generation decoder per schema change, followed by a release this repository then pins. Mori's completed IR-18, `mori://shinzui/mori/okf/improvement-requests/concepts/IR-18`, already projects profile-declared references as typed concept edges. The transitions profile's description ends with "Run mori transitions validate after strict profile enforcement", which is the existing precedent for Mori-owned cross-bundle checks.

Relevant local decisions are [ADR-1](../adr/0001-house-status-diverges-from-okf-v0-2.md), which permits deliberate house lifecycle vocabularies; [ADR-4](../adr/0004-reviews-and-verified-coexist.md), which distinguishes detailed reviews from OKF confirmations; [ADR-5](../adr/0005-v0-2-field-families-are-defined-once.md), which requires reuse of `Profile/V02.dhall`; [ADR-7](../adr/0007-blueprint-versions-track-the-catalog-tag.md), which bumps a blueprint's version only in lockstep with a catalog release; [ADR-8](../adr/0008-recommended-means-a-well-run-corpus-carries-it.md), which reserves recommendations for actual deficiencies (`documentation.specifications` applies it to keep `reviews` optional for drafts); [ADR-9](../adr/0009-a-rejection-fixture-must-fail-for-exactly-one-reason.md), which requires focused diagnostics and negative controls; [ADR-10](../adr/0010-a-review-is-an-artifact-not-only-an-annotation.md), which separates document review annotations from standalone review artifacts; [ADR-12](../adr/0012-guidance-is-an-evidence-backed-exception.md), which keeps profile and type `guidance` absent unless there is evidence of a demonstrated authoring failure; [ADR-13](../adr/0013-a-specification-is-not-a-decision-or-a-reference.md), which separates document classes by the questions they answer; and [ADR-14](../adr/0014-a-term-defines-a-word-and-derives-its-inverse-relations.md), which derives inverse relations rather than authoring them and places corpus-wide checks in a consumer gate rather than a profile. No existing ADR decides the product-discovery boundary introduced here. Create one during implementation, allocating its handle with OKF rather than guessing it.

The newest test style to copy is `scripts/test-transitions-profile.sh`, a two-line wrapper around `scripts/test-transitions-profile.py`. The Python script validates the acceptance bundle strictly. Then, for every entry in `fixtures/transitions-invalid/expected.json` (fixture name → field name), it asserts that an advisory run's diagnostics name that field and that an enforced run fails. It reads `OKF_BIN` and an optional `PROFILE` override from the environment. `just test` runs every `scripts/*.sh` from the repository root, so a Python test needs such a wrapper to enter the gate.

## Plan of Work


### Milestone 1: Publish jobs and product-research contracts


Add `profiles/coordination/jobs.dhall` and `profiles/documentation/product-research.dhall`. Export them as `coordination.jobs` and `documentation.productResearch`, with profile names `jobs` and `product-research`. The new profiles declare OKF 0.2, require bundle version 0.2, reject unknown concept types, and retain the default open extension-field policy. Require `type`, `title`, `description`, and shared `v02.generated` on every concept. Make `reviews` (the house `Profile/ReviewRule.dhall` family) and shared `v02.verified` optional, applying ADR-8's test the way `documentation.specifications` does: a hypothesis or observation can legitimately exist before anyone reviews the document. Mirror approvals without inventing human provenance. Do not declare legacy timestamps on new profiles. Use house lifecycle statuses and do not splice the standard status/staleness pair. Leave `guidance` at its `None Text` default on every profile and type, per ADR-12. Explain authorship, research support, and observation versus interpretation in short field and type descriptions, Dhall header comments, and `README.md`. okf echoes a description inside its missing-field diagnostic, so keep descriptions to one sentence and put longer reasoning in comments.

Every reference to a concept owned by a different profile is written as an external-only handle reference. The rule uses the declaring profile's own `localPrefix`, sets `allowLocal = False` and `externalUriSchemes = [ "mori" ]`, and sets an `externalUriPattern` of the form `mori://[^/]+/[^/]+/okf/[^/]+/concepts/<TARGET>-[1-9][0-9]*`. Never declare the target's prefix: okf rejects a reference prefix the profile does not declare. Never combine `reference` with `format`. Define a small `externalOnly` helper per profile, as `profiles/coordination/pattern-applications.dhall` does.

The jobs profile contains one type, `Job`, with `jobId: JOB-N`, `idField = Some "jobId"`, prefix `JOB`, and root-level concept paths (`pathPattern = Some "*"`). Require `actor`, `situation`, `motivation`, `status`, `validationStatus`, and `outcomes`. `status` is `draft`, `active`, or `retired`. `validationStatus` is `untested`, `supported`, `mixed`, or `challenged`. A job states desired customer progress independently of a particular UI or implementation. It remains active even if one attempted solution fails.

`outcomes` is a non-empty list unique by required scalar `name`. Each entry also requires scalar `description`. Optional flat members are `metric`, `unit`, `direction`, `method`, `baseline`, `target`, `population`, and `period`. `direction` is `increase`, `decrease`, or `maintain`. A qualitative outcome may omit all measurement members. If any measurement member exists, the semantic checker requires `metric`, `unit`, `direction`, and `method` together. `baseline` and `target` are finite numbers in the declared unit, enforced by the checker because the current descriptor has no general numeric-scalar rule. A stated baseline additionally requires population/period context and a top-level `sources` entry documenting its evidence. A target is an aspiration, never an observation. Do not require metric definitions for every job.

Optional job fields are `functionalContext`, `emotionalContext`, `socialContext`, `relatedJobs`, `sources` using the shared family, and `assessment`. `relatedJobs` accepts local JOB handles or canonical external job concept URIs. Its reference rule is `localPrefix = "JOB"`, `allowLocal = True`, `allowSelf = False`, with a JOB-N `externalUriPattern`, so okf itself resolves local handles and rejects self-reference. `assessment` is a top-level object with required `rationale`, `assessedAt` (RFC3339 UTC), and non-empty `findingRefs` (canonical product-research concept URIs). `findingRefs` is an external-only nested reference with `localPrefix = "JOB"` and a PR-N pattern. Its presence is required whenever `validationStatus` is `supported`, `mixed`, or `challenged`. An `untested` job may omit it. The checker ensures cited concepts are findings about this job; support is an explicit synthesis, not a vote or count of findings. Do not infer it from `verified`.

The product-research profile has `idField = Some "productResearchId"`. Both `Product Research Study` and `Product Research Finding` use unique `PR-N` identifiers, prefix `PR`, and root-level documents. Sharing the prefix enables one bundle-wide allocator while type checking stays explicit; `profiles/documentation/specifications.dhall` is the precedent for two types sharing one prefix and `idField`. Within this profile, `studyRef` and `supersededBy` use `localPrefix = "PR"` with `allowLocal = True`, a PR-N pattern, and (for `supersededBy`) `allowSelf = False`. Study `jobRefs` and the nested `jobRef` members below are external-only with `localPrefix = "PR"` and a JOB-N pattern. The study is the bounded research activity; the finding is a separately citable observation and interpretation. There is no automatically stored inverse list of findings on a study.

A study requires `question`, `method`, `population`, `context`, and `status`. Methods are `interview`, `observation`, `survey`, `experiment`, `analytics`, `desk-research`, or `mixed`; mixed methods must be explained in the body. Status is `planned`, `active`, `complete`, or `cancelled`. Optional fields are `jobRefs`, shared `sources`, `startedAt`, `completedAt`, and `limitations`; timestamps use RFC3339 UTC. `completedAt` and `limitations` become required at `complete`; `cancellationReason` becomes required at `cancelled`. A completed study may conclude that it found nothing conclusive. A study can precede identification of a job, so `jobRefs` stays optional.

A finding requires `studyRef`, `observation`, `interpretation`, `context`, `observedAt`, `limitations`, shared `sources`, and `status`. `studyRef` accepts a local `PR-N` or a canonical product-research concept URI; the semantic checker requires a study target. `observation` states what was seen; `interpretation` states the conclusion drawn. `observedAt` records the observation time, independently of `generated.at`. `status` is `current`, `superseded`, or `withdrawn`; require `supersededBy` for a superseded finding and `withdrawalReason` for a withdrawn one. `supersededBy` must target another finding. Raw material may live outside the bundle and is referenced through `sources`; do not copy sensitive transcripts into examples.

Optional `jobAssessments` is a non-empty list of flat records with required `jobRef`, `claim`, `stance`, and `rationale`, and optional `outcomeName`. `stance` is `supports`, `challenges`, or `inconclusive`. Assess the named claim, not every possible assertion about the job. Optional `measurements` is a non-empty list of flat records requiring `name`, `jobRef`, `outcomeName`, `value`, `unit`, `method`, `population`, `periodStart`, and `periodEnd`; use `uniqueBy = Some "name"`. The value must be finite numeric data; periods are RFC3339 UTC and must be ordered. A measurement refers to a defined measurable outcome and uses its unit; conversions must be explicit in the finding before reporting a compatible value. Both findings and jobs can exist without quantitative measurements.

Add `fixtures/jobs`, `fixtures/jobs-invalid`, `fixtures/product-research`, and `fixtures/product-research-invalid`, each acceptance bundle carrying valid index and log files. Demonstrate a draft untested job, a supported job, a qualitative outcome, a measured outcome, a planned study with no findings yet, and two findings with opposed assessments of a job. Test wrappers are `scripts/test-jobs-profile.sh` and `scripts/test-product-research-profile.sh`. Following `scripts/test-transitions-profile.sh`, each calls a Python script (`scripts/test-jobs-profile.py`, `scripts/test-product-research-profile.py`) that supports `OKF_BIN`, accepts an optional `PROFILE` override for mutation testing, checks strict acceptance with `--log-enforce`, and asserts focused rejection diagnostics. The fixture-to-field mapping lives in `fixtures/jobs-invalid/expected.json` and `fixtures/product-research-invalid/expected.json`. Include a rejection fixture for a job whose `relatedJobs` names itself and a finding whose `supersededBy` names itself. This milestone is complete when both profiles type-check and their scripts pass independently. Cross-bundle semantic checks arrive in milestone 3.

### Milestone 2: Publish independently addressable features


Add `profiles/coordination/features.dhall`, exported as `coordination.features`, profile name `features`, with a single `Feature` type. Apply the same common metadata and lifecycle conventions as the new profiles above. Set `idField = Some "featureId"`, prefix `FEAT`, and root-level paths. A stable `FEAT-N` concept describes a coherent product behavior that can advance through discovery and delivery and can appear in more than one use case. Its identity does not depend on its title, owning repository, or a screen layout.

Require `featureId`, `status`, and `behavior` in addition to common metadata. `status` is `discovered`, `planned`, `in-progress`, `delivered`, `blocked`, `deferred`, or `retired`. `behavior` states the proposed or actual customer-visible behavior. Optional fields are `jobRefs`, `outcomeRefs`, `capabilityRefs`, `specificationRefs`, `owners`, `acceptanceCriteria`, `improvementRequests`, `deliveredAt`, `deliveryEvidence`, and `priority`. All cross-bundle artifact references are canonical Mori URIs, written as external-only handle references with `localPrefix = "FEAT"` and `allowLocal = False`. The `externalUriPattern` ends in JOB-N for `jobRefs` and `outcomeRefs[].jobRef`, CAP-N for `capabilityRefs`, SPEC-N for `specificationRefs`, and IR-N for `improvementRequests`, each accepting any producer-selected bundle name. `owners` is a list of canonical Mori project URIs and uses `format = Some (FieldFormat.UriWithScheme "mori")` with no reference rule, matching the inline use-case `owners`. `jobRefs` can be absent for technical enabling features; do not invent customer jobs merely to populate it. `outcomeRefs` contains flat `{ jobRef, outcomeName }` records, whose jobs must also appear in `jobRefs`.

`capabilityRefs` is a non-empty list, when present, of canonical CAP-N concept URIs naming producer capabilities that contribute implementation behavior. It can name only some of the implementation; a feature can be planned around capabilities that already exist, while missing producer behavior is represented by improvement requests. Do not create planned capability records. `specificationRefs` is a non-empty list, when present, of canonical SPEC-N concept URIs naming `Specification` or `Specification Pointer` records that govern or are proposed to govern the feature. Show the target's lifecycle/version when presenting it; a draft specification is not a ratified obligation. The graph checker checks existence and allowed target type, not conformance, completeness, or lifecycle promotion. Pointer targets are accepted without recursively resolving their `authoritativeSpec`. Neither field is required for discovery or delivery, and neither causes a feature status to change. Do not store inverse feature lists on capabilities or specifications.

`acceptanceCriteria` is a non-empty list unique by required scalar `id`, formatted with `FieldFormat.DocumentHandle "AC"`. Every entry requires `id`, `statement`, and `verification`, following the existing improvement-request shape. `statement` describes the observable product acceptance condition; `verification` describes the expected procedure or evidence, not a claim that it already passed. An AC-N ID is stable and unique only within its owning feature, so references to a criterion require the owning feature URI plus the criterion ID; do not invent a Mori fragment convention. Feature criteria and request criteria remain independent even if both use `AC-1`. Match the existing descriptor constraints without changing the improvement-request profile or introducing a shared helper refactor as incidental work. `owners` and `acceptanceCriteria` are conditionally required for `planned`, `in-progress`, `blocked`, and `delivered`. A discovered feature may have neither. `deliveryEvidence` reuses the structure of the shared source rule under the house field name, with its purpose clearly described; it names evidence of delivered behavior. `deliveredAt` (RFC3339 UTC) and `deliveryEvidence` become required when delivered. Retiring a feature preserves its handle and history. Delivery evidence demonstrates implementation acceptance, not customer outcome improvement.

`priority`, when present, is `low`, `medium`, `high`, or `critical`. It is a producer's declared ordering signal for a future UI, not a computed score. Do not add frontend component names, routes, CSS properties, UI framework details, or an invented scoring algorithm. Do not store inverse `useCaseRefs`: derive where a feature is used from the use-case references. Improvement-request links remain optional external IR concept URIs; no changes to the improvement-request profile are needed.

Add `fixtures/features`, `fixtures/features-invalid` (with `expected.json`), `scripts/test-features-profile.sh`, and `scripts/test-features-profile.py` in the same style as milestone 1. Include discovered and delivered features, a feature with multiple repository owners, an enabling feature without a job, and a feature with capability and specification links. Isolated rejections cover missing required delivery information, invalid status/priority, missing criterion id/statement/verification, wrong AC prefix, duplicate criterion IDs, malformed owners, malformed CAP/SPEC/IR artifact references, and core metadata. The profile must type-check and its tests pass before integrating use cases.

### Milestone 3: Connect use cases and validate the relationship graph


Extend `profiles/coordination/use-cases.dhall` additively. Keep its types, handles, lifecycle vocabulary, inline job structure, and existing feature-entry constraints. Add optional `jobs[].jobRef`, a canonical job concept URI, and optional `jobs[].outcomeNames`, a list of outcome names. `jobRef`, the new top-level `featureRefs`, and `features[].featureRef` are external-only handle references with `localPrefix = "UC"` (the only prefix this profile declares), `allowLocal = False`, and JOB-N or FEAT-N patterns. A linked inline job supplies this scenario's actor, circumstances, motivation, and desired outcome; it does not replace the canonical job. An `outcomeNames` member requires `jobRef` in the semantic checker and must name actual outcomes.

Add top-level optional `featureRefs`, a non-empty list of canonical feature concept URIs. A use case adopting standalone features uses this list and omits inline `features`. Keep inline `features` available for existing corpora, but move its presence from required to optional. Add optional `features[].featureRef` for a transitional inline record connected to a standalone feature. Every existing inline child constraint still applies when present. A linked inline record is a retained scenario snapshot; the standalone feature owns current delivery status, ownership, and shared acceptance. A UI must not overwrite canonical values from the snapshot. The `featureRefs` field description and the README's authoring section, not a profile `guidance` field, state the preference for `featureRefs` and the avoidance of duplicate inline records.

Both representations may occur during migration, but the semantic checker rejects referencing the same canonical feature twice, whether within `featureRefs`, through inline `featureRef`, or across the two. It checks uniqueness of inline job and feature names and resolves `features[].jobs` against this use case's inline job names. Keep these extra semantic constraints opt-in for existing corpora rather than adding new unconditional descriptor constraints to legacy lists.

A `draft` or `validated` scenario can have no features. `planned`, `in-progress`, and `delivered` scenarios require at least one inline feature or canonical feature reference in the semantic checker. A retired scenario can omit features. This alternative-presence condition cannot be expressed by the current descriptor; document explicitly that profile-only validation now checks feature shape but the additional checker enforces delivery readiness. Do not add an upstream validator extension or require a new discriminator field on all existing use cases. Empty optional lists are treated as absent, never as evidence that a delivery condition is met. `validated` remains a scenario lifecycle state and makes no automatic claim about the job's research support.

Implement `scripts/check-product-discovery.py` using Python's standard library, subprocess calls to `okf`, and a required JSON manifest. It is an interim, opt-in consumer gate in ADR-14's sense, not part of any profile. Each check it performs is a named rule whose intended long-term owner is recorded in a module-level table of `{ id, owner, description }` entries. `owner` is `okf` when the rule reads only one concept's own frontmatter, since that is a descriptor-language gap to close under okf ADR-11. It is `mori` when the rule follows a reference to another concept, which is registry resolution under okf ADR-1. `python3 scripts/check-product-discovery.py --list-rules` prints that table, one rule per line, and exits 0 without a manifest. The upstream improvement requests filed in milestone 4 cite these rule IDs, so each rule can be deleted when its owner ships support. The command is `python3 scripts/check-product-discovery.py --manifest PATH`; it respects `OKF_BIN`. The manifest has `bundles`, a list of `{ uri, path, profile }` objects. `uri` is a canonical bundle URI, `path` is a local bundle directory, and `profile` is its descriptor. Resolve paths relative to the manifest file. Validate the manifest, run strict profile and log enforcement for each supplied bundle, and read concepts with `okf concepts BUNDLE --json`. Index by bundle URI plus the correct ID field for each concept type. Use argv arrays, never shell interpolation, and never fetch a URI from the network.

Resolve local `PR-N` references inside the finding's product-research bundle and local JOB references inside a jobs bundle. All cross-bundle links in this design are canonical concept URIs. Use handle patterns `JOB-[1-9][0-9]*`, `PR-[1-9][0-9]*`, and `FEAT-[1-9][0-9]*`; bundle names are producer-selected, so URI patterns must not hard-code `jobs` or `product-research` as the only permitted bundle names. Project owner references have project scope rather than concept scope. Imported jobs, studies, findings, features, capabilities, and specifications must be supplied through manifest mappings whenever they are referenced by scoped relationship fields. Index `Capability` using `capabilityId: CAP-N` and `Specification`/`Specification Pointer` using `specId: SPEC-N` in addition to the new profiles' ID fields. `capabilityRefs` must target a `Capability`; `specificationRefs` may target either specification type. Their external-reference patterns end with CAP-N or SPEC-N and accept producer-selected bundle names. Accept only these known core concept types and the existing `Use Case Theme` in the checker's manifest; theme concepts are validated but do not require IDs or enter the handle index. Missing mappings or missing/wrong-type targets are errors, not silent successes. Owners and improvement requests are outside this checker's resolution domain: validate their shape in the profiles, and report them as externally unchecked in the checker's success summary. Generic `sources`, capability-to-capability dependencies, specification supersession and pointer destinations are also outside semantic resolution in this checker: profile constraints still apply, and the summary identifies these untraversed relationship classes. Do not present this as global Mori resolution.

Enforce all semantic constraints described above, grouped by intended owner.

Rules owned by `okf` read only one concept's frontmatter:

- numeric values that exclude booleans and non-finite values (`baseline`, `target`, `value`);
- measurement field completeness on job outcomes;
- measurement period ordering;
- `outcomeRefs[].jobRef` also appearing in the feature's `jobRefs`;
- uniqueness of inline job and feature names within a use case;
- `features[].jobs` naming this use case's own inline jobs;
- `outcomeNames` requiring a sibling `jobRef`;
- duplicate canonical feature references within one use case;
- delivery-stage feature presence (`features` or `featureRefs`).

Rules owned by `mori` follow references:

- target existence and type for JOB, PR study, PR finding, FEAT, CAP, and SPEC references;
- outcome-name existence on the referenced job;
- assessment evidence, meaning that every cited current finding has at least one `jobAssessments` entry targeting the assessed job;
- current-status checks on cited findings;
- supersession cycles.

Withdrawn or superseded findings cannot substantiate the current job assessment; authors must re-assess it or cite replacements. Do not derive `supported`, `mixed`, or `challenged` by counting stances. Self-reference is rejected by the descriptors' `allowSelf = False`, not by the checker. Document checks that remain editorial, including whether an observation truly supports an interpretation or whether study sampling is adequate.

Errors identify the source canonical concept URI, the full field path, such as `jobs[0].outcomeNames[0]`, and the rule ID in brackets. Exit 0 only when every scoped check passes, 1 on validation errors, and 2 on bad CLI usage or an unreadable/invalid manifest. Report a concise success summary with concept and checked-reference counts and the external-resolution boundary.

Create `fixtures/product-discovery/manifest.json`, with six acceptance bundles under `fixtures/product-discovery/jobs`, `research`, `features`, `use-cases`, `capabilities`, and `specifications`. Use synthetic project identity `mori://example/product` solely as fixture data. Include two use cases referring to one FEAT concept, one draft without features, a CAP concept providing part of that feature, and a governing SPEC concept. Include a second acceptance case with a Specification Pointer so both allowed target types are exercised. Link the specification's existing `sources` entries to the relevant job, finding, and feature. Use existing capability/specification profiles and satisfy their strict and log requirements rather than creating new requirements on those profiles.

Alongside these six bundles add `fixtures/product-discovery/improvement-requests`, `bug-reports`, and `technical-research` as integration examples governed by their existing profiles. They are not entries in the discovery checker's manifest. The request uses its existing `origin` to name FEAT-1, and FEAT-1 lists that request in `improvementRequests`; do not add a reciprocal feature field to requests or assume every referenced request must have that origin. The bug's existing `affects` names FEAT-1 and its `capability` names the contradicted CAP concept. The technical investigation uses existing `sources` to cite FEAT-1. The request and feature deliberately each have `AC-1` with different statements and verification procedures, proving that criteria are scoped to their owners. `scripts/test-product-discovery.sh` must strictly validate these three auxiliary bundles, then inspect their `okf concepts --json` data to assert these exact fixture relationships. This is a bounded integration test, not a new general-purpose validator for request origins, bug targets, or sources. Add `scripts/test-product-discovery.sh` with Python-based negative cases in a temporary directory, so each mutation leaves all unrelated checks passing. Update `scripts/test-use-cases-profile.sh` and add its new shape/reference fixtures while retaining existing fixtures unchanged. This milestone passes when both legacy use-case validation and the new complete graph work, and a wrong outcome, wrong study type, missing imported feature, missing/wrong-type CAP or SPEC target, and delivery-stage scenario without features each fail at the intended field. Add focused integration-test negative controls for the request origin, bug affects/capability, and specification/technical-research sources, asserting the expected fixture field when one intended link is removed or changed.

### Milestone 4: Register and document the public contracts


Add profile declarations in `mori.dhall` for `jobs`, `product-research`, and `features`, with the correct exports and paths. Their canonical catalog references are `mori://shinzui/okf-profiles/profiles/jobs`, `mori://shinzui/okf-profiles/profiles/product-research`, and `mori://shinzui/okf-profiles/profiles/features`. These are intended artifact identities even if registry refresh has not made them resolvable. Do not advertise an unissued release tag: omit the optional version for new entries until release work assigns it.

Extend `scripts/test-profile-docs.sh` with `coordination.jobs:jobs`, `documentation.productResearch:product-research`, and `coordination.features:features`. Update the header comments and profile description in `profiles/coordination/capabilities.dhall`, plus the family overview in `profiles/coordination/package.dhall`, to recognize standalone product features alongside use-case features. Preserve every capability field, status, and validation rule. In the "Policy one" header comment of `Profile/V02.dhall`, add `coordination.jobs` (`status` and `validationStatus`), `documentation.productResearch` (study and finding `status`), and `coordination.features` (`status`) to the list of profiles keeping a house `status` vocabulary, and correct the count. This is a comment-only change. Run `just docs` to generate new bundles and refresh use-case and capability documentation. Update `README.md` with exports, concept responsibilities, the distinction between technical and product research, canonical authoring and migration examples, the new capability/specification relationships, owner-scoped AC-N criteria, existing request/bug/source integration fields, the deferred standalone-review extension, and both validation layers. Update `CHANGELOG.md` under Unreleased with the three additions, optional links, capability guidance changes without schema changes, reuse of the existing acceptance-criterion shape, the relaxed inline-feature presence rule, and the need for the semantic checker when enforcing the alternative delivery representations. Explain that consumers refresh their package semantic hash when they eventually repin; this plan does not publish a version or change existing blueprint pins. Add a follow-up line naming the three `adopt-capabilities` blueprint files whose "use-case feature" wording the next release must align with the capability profile.

File two upstream improvement requests, one per owner, so that the interim checker's rules have a path to retirement. Each request lives in the receiving project's own improvement-request bundle and sets `origin` to this plan's canonical URI, `mori://shinzui/okf-profiles/plans/12-add-jobs-and-product-research-profiles-linked-to-use-cases`. This is the convention visible in `docs/improvement-requests/add-a-platform-transitions-profile.md`, whose `origin` is a Mori plan.

The okf request covers the `okf`-owned rules. It asks for descriptor features that would express them, for example a finite-decimal format, co-presence of nested members, ordering between two timestamp members, nested uniqueness, an any-of presence condition, and intra-concept name resolution. It lists the checker rule IDs each feature would retire.

The Mori request covers the `mori`-owned rules. It asks for registry-backed existence and type checks on profile-declared reference edges, which IR-18 already indexes, plus the outcome-name, assessment-evidence, and cycle checks, again listing rule IDs.

Before writing, discover each bundle and its descriptor with `mori registry show shinzui/okf --full`, `mori registry show shinzui/mori --full`, and that project's `mori.dhall` `okfBundles` entry. Check for an existing request covering the same need with `mori registry concepts --search`. Allocate each handle with `okf id next` against that bundle, add a log entry, and validate strictly with the bundle's own profile. These writes land in other repositories, so confirm with the user before making them. If the user declines, record the request text in this plan's Surprises & Discoveries instead. Record the resulting canonical request URIs in this plan, in `README.md` beside the checker, and in the new ADR.

Create a profiled ADR recording the separation of jobs, product research, features, scenarios, capabilities, and repository requests, the meanings and direction of capability/specification links, the distinction between feature and request acceptance criteria, the unchanged existing-profile schemas and deferred standalone reviews, and why cross-bundle validation is separate from descriptor validation. It also records the interim status of the checker, the okf/mori ownership split with links to both upstream requests, and the external-only reference encoding. Read and type-check `docs/adr/profile.dhall`; obtain the next handle with `okf id next`, preserve the established filename convention (`NNNN-slug.md`, zero-padded to four digits), update the index and bundle log, and validate strictly. Cite this plan locally through the ADR's `originatingPlan` frontmatter field, as `docs/adr/0012-guidance-is-an-evidence-backed-exception.md` does. Existing technical-research documents retain their original contract. This milestone is observable through `okf profile list --no-local --registry ./package.dhall`, current generated docs, a strictly valid ADR bundle, and two recorded upstream request URIs (or their declined text) that cite the checker's rule IDs.

### Milestone 5: Prove compatibility and complete the plan


Run every new profile suite, the existing use-case, capability, specification, improvement-request, bug-report, standalone-review, and technical-research suites, graph/integration tests, generated-doc checks, and `just check`. Capability changes are guidance-only and must leave its validation behavior unchanged; the other reused profiles retain their existing descriptors and baseline fixtures. Apply ADR-9 to all changed rules: inspect advisory diagnostics for one intended violation per isolated rejection and perform negative controls by relaxing the governing constraint in a temporary descriptor. Existing invalid use-case fixtures are included, not merely newly added ones. Keep relative imports resolvable in temporary descriptor copies; do not mutate the working profile with unsafe reset/restore loops. Composite format/prefix or nested-shape constraints may need to be relaxed together as the authored policy unit, as ADR-9 explains. Record a rule-to-fixture mapping and any known overlapping core diagnostics with specific reasons.

For semantic checks, show that the valid fixture passes, each single mutation fails at its intended source URI, field, and rule ID, and reverting that mutation restores success. Assert that every rule printed by `--list-rules` has an owner of `okf` or `mori`, is exercised by at least one mutation, and is cited by the matching upstream request. Cover both declarative and semantic boundaries: profile validation can accept a well-formed external reference whose target is missing, but the manifest-based checker must reject it. No test claims to prove research truth. Record actual output summaries in this plan, distill any further durable lessons into the ADR, and mark work complete only after those gates pass.

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
python3 scripts/check-product-discovery.py --list-rules
python3 scripts/check-product-discovery.py --manifest fixtures/product-discovery/manifest.json
bash scripts/test-product-discovery.sh
bash scripts/test-use-cases-profile.sh
bash scripts/test-research-documents-profile.sh
bash scripts/test-capabilities-profile.sh
bash scripts/test-specifications-profile.sh
bash scripts/test-improvement-requests-profile.sh
bash scripts/test-bug-reports-profile.sh
bash scripts/test-reviews-profile.sh
```

The manifest's path bases are explicit; for example the jobs bundle entry is:

```json
{
  "uri": "mori://example/product/okf/jobs",
  "path": "jobs",
  "profile": "../../profiles/coordination/jobs.dhall"
}
```

The complete manifest wraps this and the other five core entries in `{ "bundles": [...] }`, adding capability and specification mappings with their existing descriptors. The three auxiliary request/bug/technical-research bundles are validated separately by the integration suite. The checker success summary must distinguish resolved discovery, capability, and specification concepts from owners, IR references, and generic relationships that were not semantically resolved. A negative mutation of a use-case outcome should include an error of this form, with actual identifiers and indexes from the fixture:

```text
mori://example/product/okf/use-cases/concepts/UC-1 jobs[0].outcomeNames[0]: [outcome-exists] unknown outcome missing-outcome on mori://example/product/okf/jobs/concepts/JOB-1
```

`--list-rules` prints one line per rule with its ID, owner, and description, for example:

```text
outcome-exists  mori  A use-case or feature outcome name exists on the referenced job.
measurement-complete  okf  A job outcome with any measurement member has metric, unit, direction, and method.
```

Before filing the upstream improvement requests in milestone 4, discover each receiving bundle and check for existing coverage:

```bash
mori registry show shinzui/okf --full
mori registry show shinzui/mori --full
mori registry concepts --search 'reference target existence' --json
mori registry concepts --search 'numeric format' --json
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


The feature is accepted when a reader can independently allocate and query JOB, PR, and FEAT handles; keep a customer job untested without fabricating evidence; record a study before it produces findings; cite actual observations and opposed interpretations; and show one feature reused by two scenarios without duplicating its current delivery state. Moving a feature to delivered requires its implementation acceptance evidence, while the job's assessment remains an independent declaration. A qualitative job is valid without metrics. A linked capability or ratified specification does not promote a feature to delivered, and a delivered feature does not establish specification conformance or job satisfaction.

A canonical use case can omit inline features and reference a FEAT concept instead. An early use case may omit both representations. A delivery-stage use case lacking both is rejected by the documented graph check. Previously valid inline use-case and technical-research fixtures still pass. Feature owners and IR links retain their current Mori conventions. The integration example navigates from two scenarios to one feature, its job, implementation requests, capability, specification, and a bug affecting it. Specification and technical-research sources cite the relevant product concepts using their existing schemas. Feature AC-1 and request AC-1 coexist with different meanings, while duplicate AC-1 IDs within one feature are rejected. Standalone reviews, transitions, and runbooks retain their schemas. No real consumer repository is changed by the demonstration.

Malformed IDs (including AC-N), missing criterion verification, bad timestamps and actors, duplicate outcome names or criterion IDs, unsupported vocabularies, missing conditional fields, malformed URI families, and wrong metadata shapes receive profile failures. Missing/wrong-type imported concepts including CAP/SPEC targets, invalid local outcome names, partial measurement definitions, invalid numeric observations, reversed periods, unrelated assessment evidence, duplicate feature references, and missing delivery-stage features receive semantic-check failures. A job whose `relatedJobs` names itself, and a finding whose `supersededBy` names itself, receive profile failures through `allowSelf = False`. Error messages identify the failing concept and field, and semantic errors also name the rule ID; a nonzero exit alone is insufficient evidence. Every semantic rule is listed by `--list-rules` with an `okf` or `mori` owner, and two upstream improvement requests citing those rule IDs exist, or their declined text is recorded in this plan.

The UI-facing deliverable is stable, queryable concept identity and explicit relations, observable through `okf concepts --json`. It does not promise a frontend API, interactive screens, automatic prioritization, synchronization into a remote service, or proof that a feature caused an outcome. Documentation explains these boundaries as part of the contract.

## Idempotence and Recovery


All adoption is additive and opt-in. Do not rewrite existing inline use cases or turn technical research into product findings. Preserve existing handles when authors later link records to canonical concepts. Canonical `featureRefs` is the preferred new representation; inline linked snapshots can be removed deliberately by consumers after preserving scenario-specific prose. A record's rename must not change its handle. Existing profiles do not acquire mandatory product dependencies. Reusing the AC-N shape is for new standalone feature records; do not migrate legacy inline `acceptance` prose or renumber request criteria as part of this work.

Tests create temporary copies for semantic mutations and negative controls. Clean up only temporary paths created by the test, preserve unrelated working-tree changes, and never use blanket reset/restore commands. Documentation generation is deterministic and can be rerun. Profile listing and graph validation are read-only. If a gate fails, fix the isolated change and rerun the affected gate before the final complete check.

If the existing descriptor cannot express a claimed constraint, retain that constraint in the documented semantic checker rather than silently weakening it or changing the schema dependency. If implementation discovers a necessary dependency upgrade, stop treating the pinned schema as sufficient: use Mori to discover sources, verify authoritative registry releases and upstream tags, and revise this plan with the actual compatibility evidence before changing any pin. No upgrade is selected by this plan.

## Interfaces and Dependencies


The new public exports are `coordination.jobs`, `documentation.productResearch`, and `coordination.features`. The existing `coordination.useCases` export adds `jobs[].jobRef`, `jobs[].outcomeNames`, `featureRefs`, and `features[].featureRef`, while making inline `features` optional. The unchanged `documentation.researchDocuments` export retains its technical-research purpose. Features add optional `capabilityRefs` and `specificationRefs` and reuse the request criterion shape `{ id: AC-N, statement, verification }`. Capability descriptions and family guidance change, but its schema and those of improvement requests, bug reports, specifications, technical research, transitions, runbooks, and standalone reviews remain unchanged. Common source and provenance constraints are reused from `Profile/V02.dhall`; no new package dependency or changes to OKF core are required.

The checker is an explicitly invoked repository utility with the manifest, `--list-rules`, and exit-status contract defined in milestone 3. It is an interim consumer gate: each rule names its intended owner (`okf` for single-concept rules, `mori` for reference-following rules). A later plan removes rules as okf releases matching descriptor features or as Mori ships registry-backed resolution; this plan neither bumps the okf pin nor depends on a Mori change. Consumers outside this repository obtain the script from a tagged checkout; no blueprint distributes it in this plan. It consumes `okf concepts --json` through `OKF_BIN`, validates through the same executable, resolves only declared local bundle mappings, and requires no YAML parser or network connection. Its stdlib tests and shell wrapper enter the existing `just test` loop. Consumers wanting the same semantic checks must adopt this utility and a manifest explicitly; merely importing the Dhall profiles does not execute it.

New durable cross-repository references use canonical `mori://` project/bundle/concept identities. In a producer whose registered bundle names are `jobs`, `product-research`, and `features`, the corresponding concept shapes are `mori://<namespace>/<project>/okf/jobs/concepts/JOB-N`, `mori://<namespace>/<project>/okf/product-research/concepts/PR-N`, and `mori://<namespace>/<project>/okf/features/concepts/FEAT-N`. Other registered bundle names remain valid. These are artifact URI patterns, not citations to artifacts that already exist. Resolution failure before registration does not justify replacing them with ambiguous bare handles.

Authoring note (2026-10-16): Created from the user's request for a precise implementation plan, incorporating the explicit separation of product research from technical research, the subsequent request for standalone features for future UI work, and the intention created through `mina ci --json`. The plan remains unimplemented.

Revision note (2026-10-16): Incorporated the agreed existing-profile integration: optional feature capability/specification references, record-local AC-N acceptance criteria matching improvement requests, capability guidance updates, explicit reuse of origin/affects/sources, and focused integration/compatibility tests. Expanded manifest resolution to CAP/SPEC targets and kept auxiliary request, bug, and technical-research examples separately validated. Standalone-review vocabulary expansion remains deferred. Implementation has not started.

Revision note (2026-10-16, validation): Validated the plan against the working tree, the pinned okf source (`bdf8893`), and the local ADRs, then fixed what did not hold. okf rejects a reference prefix that the declaring profile does not declare, so every cross-profile reference is now specified as an external-only rule using the profile's own prefix with an `externalUriPattern`, and `owners` stays format-only. Profile `guidance` was removed per ADR-12. ADR-7, ADR-12, ADR-14, and okf ADR-1 and ADR-11 are now cited, and the `reviews` placement is justified by the specifications precedent. Self-reference moved into descriptors via `allowSelf`. The user asked whether the okf CLI should own the checks, which led to their decision to keep the Python checker as an interim gate whose rules are tagged `okf` or `mori` and listed by `--list-rules`, with one upstream improvement request filed per owner. Also added: the `Profile/V02.dhall` house-status list update, the transitions-style `expected.json` test harness, `originatingPlan` on the new ADR, and the deferred `adopt-capabilities` blueprint wording as a recorded follow-up. Implementation has not started.

Revision note (2026-10-16, implementation): Implemented all five milestones and recorded progress, discoveries, decisions, and outcomes. Departures from the plan text, each with its reasoning in the Decision Log or Surprises & Discoveries:

- The profile acceptance bundles double as the discovery graph's core bundles.
- `scripts/profile_fixture_cases.py` is a shared, stricter test harness.
- The checker has 16 named rules.
- The documentation pairs were registered in milestone 3 to keep that commit green.
- `scripts/sweep-profile-rules.py` was added and its gaps were filled.
- With the user's approval, the upstream requests were written uncommitted, and okf's legacy request bundle was handled as described in Surprises & Discoveries.
