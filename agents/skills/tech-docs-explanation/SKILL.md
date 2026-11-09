---
name: "tech-docs-explanation"
description: "Write a discussion explaining why something works the way it does, covering design decisions, context, and trade-offs. Use when asked to explain concepts or architecture in prose."
argument-hint: "<the question or topic to discuss>"
user-invocable: true
---

# Write an explanation

An explanation is a discussion that deepens understanding. It is read away from the work.

## Workflow

1. Read [WRITING-RULES.md](WRITING-RULES.md).
2. Confirm the form. Write one sentence stating the reader's need. If that need is not to understand something after stepping away from the work, hand back to `tech-docs`.
3. Discover the project's conventions, sample nearby pages for voice as `WRITING-RULES.md` directs, and choose the location. Use `docs/explanation/` only when the project has no documentation layout of its own, and create only the directory the page needs.
4. Ground the content in source and execution.
5. Draft by the rules below.
6. Verify, as described below.
7. Review the page against the listed failures.
8. Link the page from related pages.
9. Report what was verified, what was not, and which pages were sampled for voice, or that there were none.

## Rules

Bound the page by a stated "why" question or a drawn perimeter. Title it with an implicit "About", such as "About connection policies".

Cover context, history, design decisions, constraints, trade-offs, and alternatives. Make connections to neighbouring ideas.

Allow opinions when reasons are given and counter-arguments acknowledged, using forms such as "W is better than z, because…" and "Some users prefer w. This can be a good approach, but…".

Give history and analogy in forms such as "The reason for x is because historically, y…" and "An x in system y is analogous to a w in system z. However…".

Use diagrams where they explain better than text, and keep code snippets basic.

Be matter-of-fact about limitations.

## Verify

Where the page's claims rest on code, verify them in the source. Where they rest on history, verify them against the project's commits, plans, or decision records, and mark anything you could not confirm.

## Listed failures

- No boundary.
- Steps or specifications creeping in.
- Explanation scattered across other pages and left unrecognised.
- Advertising.
