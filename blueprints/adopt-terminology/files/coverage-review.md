# Coverage and editorial review

Use this matrix as working evidence and summarize it in the final report. Do not place audit
records inside the terminology bundle as fake `Term` concepts. An existing project audit location
may hold a durable report if appropriate; the glossary itself remains a vocabulary.

## Inventory independently of the existing glossary

| Surface to inspect when applicable | Questions that expose missing terms |
|---|---|
| README, getting started, architecture overview | Which words does a first-time reader need before the first example makes sense? |
| Public packages, modules, CLI commands, configuration | Which exposed features and concepts have no glossary coverage? Which names hide a distinct role? |
| Core domain model and data flow | What are the entities, identities, boundaries, decisions, inputs, outputs, and relationships? |
| Storage, delivery, and background processing | What persists? What can retry? Which position, cursor, receipt, or ordering concept does the user need? |
| Query and read interfaces | What is data versus update logic versus a public contract? What is current, available, or compatible? |
| Lifecycle, operations, and failure recovery | Which terms name states, transitions, rebuilds, cutovers, recovery units, or limits? |
| Evolution and compatibility | Which versions refer to payloads, behavior, schemas, physical instances, or public contracts? |
| Tooling and generated artifacts | What does the user author? What gets generated or preserved? Which user-facing compiler or DSL concepts precede supporting files? |
| Tests, examples, and accepted decisions | Do claimed meanings and guarantees match executable behavior and current decisions? |
| Dependencies and integration boundaries | Which meanings are inherited, locally specialized, overloaded, or externally owned? |

For each candidate, record:

```text
Name | Topic/journey | Evidence | Owner | Existing ID | Reader confusion | Disposition/reason
```

Do not turn every cell into a term. A supported subsystem needs either coverage or an explicit
reason it has no distinctive vocabulary. Give priority to project-specific meanings, consequential
distinctions, terms needed to understand other definitions, and named features absent altogether.
Generic background words need standalone entries only when discoverability or local usage warrants
them. An index of exported identifiers is not a concept inventory.

## Lessons from the first adoption

The observed adoption is `mori://shinzui/keiro/okf/terminology`; individual entries include
`mori://shinzui/keiro/okf/terminology/concepts/TERM-2` (event stream),
`mori://shinzui/keiro/okf/terminology/concepts/TERM-39` (query freshness), and
`mori://shinzui/keiro/okf/terminology/concepts/TERM-48` (implementation hole).

- Rewriting the initial 27 definitions improved readability but did not detect missing concepts.
  A separate audit found 37 additions. The count is an observation, never a target for another repo.
- Core runtime primitives were present while subscriptions, checkpoints, rebuild ownership,
  query freshness, and an entire work-queue feature were absent. Audit supported surfaces rather
  than only the existing index.
- Several entries began with Haskell signatures, SQL mechanics, or migration history. Replacing
  those openings with roles, examples, and links made them accessible to developers already
  familiar with event sourcing.
- Seven original entries concerned generated supporting files, while the model's registers,
  transitions, and implementation ownership were unexplained. Completeness requires balanced
  coverage of what users first encounter, not equal numbers in arbitrary categories.
- Familiar words had distinct local meanings: a stored stream versus an aggregate contract;
  immediate querying versus up-to-date results; a committed deduplicated effect versus an action
  executing only once. Avoid broad guarantees when a precise boundary matters.
- The shared profile already supplied `tags`, `scope`, `broader`, and `related`. Topic tags and a
  grouped index improved navigation without adding fields or pretending categories were concepts.
- Strict OKF validation passed while the installed Mori lacked `terms validate`. Detect available
  gates and report limitations instead of installing a known-broken verification command.

Do not import Keiro's names or topic list into unrelated projects. Transfer the audit and writing
method, and derive each definition from the consuming project's evidence.

## Acceptance scenarios

These scenarios describe behavioral checks for an operator evaluating the blueprint. Structural
blueprint lint and profile fixture tests cannot establish agent-run outcomes. Record which scenarios
were actually exercised; do not claim all passed merely because the instructions mention them.

| Scenario | Expected behavior and evidence |
|---|---|
| Empty or unsettled project | Inspect docs and source; where no settled vocabulary exists, create no files or manifest/tasks. Report the no-op evidence. |
| Mature project without a glossary | Derive terms from current guides, examples, APIs, and tests; lack of a glossary does not cause a no-op. |
| Partial implementation-heavy glossary | Preserve IDs, improve supported definitions, and independently audit for missing features and supporting concepts. |
| Already complete adoption | Repeat against unchanged evidence; Git diff, IDs, timestamps, log, index, manifest, and tasks stay unchanged. |
| Newly documented feature | Add only justified missing terms with fresh IDs; preserve existing content and classifications unless evidence changed. |
| Overloaded familiar word | Explain the local meaning and contrast it with likely prior knowledge; do not mark two distinct meanings as aliases. |
| Unresolved ownership or contradictory meaning | Report the affected candidate, preserve ambiguity, and complete independent supported work. |
| Upstream concept without published terminology | Use an evidence-backed owner link; never invent an external TERM handle or `sameAs` edge. |
| Retired wording or duplicate identity | Preserve deprecated records and succession; stop affected identity edits rather than silently renumbering or merging. |
| Multiple tags or existing scopes | Keep machine tags and context qualifiers distinct; list each term once under a deterministic primary navigation group. |
| Mori absent or lacking terminology commands | Complete available OKF and local checks, avoid adding an unavailable command, and explicitly report missing discovery/gate coverage. |
| Dirty worktree or different local profile | Preserve unrelated changes and the governing contract; do not overwrite or downgrade as an adoption shortcut. |

The final coverage report should name inspected surfaces, accepted and omitted candidates, unresolved
meanings, topic counts, and the most consequential distinctions. Separately report schema, link,
relation, discovery, editorial, and repeatability results. A catalog can validate structurally while
still being incomplete or incomprehensible.
