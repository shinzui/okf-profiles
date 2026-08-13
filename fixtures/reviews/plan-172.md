---
type: Review
title: Human review of the projection-store replacement plan
description: A person read the plan in full and asked for the rollback step to be written down before it is approved.
generated:
  by: human:nadeem
  at: "2026-08-13T10:30:00Z"
reviewId: REV-3
subject: mori://example/platform/plans/172-replace-the-projection-store
subjectKind: plan
reviewedSha: e93b7c0142fd8a65be3097c4d15a8f2b6047ce39
coverage: full
reviewedAt: "2026-08-13T10:25:00Z"
reviewerKind: human
reviewer: human:nadeem
outcome: changes-requested
dimensions:
  - design
  - operability
produced:
  - mori://example/platform/okf/improvement-requests/concepts/IR-9
---

# Human review of the projection-store replacement plan

This conforming fixture proves the human branch. `reviewerKind: human` demands
none of `provider`, `model`, or `effort` — a person has no serving provider — and
a record that carried them would be describing a review that did not happen.

`subject` needs no `component`: a plan has a Mori URI of its own, so the URI is
already the most specific identifier available and repeating the plan's name
would be duplication a reader has to keep in sync.

The plan lives in one repository and is reviewed against the commit that carries
it, so `repository` is absent: `subject` settles which repository `reviewedSha`
belongs to. A review of code in a project with several repositories would name
it.
