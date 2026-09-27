---
type: OKF Profile
title: verification-evidence
description: 'Evidence about a runtime: definitions of how verdicts are computed,
  immutable records of runs that link to their data by digest, and attestations that
  a deterministic verifier re-checked that data.'
generated:
  by: process:okf-profile-document
---

# verification-evidence

Evidence about a runtime: definitions of how verdicts are computed, immutable records of runs that link to their data by digest, and attestations that a deterministic verifier re-checked that data.

## Settings

- OKF version: `0.2`
- Required bundle version: `0.2`
- Unknown concept types: rejected
- Unknown frontmatter keys: rejected
- Document ID field: `computationId`

## Frontmatter rules

These rules apply to every concept in a bundle governed by this profile,
whatever its type. Each concept type's own page repeats them merged with that
type's rules, which is the form that actually applies.

### `description` — required

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

### `generated` — required

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

### `title` — required

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

### `type` — required

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

### `verified` — optional

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

## Concept types

- [Attested Computation](/types/attested-computation.md) — How one outcome, verdict or figure is computed from raw run data, and how a deterministic verifier re-checks it.
- [Verification Run](/types/verification-run.md) — One recorded run, or one recorded comparison of runs: what ran, against what, where, with which outcome, and where the data is.
- [Attestation](/types/attestation.md) — A deterministic verifier fetched a record's data, re-checked it, and this is what it concluded.
