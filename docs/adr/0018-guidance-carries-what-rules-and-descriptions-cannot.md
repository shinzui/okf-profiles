---
type: Architecture Decision Record
title: Guidance carries what rules and descriptions cannot, and stays rare
description: Profile and type guidance is allowed for lifecycle meaning, checks the descriptor cannot express, and where prose belongs, and for nothing else; absence stays the default and every sentence must change what an author does.
docId: ADR-18
status: Accepted
date: 2026-10-19
supersedes:
  - ADR-12
generated:
  by: claude-code/claude-opus-5-5
  at: 2026-10-19T18:00:00Z
---

# Guidance carries what rules and descriptions cannot, and stays rare

## Context

[ADR-12](0012-guidance-is-an-evidence-backed-exception.md) admitted `guidance` only as a
correction for an observed, repeated authoring failure. Its reasons still hold: guidance is
unvalidated prose that changes how a model reasons, profile guidance is inherited by every type,
type guidance stacks on top, and a catalog that treats guidance as coverage turns an escape hatch
into a default prompt.

Its admission test did not hold. Some knowledge cannot be inferred from a descriptor by
construction, so waiting for failures means shipping a profile whose first authors get it wrong:

- **Lifecycle meaning.** A status vocabulary says which values exist, not what moves a document
  from one to the next or who signs it off.
- **Checks the descriptor cannot express.** okf checks one concept's frontmatter. Invariants
  across documents — a breadboard's viewers declared by its brief, every scenario drawn or matched
  — and checks delegated to another tool are invisible to an author who reads only the rules.
- **Where prose goes.** Some content has no field and belongs in the body, in named sections.

The catalog had already acted on this. `coordination.transitions` shipped profile guidance listing
the checks Mori performs and the profile engine cannot, and the README's claim that every export
leaves guidance absent was false.

## Decision

**Absence is still the default, and needs no justification.** A profile or type without guidance
is complete.

**Guidance may carry three kinds of content, and nothing else:**

1. what moves a document between statuses, and who or what signs that off;
2. a check the descriptor cannot express, stated as what the author must verify by reading or
   which tool verifies it; and
3. which body sections carry content that has no field.

**Guidance never carries:**

- anything a structured rule can express. Write the rule and its rejection fixture
  ([ADR-9](0009-a-rejection-fixture-must-fail-for-exactly-one-reason.md)) instead;
- a restatement of allowed values, required fields, formats, path rules or a field description;
- general writing advice, best practice, tone, or encouragement;
- a task runbook, a step-by-step procedure, or tool invocations beyond naming the tool that runs a
  delegated check; or
- a house's people, tools, skills or vocabulary in a shared profile. A house adds those locally
  with `//` on the imported profile.

**Every sentence must change what an author does.** The review test is deletion: remove the
sentence, and if an author holding the rules and descriptions would still do the right thing, the
sentence goes. Prefer one sentence over a paragraph and a type over the profile; profile-wide
guidance is for content every type shares.

**Guidance shrinks as tools grow.** When okf or Mori gains a check that guidance delegates, the
sentence naming it is deleted in the same release.

**The addition is argued where it lands.** The commit, plan or decision that adds or widens
guidance names which of the three kinds each sentence is. A reviewer rejects a sentence that fits
none of them.

## Rationale

ADR-12 put the burden on presence, which was right, but measured it with the wrong evidence. A
repeated failure proves a hint is needed after the damage; it cannot show that lifecycle meaning or
an unexpressed cross-document check is missing, because those are absent from every input the
author has. The three permitted kinds are exactly the knowledge no other part of a profile can
hold, which is what keeps guidance from duplicating descriptions or competing with rules.

The prohibitions matter more than the permissions. Guidance is applied to every document in its
scope whether or not the document needs it, so its cost is paid on every read. A profile that drifts
into advice, procedure or house conventions makes every consumer pay for one author's habits, and
because okf never validates it, nothing else will stop the drift. Treat each sentence as a standing
cost that must keep earning its place.

## Rejected alternatives

- **Keep ADR-12.** The catalog already contradicted it, and new profiles with real lifecycle and
  cross-document semantics would push that knowledge into header comments no author reads.
- **Guidance for every type, as coverage.** Rejected for ADR-12's reasons, which still stand.
- **Encode lifecycle meaning in descriptions.** Descriptions render into every validation message
  and must stay one line; a transition rule there makes diagnostics unreadable.

## Consequences

ADR-12 is superseded. `coordination.transitions` keeps its guidance: it states checks delegated to
Mori, which is the second permitted kind, and it should shrink as Mori and okf absorb them.
`coordination.designs` adds type guidance under this policy: lifecycle steps, cross-document checks
okf cannot run, and the body sections a brief and a breadboard carry.

There is still no test counting guided types and no fixture for prose; the generated-documentation
drift check covers the rendering. Review is the enforcement, which is why the burden of naming the
kind of every sentence sits on the change that adds it.
