---
type: OKF Profile
title: designs
description: Design work per surface in three linked concepts — Design Brief (why/what),
  Breadboard (structure), Detailed Design (presentation). Jobs and features are canonical
  concepts referenced by Mori URI; implementation is tracked on the features. Approval
  requires `verified`, mirroring the approving `reviews` entry.
generated:
  by: process:okf-profile-document
---

# designs

Design work per surface in three linked concepts — Design Brief (why/what), Breadboard (structure), Detailed Design (presentation). Jobs and features are canonical concepts referenced by Mori URI; implementation is tracked on the features. Approval requires `verified`, mirroring the approving `reviews` entry.

## Settings

- OKF version: `0.2`
- Required bundle version: `0.2`
- Unknown concept types: rejected
- Unknown frontmatter keys: allowed
- Document ID field: `designId`

## Frontmatter rules

These rules apply to every concept in a bundle governed by this profile,
whatever its type. Each concept type's own page repeats them merged with that
type's rules, which is the form that actually applies.

### `description` — required

One sentence: what this document settles.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

### `generated` — required

§5.2. Who produced this document's current content, and when.

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

### `reviews` — recommended

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

### `tags` — optional

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

### `title` — required

Human-readable title, usually the surface.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

### `type` — required

Design Brief, Breadboard or Detailed Design.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

### `verified` — optional

§5.2. Mirror an approving `reviews` entry here.

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

## Concept types

- [Design Brief](/types/design-brief.md) — Why the surface exists and what it must achieve: the problem, who views it and for which jobs, the states the thing shown can be in, the outcomes it should move, the constraints, the scenarios it must work in, and the criteria it is judged by. No structure, no layout.
- [Breadboard](/types/breadboard.md) — How the surface works, before what it looks like: places, the affordances in each, the connections between them, and what each viewer gets.
- [Detailed Design](/types/detailed-design.md) — What the breadboard looks like and how it behaves: the chosen direction, layouts, visual hierarchy, components, interaction details and every affordance state, with the final screens.
