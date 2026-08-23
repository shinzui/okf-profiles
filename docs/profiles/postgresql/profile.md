---
type: OKF Profile
title: shinzui-postgresql
description: 'Conventions for documenting PostgreSQL schemas, tables, and views as
  an OKF bundle. Targets OKF v0.2: provenance goes in `generated`, independent confirmation
  in `verified`, and lifecycle in `status` and `stale_after` — a database description
  decays whether or not anyone edits it.'
generated:
  by: process:okf-profile-document
---

# shinzui-postgresql

Conventions for documenting PostgreSQL schemas, tables, and views as an OKF bundle. Targets OKF v0.2: provenance goes in `generated`, independent confirmation in `verified`, and lifecycle in `status` and `stale_after` — a database description decays whether or not anyone edits it.

## Settings

- OKF version: `0.2`
- Required bundle version: `0.2`
- Unknown concept types: rejected
- Unknown frontmatter keys: allowed
- Document ID field: none

## Frontmatter rules

These rules apply to every concept in a bundle governed by this profile,
whatever its type. Each concept type's own page repeats them merged with that
type's rules, which is the form that actually applies.

### `description` — recommended

One or two sentences explaining the object's purpose.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none
- Checked only under `--strict`

### `generated` — recommended

§5.2. Who or what produced this description, and when it was last confirmed accurate.

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
- Checked only under `--strict`

### `resource` — recommended

postgresql:// URI locating the live object.

- Allowed values: any
- Cardinality: scalar
- Format: uri-with-scheme(postgresql)
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none
- Checked only under `--strict`

### `stale_after` — optional

§5.5. Date after which this description should be re-confirmed against the live object.

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

### `timestamp` — optional

Superseded v0.1 confirmation timestamp. Prefer `generated.at`.

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

Human-readable name of the database object.

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

The exact PostgreSQL concept type governed by this profile.

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

§5.2. Independent confirmations that this description still matches the live object.

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

- [PostgreSQL Schema](/types/postgresql-schema.md) — One PostgreSQL namespace and the objects it groups.
- [PostgreSQL Table](/types/postgresql-table.md) — One physical table, including its column contract.
- [PostgreSQL View](/types/postgresql-view.md) — One view and the columns it projects.
