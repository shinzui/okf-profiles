---
type: OKF Profile Type
title: Product Research Finding
description: One citable observation from a study and the interpretation drawn from
  it.
generated:
  by: process:okf-profile-document
---

# Product Research Finding

One citable observation from a study and the interpretation drawn from it.

Declared by the [product-research](/profile.md) profile.

## Type settings

- Path pattern: `*`
- Resource URI scheme: none
- Requires a `# Schema` section: no
- Schema columns: none
- Document ID prefix: `PR`

## Frontmatter rules

Every rule below is the effective rule for a concept of type `Product Research Finding`:
the profile-wide rule and this type's own rule, already merged.

### Required

#### `context` — required

Circumstances in which the observation was made.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `description` — required

One sentence stating the study or finding.

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

§5.2. Who produced this document's current content, and when.

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

#### `interpretation` — required

The conclusion the authors draw from the observation.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `limitations` — required

What this finding cannot support.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `observation` — required

What was seen or measured, without interpretation.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `observedAt` — required

UTC RFC3339 time the observation was made.

- Allowed values: any
- Cardinality: scalar
- Format: rfc3339-utc
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `productResearchId` — required

Bundle-scoped stable PR-N handle.

- Allowed values: any
- Cardinality: scalar
- Format: document-handle(PR)
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `sources` — required

§5.1. Raw material the observation rests on, possibly outside the bundle.

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

#### `status` — required

Finding lifecycle: `current`, `superseded`, or `withdrawn`.

- Allowed values: `current`, `superseded`, `withdrawn`
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `studyRef` — required

Local PR-N handle or canonical Mori URI of the study producing this finding.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: local handles with prefix `PR`; external URIs with scheme `mori`; local handles allowed; self-reference not allowed; external URI whole-value pattern `mori://[^/]+/[^/]+/okf/[^/]+/concepts/PR-[1-9][0-9]*`
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `supersededBy` — required when `status` is `superseded`

Local PR-N handle or canonical Mori URI of the replacing finding.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: local handles with prefix `PR`; external URIs with scheme `mori`; local handles allowed; self-reference not allowed; external URI whole-value pattern `mori://[^/]+/[^/]+/okf/[^/]+/concepts/PR-[1-9][0-9]*`
- Path: none
- Unique by: none
- Condition: applies only when `status` is `superseded`
- Object fields: none
- Element fields: none

#### `title` — required

Human-readable title.

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

The Product Research Study or Product Research Finding concept type.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `withdrawalReason` — required when `status` is `withdrawn`

Why the finding no longer stands.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: applies only when `status` is `withdrawn`
- Object fields: none
- Element fields: none

### Recommended

(none)

### Optional

#### `jobAssessments` — optional

What this finding says about named claims concerning canonical jobs.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields:
    - `claim` — required; allowed values: any; cardinality: scalar; format: none — The specific claim about the job being assessed.
    - `jobRef` — required; allowed values: any; cardinality: scalar; format: none; reference: local handles with prefix `PR`; external URIs with scheme `mori`; local handles prohibited; self-reference not allowed; external URI whole-value pattern `mori://[^/]+/[^/]+/okf/[^/]+/concepts/JOB-[1-9][0-9]*` — Canonical Mori URI of the job concerned.
    - `outcomeName` — optional; allowed values: any; cardinality: scalar; format: none — Name of the job outcome the claim concerns, when it concerns one.
    - `rationale` — required; allowed values: any; cardinality: scalar; format: none — Why the observation bears on the claim.
    - `stance` — required; allowed values: `supports`, `challenges`, `inconclusive`; cardinality: scalar; format: none — `supports`, `challenges`, or `inconclusive` toward the claim.

#### `measurements` — optional

Observed values of a job's measurable outcome, in that outcome's unit.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: `name`
- Condition: none
- Object fields: none
- Element fields:
    - `jobRef` — required; allowed values: any; cardinality: scalar; format: none; reference: local handles with prefix `PR`; external URIs with scheme `mori`; local handles prohibited; self-reference not allowed; external URI whole-value pattern `mori://[^/]+/[^/]+/okf/[^/]+/concepts/JOB-[1-9][0-9]*` — Canonical Mori URI of the job concerned.
    - `method` — required; allowed values: any; cardinality: scalar; format: none — How the value was obtained.
    - `name` — required; allowed values: any; cardinality: scalar; format: none — Stable measurement name, unique within this finding.
    - `outcomeName` — required; allowed values: any; cardinality: scalar; format: none — Name of the measured outcome on the job.
    - `periodEnd` — required; allowed values: any; cardinality: scalar; format: rfc3339-utc — UTC RFC3339 end of the observed period.
    - `periodStart` — required; allowed values: any; cardinality: scalar; format: rfc3339-utc — UTC RFC3339 start of the observed period.
    - `population` — required; allowed values: any; cardinality: scalar; format: none — Whose behavior the value describes.
    - `unit` — required; allowed values: any; cardinality: scalar; format: none — Unit of `value`; the outcome's declared unit.
    - `value` — required; allowed values: any; cardinality: scalar; format: none — Observed finite number in `unit`.

#### `reviews` — optional

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

#### `tags` — optional

Producer-defined search and grouping tags.

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

§5.2. Independent confirmations that this document is accurate. Mirror an approving `reviews` entry here.

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

