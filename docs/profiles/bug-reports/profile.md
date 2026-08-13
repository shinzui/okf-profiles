---
type: OKF Profile
title: bug-reports
description: 'Defect reports against behavior a repository already provides, with
  stable BUG handles, an observable severity scale, and a reproduction a reader can
  follow. Behavior that was never provided is an improvement request, not a bug. The
  house `reviews` family and OKF `verified` coexist: `reviews` records far more than
  `verified` can, so an approving `reviews` entry should also be mirrored into `verified`
  to keep the derived trust tier accurate.'
generated:
  by: process:okf-profile-document
---

# bug-reports

Defect reports against behavior a repository already provides, with stable BUG handles, an observable severity scale, and a reproduction a reader can follow. Behavior that was never provided is an improvement request, not a bug. The house `reviews` family and OKF `verified` coexist: `reviews` records far more than `verified` can, so an approving `reviews` entry should also be mirrored into `verified` to keep the derived trust tier accurate.

## Settings

- OKF version: `0.2`
- Required bundle version: `0.2`
- Unknown concept types: rejected
- Unknown frontmatter keys: allowed
- Document ID field: `bugId`

## Frontmatter rules

These rules apply to every concept in a bundle governed by this profile,
whatever its type. Each concept type's own page repeats them merged with that
type's rules, which is the form that actually applies.

### `affectedVersion` — required

Released version the defect was observed in; `unreleased` or `unknown` otherwise.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

### `affects` — required

Mori URI of the project or artifact whose behavior is wrong.

- Allowed values: any
- Cardinality: scalar
- Format: uri-with-scheme(mori)
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

### `bugId` — required

Bundle-scoped stable BUG-N handle.

- Allowed values: any
- Cardinality: scalar
- Format: document-handle(BUG)
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

### `capability` — optional

Mori URI of the capability whose provision claim this defect contradicts.

- Allowed values: any
- Cardinality: scalar
- Format: uri-with-scheme(mori)
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

### `description` — required

One sentence naming what is wrong, evaluable without the body.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

### `duplicateOf` — required when `status` is `duplicate`

The report this one duplicates, as a local BUG-N handle or an external Mori URI.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: local handles with prefix `BUG`; external URIs with scheme `mori`; self-reference not allowed
- Path: none
- Condition: applies only when `status` is `duplicate`
- Object fields: none
- Element fields: none

### `environment` — optional

Where the observation was made, when the defect does not reproduce everywhere.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

### `expected` — required

What should happen instead, and on whose authority — a guide, a capability, a test.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

### `fixedVersion` — required when `status` is `fixed`

Released version carrying the fix; `unreleased` while it is on the default branch only.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Condition: applies only when `status` is `fixed`
- Object fields: none
- Element fields: none

### `generated` — required

§5.2. Who produced this report's current content, and when.

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

### `lastWorkingVersion` — optional

Newest release where the behavior was correct. Its presence makes this a regression.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

### `observed` — required

What actually happens, stated as a fact.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

### `origin` — required

Mori URI of the project or artifact that observed the defect.

- Allowed values: any
- Cardinality: scalar
- Format: uri-with-scheme(mori)
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

### `reproduction` — required

Ordered steps a reader can follow to see it, one step per entry.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

### `resolution` — recommended

Why this report closed the way it did, recorded when it reaches a terminal status.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Condition: applies only when `status` is one of `fixed`, `wont-fix`, `duplicate`, `not-a-bug`, `cannot-reproduce`
- Object fields: none
- Element fields: none
- Checked only under `--strict`

### `reviews` — recommended

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
    - `effort` — required when `kind` is `model`; allowed values: `low`, `medium`, `high`, `xhigh`, `max`, `unspecified`; cardinality: scalar; format: none — Reasoning or thinking effort the review was run at.
    - `kind` — required; allowed values: `human`, `model`; cardinality: scalar; format: none — Whether a human or model performed the review.
    - `model` — required when `kind` is `model`; allowed values: any; cardinality: scalar; format: none — Most specific available model identifier.
    - `outcome` — required; allowed values: `approved`, `changes-requested`, `commented`; cardinality: scalar; format: none — Result recorded by the reviewer.
    - `provider` — required when `kind` is `model`; allowed values: any; cardinality: scalar; format: none — Serving provider for a model review.
    - `reviewed_at` — required; allowed values: any; cardinality: scalar; format: rfc3339-utc — UTC time at which the review completed.
    - `reviewer` — required; allowed values: any; cardinality: scalar; format: none — Stable identity of the reviewing person or agent.
    - `scope` — required; allowed values: `content`, `technical-accuracy`, `editorial`, `catalog-metadata`, `content-and-metadata`; cardinality: scalar; format: none — Aspect of the document covered by the review.
- Checked only under `--strict`

### `severity` — required

Observable consequence for a consumer, most severe first.

- Allowed values: `data-loss`, `unusable`, `degraded`, `cosmetic`
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

### `status` — required

Where this report has got to. `confirmed` means the owning repository reproduced it.

- Allowed values: `reported`, `confirmed`, `in-progress`, `fixed`, `wont-fix`, `duplicate`, `not-a-bug`, `cannot-reproduce`
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

### `title` — required

Short statement of the wrong behavior.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

### `type` — required

The Bug Report concept type.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

### `verified` — optional

§5.2. Independent confirmations that this report is accurate. Mirror an approving `reviews` entry here.

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

### `workaround` — recommended

What a consumer can do meanwhile. Demanded once `severity` is `degraded`.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Condition: applies only when `severity` is `degraded`
- Object fields: none
- Element fields: none
- Checked only under `--strict`

## Concept types

- [Bug Report](/types/bug-report.md) — One wrong behavior, in something this repository already provides, with one reproduction.
