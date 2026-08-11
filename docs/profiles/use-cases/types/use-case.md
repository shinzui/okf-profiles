---
type: OKF Profile Type
title: Use Case
description: A user-value scenario expressed as JTBD records and the features needed
  to deliver it.
generated:
  by: process:okf-profile-document
---

# Use Case

A user-value scenario expressed as JTBD records and the features needed to deliver it.

Declared by the [jtbd-use-cases](/profile.md) profile.

## Type settings

- Path pattern: `*`
- Resource URI scheme: none
- Requires a `# Schema` section: no
- Schema columns: none
- Document ID prefix: `UC`

## Frontmatter rules

Every rule below is the effective rule for a concept of type `Use Case`:
the profile-wide rule and this type's own rule, already merged.

### Required

#### `description` — required

Concise statement of the use case or theme.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

#### `features` — required

Capabilities whose delivery makes the use case possible, with ownership and request tracking.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields:
    - `acceptance` — required; allowed values: any; cardinality: scalar; format: none — Observable evidence that proves the feature is delivered.
    - `description` — required; allowed values: any; cardinality: scalar; format: none — Capability or behavior the feature supplies.
    - `improvementRequests` — optional; allowed values: any; cardinality: list; format: uri-with-scheme(mori) — Stable Mori concept URIs of repository-owned requests delivering this feature.
    - `jobs` — optional; allowed values: any; cardinality: list; format: none — Names of the JTBD records this feature advances.
    - `name` — required; allowed values: any; cardinality: scalar; format: none — Stable feature name within the use case.
    - `owners` — required; allowed values: any; cardinality: list; format: uri-with-scheme(mori) — Mori project URIs accountable for delivering the feature.
    - `status` — required; allowed values: `discovered`, `planned`, `in-progress`, `delivered`, `blocked`, `deferred`; cardinality: scalar; format: none — Current delivery state of the feature.

#### `generated` — required

§5.2. Who produced this use case or theme's current content, and when.

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

#### `jobs` — required

Jobs-to-be-Done statements describing the actor, situation, desired progress, and observable outcome.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields:
    - `actor` — required; allowed values: any; cardinality: scalar; format: none — Person, role, or agent trying to make progress.
    - `motivation` — required; allowed values: any; cardinality: scalar; format: none — Progress the actor wants to make.
    - `name` — required; allowed values: any; cardinality: scalar; format: none — Stable name for this job within the use case.
    - `outcome` — required; allowed values: any; cardinality: scalar; format: none — Observable result that satisfies the job.
    - `situation` — required; allowed values: any; cardinality: scalar; format: none — Circumstance in which the job arises.

#### `origin` — required

Mori project URI that owns this use case.

- Allowed values: any
- Cardinality: scalar
- Format: uri-with-scheme(mori)
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

#### `status` — required

Lifecycle state of the use case.

- Allowed values: `draft`, `validated`, `planned`, `in-progress`, `delivered`, `retired`
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

#### `title` — required

Human-readable title.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

#### `type` — required

The Use Case or Use Case Theme concept type.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

#### `useCaseId` — required

Bundle-scoped stable UC-N handle.

- Allowed values: any
- Cardinality: scalar
- Format: document-handle(UC)
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

### Recommended

#### `reviews` — recommended

Chronological human or model review provenance for this document revision.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields:
    - `context` — required; allowed values: any; cardinality: scalar; format: none — Evidence and repository context used for the review.
    - `document_timestamp` — required; allowed values: any; cardinality: scalar; format: rfc3339-utc — Document revision timestamp covered by the review.
    - `effort` — required when `kind` is `model`; allowed values: `low`, `medium`, `high`, `xhigh`, `unspecified`; cardinality: scalar; format: none — Provider-reported reasoning or thinking effort.
    - `kind` — required; allowed values: `human`, `model`; cardinality: scalar; format: none — Whether a human or model performed the review.
    - `model` — required when `kind` is `model`; allowed values: any; cardinality: scalar; format: none — Most specific available model identifier.
    - `outcome` — required; allowed values: `approved`, `changes-requested`, `commented`; cardinality: scalar; format: none — Result recorded by the reviewer.
    - `provider` — required when `kind` is `model`; allowed values: any; cardinality: scalar; format: none — Serving provider for a model review.
    - `reviewed_at` — required; allowed values: any; cardinality: scalar; format: rfc3339-utc — UTC time at which the review completed.
    - `reviewer` — required; allowed values: any; cardinality: scalar; format: none — Stable identity of the reviewing person or agent.
    - `scope` — required; allowed values: `content`, `technical-accuracy`, `editorial`, `catalog-metadata`, `content-and-metadata`; cardinality: scalar; format: none — Aspect of the document covered by the review.
- Checked only under `--strict`

#### `themes` — recommended

Theme slugs mirrored by body links to theme concepts.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none
- Checked only under `--strict`

### Optional

#### `improvementRequests` — optional

Stable Mori request URIs; mirror the union of feature-level request references.

- Allowed values: any
- Cardinality: list
- Format: uri-with-scheme(mori)
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

#### `links` — optional

Additional navigation links retained as producer metadata.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

#### `relatedUseCases` — optional

Related local UC handles or external Mori use-case URIs.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: local handles with prefix `UC`; external URIs with scheme `mori`; self-reference not allowed
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

#### `tags` — optional

Producer-defined search and grouping tags.

- Allowed values: any
- Cardinality: list
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

§5.2. Independent confirmations that this content is accurate. Mirror an approving `reviews` entry here.

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

