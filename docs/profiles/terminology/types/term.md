---
type: OKF Profile Type
title: Term
description: One concept of this project's vocabulary, under the one name the project
  uses for it.
generated:
  by: process:okf-profile-document
---

# Term

One concept of this project's vocabulary, under the one name the project uses for it.

Declared by the [terminology](/profile.md) profile.

## Type settings

- Path pattern: `*`
- Resource URI scheme: none
- Requires a `# Schema` section: no
- Schema columns: none
- Document ID prefix: `TERM`

## Frontmatter rules

Every rule below is the effective rule for a concept of type `Term`:
the profile-wide rule and this type's own rule, already merged.

### Required

#### `description` — required

A one-sentence definition.

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

§5.2. Who produced this term's current content, and when.

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

#### `replacedBy` — required when `status` is `deprecated`

The term to use instead. Demanded once `status` is `deprecated`.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: local handles with prefix `TERM`; external URIs with scheme `mori`; local handles allowed; self-reference not allowed
- Path: none
- Unique by: none
- Condition: applies only when `status` is `deprecated`
- Object fields: none
- Element fields: none

#### `status` — required

Whether this is the term to use or a retired one.

- Allowed values: `current`, `deprecated`
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `termId` — required

Bundle-scoped stable TERM-N handle.

- Allowed values: any
- Cardinality: scalar
- Format: document-handle(TERM)
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `title` — required

The canonical term, spelled and cased exactly as it should be written.

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

The Term concept type.

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

#### `abbreviation` — optional

An accepted short form of the term.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `aliases` — optional

Accepted synonyms with identical meaning.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `anchors` — optional

What embodies this term: a module, type, function, file, document, or absolute URI a reader can open.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields:
    - `kind` — required; allowed values: `module`, `type`, `function`, `file`, `doc`, `uri`; cardinality: scalar; format: none — What sort of artifact this anchor names.
    - `note` — optional; allowed values: any; cardinality: scalar; format: none — Why this anchor matters.
    - `resource` — required; allowed values: any; cardinality: scalar; format: none — Module name, qualified identifier, repository-relative path, or absolute URI.

#### `broader` — optional

More general terms this term specialises.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: local handles with prefix `TERM`; external URIs with scheme `mori`; local handles allowed; self-reference not allowed
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `discouraged` — optional

Wording that must not be used for this concept. The body says why.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `related` — optional

Associated terms that are neither broader nor equivalent.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: local handles with prefix `TERM`; external URIs with scheme `mori`; local handles allowed; self-reference not allowed
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `replaces` — optional

Terms this term succeeds.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: local handles with prefix `TERM`; external URIs with scheme `mori`; local handles allowed; self-reference not allowed
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `sameAs` — optional

The same concept published by another project, as canonical Mori term URIs.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: local handles with prefix `TERM`; external URIs with scheme `mori`; local handles prohibited; self-reference not allowed; external URI whole-value pattern `mori://[^/]+/[^/]+/okf/[^/]+/concepts/TERM-[1-9][0-9]*`
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `scope` — optional

The subsystem or bounded context in which this meaning holds.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `tags` — optional

Free classification tags.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `verified` — optional

§5.2. Independent confirmations that this definition is accurate.

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

