---
type: Review
title: Full review of the Order aggregate
description: Every path through the aggregate read at one commit, for correctness, security, and test coverage.
generated:
  by: process:example-agent
  at: "2026-08-12T09:40:00Z"
reviewId: REV-1
subject: mori://example/orders
subjectKind: aggregate
component: Orders.Domain.Order
repository: mori://example/orders/repos/orders
reviewedSha: 4c1f9b2e7a30d5c8e1b64f0a92d7c3518ae6b0d4
coverage: full
reviewedAt: "2026-08-12T09:38:00Z"
reviewerKind: model
reviewer: process:example-agent
provider: example-provider
model: example-model-5
effort: max
outcome: changes-requested
dimensions:
  - correctness
  - security
  - test-coverage
produced:
  - mori://example/orders/okf/bug-reports/concepts/BUG-4
context: >-
  Read the aggregate, its command handlers, and the projection it writes, with
  the package's test suite green at the reviewed commit.
verified:
  - by: human:nadeem
    at: "2026-08-12T16:05:00Z"
---

# Full review of the Order aggregate

This conforming fixture proves the first stable review handle and the shape of
the identity this profile is built around. `subject` is the project URI because
an aggregate has no Mori URI of its own, so `component` carries the identifier
the codebase uses — `Orders.Domain.Order`, the module path, not "the order
aggregate". The next review of this aggregate finds this record by matching the
pair, and starts from `reviewedSha`.

`coverage: full` says the whole aggregate was read at that commit, which is what
makes REV-2 able to read only what changed since. A record that recorded the
date alone would leave the next reviewer no honest starting point.

`dimensions` lists what was examined and nothing else: performance was not
looked at here, so it is absent rather than implied by an outcome. The one
finding worth acting on left as a bug report in the reviewed repository, and
`produced` links to it — the analysis belongs in this body, the defect belongs in
that corpus.

The `verified` entry is a person's second look, recorded the way OKF §5.2 and
§5.3 expect: `human:nadeem`, which is the prefix `okf trust` reads to report the
human-reviewed tier. `reviewer` is the harness that ran the review rather than
the model that ran inside it, so retargeting the agent at a newer model leaves
the actor stable and changes only `model`.
