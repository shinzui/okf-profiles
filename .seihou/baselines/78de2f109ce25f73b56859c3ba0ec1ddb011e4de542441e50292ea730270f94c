---
name: "tech-docs-walkthrough"
description: "Write a code walkthrough that guides a reader through real source files along one thread, anchored to a specific revision and linked from the document it augments. Use when asked to walk through, tour, or trace code."
argument-hint: "<the code path to trace, and the document it augments>"
user-invocable: true
---

# Write a code walkthrough

A code walkthrough is a guided reading of real source code along one thread, written for someone who needs a working mental model in order to read or change that code.

It differs from a tutorial because the reader builds nothing, from a how-to guide because no task is performed, from reference because it is selective and ordered for comprehension, and from explanation because each point is anchored to specific code at a specific revision.

## Workflow

1. Read [WRITING-RULES.md](WRITING-RULES.md).
2. Confirm the form. Write one sentence stating the reader's need. If that need is not to build a mental model of specific code, hand back to `tech-docs`.
3. Discover the project's conventions, sample nearby pages for voice as `WRITING-RULES.md` directs, and choose the location. Use `docs/walkthroughs/` only when the project has no documentation layout of its own, and create only the directory the page needs.
4. Ground the content in source and execution. Trace the path before you write about it.
5. Draft by the rules below.
6. Verify, as described below.
7. Review the page against the listed failures.
8. Link the page from related pages, including its parent.
9. Report what was verified, what was not, and which pages were sampled for voice, or that there were none.

## Rules

### Frame the walkthrough

A walkthrough augments something. Name its parent document or task, link to the parent, and add a link from the parent back to the walkthrough. If there is no parent, ask the user for one. Do not repeat the parent's steps or specifications.

Answer one question, such as "What happens when a plan is created?", and state what is out of scope.

Near the top, state the intended reader, what they should already know, and the commit identifier or release the walkthrough was written against.

Begin with a short map of the files or stages involved, using a diagram when it helps.

Order the stops by execution or data flow, or by what makes the next stop understandable. Never order them by file.

### Write each stop

Give each stop these four parts.

1. A location, as a repository-relative path and a symbol name.
2. The smallest excerpt that makes the point.
3. What the code does and why it matters.
4. A transition to the next stop.

Keep excerpts verbatim. Mark any omission explicitly, for example with `// ...`. Never tidy or rename code in an excerpt.

Prefer path and symbol anchors, because they survive edits. Use line numbers only together with a pinned revision. Use a commit-pinned permalink when the project is hosted somewhere that supports one. Across repositories, use the project's canonical URI convention.

Explain what is not obvious from reading: invariants, error paths, ordering constraints, surprising decisions, and where a common change would be made. Do not narrate syntax.

### Finish

End by restating the mental model and pointing to related pages.

## Verify

Confirm every anchor against the stated revision. Compare every excerpt character by character with the source at that revision. Trace or run the path, so that behavioural claims are observed rather than inferred.

## Listed failures

- Touring files with no thread.
- Paraphrased code.
- Excerpts too long to read.
- Drifting into instructions.
- A walkthrough that nothing links to.
