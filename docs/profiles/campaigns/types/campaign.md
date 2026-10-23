---
type: OKF Profile Type
title: Campaign
description: Coordinated work carrying a hypothesis, announcement, or engagement purpose.
generated:
  by: process:okf-profile-document
---

# Campaign

Coordinated work carrying a hypothesis, announcement, or engagement purpose.

Declared by the [campaigns](/profile.md) profile.

## Guidance

### Type-specific

Approval and sending require the responsible owners’ actual review and send evidence; dates alone never promote the lifecycle. The opt-in check-gtm.py verifies secondary purpose blocks, experiment-study targets, result-finding targets, metric context and reference targets that descriptors cannot express.

## Type settings

- Path pattern: `*/campaign`
- Resource URI scheme: none
- Requires a `# Schema` section: no
- Schema columns: none
- Document ID prefix: `CMP`

## Frontmatter rules

Every rule below is the effective rule for a concept of type `Campaign`:
the profile-wide rule and this type's own rule, already merged.

### Required

#### `announcement` — required when `purpose` is `announcement`

Announced features and intended availability.

- Allowed values: any
- Cardinality: object
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: applies only when `purpose` is `announcement`
- Object fields:
    - `featureRefs` — required; allowed values: any; cardinality: list; format: none; reference: local handles with prefix `CMP`; external URIs with scheme `mori`; local handles prohibited; self-reference not allowed; external URI whole-value pattern `mori://[^/]+/[^/]+/okf/[^/]+/concepts/FEAT-[1-9][0-9]*` — Canonical URIs of the announced Features.
    - `liveBy` — required; allowed values: any; cardinality: scalar; format: rfc3339-utc — Intended availability deadline.
- Element fields: none

#### `campaignId` — required

Bundle-scoped stable CMP-N handle.

- Allowed values: any
- Cardinality: scalar
- Format: document-handle(CMP)
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `cancellationReason` — required when `status` is `cancelled`

Why the campaign was cancelled.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: applies only when `status` is `cancelled`
- Object fields: none
- Element fields: none

#### `description` — required

One sentence describing the concept.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `engagement` — required when `purpose` is `engagement`

Behavior this campaign seeks and why.

- Allowed values: any
- Cardinality: object
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: applies only when `purpose` is `engagement`
- Object fields:
    - `behavior` — required; allowed values: any; cardinality: scalar; format: none — The behavior to encourage.
    - `why` — required; allowed values: any; cardinality: scalar; format: none — Why the behavior matters.
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

#### `hypothesis` — required when `purpose` is `hypothesis`

The problem, belief, prediction, and falsification condition.

- Allowed values: any
- Cardinality: object
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: applies only when `purpose` is `hypothesis`
- Object fields:
    - `belief` — required; allowed values: any; cardinality: scalar; format: none — The causal belief being tested.
    - `falsifiedIf` — required; allowed values: any; cardinality: scalar; format: none — The observation that would falsify the belief.
    - `prediction` — required; allowed values: any; cardinality: scalar; format: none — The observable result expected if the belief holds.
    - `problem` — required; allowed values: any; cardinality: scalar; format: none — The observed problem being addressed.
- Element fields: none

#### `owners` — required

Actors or canonical Mori URIs accountable for the campaign.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `purpose` — required

Primary purpose of the coordinated campaign.

- Allowed values: `hypothesis`, `announcement`, `engagement`
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `readout` — required when `status` is `read-out`

Decision and research findings evaluating the campaign.

- Allowed values: any
- Cardinality: object
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: applies only when `status` is `read-out`
- Object fields:
    - `decision` — required; allowed values: any; cardinality: scalar; format: none — Decision taken in light of the findings.
    - `findingRefs` — required; allowed values: any; cardinality: list; format: none; reference: local handles with prefix `CMP`; external URIs with scheme `mori`; local handles prohibited; self-reference not allowed; external URI whole-value pattern `mori://[^/]+/[^/]+/okf/[^/]+/concepts/PR-[1-9][0-9]*` — Canonical result Finding URIs.
- Element fields: none

#### `status` — required

Campaign coordination lifecycle.

