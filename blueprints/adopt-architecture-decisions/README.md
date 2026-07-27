# adopt-architecture-decisions

Agent-driven migration of an existing `docs/adr/` corpus to the shared OKF architecture-decision
profile. The blueprint adapts legacy metadata and numbering, registers the `adrs` Mori bundle, adds
strict profile enforcement to the repository's existing check surface, and verifies rename-stable
`mori://…/concepts/ADR-N` references.

Install the blueprint from this repository and run it in the target repository:

```bash
seihou agent run adopt-architecture-decisions
```

Pass a repository-specific prompt when local history or checks need extra guidance:

```bash
seihou agent run adopt-architecture-decisions \
  "Keep our supersession fields and wire validation into just docs-check."
```

This is intentionally a one-shot adoption blueprint. Seihou's `BlueprintMigration` edges are for
moving a library between explicit source and target versions; an existing ADR corpus has no such
version axis and should instead be inventoried and adapted from repository evidence.

Preview the complete rendered prompt without changing the target:

```bash
seihou agent --debug run adopt-architecture-decisions
```
