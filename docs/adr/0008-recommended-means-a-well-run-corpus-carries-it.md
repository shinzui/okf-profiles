---
type: Architecture Decision Record
title: Recommended means a well-run corpus actually carries it
description: A field whose absence is ordinary belongs in optional; recommended is reserved for fields whose absence is a real deficiency.
docId: ADR-8
status: Accepted
date: 2026-08-02
generated:
  by: human:nadeem
  at: "2026-08-02T00:00:00Z"
---

# Recommended means a well-run corpus actually carries it

## Context

okf has three presence classes. `required` is a hard error when absent.
`optional` is never reported when absent, in any mode, while every constraint the
rule declares still applies when the field is present. `recommended` sits between
them: absent is fine normally, and an **error** under `--strict`.

Before this release much of the catalog used `recommended` to mean "nice to
have". That reading breaks the moment a consumer turns on `--strict`, which this
release pushes them toward. The evidence was already in the wild: the
`adopt-architecture-decisions` blueprint shipped a consumer-side override
reclassifying `supersedes`, `supersededBy`, and `originatingPlan` from
`recommended` to `optional`, because essentially every real ADR corpus lacks all
three — a live decision that has never been superseded has nothing to record.
That override existed to work around a defect in this catalog, not to express a
consumer preference.

## Decision

**`recommended` is reserved for fields whose absence is a genuine deficiency in a
well-run corpus.** A field that a correct, complete document ordinarily lacks
belongs in `optional`, where its constraints still apply whenever it is present.

Applying the rule across the catalog moved these to `optional`:

| Profile | Moved to `optional` |
|---------|--------------------|
| `documentation.architectureDecisions` | `supersedes`, `supersededBy`, `originatingPlan` |
| `documentation.patternCatalog` | `sources`, `supersedes` |
| `documentation.researchDocuments` | `sources`, `supersedes`, `relatedPlans`, `relatedDecisions` |
| `coordination.improvementRequests` | `targetPlan` |
| `postgresql`, `tanPostgresql` | `timestamp` |

`reviews` is deliberately the only unconditional `recommended` field left in the
catalog, on `documentation.researchDocuments`,
`coordination.improvementRequests`, and `coordination.useCases`. A corpus that
records no review provenance at all *is* deficient, and `--strict` should say so.
`coordination.improvementRequests` also keeps a conditional `resolution`
recommendation, which only fires once a request reaches a terminal state — a
completed request with no resolution is a real gap; a proposed one is not.

## Rationale

The test is not "would we like this field?" but "does a document that is complete
and correct still lack it?" Provenance fields fail that test almost always:
supersession, originating plans, and related work are recorded when they exist
and are absent when they do not.

Leaving such a field `recommended` produces a `--strict` failure on a document
with nothing wrong with it, which teaches consumers to disable `--strict` or to
layer local overrides. Both outcomes lose more checking than the recommendation
ever bought.

Where the fixture, not the rule, was the deficient party, the fixture was brought
up to standard instead — a review entry was added to two fixture concepts rather
than demoting `reviews`. Demoting a rule to make a test green is the failure mode
this decision exists to prevent in the other direction.

## Consequences

Every reclassification here is a pure relaxation for a consumer: a corpus that
omitted those fields stops failing `--strict`, and one that carries them is
checked exactly as before, because `optional` still enforces formats and
reference rules.

A consumer carrying a local override that reclassifies any of the fields above
can now delete it. The `adopt-architecture-decisions` blueprint's shipped
descriptor did exactly that in v0.8.0 and is now a plain pinned import.

A new field added to any profile in this catalog must be classified by this test,
not by how important it feels.
