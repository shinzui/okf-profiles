---
type: OKF Profile Type
title: Attested Computation
description: How one outcome, verdict or figure is computed from raw run data, and
  how a deterministic verifier re-checks it.
generated:
  by: process:okf-profile-document
---

# Attested Computation

How one outcome, verdict or figure is computed from raw run data, and how a deterministic verifier re-checks it.

Declared by the [verification-evidence](/profile.md) profile.

## Type settings

- Path pattern: `computations/*`
- Resource URI scheme: none
- Requires a `# Schema` section: no
- Schema columns: none
- Document ID prefix: `VC`

## Frontmatter rules

Every rule below is the effective rule for a concept of type `Attested Computation`:
the profile-wide rule and this type's own rule, already merged.

### Required

#### `algorithm` — required

Identifier the harness writes into its documents.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `algorithmVersion` — required

A change that can alter a result takes a new VC handle.

- Allowed values: any
- Cardinality: scalar
- Format: non-negative-integer
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `attester` — required

Deterministic code that re-checks a run.

- Allowed values: any
- Cardinality: object
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields:
    - `resource` — required; allowed values: any; cardinality: any; format: none; path: bundle paths resolved to concepts; external URLs not allowed; self-reference not allowed — The verifier: a non-Markdown file here.
- Element fields: none

#### `computationId` — required

Bundle-scoped stable VC-N handle.

- Allowed values: any
- Cardinality: scalar
- Format: document-handle(VC)
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

#### `executor` — required

How a run is performed and what it returns.

- Allowed values: any
- Cardinality: object
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields:
    - `receipt` — required; allowed values: any; cardinality: list; format: none — Run-directory documents a run returns.
    - `resource` — required; allowed values: any; cardinality: any; format: none; path: bundle paths resolved to concepts; external URLs not allowed; self-reference not allowed — Run instructions: a non-Markdown file here.
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

#### `implementation` — required

Module implementing the algorithm.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `inputs` — required

Data-link kinds the computation reads.

- Allowed values: `run-spec`, `run-result`, `manifest`, `cell-manifest`, `samples`, `series`, `verdicts`, `diagnosis`, `logs`, `comparison`
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `parameters` — required

Typed named holes; empty when it takes none.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields:
    - `name` — required; allowed values: any; cardinality: scalar; format: none — The name the computation binds.
    - `required` — optional; allowed values: any; cardinality: scalar; format: boolean — Whether a caller must supply it.
    - `type` — required; allowed values: any; cardinality: scalar; format: none — What kind of value it takes.

#### `produces` — required

What the computation yields.

- Allowed values: `outcome`, `verdict`, `diagnosis`, `comparison`, `summary`
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `runtime` — required

How the computation is run.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
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

### Recommended

(none)

### Optional

#### `appliesTo` — optional

Evidence kinds whose runs may name it.

- Allowed values: `correctness`, `concurrency`, `soak`, `benchmark`
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `computation` — optional

The computation file, when not inline.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: bundle paths resolved to concepts; external URLs not allowed; self-reference not allowed
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `stale_after` — optional

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

#### `status` — optional

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

#### `supersedes` — optional

The definition this one replaces.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: local handles with prefix `VC`; external URIs not allowed; local handles allowed; self-reference not allowed
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
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

