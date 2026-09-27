---
type: OKF Profile Type
title: Attestation
description: A deterministic verifier fetched a record's data, re-checked it, and
  this is what it concluded.
generated:
  by: process:okf-profile-document
---

# Attestation

A deterministic verifier fetched a record's data, re-checked it, and this is what it concluded.

Declared by the [verification-evidence](/profile.md) profile.

## Type settings

- Path pattern: `attestations/*/*/*`
- Resource URI scheme: none
- Requires a `# Schema` section: no
- Schema columns: none
- Document ID prefix: none

## Frontmatter rules

Every rule below is the effective rule for a concept of type `Attestation`:
the profile-wide rule and this type's own rule, already merged.

### Required

#### `attestationId` — required

UUIDv7. Equals the file name.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `attestedAt` — required

UTC completion time.

- Allowed values: any
- Cardinality: scalar
- Format: rfc3339-utc
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `attester` — required

The verifier, as an OKF actor.

- Allowed values: any
- Cardinality: scalar
- Format: actor
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `attesterRevision` — required

Full 40-character commit of the verifier.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `checks` — required

Every check, and what it found.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: `name`
- Condition: none
- Object fields: none
- Element fields:
    - `detail` — optional; allowed values: any; cardinality: scalar; format: none — One line saying why.
    - `name` — required; allowed values: `digests-match`, `revisions-resolve`, `cohort-matches-plan`, `verdict-recomputed`, `environment-captured`, `clean-worktree`; cardinality: scalar; format: none — Which check.
    - `result` — required; allowed values: `passed`, `failed`, `skipped`; cardinality: scalar; format: none — What it found.

#### `dataDigests` — required

64-hex SHA-256 of every object fetched and matched.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `description` — required

One sentence a reader can evaluate alone.

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

#### `run` — required

The record attested.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: bundle paths resolved to concepts; external URLs not allowed; self-reference not allowed
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `title` — required

What this record is, in one line.

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

One of the three concept types.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `verdict` — required

What the verifier concluded.

- Allowed values: `confirmed`, `refuted`, `incomplete`
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

#### `exception` — optional

A human's acceptance of an anomaly.

- Allowed values: any
- Cardinality: object
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields:
    - `authority` — required; allowed values: any; cardinality: scalar; format: human-actor — The human who accepted it.
    - `reason` — required; allowed values: any; cardinality: scalar; format: none — Why the anomaly is acceptable.
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

