---
name: "tech-docs"
description: "Decide what kind of technical documentation a reader needs and write or plan it. Use when asked to document something and the form is not yet clear, to plan a set of docs, or to improve an existing page."
argument-hint: "<what to document, and for whom>"
user-invocable: true
---

# Technical documentation

Work out what a reader needs, then write or plan the document that meets that need. Documents follow the Diátaxis framework by default, may step outside it when the project's needs call for that, and can be augmented with code walkthroughs.

Read [WRITING-RULES.md](WRITING-RULES.md). It applies to every document, in or out of the framework.

Work through the six parts below in order. If the user asks only which form you would use, report the form, the skill, and your reasons, and stop without writing files.

## 1. Identify the reader and their moment

Identify who will read the document and what they are trying to do at the moment they open it. If the request does not say and the answer would change the form, ask.

## 2. Survey the existing documentation

Determine the project's documentation layout, its conventions, and any generated reference.

If a generated page already covers the request, tell the user so and name the page. Generated output is changed through its generator, never by hand.

If the target directory is an Open Knowledge Format (OKF) bundle, keep its required frontmatter, and use the `author-okf-concept` skill (`mori://shinzui/okf-kit/skills/author-okf-concept`) when it is installed.

If the request is about stale documentation rather than authoring, send it to the project's `update-docs` skill or `docs-sync` workflow when one is installed. Those keep existing pages in step with code changes. This skill authors documents.

## 3. Classify with the compass

Ask two questions, first of the whole request and then, when doubt remains, of individual paragraphs.

1. Does the content inform *action*, meaning practical doing, or *cognition*, meaning thinking?
2. Does it serve the *acquisition* of skill, meaning study, or the *application* of skill, meaning work?

| | Acquisition (study) | Application (work) |
|---|---|---|
| **Action (doing)** | Tutorial: `tech-docs-tutorial` | How-to guide: `tech-docs-how-to` |
| **Cognition (thinking)** | Explanation: `tech-docs-explanation` | Reference: `tech-docs-reference` |

Two distinctions settle most doubts.

- A tutorial differs from a how-to guide as study differs from work. The difference is never basic against advanced. An advanced lesson is still a tutorial, and a simple task recipe is still a how-to guide.
- Reference differs from explanation by when it is read. Reference is consulted in the middle of a task. Explanation is read after stepping away from the work to think.

Hand off to the skill the compass selects, by invoking it by name.

## 4. Decide whether the request sits outside the framework

A README, changelog, release notes, migration guide, runbook, Architecture Decision Record, design document, or OKF concept has its own established form. Write it by the project's convention for that form plus [WRITING-RULES.md](WRITING-RULES.md).

Do not force such a document into one of the four types, and do not hand it to one of their skills. The compass may still be used section by section, for example to keep a README's installation steps short and link out for the rest.

## 5. Decide whether a walkthrough should augment the document

A code walkthrough is a guided reading of real source code along one thread, written by `tech-docs-walkthrough`. It is not one of the four Diátaxis types, and the compass does not select it.

Use it directly when the request is to walk through, tour, or trace code. A walkthrough always augments something, so identify its parent document or task, or ask the user for one.

Offer a walkthrough alongside another document when the reader must understand or change real code, or when the document's central claim rests on a specific code path. Do not add one by default.

A document and its walkthrough are separate pages that link to each other.

## 6. Handle compound work

A request spanning several needs becomes several linked pages, written one at a time. State which page is which form before writing the first.

A request to "document this project" gets a proposed list of pages, drawn from these reader questions.

- How do I set it up?
- How do I use it effectively?
- How do I solve a specific problem?
- How does it work?
- What can I look up?

Not every project needs every section. The user confirms the list before you write anything. Create no empty structure in advance.

To improve an existing page, work in a loop. Pick one piece no larger than a page. Assess which need it serves and how well it serves it. Choose the single next improvement, complete it, and repeat.
