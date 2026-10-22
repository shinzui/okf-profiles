---
type: OKF Profile Type
title: Friction Entry
description: One surface costing an implementer effort once, recorded before triage.
generated:
  by: process:okf-profile-document
---

# Friction Entry

One surface costing an implementer effort once, recorded before triage.

Declared by the [friction-log](/profile.md) profile.

## Guidance

### Type-specific

An entry is `logged` when written and moves only at triage by the recording repository: to `promoted` once the artifact in `promotedTo` tracks it, to `resolved` once its cause is gone, to `accepted` once the house decides to live with it, or to `duplicate`.
What was attempted and what happened instead, with evidence, go in the body under `## Attempted` and `## Encountered`.

## Type settings

- Path pattern: `*`
- Resource URI scheme: none
- Requires a `# Schema` section: no
- Schema columns: none
- Document ID prefix: `FRIC`

## Frontmatter rules

Every rule below is the effective rule for a concept of type `Friction Entry`:
the profile-wide rule and this type's own rule, already merged.

### Required

#### `affects` — required

URI of the project or artifact whose surface cost the effort: its canonical Mori URI when registered, otherwise its canonical URL.

- Allowed values: any
- Cardinality: scalar
- Format: uri
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `description` — required

One sentence naming the surface and the cost, evaluable without the body.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `duplicateOf` — required when `status` is `duplicate`

The entry this one duplicates, as a local FRIC-N handle or an external Mori URI. Demanded once `status` is `duplicate`.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: local handles with prefix `FRIC`; external URIs with scheme `mori`; local handles allowed; self-reference not allowed
- Path: none
- Unique by: none
- Condition: applies only when `status` is `duplicate`
- Object fields: none
- Element fields: none

#### `frictionId` — required

Bundle-scoped stable FRIC-N handle.

- Allowed values: any
- Cardinality: scalar
- Format: document-handle(FRIC)
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `generated` — required

§5.2. Who observed the friction and wrote this entry, and when.

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

#### `impact` — required

What happened to the work, most severe first.

- Allowed values: `blocked`, `detour`, `slowdown`, `nuisance`
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `kind` — required

The sort of surface that cost the effort.

- Allowed values: `documentation`, `interface`, `tooling`, `environment`, `process`
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `origin` — required

Mori URI of the project in which the friction was experienced.

- Allowed values: any
- Cardinality: scalar
- Format: uri-with-scheme(mori)
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `promotedTo` — required when `status` is `promoted`

URI of the bug report, improvement request, plan, or external issue that now tracks this friction. Demanded once `status` is `promoted`.

- Allowed values: any
- Cardinality: scalar
- Format: uri
- Reference: none
- Path: none
- Unique by: none
- Condition: applies only when `status` is `promoted`
- Object fields: none
- Element fields: none

#### `resolution` — required when `status` is one of `resolved`, `accepted`

How the cause went away, or why the house lives with it. Demanded once `status` is `resolved` or `accepted`.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: applies only when `status` is one of `resolved`, `accepted`
- Object fields: none
- Element fields: none

#### `status` — required

Where triage has got to.

- Allowed values: `logged`, `promoted`, `resolved`, `accepted`, `duplicate`
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `title` — required

Short statement of what cost effort.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `type` — required

The Friction Entry concept type.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `workaround` — required when `impact` is `detour`

What the implementer did instead. Demanded once `impact` is `detour`.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: applies only when `impact` is `detour`
- Object fields: none
- Element fields: none

### Recommended

(none)

### Optional

#### `affectedVersion` — optional

Released version of the affecting surface the friction was met with; `unreleased` or `unknown` otherwise.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `amended` — optional

Later changes that leave the entry standing, such as a status change at triage, newest last. `generated` keeps who observed the friction.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields:
    - `at` — required; allowed values: any; cardinality: scalar; format: rfc3339-utc — UTC RFC3339 timestamp, ending in `Z`, for when this happened.
    - `by` — required; allowed values: any; cardinality: scalar; format: actor — §7. The actor responsible: `<producer>/<version>`, `human:<id>`, or `process:<id>`.
    - `change` — required; allowed values: any; cardinality: scalar; format: none — What changed, in one sentence.

#### `plan` — optional

Repository-relative path or Mori URI of the plan being implemented when the friction occurred.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `reviews` — optional

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

#### `tags` — optional

Producer-defined search and grouping tags.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `verified` — optional

§5.2. Independent confirmations that this entry is accurate. A list of mappings, or one bare mapping.

- Allowed values: any
- Cardinality: any
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields:
    - `at` — recommended; allowed values: any; cardinality: any; format: rfc3339-utc — UTC RFC3339 timestamp, ending in `Z`, for when this happened.
    - `by` — required; allowed values: any; cardinality: any; format: actor — §7. The actor responsible: `<producer>/<version>`, `human:<id>`, or `process:<id>`.
- Element fields:
    - `at` — recommended; allowed values: any; cardinality: any; format: rfc3339-utc — UTC RFC3339 timestamp, ending in `Z`, for when this happened.
    - `by` — required; allowed values: any; cardinality: any; format: actor — §7. The actor responsible: `<producer>/<version>`, `human:<id>`, or `process:<id>`.

