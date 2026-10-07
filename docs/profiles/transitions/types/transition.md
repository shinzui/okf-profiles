---
type: OKF Profile Type
title: Transition
description: Concept type "Transition" as declared by the transitions profile.
generated:
  by: process:okf-profile-document
---

# Transition

Declared by the [transitions](/profile.md) profile.

## Guidance

### Profile-wide

Use canonical project roots and typed capability/context/flow/use-case URIs. Requirements may be absent or empty. Their environments default to all; acceptance defaults false; itemized defaults true for consumer-migration, event-obligation and responsibility-transfer, otherwise false. Responsibility-transfer is always itemized and has no responsibility field. Mori validates lowercase slugs, fixed maxAge durations, requirements[].owner role/party (a depth-two object), exactly one successor identity, to iff move, cross-list keys, retained duties, environment subsets, registry ownership and reference kinds. The profile engine cannot express these joins, forbidden conditional fields, regexes or recursive owner records. Capability status can raise caution but supplies no retirement evidence. Run mori transitions validate after strict profile enforcement.

## Type settings

- Path pattern: `*`
- Resource URI scheme: none
- Requires a `# Schema` section: no
- Schema columns: none
- Document ID prefix: `TR`

## Frontmatter rules

Every rule below is the effective rule for a concept of type `Transition`:
the profile-wide rule and this type's own rule, already merged.

### Required

#### `accountable` — required

Accountable parties.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields:
    - `party` — required; allowed values: any; cardinality: scalar; format: none — Owner identity; unassigned is explicit uncertainty.
    - `role` — required; allowed values: any; cardinality: scalar; format: none — Accountable role.

#### `coordinator` — required

Owning coordinator project root.

- Allowed values: any
- Cardinality: scalar
- Format: uri-with-scheme(mori)
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `description` — required

One-sentence intent.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `environments` — required

Nonempty lowercase environment slugs.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `generated` — required

§5.2. How this content was produced. Supersedes the v0.1 `timestamp` key.

- Allowed values: any
- Cardinality: object
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields:
    - `at` — recommended; allowed values: any; cardinality: any; format: rfc3339-utc — UTC RFC3339 timestamp, ending in `Z`, for when this happened.
    - `by` — required; allowed values: any; cardinality: any; format: actor — §7. The actor responsible: `<producer>/<version>`, `human:<id>`, or `process:<id>`.
- Element fields: none

#### `kind` — required

- Allowed values: `split`, `absorption`, `replacement`, `consolidation`, `extraction`
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `phase` — required

- Allowed values: `planned`, `in-progress`, `validating`, `complete`, `abandoned`
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `predecessors` — required

Services participating before responsibility movement.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: `project`
- Condition: none
- Object fields: none
- Element fields:
    - `disposition` — required; allowed values: `retire`, `retain`; cardinality: scalar; format: none — Retire or retain.
    - `project` — required; allowed values: any; cardinality: scalar; format: uri-with-scheme(mori) — Canonical predecessor project root.

#### `responsibilities` — required

Declared duties and their dispositions.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: `key`
- Condition: none
- Object fields: none
- Element fields:
    - `capabilityRefs` — optional; allowed values: any; cardinality: list; format: uri-with-scheme(mori) — Capability concept URIs; read only.
    - `contextRefs` — optional; allowed values: any; cardinality: list; format: uri-with-scheme(mori) — Typed DDD context URIs.
    - `disposition` — required; allowed values: `move`, `discontinue`, `retain`; cardinality: scalar; format: none — Move, discontinue or retain.
    - `flowRefs` — optional; allowed values: any; cardinality: list; format: uri-with-scheme(mori) — Typed DDD flow URIs.
    - `from` — required; allowed values: any; cardinality: scalar; format: uri-with-scheme(mori) — Listed predecessor project root.
    - `key` — required; allowed values: any; cardinality: scalar; format: none — Unique lowercase responsibility key.
    - `owner` — optional; allowed values: any; cardinality: scalar; format: none — Responsible party.
    - `title` — required; allowed values: any; cardinality: scalar; format: none — Human-readable duty.
    - `to` — required when `disposition` is `move`; allowed values: any; cardinality: scalar; format: none — Listed successor key, required for move.
    - `useCaseRefs` — optional; allowed values: any; cardinality: list; format: uri-with-scheme(mori) — Use Case concept URIs.

