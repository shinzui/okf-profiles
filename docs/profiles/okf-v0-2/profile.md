---
type: OKF Profile
title: okf-v0-2
description: 'Reference profile for the OKF v0.2 frontmatter families: provenance,
  trust, lifecycle, and sources.'
generated:
  by: process:okf-profile-document
---

# okf-v0-2

Reference profile for the OKF v0.2 frontmatter families: provenance, trust, lifecycle, and sources.

## Settings

- OKF version: `0.2`
- Required bundle version: none
- Unknown concept types: allowed
- Unknown frontmatter keys: allowed
- Document ID field: none

## Frontmatter rules

These rules apply to every concept in a bundle governed by this profile,
whatever its type. Each concept type's own page repeats them merged with that
type's rules, which is the form that actually applies.

### `description` — required

One or two sentences on what this concept is.

- Allowed values: any
- Cardinality: any
- Format: none
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

### `generated` — required

§5.2. How this content was produced. Supersedes the v0.1 `timestamp` key.

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

### `sources` — optional

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

### `stale_after` — optional

§5.5. Calendar date after which the content should be re-confirmed.

- Allowed values: any
- Cardinality: scalar
- Format: date
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

### `status` — optional

§5.4. Lifecycle state. Absence means `stable`, so this is never demanded.

- Allowed values: `draft`, `stable`, `deprecated`
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

### `title` — required

Human-readable name of the concept, as a reader would say it.

- Allowed values: any
- Cardinality: any
- Format: none
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

### `type` — required

The concept type. This profile constrains no vocabulary, because OKF defines no fixed taxonomy and requires consumers to tolerate unknown types.

- Allowed values: any
- Cardinality: any
- Format: none
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

### `usage_window` — optional

§5.1. The period the sources were observed over, when one applies to the whole concept.

- Allowed values: any
- Cardinality: object
- Format: none
- Reference: none
- Path: none
- Condition: none
- Object fields:
    - `from` — optional; allowed values: any; cardinality: any; format: date — §5.1. Calendar date the window opens.
    - `to` — optional; allowed values: any; cardinality: any; format: date — §5.1. Calendar date the window closes.
- Element fields: none

### `verified` — optional

§5.2. Independent confirmations that the content is accurate. A list of mappings, or one bare mapping.

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

## Concept types

(none declared)