- Allowed values: `drafting`, `in-review`, `approved`, `sending`, `measuring`, `read-out`, `cancelled`
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `title` — required

Human-readable concept title.

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

The declared concept type.

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

#### `audience` — optional

Inline audience definitions for a corpus without a Segment bundle.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields:
    - `asOf` — required; allowed values: any; cardinality: scalar; format: rfc3339-utc — Time the population size describes.
    - `definition` — required; allowed values: any; cardinality: scalar; format: none — Queryable population definition.
    - `segment` — required; allowed values: any; cardinality: scalar; format: none — Segment name.
    - `size` — required; allowed values: any; cardinality: scalar; format: none — Population size at the stated time.

#### `audienceRefs` — optional

Canonical audience Segment URIs.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: local handles with prefix `CMP`; external URIs with scheme `mori`; local handles prohibited; self-reference not allowed; external URI whole-value pattern `mori://[^/]+/[^/]+/okf/[^/]+/concepts/SEG-[1-9][0-9]*`
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `chapters` — optional

Chapter labels in scope.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `jobRefs` — optional

Customer jobs this campaign serves.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: local handles with prefix `CMP`; external URIs with scheme `mori`; local handles prohibited; self-reference not allowed; external URI whole-value pattern `mori://[^/]+/[^/]+/okf/[^/]+/concepts/JOB-[1-9][0-9]*`
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `launchRef` — optional

Canonical Launch URI.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: local handles with prefix `CMP`; external URIs with scheme `mori`; local handles prohibited; self-reference not allowed; external URI whole-value pattern `mori://[^/]+/[^/]+/okf/[^/]+/concepts/LAUNCH-[1-9][0-9]*`
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `outcomeRefs` — optional

Named job outcomes this work is intended to move.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields:
    - `jobRef` — required; allowed values: any; cardinality: scalar; format: none; reference: local handles with prefix `CMP`; external URIs with scheme `mori`; local handles prohibited; self-reference not allowed; external URI whole-value pattern `mori://[^/]+/[^/]+/okf/[^/]+/concepts/JOB-[1-9][0-9]*` — Canonical job URI.
    - `outcomeName` — required; allowed values: any; cardinality: scalar; format: none — Name of an outcome declared by that job.

#### `primaryMetric` — optional

Primary evaluation metric; observed values belong in findings or claim checks.

- Allowed values: any
- Cardinality: object
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields:
    - `baseline` — optional; allowed values: any; cardinality: scalar; format: none — Numeric starting value; evidence, not a target.
    - `direction` — required; allowed values: `increase`, `decrease`, `maintain`; cardinality: scalar; format: none — Desired direction of change.
    - `method` — required; allowed values: any; cardinality: scalar; format: none — How the metric is obtained.
    - `metric` — required; allowed values: any; cardinality: scalar; format: none — What is counted or measured.
    - `name` — required; allowed values: any; cardinality: scalar; format: none — Stable name for this metric.
    - `period` — required; allowed values: any; cardinality: scalar; format: none — Observation period for the baseline.
    - `population` — required; allowed values: any; cardinality: scalar; format: none — Population described by the metric.
    - `unit` — required; allowed values: any; cardinality: scalar; format: none — Unit of measurement.
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

#### `secondaryPurposes` — optional

Additional purposes whose blocks also apply.

- Allowed values: `hypothesis`, `announcement`, `engagement`
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `sources` — optional

§5.1. What this content was derived from, one entry per source.

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

#### `studyRef` — optional

Canonical experiment Study URI.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: local handles with prefix `CMP`; external URIs with scheme `mori`; local handles prohibited; self-reference not allowed; external URI whole-value pattern `mori://[^/]+/[^/]+/okf/[^/]+/concepts/PR-[1-9][0-9]*`
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

#### `window` — optional

Campaign evaluation interval.

- Allowed values: any
- Cardinality: object
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields:
    - `from` — required; allowed values: any; cardinality: scalar; format: rfc3339-utc — Start of the evaluation window.
    - `to` — required; allowed values: any; cardinality: scalar; format: rfc3339-utc — End of the evaluation window.
- Element fields: none

