---
type: OKF Profile Type
title: Detailed Design
description: 'What the breadboard looks like and how it behaves: the chosen direction,
  layouts, visual hierarchy, components, interaction details and every affordance
  state, with the final screens.'
generated:
  by: process:okf-profile-document
---

# Detailed Design

What the breadboard looks like and how it behaves: the chosen direction, layouts, visual hierarchy, components, interaction details and every affordance state, with the final screens.

Declared by the [designs](/profile.md) profile.

## Guidance

### Type-specific

`exploring` (rough ideas, then options) → `chosen` (the direction is recorded in `decisions`) → `designed` (the final screens are exported, the `## Design handoff` section is written and the design review is signed off).

By `designed`, every brief scenario is either in the `## Design handoff` table, which names the scenario of each screen, or has a line in the body saying which drawn scenario it equals and what differs, and every `states[].affordance` is declared by the breadboard. okf does not check either; read them.

## Type settings

- Path pattern: `*/design`
- Resource URI scheme: none
- Requires a `# Schema` section: no
- Schema columns: none
- Document ID prefix: `DES`

## Frontmatter rules

Every rule below is the effective rule for a concept of type `Detailed Design`:
the profile-wide rule and this type's own rule, already merged.

### Required

#### `breadboard` — required

The breadboard this design presents.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: local handles with prefix `BB`; external URIs not allowed; local handles allowed; self-reference not allowed
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `decisions` — required when `status` is one of `chosen`, `designed`

Settled questions a later phase must not reopen. D-N ids are unique across the surface's three documents.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: `id`
- Condition: applies only when `status` is one of `chosen`, `designed`
- Object fields: none
- Element fields:
    - `by` — optional; allowed values: any; cardinality: scalar; format: none — Who decided.
    - `date` — required; allowed values: any; cardinality: scalar; format: date — When it was decided.
    - `id` — required; allowed values: any; cardinality: scalar; format: document-handle(D) — D-N handle.
    - `statement` — required; allowed values: any; cardinality: scalar; format: none — The decision.

#### `description` — required

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

#### `designArtifacts` — required when `status` is one of `chosen`, `designed`

Where the design lives.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: `resource`
- Condition: applies only when `status` is one of `chosen`, `designed`
- Object fields: none
- Element fields:
    - `kind` — required; allowed values: any; cardinality: scalar; format: none — Tool or medium, such as figma, sketch, screenshot or video.
    - `note` — optional; allowed values: any; cardinality: scalar; format: none — What this artifact shows.
    - `resource` — required; allowed values: any; cardinality: scalar; format: none — A URL, or a path relative to this concept for a file in the repository.

#### `designId` — required

Bundle-scoped stable DES-N handle.

- Allowed values: any
- Cardinality: scalar
- Format: document-handle(DES)
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `generated` — required

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

#### `states` — required

The states each affordance is designed in: with-data, and empty wherever the affordance can be empty; add absent (feature not shipped) and any domain state.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: `affordance`
- Condition: none
- Object fields: none
- Element fields:
    - `affordance` — required; allowed values: any; cardinality: scalar; format: none — A breadboard affordance.
    - `states` — required; allowed values: any; cardinality: list; format: none — State names; every one appears on at least one final screen.

#### `status` — required

Workflow step. See the type guidance.

- Allowed values: `exploring`, `chosen`, `designed`, `retired`
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `supersededBy` — required when `status` is `retired`

Later document replacing this one.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: local handles with prefix `DES`; external URIs with scheme `mori`; local handles allowed; self-reference not allowed; external URI whole-value pattern `mori://[^/]+/[^/]+/okf/[^/]+/concepts/DES-[1-9][0-9]*`
- Path: none
- Unique by: none
- Condition: applies only when `status` is `retired`
- Object fields: none
- Element fields: none

#### `title` — required

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

#### `type` — required

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

#### `verified` — required when `status` is `designed`

The approving review, mirrored from `reviews`.

- Allowed values: any
- Cardinality: any
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: applies only when `status` is `designed`
- Object fields:
    - `at` — recommended; allowed values: any; cardinality: any; format: rfc3339-utc — UTC RFC3339 timestamp, ending in `Z`, for when this happened.
    - `by` — required; allowed values: any; cardinality: any; format: actor — §7. The actor responsible: `<producer>/<version>`, `human:<id>`, or `process:<id>`.
- Element fields:
    - `at` — recommended; allowed values: any; cardinality: any; format: rfc3339-utc — UTC RFC3339 timestamp, ending in `Z`, for when this happened.
    - `by` — required; allowed values: any; cardinality: any; format: actor — §7. The actor responsible: `<producer>/<version>`, `human:<id>`, or `process:<id>`.

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

#### `openQuestions` — optional

Questions still open, each with an owner. Q-N ids are unique across the surface's three documents.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: `id`
- Condition: none
- Object fields: none
- Element fields:
    - `id` — required; allowed values: any; cardinality: scalar; format: document-handle(Q) — Q-N handle.
    - `owner` — required; allowed values: any; cardinality: scalar; format: none — Who answers it.
    - `question` — required; allowed values: any; cardinality: scalar; format: none — The question.

#### `tags` — optional

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

