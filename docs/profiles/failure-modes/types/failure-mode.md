---
type: OKF Profile Type
title: Failure Mode
description: One mechanism, with the signature that identifies it and the control
  that stops it.
generated:
  by: process:okf-profile-document
---

# Failure Mode

One mechanism, with the signature that identifies it and the control that stops it.

Declared by the [failure-modes](/profile.md) profile.

## Type settings

- Path pattern: `*`
- Resource URI scheme: none
- Requires a `# Schema` section: no
- Schema columns: none
- Document ID prefix: `FM`

## Frontmatter rules

Every rule below is the effective rule for a concept of type `Failure Mode`:
the profile-wide rule and this type's own rule, already merged.

### Required

#### `control` — required when `status` is one of `mitigated`, `prevented`, `accepted`

The change that stops this recurring, or — under `accepted` — what makes living with it tolerable.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: applies only when `status` is one of `mitigated`, `prevented`, `accepted`
- Object fields: none
- Element fields: none

#### `description` — required

One sentence a reader can match against a live symptom without opening the body.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `diagnosis` — required

Ordered checks that confirm this mode once the signature matches, cheapest first.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `failureModeId` — required

Bundle-scoped stable FM-N handle.

- Allowed values: any
- Cardinality: scalar
- Format: document-handle(FM)
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `generated` — required

§5.2. Who produced this entry's current content, and when.

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

#### `occurrences` — required

One entry per sighting, newest last, each naming the Mori URI where it fired and the date.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `rootCause` — required when `status` is one of `diagnosed`, `mitigated`, `prevented`, `accepted`

The mechanism, stated so that someone who has never seen it can predict when it fires.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: applies only when `status` is one of `diagnosed`, `mitigated`, `prevented`, `accepted`
- Object fields: none
- Element fields: none

#### `scope` — required

Where the mechanism lives, and therefore where a durable fix must go.

- Allowed values: `project`, `fleet`, `toolchain`, `platform`
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `signature` — required

What a reader matches against a live symptom in seconds, from what is already on screen. Not a diagnostic procedure.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `status` — required

How far this has been driven to ground. `prevented` means the control is deployed everywhere the mode can fire, not merely written.

- Allowed values: `observed`, `diagnosed`, `mitigated`, `prevented`, `accepted`
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `title` — required

Short statement of the mechanism, not of one incident.

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

The Failure Mode concept type.

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

#### `detection` — recommended

The standing, cheap signal that surfaces this early — the thing to watch rather than to remember.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: applies only when `status` is one of `mitigated`, `prevented`, `accepted`
- Object fields: none
- Element fields: none
- Checked only under `--strict`

#### `eliminated` — recommended

Explanations tested and disproved, each naming the check that disproved it. An entry without a check belongs in the body.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: applies only when `status` is one of `diagnosed`, `mitigated`, `prevented`, `accepted`
- Object fields: none
- Element fields: none
- Checked only under `--strict`

#### `reviews` — recommended

Chronological human or model review provenance for this document revision.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields:
    - `context` — required; allowed values: any; cardinality: scalar; format: none — Evidence and repository context used for the review.
    - `document_timestamp` — required; allowed values: any; cardinality: scalar; format: rfc3339-utc — Document revision timestamp covered by the review.
    - `effort` — required when `kind` is `model`; allowed values: `low`, `medium`, `high`, `xhigh`, `max`, `unspecified`; cardinality: scalar; format: none — Reasoning or thinking effort the review was run at.
    - `kind` — required; allowed values: `human`, `model`; cardinality: scalar; format: none — Whether a human or model performed the review.
    - `model` — required when `kind` is `model`; allowed values: any; cardinality: scalar; format: none — Most specific available model identifier.
    - `outcome` — required; allowed values: `approved`, `changes-requested`, `commented`; cardinality: scalar; format: none — Result recorded by the reviewer.
    - `provider` — required when `kind` is `model`; allowed values: any; cardinality: scalar; format: none — Serving provider for a model review.
    - `reviewed_at` — required; allowed values: any; cardinality: scalar; format: rfc3339-utc — UTC time at which the review completed.
    - `reviewer` — required; allowed values: any; cardinality: scalar; format: none — Stable identity of the reviewing person or agent.
    - `scope` — required; allowed values: `content`, `technical-accuracy`, `editorial`, `catalog-metadata`, `content-and-metadata`; cardinality: scalar; format: none — Aspect of the document covered by the review.
- Checked only under `--strict`

### Optional

#### `bugReport` — optional

Mori URI of a bug report that is one instance of this mode, where a repository owns the defect.

- Allowed values: any
- Cardinality: scalar
- Format: uri-with-scheme(mori)
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `cost` — optional

What each undiagnosed occurrence has cost, stated observably — machine-hours lost, work blocked. Ranks the catalog by what is worth preventing.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `supersededBy` — optional

The entry that replaces this one, as a local FM-N handle or an external Mori URI, once a sharper mechanism subsumes it.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: local handles with prefix `FM`; external URIs with scheme `mori`; local handles allowed; self-reference not allowed
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `verified` — optional

§5.2. Independent confirmations that this diagnosis holds. Mirror an approving `reviews` entry here.

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

