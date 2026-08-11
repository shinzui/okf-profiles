---
type: OKF Profile Type
title: PostgreSQL View
description: One view and the columns it projects.
generated:
  by: process:okf-profile-document
---

# PostgreSQL View

One view and the columns it projects.

Declared by the [shinzui-postgresql](/profile.md) profile.

## Type settings

- Path pattern: `schemas/*/views/*`
- Resource URI scheme: `postgresql`
- Requires a `# Schema` section: yes
- Schema columns: `Column`, `Type`, `Description`
- Document ID prefix: none

## Frontmatter rules

Every rule below is the effective rule for a concept of type `PostgreSQL View`:
the profile-wide rule and this type's own rule, already merged.

### Required

#### `title` — required

Human-readable name of the database object.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

#### `type` — required

The exact PostgreSQL concept type governed by this profile.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

### Recommended

#### `description` — recommended

One or two sentences explaining the object's purpose.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none
- Checked only under `--strict`

#### `generated` — recommended

§5.2. Who or what produced this description, and when it was last confirmed accurate.

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
- Checked only under `--strict`

#### `resource` — recommended

postgresql:// URI locating the live object.

- Allowed values: any
- Cardinality: scalar
- Format: uri-with-scheme(postgresql)
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none
- Checked only under `--strict`

### Optional

#### `stale_after` — optional

§5.5. Date after which this description should be re-confirmed against the live object.

- Allowed values: any
- Cardinality: scalar
- Format: date
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

#### `status` — optional

§5.4. Lifecycle state. Absence means `stable`, so this is never demanded.

- Allowed values: `draft`, `stable`, `deprecated`
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

#### `timestamp` — optional

Superseded v0.1 confirmation timestamp. Prefer `generated.at`.

- Allowed values: any
- Cardinality: any
- Format: rfc3339-utc
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

#### `verified` — optional

§5.2. Independent confirmations that this description still matches the live object.

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

