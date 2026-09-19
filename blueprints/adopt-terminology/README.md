# adopt-terminology

An adaptive Seihou blueprint that audits a project's vocabulary and authors a comprehensive
`docs/terminology` catalog for developers familiar with its domain but new to the project.

```bash
seihou agent run adopt-terminology
```

It works for first adoption, expansion of an incomplete glossary, and idempotent reconciliation.
Existing documentation is not required: public source, examples, and tests can establish vocabulary.
If no settled vocabulary exists after inspection, it completes without creating an empty bundle.

## What it produces

- Concept-first definitions with examples, important distinctions, and links to authoritative detail.
- Coverage across the project's supported features and reader journeys, including concepts absent
  from an existing glossary; unresolved and omitted candidates remain visible in the final report.
- Stable `TERM-N` handles, truthful provenance, evidence-backed aliases and relationships, and
  topic tags with a grouped index.
- A frozen `documentation.terminology` descriptor targeting v0.17.0, bundle logs, Mori discovery
  metadata when applicable, and repository-native validation.

The method comes from the first adoption in `mori://shinzui/keiro/okf/terminology`, where a separate
coverage audit exposed gaps that a readability rewrite alone missed. It transfers the method, not
that project's vocabulary or category list. See the shipped
[coverage review](files/coverage-review.md) for the audit rubric and acceptance scenarios, and the
[authoring reference](files/authoring-reference.md) for the contract.

## Running it

Use `okf` 0.9.0.0 or later, `dhall`, `git`, `rg`, and a tool-capable Seihou provider. Mori is used
for dependency lookup and existing project discovery; lack of its newer terminology command does
not justify adding a broken check. The new blueprint is in the working catalog until the next
release; its target contract is the already-released v0.17.0 profile. It has no migration edges.

Pass audience or project-specific guidance when useful:

```bash
seihou agent run adopt-terminology \
  "Assume familiarity with message queues; emphasize our delivery and recovery terminology."
```

The blueprint preserves valid handles and unrelated edits. It does not publish a release, commit,
push, or update shared registries without authorization. It does not invent vocabulary to reach a
term count or present author self-review as independent verification.

Validate the blueprint artifact with:

```bash
seihou validate-blueprint blueprints/adopt-terminology --lint
```

Seihou debug runs can still write `.seihou/manifest.json`; use a disposable checkout for behavioral
rehearsals. A lint result validates packaging, not the completeness of an agent-authored glossary.
