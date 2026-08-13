---
type: OKF Profile
title: reviews
description: 'Records of an artifact having been reviewed: what was examined and under
  which stable identity, the commit it was examined at, who or which model examined
  it and at what effort, and what came of it. A finding worth acting on becomes a
  bug report or an improvement request; this corpus records the examination. A human
  who reads a model''s review records that as an OKF `verified` entry under a `human:`
  actor, which is what `okf trust` reads to report the human-reviewed tier.'
generated:
  by: process:okf-profile-document
---

# reviews

Records of an artifact having been reviewed: what was examined and under which stable identity, the commit it was examined at, who or which model examined it and at what effort, and what came of it. A finding worth acting on becomes a bug report or an improvement request; this corpus records the examination. A human who reads a model's review records that as an OKF `verified` entry under a `human:` actor, which is what `okf trust` reads to report the human-reviewed tier.

## Settings

- OKF version: `0.2`
- Required bundle version: `0.2`
- Unknown concept types: rejected
- Unknown frontmatter keys: allowed
- Document ID field: `reviewId`

## Frontmatter rules

These rules apply to every concept in a bundle governed by this profile,
whatever its type. Each concept type's own page repeats them merged with that
type's rules, which is the form that actually applies.

### `baseSha` — required when `coverage` is `incremental`

Commit the examined range starts after. Demanded once `coverage` is `incremental`.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Condition: applies only when `coverage` is `incremental`
- Object fields: none
- Element fields: none

### `component` — optional

Identifier the codebase uses for the part reviewed, when `subject` names the container. Never a prose description.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

### `context` — optional

What the reviewer could see and how the review was run, where it bounds the result.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

### `coverage` — required

Whether the whole subject was read at `reviewedSha`, or only the range since `baseSha`.

- Allowed values: `full`, `incremental`
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

### `description` — required

One sentence a reader can evaluate without opening the body.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

### `dimensions` — required

Concerns the review actually examined, one per entry. A concern nobody looked at is left off.

- Allowed values: `correctness`, `security`, `performance`, `design`, `test-coverage`, `documentation`, `operability`
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

### `effort` — required when `reviewerKind` is `model`

Reasoning or thinking effort the review was run at.

- Allowed values: `low`, `medium`, `high`, `xhigh`, `max`, `unspecified`
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Condition: applies only when `reviewerKind` is `model`
- Object fields: none
- Element fields: none

### `generated` — required

§5.2. Who produced this record's current content, and when. Not the review itself — see `reviewer` and `reviewedAt`.

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

### `model` — required when `reviewerKind` is `model`

Most specific available model identifier.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Condition: applies only when `reviewerKind` is `model`
- Object fields: none
- Element fields: none

### `outcome` — required

Result the reviewer recorded.

- Allowed values: `approved`, `changes-requested`, `commented`
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

### `previousReview` — recommended

The review this one continues from, as a local REV-N handle or an external Mori URI. Demanded once `coverage` is `incremental`.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: local handles with prefix `REV`; external URIs with scheme `mori`; self-reference not allowed
- Path: none
- Condition: applies only when `coverage` is `incremental`
- Object fields: none
- Element fields: none
- Checked only under `--strict`

### `produced` — optional

Mori URIs of records this review caused to exist: bug reports, improvement requests, plans.

- Allowed values: any
- Cardinality: list
- Format: uri-with-scheme(mori)
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

### `provider` — required when `reviewerKind` is `model`

Serving provider for a model review.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Condition: applies only when `reviewerKind` is `model`
- Object fields: none
- Element fields: none

### `repository` — optional

Mori URI of the repository `reviewedSha` belongs to, when `subject` alone does not settle it.

- Allowed values: any
- Cardinality: scalar
- Format: uri-with-scheme(mori)
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

### `reviewId` — required

Bundle-scoped stable REV-N handle.

- Allowed values: any
- Cardinality: scalar
- Format: document-handle(REV)
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

### `reviewedAt` — required

UTC time at which the review completed.

- Allowed values: any
- Cardinality: scalar
- Format: rfc3339-utc
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

### `reviewedSha` — required

Full 40-character commit SHA of the state reviewed. Never a branch or tag name, which move.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

### `reviewer` — required

§7 actor that performed the review: `human:<id>`, `process:<agent>`, or `<producer>/<version>`.

- Allowed values: any
- Cardinality: scalar
- Format: actor
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

### `reviewerKind` — required

Whether a person or a model performed the review. Gates the provider, model, and effort keys.

- Allowed values: `human`, `model`
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

### `subject` — required

Mori URI of what was reviewed: the most specific artifact that has one, else the project containing it.

- Allowed values: any
- Cardinality: scalar
- Format: uri-with-scheme(mori)
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

### `subjectKind` — required

What `subject` and `component` name, assigned by what was read.

- Allowed values: `project`, `component`, `aggregate`, `migration`, `plan`
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

### `title` — required

Short statement of what was reviewed and how it went.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

### `type` — required

The Review concept type.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

### `verified` — optional

§5.2. Independent confirmations that this review is sound. A person who read it records `by: human:<id>` here.

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

## Concept types

- [Review](/types/review.md) — One subject examined at one commit, for one named set of concerns.
