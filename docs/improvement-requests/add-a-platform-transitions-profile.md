---
type: Improvement Request
title: Add a platform transitions profile and adoption blueprint
description: >-
  Publish coordination.transitions for stable TR-N declared transition concepts with typed participants, responsibility dispositions, environment-scoped retirement requirements and accountable ownership, plus an adopt-transitions blueprint.
timestamp: "2026-10-07T04:36:00Z"
generated:
  by: codex/gpt-6.1-sol
  at: "2026-10-07T04:36:00Z"
requestId: IR-8
status: proposed
origin: mori://shinzui/mori/plans/293-specify-the-platform-transition-contract-and-request-it-upstream
reviews:
  - kind: model
    reviewer: process:openai-codex
    reviewed_at: "2026-10-07T04:36:00Z"
    document_timestamp: "2026-10-07T04:36:00Z"
    scope: content-and-metadata
    outcome: commented
    provider: openai
    model: gpt-6.1-sol
    effort: unspecified
    context: >-
      Author self-check against Mori MasterPlan 40, ExecPlan 293, the fixture corpus,
      and the owner repository's improvement-request profile; not an independent review.
acceptanceCriteria:
  - id: AC-1
    statement: The package exports coordination.transitions for OKF type Transition with transitionId handles TR-N and one concept per root Markdown file.
    verification: Inspect the released descriptor with okf profile show and typecheck package.dhall.
  - id: AC-2
    statement: The descriptor encodes every field, vocabulary, presence class, and expressible nested constraint in the requested contract.
    verification: Strict profile enforcement accepts the Mori valid corpus and rejects each profile-level invalid case for its named rule; document any semantic check delegated to Mori.
  - id: AC-3
    statement: Documentation describes the intent/evidence/verdict boundary and includes all field defaults and canonical reference grammars.
    verification: Generate profile documentation and compare it with the full contract below.
  - id: AC-4
    statement: adopt-transitions publishes existing owner-backed transition intent without inventing successors, duties, inventories, runtime evidence or owner acceptance.
    verification: Rehearse adoption of a known register, a repository without transitions, and an already adopted bundle; preserve every published handle on rerun.
  - id: AC-5
    statement: The profile ships in a tagged release with a pinnable semantic hash and catalog/CHANGELOG entries.
    verification: Strictly validate the fixtures using the released remote descriptor, then compare its hash with the local descriptor.
---

# Add a platform transitions profile and adoption blueprint

## Problem and ownership

Platform coordination needs to describe responsibility movement while services continue
running. Context succession, capability provision, and project lifecycle answer different
questions. Mori's three-layer design is specified by
`mori://shinzui/mori/masterplans/40-track-platform-transitions-and-explain-predecessor-retirement` and `mori://shinzui/mori/plans/293-specify-the-platform-transition-contract-and-request-it-upstream`, with its durable boundary in
`mori://shinzui/mori/okf/adrs/concepts/ADR-57`.

This request owns the authored document contract only. Observation envelopes, deterministic
fact keys, freshness, and the retirement evaluator are Mori JSON/runtime contracts and are
not part of this profile. A transition phase never proves production migration.

## Requested profile

Publish `coordination.transitions`, addressed as
`mori://shinzui/okf-profiles/profiles/transitions`, with type `Transition`,
`idField = transitionId`, `idPrefix = TR`, and root `pathPattern = *`.
The conventional bundle is `transitions` at `docs/transitions`, OKF 0.2 with reserved
`index.md` and `log.md`. Keep the Markdown body free prose; no body/frontmatter mirror
is demanded. Use the shared generated and review rules.

Required top-level fields are `type`, `title`, `description`, `timestamp`, `generated`,
`transitionId`, `coordinator`, `kind`, `phase`, `environments`, `accountable`,
`predecessors`, `successors`, and `responsibilities`. `reviews` is recommended through
the shared review rule. `phaseSource` and `requirements` are optional; an absent
requirements list produces unknown readiness, not a profile failure.

All listed collections except requirements and optional reference lists are non-empty.
Environment and entity keys are lowercase slugs; handles are positive unpadded TR-N.
Nested required/optional placement and exact vocabularies follow this complete contract:

One Markdown document per transition in a bundle named `transitions` at `docs/transitions`,
frontmatter type `Transition`. The body is free prose (rationale, links to ADRs and plans).

```yaml
---
type: Transition
transitionId: TR-1                     # required; handle prefix TR
title: Replace registration-service with registration-service-v2
description: One sentence.
timestamp: "2026-10-06T23:00:00Z"
generated: { by: "...", at: "..." }
coordinator: mori://tan/tan-platform   # required; must be the project that owns the bundle
kind: replacement                      # required: split | absorption | replacement | consolidation | extraction
phase: in-progress                     # required: planned | in-progress | validating | complete | abandoned
phaseSource: "User statement 2026-10-06"   # optional free text
environments: [staging, production]    # required, non-empty; lowercase slugs [a-z0-9-]+
accountable:                           # required, non-empty
  - { role: coordinator, party: johnhampton }
predecessors:                          # required, non-empty
  - project: mori://tan/registration-service   # canonical project-root URI
    disposition: retire                # retire | retain (retain = keeps other duties; never evaluated)
successors:                            # required, non-empty
  - key: registration-v2               # slug, unique in this document
    project: mori://tan/registration-service-v2
  - key: billing
    pendingIdentity: "Subscription/Stripe successor; project not identified"   # instead of project
responsibilities:                      # required, non-empty
  - key: member-registration           # slug, unique in this document
    title: Member registration workflow
    from: mori://tan/registration-service      # must be a listed predecessor
    disposition: move                  # move | discontinue | retain
    to: registration-v2                # successor key; required iff disposition is move
    owner: johnhampton                 # optional party
    capabilityRefs: []                 # optional; Capability concept URIs
    contextRefs: []                    # optional; DddContext URIs, e.g. mori://ns/p/ddd/contexts/<key>
    flowRefs: []                       # optional; DddFlow URIs, e.g. mori://ns/p/ddd/flows/<key>
    useCaseRefs: [mori://tan/tan-platform/okf/business-use-cases/concepts/UC-1]   # optional; type "Use Case" concepts
requirements:                          # optional list; see verdict rules for absence
  - key: callers-migrated              # slug, unique in this document
    predecessor: mori://tan/registration-service   # must be a listed predecessor
    environments: [production]         # optional subset of environments; default all
    kind: consumer-migration           # see kinds below
    statement: Every caller of registration-service endpoints uses registration-service-v2.
    owner: { role: service-owner, party: johnhampton }   # party may be the literal "unassigned"
    minimumBasis: runtime-observed     # declared | source-observed | runtime-observed
    requiresAcceptance: true           # optional, default false
    itemized: true                     # optional; default true for consumer-migration, event-obligation, and responsibility-transfer, false otherwise
    responsibility: member-registration   # optional responsibility key; not allowed on responsibility-transfer
    maxAge: P30D                       # optional ISO-8601 duration, an owner-chosen freshness window
---
```

Requirement kinds: `consumer-migration`, `responsibility-transfer`, `routing-cutover`,
`in-flight-drain`, `data-obligation`, `event-obligation`, `rollback`, `operational-continuity`,
`ownership`, `other`.

*Responsibility-transfer requirements.* A requirement of kind `responsibility-transfer` is how a
predecessor's duties are accounted for. It is always itemized, and its items are
responsibilities. An item key is the responsibility key when the responsibility is declared in
the same transition, or `<transition concept URI>#<responsibility key>` when it is declared in
another transition for the same predecessor. The `inventory` observation for such a requirement is
the claim "this is the predecessor's complete set of duties in this environment": its
`inventoryItems` list every duty, including duties handled by other transitions and duties that
were discovered but not yet declared (a discovered duty gets any new slug as its key). An `item`
observation with finding `met` says that responsibility has been transferred (disposition
`move`) or discontinued (disposition `discontinue`). One responsibility-transfer requirement per
retiring predecessor and environment is expected; it does not take the `responsibility` field.

