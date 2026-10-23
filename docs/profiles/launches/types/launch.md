---
type: OKF Profile Type
title: Launch
description: Coordinated go-live work with a deadline and explicit readiness conditions.
generated:
  by: process:okf-profile-document
---

# Launch

Coordinated go-live work with a deadline and explicit readiness conditions.

Declared by the [launches](/profile.md) profile.

## Guidance

### Type-specific

Readiness describes conditions and verification, not that they passed. Launched records a go-live event and evidence, not proof of customer outcome.

## Type settings

- Path pattern: `launches/*`
- Resource URI scheme: none
- Requires a `# Schema` section: no
- Schema columns: none
- Document ID prefix: `LAUNCH`

## Frontmatter rules

Every rule below is the effective rule for a concept of type `Launch`:
the profile-wide rule and this type's own rule, already merged.

### Required

#### `cancellationReason` — required when `status` is `cancelled`

Why the launch was cancelled.

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

#### `launchEvidence` — required when `status` is `launched`

Evidence of the actual launch, in the shared sources shape.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: applies only when `status` is `launched`
- Object fields: none
- Element fields:
    - `author` — optional; allowed values: any; cardinality: any; format: actor — §5.1. Who or what produced the source, per the §7 actor convention.
    - `id` — optional; allowed values: any; cardinality: any; format: none — §5.1. Short label for this entry, used to cite it from a footnote in the body.
    - `last_modified` — optional; allowed values: any; cardinality: any; format: date — §5.1. Calendar date the source itself last changed.
    - `resource` — required; allowed values: any; cardinality: any; format: none — §5.1. What the source is: a followable artifact, or a scope descriptor.
    - `title` — optional; allowed values: any; cardinality: any; format: none — §5.1. Human-readable name for the source.
    - `usage_count` — optional; allowed values: any; cardinality: scalar; format: non-negative-integer — §5.1. How many times the source was drawn on. A count, so never negative.

#### `launchId` — required

Bundle-scoped stable LAUNCH-N handle.

- Allowed values: any
- Cardinality: scalar
- Format: document-handle(LAUNCH)
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `launchedAt` — required when `status` is `launched`

Actual UTC launch time.

- Allowed values: any
- Cardinality: scalar
- Format: rfc3339-utc
- Reference: none
- Path: none
- Unique by: none
- Condition: applies only when `status` is `launched`
- Object fields: none
- Element fields: none

#### `liveBy` — required

Intended UTC go-live deadline.

- Allowed values: any
- Cardinality: scalar
- Format: rfc3339-utc
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `readiness` — required when `status` is one of `ready`, `launched`

Conditions for release and how each will be verified; not a pass declaration.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: `id`
- Condition: applies only when `status` is one of `ready`, `launched`
- Object fields: none
- Element fields:
    - `id` — required; allowed values: any; cardinality: scalar; format: document-handle(AC) — Launch-local AC-N condition handle.
    - `statement` — required; allowed values: any; cardinality: scalar; format: none — Observable readiness condition.
    - `verification` — required; allowed values: any; cardinality: scalar; format: none — Procedure or evidence that will verify the condition.

#### `status` — required

Launch coordination lifecycle.

- Allowed values: `planned`, `ready`, `launched`, `cancelled`
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

#### `campaignRefs` — optional

Launch campaigns.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: local handles with prefix `LAUNCH`; external URIs with scheme `mori`; local handles prohibited; self-reference not allowed; external URI whole-value pattern `mori://[^/]+/[^/]+/okf/[^/]+/concepts/CMP-[1-9][0-9]*`
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `chapters` — optional

Producer chapter labels in scope.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `featureRefs` — optional

Features in the launch.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: local handles with prefix `LAUNCH`; external URIs with scheme `mori`; local handles prohibited; self-reference not allowed; external URI whole-value pattern `mori://[^/]+/[^/]+/okf/[^/]+/concepts/FEAT-[1-9][0-9]*`
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `initiativeRef` — optional

Initiative coordinating the launch.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: local handles with prefix `LAUNCH`; external URIs with scheme `mori`; local handles prohibited; self-reference not allowed; external URI whole-value pattern `mori://[^/]+/[^/]+/okf/[^/]+/concepts/INIT-[1-9][0-9]*`
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `landingPageRefs` — optional

Related Landing Pages.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: local handles with prefix `LP`; external URIs with scheme `mori`; local handles allowed; self-reference not allowed; external URI whole-value pattern `mori://[^/]+/[^/]+/okf/[^/]+/concepts/LP-[1-9][0-9]*`
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

#### `segmentRefs` — optional

Segments addressed.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: local handles with prefix `LAUNCH`; external URIs with scheme `mori`; local handles prohibited; self-reference not allowed; external URI whole-value pattern `mori://[^/]+/[^/]+/okf/[^/]+/concepts/SEG-[1-9][0-9]*`
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

