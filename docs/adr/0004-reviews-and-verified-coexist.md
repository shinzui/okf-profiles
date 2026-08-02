---
type: Architecture Decision Record
title: The house reviews family and OKF verified coexist
description: Neither is a superset of the other, so both are declared and an approving review is mirrored into verified.
docId: ADR-4
status: Accepted
date: 2026-08-01
generated:
  by: human:nadeem
  at: "2026-08-01T00:00:00Z"
---

# The house reviews family and OKF verified coexist

## Context

`Profile/ReviewRule.dhall` defines a rich house review record shared by
`coordination.improvementRequests`, `coordination.useCases`, and
`documentation.researchDocuments`. Each entry carries reviewer identity, review
kind, review scope, outcome, evidence context, and — for a model review — serving
provider, model identifier, and reasoning effort.

OKF v0.2 §5.2 defines `verified`: a list of mappings, or one bare mapping, each
carrying `by` and `at`. okf derives a document's trust tier from it on every read.

The two overlap in intent and not in content.

## Decision

**Both are declared. Neither replaces the other.** `reviews` keeps its shape and
its presence class; `verified` is added to the `optional` list of every profile
in the catalog. Each affected profile's `description` states that an approving
`reviews` entry should be mirrored into `verified` so the derived trust tier is
accurate.

## Rationale

Neither is a superset. Deleting `reviews` would destroy information three
profiles already collect and that no `verified` entry can express. Omitting
`verified` would leave `okf trust` reporting every concept as `unverified` even
where a human read and approved it, because the tier is computed from `verified`
and from nothing else.

`verified` belongs in `optional` rather than `recommended`: OKF §11 forbids
treating a missing optional family as a deficiency, so demanding it would make
`--strict` complain about every genuinely unverified concept — which is most of
them, correctly.

## Consequences

A producer that records an approving review writes it twice, in two shapes. That
duplication is accepted as the cost of keeping both the detail and the derived
tier.

**Mirroring must preserve the actor kind.** OKF §5.3 makes the `human:` prefix
the sole discriminator between the machine-confirmed and human-reviewed trust
tiers, so:

| `reviews` entry | `verified.by` |
|-----------------|---------------|
| `kind: human`, `reviewer: nadeem` | `human:nadeem` |
| `kind: model`, `reviewer: example-agent` | `process:example-agent` |

Mirroring a model review under a `human:` actor overstates the tier. This is
easy to get wrong mechanically, so both Seihou blueprints state it explicitly and
`fixtures/improvement-requests/second.md` demonstrates the model case.

No profile declares a `trust` key. A document's trust tier is computed on every
read and is never written into a bundle; a document carrying `trust:` is carrying
an ordinary extension field that okf ignores. This follows okf ADR 8
(`mori://shinzui/okf` at `docs/adr/8-derived-not-stored-trust-and-credibility.md`;
artifact-level URI pending).