*Capability links.* `capabilityRefs` on a responsibility point at existing capability records,
which belong to their providers and are never edited by a transition. A linked capability's
`provider` must be either the responsibility's `from` predecessor (the predecessor's capability)
or its `to` successor's project (the successor's capability). Capability records are only ever
used to raise caution: they can stop a verdict from being ready but never satisfy a requirement,
because "the successor has shipped it" does not mean "consumers have left the predecessor".
Responsibilities without `capabilityRefs`, including all responsibilities of services with no
capability catalog, are unaffected.

Validation rules (EP-2 implements them in `mori transitions validate`): the handle matches the
file's `transitionId`; `coordinator` equals the owning project; all keys are unique within their
list; every `from` and every requirement `predecessor` is a listed predecessor; every `to` is a
listed successor key; `to` is present exactly when `disposition` is `move`; a responsibility with
disposition `retain` must not belong to a predecessor with disposition `retire`; requirement
`environments` are a subset of the transition's; `responsibility` names a listed responsibility
and is absent on `responsibility-transfer` requirements; `itemized: false` is rejected on a
`responsibility-transfer` requirement; a successor has exactly one of `project` and
`pendingIdentity`; `capabilityRefs` resolve to `Capability` concepts whose `provider` is the
responsibility's `from` project or its `to` successor's project (`capability-provider-mismatch`
otherwise; a link to a successor with only `pendingIdentity` cannot be checked and is a warning),
`contextRefs` to `DddContext`, `flowRefs` to `DddFlow`, `useCaseRefs` to concepts of type
`Use Case`; project URIs are project roots and resolve in the registry (an unregistered successor
project is a warning, not an error, because a successor may not be registered yet).

### Additional presence and boundary rules

`accountable[]` and requirement `owner` records require both `role` and `party`.
`predecessors[]` requires `project` and `disposition`. `successors[]` requires `key`
and exactly one nonempty `project` or `pendingIdentity`. Responsibility records require
`key`, `title`, `from`, `disposition`; `to` is required exactly for `move`. `owner` and
reference lists are optional. Requirements require `key`, `predecessor`, `kind`,
`statement`, `owner`, `minimumBasis`; their `environments`, `requiresAcceptance`,
`itemized`, `responsibility`, and `maxAge` are optional. Booleans are actual YAML
booleans, not strings. Absent requirement environments mean all transition environments;
absent acceptance means false. `maxAge` is an ISO-8601 duration, not an invented global
budget. Document profile-engine limits explicitly and delegate checks requiring ownership,
cross-list joins, checkout data, or the registry to `mori transitions validate`.

Project references use canonical project-root `mori://namespace/project` URIs.
Capability and use-case references use the existing bundle-scoped OKF concept grammar;
contexts and flows use typed `/ddd/contexts/key` and `/ddd/flows/key` URIs.
No local shorthand or new transition artifact kind is introduced.

## Fixtures and consumer acceptance

The authoritative consumer corpus is `mori://shinzui/mori` at
`mori-core/test/fixtures/okf/transitions/` (artifact-level source URI pending).
`valid/` contains TR-1 registration replacement, TR-2 account split with pending billing
identity, TR-3 profile absorption with linked capability catalogs, and TR-4 notification
consolidation with independent alert duties and a retained participant. Every field appears.
`invalid/expected.json` records one expected rule per document; shape/vocabulary errors
belong to this profile and reference/provider/owner checks belong to Mori.
`capabilities/` holds the read-only provider catalogs used by semantic tests.

The separate observation/scenario corpus in the same project at
`mori-core/test/fixtures/transitions/` is background for the three-layer boundary,
not input this profile must validate. Hypothetical ready outcomes never claim TAN
production readiness. Mori's decoder completion gate requires this tagged profile.
The latest verified upstream release at request time is v0.19.0; do not bind consumers
to an unreleased tag or a fabricated hash.

## Adoption blueprint

`adopt-transitions` inventories owner-backed transition intent and existing references,
uses pendingIdentity for unresolved successor identities and unassigned parties when
ownership is unknown, and authors no invented context or capability catalog. It preserves
handles and makes no change when no transition exists. A rerun reconciles changed source
intent without recording runtime traffic or accepting requirements on an owner's behalf.
Its verify recipe runs strict profile/log enforcement then Mori's semantic validate gate.
Adoption depends on a Mori release shipping the command; profile validation alone does
not prove the complete workflow.
