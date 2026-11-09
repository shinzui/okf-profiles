---
name: "tech-docs-reference"
description: "Write dry, complete technical reference for an API, CLI, configuration, or schema. Use when asked to document all options, parameters, commands, or fields."
argument-hint: "<the API, CLI, configuration, or schema to describe>"
user-invocable: true
---

# Write reference

Reference is dry, complete technical description, consulted during work. It describes, and only describes.

## Workflow

1. Read [WRITING-RULES.md](WRITING-RULES.md).
2. Confirm the form. Write one sentence stating the reader's need. If that need is not to look something up in the middle of a task, hand back to `tech-docs`.
3. Check whether the project generates this reference. If it does, do not hand-write a competing copy. Improve the generator's input or link to the output.
4. Discover the project's conventions, sample nearby pages for voice as `WRITING-RULES.md` directs, and choose the location. Use `docs/reference/` only when the project has no documentation layout of its own, and create only the directory the page needs.
5. Ground the content in source and execution.
6. Draft by the rules below.
7. Verify, as described below.
8. Review the page against the listed failures.
9. Link the page from related pages.
10. Report what was verified, what was not, and which pages were sampled for voice, or that there were none.

## Rules

Mirror the product's own structure, and use one consistent pattern on every entry.

Lead each entry with the simplest working usage. Then add titled sections for likely uses. Those sections are illustrations only, and never become instructions or rationale.

Tabulate arguments, properties, and return values with type, requiredness, default, and meaning. Move complex arguments to linked subsections.

Cover errors, limits, and unhappy paths.

Recommend one default approach by placing it first. Mention alternatives only in passing.

Warnings of the form "You must not apply b unless c" are permitted.

Link every mentioned item.

Use the familiar OpenAPI-style layout for REST APIs.

## Verify

Check every signature, default, and limit against the code, and exercise the examples.

## Listed failures

- Instruction or rationale creeping in.
- Opinion or marketing.
- Inconsistent entries.
- Undocumented error behaviour.
