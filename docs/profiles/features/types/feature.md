---
type: OKF Profile Type
title: Feature
description: A coherent product behavior with its own identity and delivery lifecycle.
generated:
  by: process:okf-profile-document
---

# Feature

A coherent product behavior with its own identity and delivery lifecycle.

Declared by the [features](/profile.md) profile.

## Type settings

- Path pattern: `*`
- Resource URI scheme: none
- Requires a `# Schema` section: no
- Schema columns: none
- Document ID prefix: `FEAT`

## Frontmatter rules

Every rule below is the effective rule for a concept of type `Feature`:
the profile-wide rule and this type's own rule, already merged.

### Required

#### `acceptanceCriteria` — required when `status` is one of `planned`, `in-progress`, `blocked`, `delivered`

Feature-local product acceptance conditions with AC-N ids; not request criteria.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: `id`
- Condition: applies only when `status` is one of `planned`, `in-progress`, `blocked`, `delivered`
- Object fields: none
- Element fields:
    - `id` — required; allowed values: any; cardinality: scalar; format: document-handle(AC) — Stable feature-local AC-N handle for this condition.
    - `statement` — required; allowed values: any; cardinality: scalar; format: none — Observable product condition that must hold for acceptance.
    - `verification` — required; allowed values: any; cardinality: scalar; format: none — Expected procedure or evidence that will prove the condition.

#### `behavior` — required

Proposed or actual customer-visible behavior.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `deliveredAt` — required when `status` is `delivered`

UTC RFC3339 time the behavior was delivered and accepted.

- Allowed values: any
- Cardinality: scalar
- Format: rfc3339-utc
- Reference: none
- Path: none
- Unique by: none
- Condition: applies only when `status` is `delivered`
- Object fields: none
- Element fields: none

#### `deliveryEvidence` — required when `status` is `delivered`

Evidence that the behavior was delivered, in the shape of §5.1 sources.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: applies only when `status` is `delivered`
- Object fields: none
- Element fields:
    - `author` — optional; allowed values: any; cardinality: any; format: actor — §5.1. Who or what produced the source, per the §7 actor convention.
    - `id` — optional; allowed values: any; cardinality: any; format: none — §5.1. Short label for this entry, used to cite it from a footnote in the body.
    - `last_modified` — optional; allowed values: any; cardinality: any; format: date — §5.1. Calendar date the source itself last changed.
    - `resource` — required; allowed values: any; cardinality: any; format: none — §5.1. What the source is: a followable artifact, or a scope descriptor.
    - `title` — optional; allowed values: any; cardinality: any; format: none — §5.1. Human-readable name for the source.
    - `usage_count` — optional; allowed values: any; cardinality: scalar; format: non-negative-integer — §5.1. How many times the source was drawn on. A count, so never negative.

#### `description` — required

One sentence stating the feature.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `featureId` — required

Bundle-scoped stable FEAT-N handle.

- Allowed values: any
- Cardinality: scalar
- Format: document-handle(FEAT)
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `generated` — required

§5.2. Who produced this feature's current content, and when.

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

#### `owners` — required when `status` is one of `planned`, `in-progress`, `blocked`, `delivered`

Mori project URIs accountable for delivering the feature.

- Allowed values: any
- Cardinality: list
- Format: uri-with-scheme(mori)
- Reference: none
- Path: none
- Unique by: none
- Condition: applies only when `status` is one of `planned`, `in-progress`, `blocked`, `delivered`
- Object fields: none
- Element fields: none

#### `status` — required

Delivery state: discovered, planned, in-progress, delivered, blocked, deferred, or retired.

- Allowed values: `discovered`, `planned`, `in-progress`, `delivered`, `blocked`, `deferred`, `retired`
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `title` — required

Short, stable-sounding feature name.

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

The Feature concept type.

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

#### `capabilityRefs` — optional

Canonical Mori URIs of producer capabilities contributing behavior.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: local handles with prefix `FEAT`; external URIs with scheme `mori`; local handles prohibited; self-reference not allowed; external URI whole-value pattern `mori://[^/]+/[^/]+/okf/[^/]+/concepts/CAP-[1-9][0-9]*`
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `improvementRequests` — optional

Canonical Mori URIs of requests delivering parts of this feature.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: local handles with prefix `FEAT`; external URIs with scheme `mori`; local handles prohibited; self-reference not allowed; external URI whole-value pattern `mori://[^/]+/[^/]+/okf/[^/]+/concepts/IR-[1-9][0-9]*`
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `jobRefs` — optional

Canonical Mori URIs of the customer jobs this feature serves.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: local handles with prefix `FEAT`; external URIs with scheme `mori`; local handles prohibited; self-reference not allowed; external URI whole-value pattern `mori://[^/]+/[^/]+/okf/[^/]+/concepts/JOB-[1-9][0-9]*`
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `outcomeRefs` — optional

Named outcomes of jobs in `jobRefs` that this feature is meant to move.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields:
    - `jobRef` — required; allowed values: any; cardinality: scalar; format: none; reference: local handles with prefix `FEAT`; external URIs with scheme `mori`; local handles prohibited; self-reference not allowed; external URI whole-value pattern `mori://[^/]+/[^/]+/okf/[^/]+/concepts/JOB-[1-9][0-9]*` — Canonical Mori URI of a job in `jobRefs`.
    - `outcomeName` — required; allowed values: any; cardinality: scalar; format: none — Name of an outcome declared by that job.

#### `priority` — optional

Producer-declared ordering signal: low, medium, high, or critical.

- Allowed values: `low`, `medium`, `high`, `critical`
- Cardinality: scalar
- Format: none
- Reference: none
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

#### `specificationRefs` — optional

Canonical Mori URIs of specifications governing this feature.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: local handles with prefix `FEAT`; external URIs with scheme `mori`; local handles prohibited; self-reference not allowed; external URI whole-value pattern `mori://[^/]+/[^/]+/okf/[^/]+/concepts/SPEC-[1-9][0-9]*`
- Path: none
- Unique by: none
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

