---
type: OKF Profile Type
title: Design Brief
description: 'Why the surface exists and what it must achieve: the problem, who views
  it and for which jobs, the states the thing shown can be in, the outcomes it should
  move, the constraints, the scenarios it must work in, and the criteria it is judged
  by. No structure, no layout.'
generated:
  by: process:okf-profile-document
---

# Design Brief

Why the surface exists and what it must achieve: the problem, who views it and for which jobs, the states the thing shown can be in, the outcomes it should move, the constraints, the scenarios it must work in, and the criteria it is judged by. No structure, no layout.

Declared by the [designs](/profile.md) profile.

## Guidance

### Type-specific

The body carries what only prose can: **Problem**, **Who it's for**, **Non-goals**, **Constraints** (cite decisions), principles, tone, and the baseline data that shows which subject state is the common one.

okf checks the shapes, not the cross-references or the scenario coverage the `scenarios` description asks for. Read them: every `jobs[].viewers` and `scenarios[].viewer` is a declared viewer; every `scenarios[].state` a declared subject state; every `scenarios[].axes` entry a declared viewer or subject axis; every `scenarios[].jobs` entry a local job name; every `outcomeRefs[].jobRef` a `jobs[].jobRef`.

`draft` → `validated` when the surface's approver signs off.

## Type settings

- Path pattern: `*/brief`
- Resource URI scheme: none
- Requires a `# Schema` section: no
- Schema columns: none
- Document ID prefix: `BRIEF`

## Frontmatter rules

Every rule below is the effective rule for a concept of type `Design Brief`:
the profile-wide rule and this type's own rule, already merged.

### Required

#### `description` — required

One sentence: what this document settles.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `designId` — required

Bundle-scoped stable BRIEF-N handle.

- Allowed values: any
- Cardinality: scalar
- Format: document-handle(BRIEF)
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

#### `jobs` — required

The canonical jobs this surface serves, each under a short local name, and which viewers hold it. Where they arrive from is the breadboard's `connections`.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: `name`
- Condition: none
- Object fields: none
- Element fields:
    - `jobRef` — required; allowed values: any; cardinality: scalar; format: none; reference: local handles with prefix `BRIEF`; external URIs with scheme `mori`; local handles prohibited; self-reference not allowed; external URI whole-value pattern `mori://[^/]+/[^/]+/okf/[^/]+/concepts/JOB-[1-9][0-9]*` — Canonical Mori URI of the JOB concept.
    - `name` — required; allowed values: any; cardinality: scalar; format: none — Short local name used by scenarios and connections.
    - `viewers` — optional; allowed values: any; cardinality: list; format: none — Viewer names that hold this job.

#### `origin` — required

Mori project URI that owns the surface.

- Allowed values: any
- Cardinality: scalar
- Format: uri-with-scheme(mori)
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `outcomeRefs` — required when `status` is `validated`

The job outcomes this surface is meant to move — the desired outcomes, owned by the jobs.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: applies only when `status` is `validated`
- Object fields: none
- Element fields:
    - `jobRef` — required; allowed values: any; cardinality: scalar; format: none; reference: local handles with prefix `BRIEF`; external URIs with scheme `mori`; local handles prohibited; self-reference not allowed; external URI whole-value pattern `mori://[^/]+/[^/]+/okf/[^/]+/concepts/JOB-[1-9][0-9]*` — Canonical Mori URI of a job in `jobs`.
    - `outcomeName` — required; allowed values: any; cardinality: scalar; format: none — Name of an outcome declared by that job.

#### `scenarios` — required when `status` is `validated`

The situations the surface must work in, each with a concrete fixture: at least one per viewer × subject state, plus one for any axis that needs its own look. Later phases are checked against these.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: `id`
- Condition: applies only when `status` is `validated`
- Object fields: none
- Element fields:
    - `axes` — optional; allowed values: any; cardinality: list; format: none — Declared viewer and subject axes this scenario exercises.
    - `fixture` — required; allowed values: any; cardinality: scalar; format: none — Who is looking, what data exists and what is missing, and the entry point — never what the page shows.
    - `id` — required; allowed values: any; cardinality: scalar; format: none — Short handle such as S1; stable once given.
    - `jobs` — optional; allowed values: any; cardinality: list; format: none — Local job names this scenario exercises.
    - `state` — optional; allowed values: any; cardinality: scalar; format: none — A declared subject state.
    - `viewer` — required; allowed values: any; cardinality: scalar; format: none — A declared viewer name.

#### `status` — required

Workflow step. See the type guidance.

- Allowed values: `draft`, `validated`, `retired`
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `successCriteria` — required when `status` is `validated`

How the shipped surface is judged: observable conditions, each with how it will be checked. Implementation verifies these.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: `id`
- Condition: applies only when `status` is `validated`
- Object fields: none
- Element fields:
    - `id` — required; allowed values: any; cardinality: scalar; format: document-handle(SC) — Brief-local SC-N handle.
    - `statement` — required; allowed values: any; cardinality: scalar; format: none — Observable condition that must hold.
    - `verification` — required; allowed values: any; cardinality: scalar; format: none — Procedure or evidence that will prove it.

#### `supersededBy` — required when `status` is `retired`

