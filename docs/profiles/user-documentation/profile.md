---
type: OKF Profile
title: user-documentation
description: User-facing product documentation with stable DOC handles and a reader-intent
  taxonomy for navigation, learning, task completion, explanation, lookup, and operations.
generated:
  by: process:okf-profile-document
---

# user-documentation

User-facing product documentation with stable DOC handles and a reader-intent taxonomy for navigation, learning, task completion, explanation, lookup, and operations.

## Settings

- OKF version: `0.2`
- Required bundle version: `0.2`
- Unknown concept types: rejected
- Unknown frontmatter keys: allowed
- Document ID field: `docId`

## Frontmatter rules

These rules apply to every concept in a bundle governed by this profile,
whatever its type. Each concept type's own page repeats them merged with that
type's rules, which is the form that actually applies.

### `description` — required

Concise statement of the page's purpose and scope.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

### `docId` — required

Bundle-scoped stable DOC-N handle.

- Allowed values: any
- Cardinality: scalar
- Format: document-handle(DOC)
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

### `generated` — required

§5.2. Who produced this page's current content, and when.

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

### `sources` — optional

§5.1. Specifications, source code, or other evidence from which this page was derived.

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

### `stale_after` — optional

§5.5. Calendar date after which the content should be re-confirmed.

- Allowed values: any
- Cardinality: scalar
- Format: date
- Reference: none
- Path: none
- Unique by: none
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
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

### `supersededBy` — optional

Later documentation replacing this page.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: local handles with prefix `DOC`; external URIs with scheme `mori`; local handles allowed; self-reference not allowed
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

### `supersedes` — optional

Earlier documentation replaced by this page.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: local handles with prefix `DOC`; external URIs with scheme `mori`; local handles allowed; self-reference not allowed
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

### `tags` — required

Search and discovery terms for readers and agents.

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

Human-readable page title.

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

The page's primary reader intent.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
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
- Unique by: none
- Condition: none
- Object fields:
    - `from` — optional; allowed values: any; cardinality: any; format: date — §5.1. Calendar date the window opens.
    - `to` — optional; allowed values: any; cardinality: any; format: date — §5.1. Calendar date the window closes.
- Element fields: none

### `verified` — optional

§5.2. Independent confirmations that this page remains accurate.

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

- [Navigation](/types/navigation.md) — A curated entry point that routes readers to the right documentation.
- [Tutorial](/types/tutorial.md) — A learning-oriented sequence that helps a reader gain initial working experience.
- [Guide](/types/guide.md) — Goal-oriented instructions that help a reader complete a specific task.
- [Explanation](/types/explanation.md) — Conceptual material that builds understanding, context, and decision-making judgment.
- [Reference](/types/reference.md) — Authoritative lookup material describing interfaces, contracts, options, or current state.
- [Runbook](/types/runbook.md) — An operational procedure whose ordering, safety conditions, and recovery behavior matter.
