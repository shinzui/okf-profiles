---
name: "tech-docs-tutorial"
description: "Write a learning-oriented tutorial that teaches a newcomer by having them build something. Use when asked for a tutorial or lesson."
argument-hint: "<what the reader will build, and who they are>"
user-invocable: true
---

# Write a tutorial

A tutorial is a lesson. It gives a newcomer competence by having them do something, and the writer takes responsibility for that going well.

## Workflow

1. Read [WRITING-RULES.md](WRITING-RULES.md).
2. Confirm the form. Write one sentence stating the reader's need. If that need is not to learn by doing, hand back to `tech-docs`.
3. Discover the project's conventions, sample nearby pages for voice as `WRITING-RULES.md` directs, and choose the location. Use `docs/tutorials/` only when the project has no documentation layout of its own, and create only the directory the page needs.
4. Ground the content in source and execution. Build the thing yourself before you describe building it.
5. Draft by the rules below.
6. Verify, as described below.
7. Review the page against the listed failures.
8. Link the page from related pages.
9. Report what was verified, what was not, and which pages were sampled for voice, or that there were none.

## Rules

### Open the lesson

Make the title promise the concrete outcome, such as "Build a read-only key-value store in Go". Do not begin it with "How to", which belongs to how-to guides.

Use "we" throughout. Open with "In this tutorial, we will…". Never write "you will learn".

Answer in the first sentences whether the reader should care and whether this page is right for them.

Show the finished result early.

### Plan the path

Teach one thing. If other technologies are unavoidable, use the simplest option and leave production alternatives to the end.

Plan the sequence of topics before writing. Let difficulty rise gradually toward something tangible the reader built and can extend.

Leave the code in a working state after every step. Use stubs instead of unfinished code.

Minimise dependencies. As a rough guide, do not add one that saves fewer than 20 lines.

Keep demo interfaces free of styling.

### Guide the learner

Deliver visible results early and often. State the exact expected output after steps, and flag likely failures.

Sequence steps with "First, do x. Now, do y.". Introduce expected output with "The output should look something like…". Prompt checks with "Let's check…". Direct attention with "Notice that…".

Give brief, mild praise when the learner reaches a meaningful result.

Show behaviour with real output, a screenshot, or a small demo rather than describing it. Add a short quiz or interactive element only when the documentation platform supports one.

Offer no choices or alternatives. Keep a best-practice remark to one sentence with a link. Keep explanation minimal, and link out for the rest.

### Finish

End by proving that it works. Link the complete code when the project can host it. Never invent a link.

## Verify

Follow the page from a clean starting state exactly as written, without using anything you know that the page does not say. Every command must run, and every stated output must match.

## Listed failures

- Teaching by explaining.
- Presenting options.
- Steps that do not reliably produce the promised result.
- Drifting into a how-to guide.
