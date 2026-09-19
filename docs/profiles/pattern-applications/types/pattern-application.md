---
type: OKF Profile Type
title: Pattern Application
description: One service's decision about one assessable catalog pattern.
generated:
  by: process:okf-profile-document
---

# Pattern Application

One service's decision about one assessable catalog pattern.

Declared by the [pattern-applications](/profile.md) profile.

## Type settings

- Path pattern: `*`
- Resource URI scheme: none
- Requires a `# Schema` section: no
- Schema columns: none
- Document ID prefix: `PA`

## Frontmatter rules

Every rule below is the effective rule for a concept of type `Pattern Application`:
the profile-wide rule and this type's own rule, already merged.

### Required

#### `applicationId` — required

Bundle-scoped stable PA-N handle.

- Allowed values: any
- Cardinality: scalar
- Format: document-handle(PA)
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `decision` — required

Whether the pattern governs this service: `applicable`, `not-applicable`, `exception`, or `needs-triage`.

- Allowed values: `applicable`, `not-applicable`, `exception`, `needs-triage`
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `description` — required

One sentence stating the decision and the pattern it concerns.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `exception` — required when `decision` is `exception`

Who accepted not meeting an applicable pattern, over what bounded scope, why, and what reopens the decision. Demanded once `decision` is `exception`.

- Allowed values: any
- Cardinality: object
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: applies only when `decision` is `exception`
- Object fields:
    - `authority` — required; allowed values: any; cardinality: scalar; format: human-actor — The human who accepted the exception, as an OKF §7 human actor such as `human:alice`.
    - `reason` — required; allowed values: any; cardinality: scalar; format: none — Why the service does not meet the pattern.
    - `reviewCondition` — required; allowed values: any; cardinality: scalar; format: none — The date or event that reopens this decision.
    - `scope` — required; allowed values: any; cardinality: scalar; format: none — Exactly which criteria, components, or situations the exception covers.
- Element fields: none

#### `generated` — required

§5.2. Who produced this application's current content, and when.

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

#### `pattern` — required

Canonical Mori URI of the assessable pattern, such as `mori://acme/patterns/okf/patterns/concepts/PAT-3`.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: local handles with prefix `PA`; external URIs with scheme `mori`; local handles prohibited; self-reference not allowed; external URI whole-value pattern `mori://[^/]+/[^/]+/okf/[^/]+/concepts/PAT-[1-9][0-9]*`
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `rationale` — required

Why this decision holds for this service.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `service` — required

Canonical Mori project URI of the service this decision governs, such as `mori://acme/billing`.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: local handles with prefix `PA`; external URIs with scheme `mori`; local handles prohibited; self-reference not allowed; external URI whole-value pattern `mori://[^/]+/[^/]+`
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `title` — required

Human-readable application title.

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

The Pattern Application concept type.

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

#### `checks` — optional

Bindings from a pattern criterion id to a check target this service defines and allow-lists. Never a command copied from the catalog.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: `criterion`
- Condition: none
- Object fields: none
- Element fields:
    - `criterion` — required; allowed values: any; cardinality: scalar; format: none — A criterion id declared by the applied pattern.
    - `target` — required; allowed values: any; cardinality: scalar; format: none — The name of a service-owned, allow-listed check target, such as a Kotei pipeline target.

#### `tags` — optional

Free classification tags.

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

§5.2. Independent confirmations that this decision is accurate.

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

