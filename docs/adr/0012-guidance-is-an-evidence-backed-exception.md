---
type: Architecture Decision Record
title: Guidance is an evidence-backed exception
description: Profile and type guidance stays absent by default and is added only as a minimal, narrowly scoped correction for a demonstrated authoring failure.
docId: ADR-12
status: Accepted
date: 2026-09-13
originatingPlan: docs/plans/10-adopt-okf-0-9-guidance-across-existing-catalog-profiles.md
generated:
  by: claude-code/claude-opus-5
  at: 2026-09-13T17:09:46Z
---

# Guidance is an evidence-backed exception

## Context

okf 0.9.0.0 adds an optional `guidance` field to a profile and to each of its type rules. Guidance
is Markdown advice on how to author a document. okf prints it in `okf profile show`, preserves it
in JSON inspection, and renders it into generated profile documentation, but never validates it
and never executes anything written in it. Profile-wide guidance applies to every type, and a
type's own guidance is added after it rather than replacing it. The semantics are owned upstream by
`mori://shinzui/okf/okf/adrs/concepts/ADR-19`, and the rendering order by
`mori://shinzui/okf/okf/adrs/concepts/ADR-6`.

This catalog already separates two kinds of profile content. Descriptions say what a profile,
type, or field is. Structured rules — presence lists, formats, paths, references — say what a
document must satisfy, and fixtures prove each rule is load-bearing
([ADR-9](0009-a-rejection-fixture-must-fail-for-exactly-one-reason.md)). Adopting the new schema
raised the question of whether every profile and type should also receive guidance.

An initial plan answered yes and treated guidance coverage as catalog completeness. That premise
was rejected. A model authoring a concept already has the structured rules, the descriptions, the
repository's evidence, and its task. Additional instructions do not merely add information: they
constrain how the model reasons, and because profile guidance is inherited by every type and type
guidance accumulates on top, unnecessary prose compounds. Broad checklists and restated field
descriptions can make output worse.

## Decision

Keep `guidance = None Text` as the catalog default. In v0.15.0 every one of the 13 exports and all
30 type rules leave guidance absent, and helper constructors inherit the default rather than
accepting guidance.

Treat guidance as an escape hatch, in the way an index hint in SQL corrects a demonstrated bad
query plan rather than forming part of every query. Absence needs no justification. An addition
must carry all of the following:

- observed, repeated, or otherwise compelling output evidence of a specific wrong authoring choice;
- a reason the structured profile, its descriptions, repository evidence, and ordinary task
  context do not already make the correct choice reliably inferable;
- a correction that is stable for every consumer of the chosen scope, not local to one task;
- the smallest nudge that corrects it, placed at the narrowest scope — a single type rather than
  the profile unless the ambiguity is shared by every type; and
- an observable criterion for whether the hint improved the failure it targets.

Guidance never restates allowed values, required fields, path rules, descriptions, general best
practice, or a task-specific runbook, and it never carries a rule: anything a document must
satisfy belongs in a structured rule with a rejection fixture. A hint is reduced or removed once
the model, the schema, or the surrounding context can infer the behavior without it.

## Rationale

Keeping the three kinds of content apart keeps each honest. Descriptions stay short because they
render into every generated page and validation message. Rules stay enforceable because they are
tested. Guidance stays rare because its only cost-free form is absence; every sentence of it is
applied to every document it scopes, whether or not that document needed it.

Requiring evidence places the burden on the addition rather than on the absence. Without that
burden the field fills because it exists, and a catalog-wide coverage target turns an escape hatch
into a default prompt that no fixture can prove necessary.

## Consequences

Adopting the 0.9 schema changed no profile source and no generated page: okf omits absent guidance
from documentation, and the catalog's normalized JSON equals v0.14.0 once the new null members are
removed. The consumer-visible cost is a tool floor — a v0.15.0 descriptor needs `okf` 0.9.0.0 to
decode — rather than a corpus migration.

There is deliberately no permanent test counting guided profiles or types and no rejection
fixture for prose. When a hint is added, the generated-documentation drift check covers its
rendering, and its evidence and improvement criterion are recorded in the plan or decision that
introduces it.

A consumer that has its own evidence can add a local hint with `//` on the imported profile without
forking the shared value, subject to the same threshold.
