---
type: OKF Profile Type
title: Breadboard
description: 'How the surface works, before what it looks like: places, the affordances
  in each, the connections between them, and what each viewer gets.'
generated:
  by: process:okf-profile-document
---

# Breadboard

How the surface works, before what it looks like: places, the affordances in each, the connections between them, and what each viewer gets.

Declared by the [designs](/profile.md) profile.

## Guidance

### Type-specific

The body carries **ordering rules** written over the brief's viewers, subject states and axes — for example, which affordance comes first for each viewer — not a priority table per scenario.

okf checks the shapes, not the cross-references. Read them: every `viewer` is declared by the brief, and every `connections[].jobs` entry is a brief job name; every `affordances[].place` is a declared `surface` place; every `visibility[].affordance`, `connections[].from` and `connections[].to` is declared here.

`draft` → `validated` when the surface's approver signs off on the structure.

## Type settings

- Path pattern: `*/breadboard`
- Resource URI scheme: none
- Requires a `# Schema` section: no
- Schema columns: none
- Document ID prefix: `BB`

## Frontmatter rules

Every rule below is the effective rule for a concept of type `Breadboard`:
the profile-wide rule and this type's own rule, already merged.

### Required

#### `affordances` — required

What a viewer can read or do in each surface place, in words, with no layout. Each names the features that deliver it.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: `name`
- Condition: none
- Object fields: none
- Element fields:
    - `does` — required; allowed values: any; cardinality: scalar; format: none — What the viewer reads or does with it.
    - `features` — optional; allowed values: any; cardinality: list; format: none; reference: local handles with prefix `BB`; external URIs with scheme `mori`; local handles prohibited; self-reference not allowed; external URI whole-value pattern `mori://[^/]+/[^/]+/okf/[^/]+/concepts/FEAT-[1-9][0-9]*` — Canonical Mori URIs of the FEAT concepts that deliver it.
    - `name` — required; allowed values: any; cardinality: scalar; format: none — Stable affordance name, used by visibility, connections and the detailed design.
    - `place` — required; allowed values: any; cardinality: scalar; format: none — A declared surface place.

#### `brief` — required

The brief this breadboard answers.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: local handles with prefix `BRIEF`; external URIs with scheme `mori`; local handles allowed; self-reference not allowed
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `connections` — required

How the viewer moves: from an external place or an affordance to a place. Connections from external places are the entry points and name the jobs that arrive by them.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields:
    - `carries` — optional; allowed values: any; cardinality: scalar; format: none — Context passed along, such as a selected tab or filter in the URL.
    - `from` — required; allowed values: any; cardinality: scalar; format: none — A declared place or affordance.
    - `jobs` — optional; allowed values: any; cardinality: list; format: none — Brief job names that arrive by this connection.
    - `to` — required; allowed values: any; cardinality: scalar; format: none — A declared place.

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

#### `designId` — required

Bundle-scoped stable BB-N handle.

- Allowed values: any
- Cardinality: scalar
- Format: document-handle(BB)
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

#### `places` — required

Where the viewer can be: the surface's own places and the external places that lead into it or that it leads to.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: `name`
- Condition: none
- Object fields: none
- Element fields:
    - `description` — required; allowed values: any; cardinality: scalar; format: none — What the place is, in one sentence.
    - `kind` — required; allowed values: `surface`, `external`; cardinality: scalar; format: none — `surface` for a place this breadboard designs; `external` for one it only connects to.
    - `name` — required; allowed values: any; cardinality: scalar; format: none — Stable place name.

#### `status` — required

Workflow step. See the type guidance.

- Allowed values: `draft`, `validated`, `retired`
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
- Reference: local handles with prefix `BB`; external URIs with scheme `mori`; local handles allowed; self-reference not allowed
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

#### `verified` — required when `status` is `validated`

The approving review, mirrored from `reviews`.

- Allowed values: any
- Cardinality: any
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: applies only when `status` is `validated`
- Object fields:
    - `at` — recommended; allowed values: any; cardinality: any; format: rfc3339-utc — UTC RFC3339 timestamp, ending in `Z`, for when this happened.
    - `by` — required; allowed values: any; cardinality: any; format: actor — §7. The actor responsible: `<producer>/<version>`, `human:<id>`, or `process:<id>`.
- Element fields:
    - `at` — recommended; allowed values: any; cardinality: any; format: rfc3339-utc — UTC RFC3339 timestamp, ending in `Z`, for when this happened.
    - `by` — required; allowed values: any; cardinality: any; format: actor — §7. The actor responsible: `<producer>/<version>`, `human:<id>`, or `process:<id>`.

#### `visibility` — required

Affordance × viewer, one entry each. `shown` and `hidden` are what they say; `collapsed` is present but de-emphasised (relevance, not permission); `filtered` shows the affordance with its items filtered per viewer; `prompts` turns an empty affordance into a call to fill it in. A condition or exception goes in `note`. The owner is a row like any other.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields:
    - `affordance` — required; allowed values: any; cardinality: scalar; format: none — A declared affordance name.
    - `note` — optional; allowed values: any; cardinality: scalar; format: none — Why, or the condition under which the rule changes.
    - `rule` — required; allowed values: `shown`, `collapsed`, `hidden`, `filtered`, `prompts`; cardinality: scalar; format: none — What this viewer gets.
    - `viewer` — required; allowed values: any; cardinality: scalar; format: none — A viewer declared by the brief.

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

#### `decisions` — optional

Settled questions a later phase must not reopen. D-N ids are unique across the surface's three documents.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: `id`
- Condition: none
- Object fields: none
- Element fields:
    - `by` — optional; allowed values: any; cardinality: scalar; format: none — Who decided.
    - `date` — required; allowed values: any; cardinality: scalar; format: date — When it was decided.
    - `id` — required; allowed values: any; cardinality: scalar; format: document-handle(D) — D-N handle.
    - `statement` — required; allowed values: any; cardinality: scalar; format: none — The decision.

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

