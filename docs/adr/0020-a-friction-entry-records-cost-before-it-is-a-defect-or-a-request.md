---
type: Architecture Decision Record
title: A friction entry records cost before it is a defect or a request
description: The cost of doing work gets its own coordination profile with FRIC-N handles, an impact graded by what happened to the work, a mori origin and an any-URI affects, optional rather than recommended review provenance, and a triage status that names the bug report or request that took over.
docId: ADR-20
status: Accepted
date: 2026-10-21
generated:
  by: claude-code/claude-fable-5-1
  at: 2026-10-21T20:30:00Z
---

# A friction entry records cost before it is a defect or a request

## Context

The coordination family records what a consumer needs, what a producer provides, the gap
between them, and a provided claim that does not hold ([ADR-17](0017-product-discovery-separates-jobs-research-features-and-scenarios.md)
and the `coordination/package.dhall` header). Nothing recorded the cost of doing work: a guide
that omitted a step, a command whose help text did not match its behavior, a build tool that
needed a day of retries, a house process that asked the same question twice. Agents
implementing plans met this constantly and had nowhere to put it. A bug report demands a
reproduction and a contradicted claim the implementer often cannot name yet; an improvement
request demands an outcome nobody has stated; a plan's Surprises & Discoveries section holds
only what changed the plan. So the cost went into chat transcripts and was lost, and a surface's
owner never learned where it hurt across the repositories that consume it.

The planning skills published by `mori://shinzui/agent-seihou` wanted to write this down while
implementing and triage it at completion, and asked for a profile to write it against.

## Decision

**Friction gets its own profile, `coordination.frictionLog`, in front of bug reports and
requests.** A `Friction Entry` (`FRIC-N`) is one surface costing an implementer effort once. It
records what was attempted and what happened instead, and makes no claim about who is wrong.
Friction becomes a bug report once the recording repository can name the contradicted claim and
reproduce it, and an improvement request once someone can state the outcome; the entry's `status`
records that triage and `promotedTo` names what took over. The same surface costing effort again
under another plan is a second entry, because recurrence is the signal.

**`impact` is what happened to the work, graded by observation.** `blocked`, `detour`,
`slowdown` and `nuisance` are consequences, in that order; a `detour` is defined by its
`workaround`, which is therefore demanded. Priority is absent for the reason `bug-reports` gives.

**`kind` names the surface, never the cause.** `documentation`, `interface`, `tooling`,
`environment` and `process` let a surface's owner filter a corpus to what they own. Which of
them a cause turns out to be is what promotion records.

**`origin` is a Mori URI; `affects` is any absolute URI.** The two differ in exactly the case
the family exists for, a consumer recording friction with a dependency. `affects` is wider than
its siblings' because friction is often with a tool a house does not register; a registered
subject is always named canonically, and a house may narrow the format locally.

**`reviews` and `verified` are optional, not recommended.** This departs from
`coordination.bugReports` and `coordination.improvementRequests`, where ADR-8 kept `reviews`
recommended because a corpus with no review provenance is deficient. A friction entry is a
first-person observation that is correct the moment it is written; demanding review provenance on
every entry under `--strict` would price the log out of the habit it exists to create. Triage is
this family's quality gate, and it is recorded in `status`.

**`amended` keeps `generated` on the observer.** A status change at triage is a later change
that leaves the entry standing, recorded the way `documentation.architectureDecisions` records
one since v0.22.0.

**Nothing is recommended.** Every conditionally demanded field (`workaround`, `promotedTo`,
`duplicateOf`, `resolution`) is `required` with a `when`, so each is testable by a rejection
fixture without `--strict` and ADR-9's sweep covers all of them.

**The type carries two sentences of guidance, each one of ADR-18's kinds.** The first names what
moves an entry between statuses and that only the recording repository does so: lifecycle
meaning. The second names the body sections, `## Attempted` and `## Encountered`, that carry
content with no field: where prose belongs. Nothing else is in the guidance.

## Rejected alternatives

- **A section in each plan.** A plan is one repository's execution memory; a surface's owner
  cannot query it across consumers, and friction that did not change the plan has no section to
  go in.
- **One log document per plan, with a table of entries.** Entries would have no handles, so
  nothing could cite, promote, or deduplicate one, and a corpus could not be filtered by
  `affects`.
- **File bug reports or requests directly.** Both demand facts the implementer does not have
  while the friction is fresh. The cost of gathering them is why the friction was never written
  down before.
- **`affects` restricted to `mori://`.** Would make friction with an unregistered tool
  unrecordable, which is most third-party friction.
- **`reviews` recommended, for consistency.** Rejected for the reason above; consistency with
  the siblings is worth less than entries being written.

## Consequences

A repository adopts the profile with `okf profile init coordination.frictionLog` into
`docs/friction-log`, or whatever path its Mori declaration names, and validates it strictly like
any other bundle. The exec-plan and master-plan skills in `mori://shinzui/agent-seihou` bootstrap
that bundle on first use, write entries while implementing, and triage them at completion.

The family's queries are new: everything affecting one project across the repositories that
consume it, grouped by `kind` and `impact`, open entries first. Mori indexes the bundle like any
other; no new tooling is needed for the first adopters.

The profile ships without an adoption blueprint, because there is no existing corpus to adapt.
It ships without a `legacyTimestamp` rule, because no v0.1 friction corpus exists.
