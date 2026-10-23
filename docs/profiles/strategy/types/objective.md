---
type: OKF Profile Type
title: Objective
description: A time-bounded intended outcome with explicit key-result targets.
generated:
  by: process:okf-profile-document
---

# Objective

A time-bounded intended outcome with explicit key-result targets.

Declared by the [strategy](/profile.md) profile.

## Guidance

### Type-specific

Achieved or missed is an author assessment of cited evidence, never inferred from delivery. The opt-in check-gtm.py checks numeric targets, ordered periods and key-result outcome pairs and resolves assessment evidence to Findings or Claim Checks.

## Type settings

- Path pattern: `objectives/*`
- Resource URI scheme: none
- Requires a `# Schema` section: no
- Schema columns: none
- Document ID prefix: `OBJ`

## Frontmatter rules

Every rule below is the effective rule for a concept of type `Objective`:
the profile-wide rule and this type's own rule, already merged.

### Required

#### `assessment` — required when `status` is one of `achieved`, `missed`

Evidence-based assessment of the objective result.

- Allowed values: any
- Cardinality: object
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: applies only when `status` is one of `achieved`, `missed`
- Object fields:
    - `assessedAt` — required; allowed values: any; cardinality: scalar; format: rfc3339-utc — UTC assessment time.
    - `evidenceRefs` — required; allowed values: any; cardinality: list; format: none; reference: local handles with prefix `THEME`; external URIs with scheme `mori`; local handles prohibited; self-reference not allowed; external URI whole-value pattern `mori://[^/]+/[^/]+/okf/[^/]+/concepts/(PR|CLM)-[1-9][0-9]*` — Canonical Finding or Claim Check URIs.
    - `rationale` — required; allowed values: any; cardinality: scalar; format: none — Why the evidence justifies the declared result.
- Element fields: none

#### `description` — required

One sentence describing the concept.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `dropReason` — required when `status` is `dropped`

Why the objective was dropped.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: applies only when `status` is `dropped`
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

#### `keyResults` — required

Objective-local targets; observed values belong in cited evidence.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: `id`
- Condition: none
- Object fields: none
- Element fields:
    - `baseline` — optional; allowed values: any; cardinality: scalar; format: none — Finite numeric starting point.
    - `direction` — required; allowed values: `increase`, `decrease`, `maintain`; cardinality: scalar; format: none — Desired direction of change.
    - `id` — required; allowed values: any; cardinality: scalar; format: document-handle(KR) — Objective-local KR-N handle.
    - `jobRef` — optional; allowed values: any; cardinality: scalar; format: none; reference: local handles with prefix `THEME`; external URIs with scheme `mori`; local handles prohibited; self-reference not allowed; external URI whole-value pattern `mori://[^/]+/[^/]+/okf/[^/]+/concepts/JOB-[1-9][0-9]*` — Canonical job URI for an outcome pair.
    - `method` — optional; allowed values: any; cardinality: scalar; format: none — How the result will be measured.
    - `metric` — required; allowed values: any; cardinality: scalar; format: none — What is measured.
    - `outcomeName` — optional; allowed values: any; cardinality: scalar; format: none — Name of an outcome on the referenced job.
    - `population` — optional; allowed values: any; cardinality: scalar; format: none — Population the target describes.
    - `target` — required; allowed values: any; cardinality: scalar; format: none — Finite numeric aspiration, never an observed value.
    - `unit` — required; allowed values: any; cardinality: scalar; format: none — Unit of the target.

#### `periodEnd` — required

UTC end of the objective period.

- Allowed values: any
- Cardinality: scalar
- Format: rfc3339-utc
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `periodStart` — required

UTC start of the objective period.

- Allowed values: any
- Cardinality: scalar
- Format: rfc3339-utc
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `status` — required

Objective commitment and result lifecycle.

- Allowed values: `draft`, `committed`, `achieved`, `missed`, `dropped`
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `strategyId` — required

Bundle-scoped stable OBJ-N handle.

- Allowed values: any
- Cardinality: scalar
- Format: document-handle(OBJ)
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `title` — required

Human-readable concept title.

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

The declared concept type.

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

(none)

### Optional

#### `owners` — optional

Accountable actors.

- Allowed values: any
- Cardinality: list
- Format: actor
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

#### `sources` — optional

§5.1. What this content was derived from, one entry per source.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields:
    - `author` — optional; allowed values: any; cardinality: any; format: actor — §5.1. Who or what produced the source, per the §7 actor convention.
    - `id` — optional; allowed values: any; cardinality: any; format: none — §5.1. Short label for this entry, used to cite it from a footnote in the body.
    - `last_modified` — optional; allowed values: any; cardinality: any; format: date — §5.1. Calendar date the source itself last changed.
    - `resource` — required; allowed values: any; cardinality: any; format: none — §5.1. What the source is: a followable artifact, or a scope descriptor.
    - `title` — optional; allowed values: any; cardinality: any; format: none — §5.1. Human-readable name for the source.
    - `usage_count` — optional; allowed values: any; cardinality: scalar; format: non-negative-integer — §5.1. How many times the source was drawn on. A count, so never negative.

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

#### `themeRef` — optional

Strategic Theme for this objective.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: local handles with prefix `THEME`; external URIs with scheme `mori`; local handles allowed; self-reference not allowed; external URI whole-value pattern `mori://[^/]+/[^/]+/okf/[^/]+/concepts/THEME-[1-9][0-9]*`
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `verified` — optional

§5.2. Independent confirmations that the content is accurate. A list of mappings, or one bare mapping.

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

