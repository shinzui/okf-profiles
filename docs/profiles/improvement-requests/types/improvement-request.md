---
type: OKF Profile Type
title: Improvement Request
description: A request whose implementation may span repository ownership boundaries.
generated:
  by: process:okf-profile-document
---

# Improvement Request

A request whose implementation may span repository ownership boundaries.

Declared by the [cross-repository-improvement-requests](/profile.md) profile.

## Type settings

- Path pattern: `*`
- Resource URI scheme: none
- Requires a `# Schema` section: no
- Schema columns: none
- Document ID prefix: `IR`

## Frontmatter rules

Every rule below is the effective rule for a concept of type `Improvement Request`:
the profile-wide rule and this type's own rule, already merged.

### Required

#### `completedAt` — required when `status` is `completed`

UTC time at which acceptance evidence proved the request complete.

- Allowed values: any
- Cardinality: scalar
- Format: rfc3339-utc
- Reference: none
- Path: none
- Unique by: none
- Condition: applies only when `status` is `completed`
- Object fields: none
- Element fields: none

#### `description` — required

Concise explanation of the problem and desired outcome.

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

§5.2. Who produced this request's current content, and when.

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

#### `origin` — required

Mori URI of the project or artifact raising the request.

- Allowed values: any
- Cardinality: scalar
- Format: uri-with-scheme(mori)
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `requestId` — required

Bundle-scoped stable IR-N handle.

- Allowed values: any
- Cardinality: scalar
- Format: document-handle(IR)
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `status` — required

Lifecycle decision for the request.

- Allowed values: `proposed`, `accepted`, `in-progress`, `completed`, `rejected`, `withdrawn`, `superseded`
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `supersededBy` — required when `status` is `superseded`

Later request that replaces this request.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: local handles with prefix `IR`; external URIs with scheme `mori`; local handles allowed; self-reference not allowed
- Path: none
- Unique by: none
- Condition: applies only when `status` is `superseded`
- Object fields: none
- Element fields: none

#### `title` — required

Short statement of the requested improvement.

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

The Improvement Request concept type.

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

#### `resolution` — recommended

Evidence or rationale recorded when a request reaches a terminal state.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: applies only when `status` is one of `completed`, `rejected`, `withdrawn`, `superseded`
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

#### `acceptanceCriteria` — optional

Stable request-local completion conditions, not tasks, dependencies, or evidence. Later evidence may cite a criterion id without rewriting the condition it proves.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: `id`
- Condition: none
- Object fields: none
- Element fields:
    - `id` — required; allowed values: any; cardinality: scalar; format: document-handle(AC) — Stable request-local AC-N handle for this acceptance condition.
    - `statement` — required; allowed values: any; cardinality: scalar; format: none — Observable condition that must hold for the request to be complete.
    - `verification` — required; allowed values: any; cardinality: scalar; format: none — Expected procedure or evidence that will prove the condition, without claiming that evidence already exists.

#### `dependencies` — optional

Typed source relationships between improvement requests, not live operational blockers. `hard` gates source fulfillment on target fulfillment; `soft` informs or de-risks but never blocks by itself; `integration` allows independent implementation but gates source fulfillment on the named joint verification.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields:
    - `kind` — required; allowed values: `hard`, `soft`, `integration`; cardinality: scalar; format: none — Source relationship kind: `hard` gates fulfillment on the target; `soft` never blocks by itself; `integration` permits independent implementation but gates fulfillment on named joint verification.
    - `reason` — required; allowed values: any; cardinality: scalar; format: none — Concise non-empty explanation of why this source relationship exists.
    - `ref` — required; allowed values: any; cardinality: scalar; format: none; reference: local handles with prefix `IR`; external URIs with scheme `mori`; local handles prohibited; self-reference not allowed; external URI whole-value pattern `mori://[^/]+/[^/]+/okf/improvement-requests/concepts/IR-[1-9][0-9]*` — Canonical external Mori URI of the target improvement request; local IR-N handles are ambiguous across repositories.

#### `targetPlan` — optional

Repository-relative path or Mori URI of the implementation plan.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
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
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `verified` — optional

§5.2. Independent confirmations that this request is accurate. Mirror an approving `reviews` entry here.

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

