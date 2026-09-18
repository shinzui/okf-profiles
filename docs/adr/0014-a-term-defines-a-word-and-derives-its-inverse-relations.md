---
type: Architecture Decision Record
title: A term defines a word, and its inverse relations are derived
description: Project vocabulary gets its own terminology profile with TERM-N handles; narrower is never authored, sameAs is external only, and corpus-wide checks belong to a consumer gate.
docId: ADR-14
status: Accepted
date: 2026-09-18
generated:
  by: anthropic/claude-opus-5
  at: 2026-09-18T00:00:00Z
---

# A term defines a word, and its inverse relations are derived

## Context

A project's precise vocabulary lives as prose spread across user guides and
decision records. Nothing tells an author or an agent which wording to use, which
wording is retired, or that a word in one project means the same thing as a word
in another. The only structured vocabulary in the fleet was a Domain-Driven Design
glossary, which infrastructure libraries have no domain model to attach to.

IR-6 in this repository's improvement-request bundle asked for a profile. Every
existing profile describes behavior or judgment: a decision, an obligation, a
reusable solution, a provision claim, or a page for readers. A term does neither.
It defines a word and points to where the behavior is described.

## Decision

**`documentation.terminology` is a new profile with one type, `Term`, and
bundle-scoped `TERM-N` handles.** `status` is a house vocabulary, `current` or
`deprecated`, per ADR-1; a deprecated term must name `replacedBy`.

Three shape rules follow from treating the catalog as a controlled vocabulary
rather than a graph store:

- **`narrower` is not a field.** Consumers derive it as the inverse of `broader`.
  Authoring both directions creates two sources of truth that drift.
- **`sameAs` is external only.** A local `sameAs` is rejected: an equivalent
  inside one bundle is an alias, not a second term.
- **No body/frontmatter mirror rule.** The typed fields carry the edges; okf
  cannot enforce a mirror, and the capabilities profile shows how much such a rule
  costs to author.

Checks that need the whole corpus, the repository, or the registry — that a
reference resolves to a `Term`, that `broader` has no cycle, that `replaces` and
`replacedBy` agree, that an anchor exists on disk, that discouraged wording is not
another term's canonical name — belong to a consumer gate, not the profile.

Nothing is recommended, per ADR-8.

## Consequences

The profile ships without an adoption blueprint, like `documentation.specifications`
in v0.16.0. The blueprint's central risk is fabricating vocabulary, and its shape
should be observed on a first real adoption before it is written.

A corpus that needs a broader ontology — arbitrary concept types, typed
properties, reasoning — is out of scope. Decisions, specifications, patterns,
capabilities, and guides keep their own profiles, and a term links to them.
