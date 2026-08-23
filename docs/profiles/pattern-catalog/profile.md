---
type: OKF Profile
title: mori-documentation-pattern-catalog
description: Mori-addressable implementation patterns, standards, guides, and operational
  documentation.
generated:
  by: process:okf-profile-document
---

# mori-documentation-pattern-catalog

Mori-addressable implementation patterns, standards, guides, and operational documentation.

## Settings

- OKF version: `0.2`
- Required bundle version: `0.2`
- Unknown concept types: allowed
- Unknown frontmatter keys: allowed
- Document ID field: none

## Frontmatter rules

These rules apply to every concept in a bundle governed by this profile,
whatever its type. Each concept type's own page repeats them merged with that
type's rules, which is the form that actually applies.

### `description` — required

Concise statement of the document's purpose.

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

### `resource` — required

Canonical Mori URI for this document.

- Allowed values: any
- Cardinality: scalar
- Format: uri-with-scheme(mori)
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

### `sources` — optional

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

### `status` — required

Publication state of this guidance.

- Allowed values: `current`, `deprecated`
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

### `supersedes` — optional

Earlier guidance replaced by this document.

- Allowed values: any
- Cardinality: any
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

### `tags` — required

Search and discovery terms.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
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

Human-readable document title.

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

The documentation category governed by a type rule.

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

§5.2. Independent confirmations that this guidance is accurate.

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

- [Navigation](/types/navigation.md) — A catalog Navigation document.
- [Overview](/types/overview.md) — A catalog Overview document.
- [Standard](/types/standard.md) — A catalog Standard document.
- [Guide](/types/guide.md) — A catalog Guide document.
- [Pattern](/types/pattern.md) — A catalog Pattern document.
- [Runbook](/types/runbook.md) — A catalog Runbook document.
- [Reference](/types/reference.md) — A catalog Reference document.
- [Gotcha](/types/gotcha.md) — A catalog Gotcha document.
