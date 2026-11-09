---
type: Architecture Decision Record
title: The release history is published with the reference
description: The reader publishes the curated CHANGELOG.md as one explicitly selected page and attributes release notes to a profile only when they name its exact export.
docId: ADR-25
status: Accepted
date: 2026-11-09
generated:
  by: claude-code/claude-opus-5-5
  at: "2026-11-09T18:22:32Z"
---

# The release history is published with the reference

## Context

[ADR-23](0023-generated-reference-crosses-an-explicit-publication-boundary.md) limits
the publication selection to generated reference pages and requires a deliberate
change to publish anything else. Readers of a profile also need to know when and how
its contract changed. The authoritative account is the hand-written `CHANGELOG.md`,
which states what breaks for a governed corpus and how to migrate it. Generated pages
carry no history, and the installed reader has no Git access.

## Decision

Amend the ADR-23 boundary by exactly one document: the publication generator always
selects the root `CHANGELOG.md`, and fails when it is missing or is not a regular
file. No other hand-written page becomes eligible.

The reader parses the changelog when it loads the content selection. A top-level
bullet or paragraph belongs to a profile only when it names that profile's exact
export in backticks. Entries under `### Not included` are not attributed, because
they describe work that did not happen. Do not infer attribution from prose, directory
names, or Git history.

## Consequences

Each published release carries its own changelog in the immutable content snapshot,
and a profile's history needs no generator or Git access at request time. Notes that
apply to the whole catalog appear only on the full changelog page. A note that
describes one profile must name its export to appear on that profile's page.
