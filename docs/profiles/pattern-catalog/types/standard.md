---
type: OKF Profile Type
title: Standard
description: A catalog Standard document.
generated:
  by: process:okf-profile-document
---

# Standard

A catalog Standard document.

Declared by the [mori-documentation-pattern-catalog](/profile.md) profile.

## Type settings

- Path pattern: `*/**`
- Resource URI scheme: `mori`
- Requires a `# Schema` section: no
- Schema columns: none
- Document ID prefix: none

## Frontmatter rules

Every rule below is the effective rule for a concept of type `Standard`:
the profile-wide rule and this type's own rule, already merged.

### Required

#### `description` — required

Concise statement of the document's purpose.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
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
- Condition: none
- Object fields:
    - `at` — recommended; allowed values: any; cardinality: any; format: rfc3339-utc — UTC RFC3339 timestamp, ending in `Z`, for when this happened.
    - `by` — required; allowed values: any; cardinality: any; format: actor — §7. The actor responsible: `<producer>/<version>`, `human:<id>`, or `process:<id>`.
- Element fields: none

#### `resource` — required

Canonical Mori URI for this document.

- Allowed values: any
- Cardinality: scalar
- Format: uri-with-scheme(mori)
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

#### `status` — required

Publication state of this guidance.

- Allowed values: `current`, `deprecated`
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

#### `tags` — required

Search and discovery terms.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

#### `title` — required

Human-readable document title.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

#### `type` — required

The documentation category governed by a type rule.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

### Recommended

(none)

### Optional

#### `sources` — optional

§5.1. What this content was derived from, one entry per source.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
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

Earlier guidance replaced by this document.

- Allowed values: any
- Cardinality: any
- Format: none
- Reference: none
- Path: none
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
- Condition: none
- Object fields: none
- Element fields: none

#### `verified` — optional

§5.2. Independent confirmations that this guidance is accurate.

- Allowed values: any
- Cardinality: any
- Format: none
- Reference: none
- Path: none
- Condition: none
- Object fields:
    - `at` — recommended; allowed values: any; cardinality: any; format: rfc3339-utc — UTC RFC3339 timestamp, ending in `Z`, for when this happened.
    - `by` — required; allowed values: any; cardinality: any; format: actor — §7. The actor responsible: `<producer>/<version>`, `human:<id>`, or `process:<id>`.
- Element fields:
    - `at` — recommended; allowed values: any; cardinality: any; format: rfc3339-utc — UTC RFC3339 timestamp, ending in `Z`, for when this happened.
    - `by` — required; allowed values: any; cardinality: any; format: actor — §7. The actor responsible: `<producer>/<version>`, `human:<id>`, or `process:<id>`.