#### `successors` — required

Known project or explicitly pending identity; exactly one is checked by Mori.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: `key`
- Condition: none
- Object fields: none
- Element fields:
    - `key` — required; allowed values: any; cardinality: scalar; format: none — Unique lowercase successor key.
    - `pendingIdentity` — optional; allowed values: any; cardinality: scalar; format: none — Unsettled successor identity; no invented project.
    - `project` — optional; allowed values: any; cardinality: scalar; format: uri-with-scheme(mori) — Canonical successor project root.

#### `title` — required

Transition name.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `transitionId` — required

Positive unpadded TR-N handle.

- Allowed values: any
- Cardinality: scalar
- Format: document-handle(TR)
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `type` — required

Transition concept type.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

### Recommended

#### `reviews` — recommended

Chronological human or model review provenance for this document revision.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields:
    - `context` — required; allowed values: any; cardinality: scalar; format: none — Evidence and repository context used for the review.
    - `document_timestamp` — required; allowed values: any; cardinality: scalar; format: rfc3339-utc — Document revision timestamp covered by the review.
    - `effort` — required when `kind` is `model`; allowed values: `low`, `medium`, `high`, `xhigh`, `max`, `unspecified`; cardinality: scalar; format: none — Reasoning or thinking effort the review was run at.
    - `kind` — required; allowed values: `human`, `model`; cardinality: scalar; format: none — Whether a human or model performed the review.
    - `model` — required when `kind` is `model`; allowed values: any; cardinality: scalar; format: none — Most specific available model identifier.
    - `outcome` — required; allowed values: `approved`, `changes-requested`, `commented`; cardinality: scalar; format: none — Result recorded by the reviewer.
    - `provider` — required when `kind` is `model`; allowed values: any; cardinality: scalar; format: none — Serving provider for a model review.
    - `reviewed_at` — required; allowed values: any; cardinality: scalar; format: rfc3339-utc — UTC time at which the review completed.
    - `reviewer` — required; allowed values: any; cardinality: scalar; format: none — Stable identity of the reviewing person or agent.
    - `scope` — required; allowed values: `content`, `technical-accuracy`, `editorial`, `catalog-metadata`, `content-and-metadata`; cardinality: scalar; format: none — Aspect of the document covered by the review.
- Checked only under `--strict`

### Optional

#### `phaseSource` — optional

Source for the declared phase.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `requirements` — optional

Optional retirement requirements; absence never establishes readiness. Mori validates each owner object.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: `key`
- Condition: none
- Object fields: none
- Element fields:
    - `environments` — optional; allowed values: any; cardinality: list; format: none — Subset of transition environments; defaults to all.
    - `itemized` — optional; allowed values: any; cardinality: scalar; format: boolean — Defaults true for consumer-migration, event-obligation and responsibility-transfer; otherwise false.
    - `key` — required; allowed values: any; cardinality: scalar; format: none — Unique lowercase requirement key.
    - `kind` — required; allowed values: `consumer-migration`, `responsibility-transfer`, `routing-cutover`, `in-flight-drain`, `data-obligation`, `event-obligation`, `rollback`, `operational-continuity`, `ownership`, `other`; cardinality: scalar; format: none — Obligation category.
    - `maxAge` — optional; allowed values: any; cardinality: scalar; format: none — Owner-selected fixed duration; Mori parses and checks it.
    - `minimumBasis` — required; allowed values: `declared`, `source-observed`, `runtime-observed`; cardinality: scalar; format: none — Minimum factual evidence strength.
    - `owner` — optional; allowed values: any; cardinality: any; format: none — Required object with role and party by the Mori gate; nested mappings exceed the profile engine depth.
    - `predecessor` — required; allowed values: any; cardinality: scalar; format: uri-with-scheme(mori) — Listed predecessor project root.
    - `requiresAcceptance` — optional; allowed values: any; cardinality: scalar; format: boolean — Defaults to false.
    - `responsibility` — optional; allowed values: any; cardinality: scalar; format: none — Optional listed duty key; forbidden for responsibility-transfer.
    - `statement` — required; allowed values: any; cardinality: scalar; format: none — What must be established.

#### `timestamp` — optional

Superseded v0.1 revision timestamp. Prefer `generated.at`; keep this in `optional` only.

- Allowed values: any
- Cardinality: any
- Format: rfc3339-utc
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

