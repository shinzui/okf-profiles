---
type: Architecture Decision Record
title: Design work is three documents per surface, and implementation stays on features
description: A surface's design is a brief, a breadboard and a detailed design sharing one handle field and one decision space; jobs and features are referenced, implementation is tracked on features, and a house closes the viewer-axis names through a builder.
docId: ADR-19
status: Accepted
date: 2026-10-19
generated:
  by: claude-code/claude-fable-5-1
  at: 2026-10-19T20:20:00Z
---

# Design work is three documents per surface, and implementation stays on features

## Context

The product-discovery profiles ([ADR-17](0017-product-discovery-separates-jobs-research-features-and-scenarios.md))
say what a customer needs and what the product delivers. Nothing recorded how one page or
self-contained part of one gets from a need to a design: who looks at it, what each viewer gets,
and what it looks like. The `designs` profile was built and used as a local descriptor in a
product frontend repository, and is promoted here.

## Decision

**Three types per surface, one per question.** A `Design Brief` (`BRIEF-N`) says why and what:
viewers, the jobs they hold, the states the subject can be in, viewer and subject axes, scenarios
and success criteria. A `Breadboard` (`BB-N`) says how in structure: places, affordances,
connections and what each viewer gets. A `Detailed Design` (`DES-N`) says how in presentation:
affordance states, the artifacts and the handoff. They live at `<surface>/brief`,
`<surface>/breadboard` and `<surface>/design`, share the `designId` field, and each references
the one before it by a local handle only, never a URI: a surface's three documents are one
bundle's concern. A retired document's `supersededBy` is a local handle or a canonical concept
URI with the same prefix, because a replacement can live in another bundle.

**Implementation is not a fourth type or a status.** Delivery is owned by the
`coordination.features` that a breadboard's affordances name. An `implemented` status here would
copy that state.

**Jobs and features are referenced, never restated.** A brief names canonical jobs and their
outcomes by Mori URI under short local names; affordances name features. Every such reference is
external only, as ADR-17 requires.

**A brief's scenarios are not use cases.** A use case is a product scenario tying jobs and
features together across surfaces. A brief scenario is one viewer in one subject state arriving at
one surface with concrete data, the fixture a design is drawn and checked against. A brief may
name the use cases it realises.

**Decisions and questions are shared across a surface's documents.** `D-N` and `Q-N` are unique
across the three, and each entry lives in the document whose phase settles it.

**Viewer-axis names are a house choice.** Every brief answers each viewer axis, which only works
when the names are fixed for a product. `coordination.designs` leaves them open;
`coordination.designsFor { viewerAxisNames }` builds the same profile with a closed list. It is a
function, so registries skip it and a house calls it from its local descriptor.

**Approval is `verified`.** `validated` and `designed` require `verified`, mirrored from the
approving `reviews` entry (ADR-4). A detailed design records its chosen direction in
`decisions` from `chosen` on, because that is what `chosen` means.

**Type guidance is held to ADR-18's three kinds, sentence by sentence.** On each type, the
sentence naming the status steps and who signs them off is lifecycle meaning. The sentences
beginning "okf checks the shapes" on a brief and a breadboard, and "By `designed`" on a detailed
design, are checks the descriptor cannot express: cross-document references and scenario coverage
that the author verifies by reading. The sentences naming body content — **Problem** and its
siblings on a brief, **ordering rules** on a breadboard, `## Design handoff` on a detailed design —
say where prose belongs. Nothing else is in the guidance; a sentence that fits none of the kinds is
deleted ([ADR-18](0018-guidance-carries-what-rules-and-descriptions-cannot.md)).

## Rejected alternatives

- **One design document with phases as statuses.** The original local profile did this. Each
  phase's fields were required at a different status, and the document mixed why, structure and
  presentation, so a later phase reopened earlier decisions.
- **A closed list of viewer axes in the shared profile.** The original's names were one product's
  attributes; no list fits every product.
- **Viewer and visibility as cross-checked references.** okf checks one concept's frontmatter; the
  cross-document invariants are stated in guidance until okf or Mori can check them.

## Consequences

A house with a local designs descriptor replaces it with `coordination.designs`, or with
`coordination.designsFor` and its axis names, and moves house-specific guidance (tools, skills,
named approvers) onto its profile with `//`. Existing documents validate unchanged except that
`decisions`, `openQuestions` and `subjectAxes` are optional rather than recommended (ADR-8), which
only relaxes `--strict`; a detailed design at `chosen` or `designed` must carry `decisions`;
decision and question ids must be `D-N` and `Q-N` handles; `brief` and `breadboard` must be local
handles; and an external `supersededBy` must be a concept URI with the same prefix.
