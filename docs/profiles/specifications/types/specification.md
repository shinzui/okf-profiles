---
type: OKF Profile Type
title: Specification
description: A durable statement of required behavior that an owning boundary must
  satisfy.
generated:
  by: process:okf-profile-document
---

# Specification

A durable statement of required behavior that an owning boundary must satisfy.

Declared by the [specifications](/profile.md) profile.

## Type settings

- Path pattern: `**`
- Resource URI scheme: none
- Requires a `# Schema` section: no
- Schema columns: none
- Document ID prefix: `SPEC`

## Frontmatter rules

Every rule below is the effective rule for a concept of type `Specification`:
the profile-wide rule and this type's own rule, already merged.

### Required

#### `description` — required

Concise statement of what this specification governs.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `generated` — required

§5.2. Who produced this specification's current content, and when.

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

#### `normativeScope` — required when `status` is `ratified`

The parts of this document that bind. Anything not named here is informative.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: applies only when `status` is `ratified`
- Object fields: none
- Element fields: none

#### `owner` — required

Canonical URI of each boundary obliged to satisfy this specification.

- Allowed values: any
- Cardinality: list
- Format: uri
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `specId` — required

Bundle-scoped stable SPEC-N handle.

- Allowed values: any
- Cardinality: scalar
- Format: document-handle(SPEC)
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `specVersion` — required when `status` is `ratified`

Version of the contract this document ratifies, as implementations cite it.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: applies only when `status` is `ratified`
- Object fields: none
- Element fields: none

#### `status` — required

Ratification state of the specification.

- Allowed values: `draft`, `proposed`, `ratified`, `superseded`, `withdrawn`
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `supersededBy` — required when `status` is `superseded`

Later specification replacing this one.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: local handles with prefix `SPEC`; external URIs with scheme `mori`; local handles allowed; self-reference not allowed
- Path: none
- Unique by: none
- Condition: applies only when `status` is `superseded`
- Object fields: none
- Element fields: none

#### `title` — required

Human-readable specification title.

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

Whether this document is the specification or a pointer to one owned elsewhere.

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

#### `conformance` — optional

Versioned contract, fixture package, or suite that proves conformance to this specification.

- Allowed values: any
- Cardinality: list
- Format: uri
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

§5.1. Prior art, requirements, and evidence this specification was derived from.

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

#### `supersedes` — optional

Earlier specifications replaced by this one.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: local handles with prefix `SPEC`; external URIs with scheme `mori`; local handles allowed; self-reference not allowed
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `timestamp` — optional

Superseded v0.1 revision timestamp. Prefer `generated.at`.

- Allowed values: any
- Cardinality: any
- Format: rfc3339-utc
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `verified` — optional

§5.2. Independent confirmations that this specification is accurate. Mirror approving `reviews` entries here.

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

