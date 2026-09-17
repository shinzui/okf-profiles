---
type: OKF Profile
title: specifications
description: 'Normative specifications with stable SPEC handles: which boundary is
  obliged to satisfy the contract, which parts of it bind, at which version, and what
  proves conformance. The `Specification Pointer` type covers a subject specified
  authoritatively in another repository.'
generated:
  by: process:okf-profile-document
---

# specifications

Normative specifications with stable SPEC handles: which boundary is obliged to satisfy the contract, which parts of it bind, at which version, and what proves conformance. The `Specification Pointer` type covers a subject specified authoritatively in another repository.

## Settings

- OKF version: `0.2`
- Required bundle version: `0.2`
- Unknown concept types: rejected
- Unknown frontmatter keys: allowed
- Document ID field: `specId`

## Frontmatter rules

These rules apply to every concept in a bundle governed by this profile,
whatever its type. Each concept type's own page repeats them merged with that
type's rules, which is the form that actually applies.

### `conformance` — optional

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

### `description` — required

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

### `generated` — required

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

### `owner` — required

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

### `reviews` — optional

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

### `sources` — optional

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

### `specId` — required

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

### `status` — required

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

### `supersededBy` — required when `status` is `superseded`

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

### `supersedes` — optional

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

### `timestamp` — optional

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

### `title` — required

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

### `type` — required

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

### `verified` — optional

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

## Concept types

- [Specification](/types/specification.md) — A durable statement of required behavior that an owning boundary must satisfy.
- [Specification Pointer](/types/specification-pointer.md) — A specification whose authoritative text is owned by another repository, recorded here with the ownership it establishes.
