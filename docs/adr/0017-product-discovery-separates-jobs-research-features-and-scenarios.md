---
type: Architecture Decision Record
title: Product discovery separates jobs, research, features, and scenarios
description: Customer jobs, product research, and features get their own profiles with stable handles linked by external-only references, existing profiles keep their schemas, and cross-bundle checks live in an interim opt-in gate whose rules are owned by okf or Mori.
docId: ADR-17
status: Accepted
date: 2026-10-16
originatingPlan: docs/plans/12-add-jobs-and-product-research-profiles-linked-to-use-cases.md
generated:
  by: claude-code/claude-opus-5-5
  at: 2026-10-16T14:45:00Z
---

# Product discovery separates jobs, research, features, and scenarios

## Context

Before this decision a customer job and a product feature existed only as records
embedded in a use case. The same feature could not appear in two scenarios without
two copies of its delivery state, and nothing could cite a job or a feature from a
request, a bug, or a future product-management UI. The only research profile,
`documentation.researchDocuments`, records technical investigations about building
software; customer discovery had no home.

The catalog already had the producer side: a capability is a provision claim about
behavior that exists, and an improvement request is repository work that closes a gap.

## Decision

**Four concepts, four questions.** `coordination.jobs` (`JOB-N`) states the progress a
customer seeks, independent of any solution. `documentation.productResearch` (`PR-N`,
shared by `Product Research Study` and `Product Research Finding`) records how something
was learned and what was observed, keeping observation apart from interpretation.
`coordination.features` (`FEAT-N`) is one product behavior with its own delivery
lifecycle. `coordination.useCases` remains the scenario that ties them together, now
linking inline records to canonical ones (`jobs[].jobRef`, `jobs[].outcomeNames`,
`featureRefs`, `features[].featureRef`) and making inline `features` optional.
Technical research is unchanged and is never converted into product findings.

**Support is a declaration.** A job's `validationStatus` is backed by an explicit
`assessment` citing findings. It is never computed from finding stances, inferred from
`verified`, or changed by delivery. Delivery evidence shows implementation acceptance,
not customer outcome; a linked specification does not make a feature conform, and a
linked capability does not promote a feature's status.

**Link directions.** A feature names the capabilities that contribute behavior
(`capabilityRefs`) and the specifications that govern or are proposed to govern it
(`specificationRefs`). Neither link claims completeness, and neither profile on the
other side stores an inverse list. A request's `origin`, a bug's `affects`, and
`sources` on specifications and technical research reach product concepts through
their existing fields. Improvement requests, bug reports, specifications, technical
research, capabilities, transitions, runbooks, and standalone reviews keep their
schemas; only capability prose changed. Widening `assurance.reviews.subjectKind` to
product concepts is deferred; the inline `reviews` family covers review provenance.

**Criteria belong to their owner.** Feature `acceptanceCriteria` reuse the
improvement-request shape (`AC-N`, `statement`, `verification`). A criterion is
identified by its owner's URI plus its id, so a feature's `AC-1` and a request's `AC-1`
are unrelated.

**Every cross-profile reference is external only.** okf rejects a reference rule whose
`localPrefix` the profile does not declare, so each profile uses its own prefix with
`allowLocal = False` and an `externalUriPattern` naming the target prefix and accepting
any producer-chosen bundle name. Project URIs such as `owners` stay format-only. Self
references are rejected in descriptors with `allowSelf = False`.

**Cross-bundle checks are an interim consumer gate.** `scripts/check-product-discovery.py`
validates a manifest of bundles strictly and checks what descriptors cannot express. It
is opt-in, as ADR-14 places corpus-wide checks, and importing the profiles does not run
it. Each of its rules names an intended owner. A rule that reads one concept's
frontmatter is owned by okf, as a descriptor-language extension; a rule that follows a
reference is owned by Mori, as registry-backed resolution consistent with okf ADR-1
(`mori://shinzui/okf/okf/adrs/concepts/ADR-1`). The upstream requests are
`mori://shinzui/okf/okf/improvement-requests/concepts/IR-9` (descriptor features) and
`mori://shinzui/mori/okf/improvement-requests/concepts/IR-38` (reference resolution).
A rule is deleted from the checker when its owner ships equivalent support.

## Rejected alternatives

- **Widening `documentation.researchDocuments` for customer research.** Its lifecycle,
  handles, and readers differ; mixing them would make every query ask which kind of
  research a record is.
- **Keeping jobs and features inline only.** Reuse across scenarios and stable citation
  are the point of the change.
- **Making the checker the permanent gate, or deferring every check upstream with
  nothing enforcing meanwhile.** The first entrenches a Python manifest where the
  registry should answer; the second ships unenforced relationships.
- **Planned capability records.** A capability that does not exist yet remains an
  improvement request.

## Consequences

Existing use-case corpora keep validating. A corpus that relied on `features` being
required to catch an omission now needs the checker's `delivery-stage-features` rule,
because okf cannot express "inline features or `featureRefs`" for delivery-stage use
cases. The checker's success summary names what it leaves unresolved: owner and
request URIs, generic sources, related use cases, capability `requires`, and
specification supersession.

A wrong-type target is unreachable for CAP, SPEC, JOB, and FEAT in strictly valid
bundles, because each pattern fixes the prefix and each prefix belongs to one type
(or to the two allowed specification types). The type check matters where a prefix is
shared, as `PR-N` is by studies and findings, and any future relation-to-type table
must not infer types from prefixes alone.
