---
type: OKF Profile Type
title: Capability
description: One thing this repository's code does today that a consumer can adopt
  and verify independently.
generated:
  by: process:okf-profile-document
---

# Capability

One thing this repository's code does today that a consumer can adopt and verify independently.

Declared by the [capabilities](/profile.md) profile.

## Type settings

- Path pattern: `*`
- Resource URI scheme: none
- Requires a `# Schema` section: no
- Schema columns: none
- Document ID prefix: `CAP`

## Frontmatter rules

Every rule below is the effective rule for a concept of type `Capability`:
the profile-wide rule and this type's own rule, already merged.

### Required

#### `capabilityId` — required

Bundle-scoped stable CAP-N handle.

- Allowed values: any
- Cardinality: scalar
- Format: document-handle(CAP)
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

#### `description` — required

One sentence a consumer can evaluate without reading the body.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

#### `evidence` — required

Artifacts proving this capability works today. A record with no evidence is an improvement request, not a capability.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields:
    - `kind` — required; allowed values: `test`, `conformance`, `example`, `benchmark`, `module`, `guide`; cardinality: scalar; format: none — What sort of proof this entry is.
    - `proves` — recommended; allowed values: any; cardinality: scalar; format: none — What a reader learns by opening it. Without this an evidence entry is a bare path.
    - `resource` — required; allowed values: any; cardinality: scalar; format: none — Repository-relative path, package target, module name, or absolute URL a reader can open.

#### `generated` — required

§5.2. Who produced this capability record's current content, and when.

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

#### `packages` — required

Packages, artifacts, or deployables a consumer depends on to get this capability.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

#### `provider` — required

Mori project URI that provides this capability. Redundant within one bundle, load-bearing once capabilities are aggregated across repositories.

- Allowed values: any
- Cardinality: scalar
- Format: uri-with-scheme(mori)
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

#### `replacedBy` — required when `status` is one of `deprecated`, `withdrawn`

Where a consumer should go instead. Demanded once `status` is `deprecated` or `withdrawn`.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: local handles with prefix `CAP`; external URIs with scheme `mori`; self-reference not allowed
- Path: none
- Condition: applies only when `status` is one of `deprecated`, `withdrawn`
- Object fields: none
- Element fields: none

#### `since` — required

Released version in which this first became available to a consumer. `unreleased` when it exists only on the default branch.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

#### `stability` — required

Compatibility promise. `experimental` may change without a major bump.

- Allowed values: `experimental`, `stable`
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

#### `status` — required

Whether a consumer can use this capability right now.

- Allowed values: `shipped`, `deprecated`, `withdrawn`
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

#### `title` — required

Human-readable capability name.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

#### `type` — required

The Capability concept type.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Condition: none
- Object fields: none
- Element fields: none

### Recommended

#### `interface` — recommended

Entry points a consumer actually touches: module names, endpoints, or commands.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Condition: none
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

#### `requires` — optional

Capabilities this one builds on, as local CAP-N handles or external Mori capability URIs. Mirror each entry as a body link so it becomes a graph edge.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: local handles with prefix `CAP`; external URIs with scheme `mori`; self-reference not allowed
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

