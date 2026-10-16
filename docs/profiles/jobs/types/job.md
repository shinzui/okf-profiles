---
type: OKF Profile Type
title: Job
description: Progress an actor seeks in a situation, independent of any solution.
generated:
  by: process:okf-profile-document
---

# Job

Progress an actor seeks in a situation, independent of any solution.

Declared by the [jobs](/profile.md) profile.

## Type settings

- Path pattern: `*`
- Resource URI scheme: none
- Requires a `# Schema` section: no
- Schema columns: none
- Document ID prefix: `JOB`

## Frontmatter rules

Every rule below is the effective rule for a concept of type `Job`:
the profile-wide rule and this type's own rule, already merged.

### Required

#### `actor` — required

Person or role trying to make progress.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `assessment` — required when `validationStatus` is one of `supported`, `mixed`, `challenged`

The authors' synthesis of research findings behind `validationStatus`.

- Allowed values: any
- Cardinality: object
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: applies only when `validationStatus` is one of `supported`, `mixed`, `challenged`
- Object fields:
    - `assessedAt` — required; allowed values: any; cardinality: scalar; format: rfc3339-utc — UTC RFC3339 time the assessment was made.
    - `findingRefs` — required; allowed values: any; cardinality: list; format: none; reference: local handles with prefix `JOB`; external URIs with scheme `mori`; local handles prohibited; self-reference not allowed; external URI whole-value pattern `mori://[^/]+/[^/]+/okf/[^/]+/concepts/PR-[1-9][0-9]*` — Canonical Mori URIs of the product-research findings assessed.
    - `rationale` — required; allowed values: any; cardinality: scalar; format: none — Why the cited findings justify the declared validation status.
- Element fields: none

#### `description` — required

One sentence stating the job.

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

§5.2. Who produced this job's current content, and when.

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

#### `jobId` — required

Bundle-scoped stable JOB-N handle.

- Allowed values: any
- Cardinality: scalar
- Format: document-handle(JOB)
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `motivation` — required

Progress the actor wants to make.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `outcomes` — required

Desired results that show the job's progress, qualitative or measured.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: `name`
- Condition: none
- Object fields: none
- Element fields:
    - `baseline` — optional; allowed values: any; cardinality: scalar; format: none — Measured starting value in `unit`, documented by a `sources` entry.
    - `description` — required; allowed values: any; cardinality: scalar; format: none — What the actor would observe when this outcome is achieved.
    - `direction` — optional; allowed values: `increase`, `decrease`, `maintain`; cardinality: scalar; format: none — Which way the metric should move: `increase`, `decrease`, or `maintain`.
    - `method` — optional; allowed values: any; cardinality: scalar; format: none — How the metric is obtained.
    - `metric` — optional; allowed values: any; cardinality: scalar; format: none — What is measured to track this outcome.
    - `name` — required; allowed values: any; cardinality: scalar; format: none — Stable outcome name, unique within this job.
    - `period` — optional; allowed values: any; cardinality: scalar; format: none — When the baseline was observed.
    - `population` — optional; allowed values: any; cardinality: scalar; format: none — Whose behavior the baseline describes.
    - `target` — optional; allowed values: any; cardinality: scalar; format: none — Aspired value in `unit`; never an observation.
    - `unit` — optional; allowed values: any; cardinality: scalar; format: none — Unit every baseline, target, and measurement uses.

#### `situation` — required

Circumstance in which the job arises.

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

Lifecycle of this job statement: `draft`, `active`, or `retired`.

- Allowed values: `draft`, `active`, `retired`
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `title` — required

Short name for the progress the actor seeks.

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

The Job concept type.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `validationStatus` — required

Declared research support: `untested`, `supported`, `mixed`, or `challenged`.

- Allowed values: `untested`, `supported`, `mixed`, `challenged`
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

#### `emotionalContext` — optional

How the actor wants to feel, or avoid feeling.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `functionalContext` — optional

Practical task constraints surrounding the job.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `relatedJobs` — optional

Related local JOB handles or canonical Mori job URIs.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: local handles with prefix `JOB`; external URIs with scheme `mori`; local handles allowed; self-reference not allowed; external URI whole-value pattern `mori://[^/]+/[^/]+/okf/[^/]+/concepts/JOB-[1-9][0-9]*`
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

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

#### `socialContext` — optional

How the actor wants to be perceived by others.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `sources` — optional

§5.1. Evidence this job statement and any baseline were derived from.

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