Later document replacing this one.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: local handles with prefix `BRIEF`; external URIs with scheme `mori`; local handles allowed; self-reference not allowed; external URI whole-value pattern `mori://[^/]+/[^/]+/okf/[^/]+/concepts/BRIEF-[1-9][0-9]*`
- Path: none
- Unique by: none
- Condition: applies only when `status` is `retired`
- Object fields: none
- Element fields: none

#### `surface` — required

Route or component the surface is, e.g. /orders/[id].

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `title` — required

Human-readable title, usually the surface.

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

Design Brief, Breadboard or Detailed Design.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `verified` — required when `status` is `validated`

The approving review, mirrored from `reviews`.

- Allowed values: any
- Cardinality: any
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: applies only when `status` is `validated`
- Object fields:
    - `at` — recommended; allowed values: any; cardinality: any; format: rfc3339-utc — UTC RFC3339 timestamp, ending in `Z`, for when this happened.
    - `by` — required; allowed values: any; cardinality: any; format: actor — §7. The actor responsible: `<producer>/<version>`, `human:<id>`, or `process:<id>`.
- Element fields:
    - `at` — recommended; allowed values: any; cardinality: any; format: rfc3339-utc — UTC RFC3339 timestamp, ending in `Z`, for when this happened.
    - `by` — required; allowed values: any; cardinality: any; format: actor — §7. The actor responsible: `<producer>/<version>`, `human:<id>`, or `process:<id>`.

#### `viewerAxes` — required when `status` is `validated`

Attributes of the viewer that every surface must consider, each answered explicitly: does it change this surface, and why. `does-not-apply` with a reason is a complete answer; silence is not.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: `name`
- Condition: applies only when `status` is `validated`
- Object fields: none
- Element fields:
    - `applies` — required; allowed values: `applies`, `does-not-apply`, `open`; cardinality: scalar; format: none — Whether this axis changes the surface. Words, not booleans: YAML would read yes/no as true/false.
    - `because` — required; allowed values: any; cardinality: scalar; format: none — Why it applies or does not — the evidence, not the conclusion.
    - `name` — required; allowed values: any; cardinality: scalar; format: none — Which viewer attribute.
    - `rules` — optional; allowed values: any; cardinality: scalar; format: none — What changes when it applies, or which scenarios and open questions carry it.

#### `viewers` — required

The kinds of viewer this surface distinguishes, declared per brief. Every `viewer` value in this brief and in its breadboard must be one of these names.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: `name`
- Condition: none
- Object fields: none
- Element fields:
    - `computedFrom` — optional; allowed values: any; cardinality: scalar; format: none — How the app decides a viewer is this kind.
    - `definition` — required; allowed values: any; cardinality: scalar; format: none — Who this is, in one sentence.
    - `name` — required; allowed values: any; cardinality: scalar; format: none — Short identifier used by jobs, scenarios and visibility.

### Recommended

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

#### `decisions` — optional

Settled questions a later phase must not reopen. D-N ids are unique across the surface's three documents.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: `id`
- Condition: none
- Object fields: none
- Element fields:
    - `by` — optional; allowed values: any; cardinality: scalar; format: none — Who decided.
    - `date` — required; allowed values: any; cardinality: scalar; format: date — When it was decided.
    - `id` — required; allowed values: any; cardinality: scalar; format: document-handle(D) — D-N handle.
    - `statement` — required; allowed values: any; cardinality: scalar; format: none — The decision.

#### `openQuestions` — optional

Questions still open, each with an owner. Q-N ids are unique across the surface's three documents.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: `id`
- Condition: none
- Object fields: none
- Element fields:
    - `id` — required; allowed values: any; cardinality: scalar; format: document-handle(Q) — Q-N handle.
    - `owner` — required; allowed values: any; cardinality: scalar; format: none — Who answers it.
    - `question` — required; allowed values: any; cardinality: scalar; format: none — The question.

#### `subjectAxes` — optional

Attributes of the thing being viewed, or of the context, that modulate this surface: independent switches that combine freely, unlike subject states. Page-specific, so names are open.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: `name`
- Condition: none
- Object fields: none
- Element fields:
    - `applies` — required; allowed values: `applies`, `does-not-apply`, `open`; cardinality: scalar; format: none — Whether this axis changes the surface. Words, not booleans: YAML would read yes/no as true/false.
    - `because` — required; allowed values: any; cardinality: scalar; format: none — Why it applies — the evidence.
    - `name` — required; allowed values: any; cardinality: scalar; format: none — Which attribute of the subject or context.
    - `rules` — optional; allowed values: any; cardinality: scalar; format: none — What changes when it applies, or which scenarios and open questions carry it.

#### `subjectStates` — optional

The states the thing shown can be in, declared per brief — how much of a profile is filled in; open, shipped or cancelled for an order. Omit it when the subject has none, as on a form.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: `name`
- Condition: none
- Object fields: none
- Element fields:
    - `definition` — required; allowed values: any; cardinality: scalar; format: none — What the subject has in this state, in facts that can be checked against the data, in one sentence.
    - `name` — required; allowed values: any; cardinality: scalar; format: none — Short identifier used by scenarios.

#### `tags` — optional

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `useCases` — optional

Canonical Mori URIs of the use cases this surface realises.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: local handles with prefix `BRIEF`; external URIs with scheme `mori`; local handles prohibited; self-reference not allowed; external URI whole-value pattern `mori://[^/]+/[^/]+/okf/[^/]+/concepts/UC-[1-9][0-9]*`
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

