---
type: Architecture Decision Record
title: A review is an artifact, not only an annotation
description: Review records get their own assurance family and do not splice the house reviews frontmatter key, because the document is the review.
docId: ADR-10
status: Accepted
date: 2026-08-13
generated:
  by: human:nadeem
  at: "2026-08-13T00:00:00Z"
---

# A review is an artifact, not only an annotation

## Context

The catalog already records reviews. `Profile/ReviewRule.dhall` defines the house
`reviews` frontmatter family — reviewer identity, kind, scope, outcome, evidence
context, and for a model review the serving provider, model identifier, and
reasoning effort — and four profiles carry it.

That family answers "was this document reviewed?". It cannot answer the question
a repository actually accumulates reviews to answer: *what has been examined, at
which commit, and from where does the next review start?* A `reviews` entry hangs
off the document it describes, so a review of an aggregate, a migration, or a
service has nowhere to live unless that thing happens to be a concept in an OKF
bundle — and code is not. Nor does the entry record a commit, so a corpus of them
can say a review happened on a Tuesday and not what was true when it did.

Adding a `subject` and a `reviewedSha` to `ReviewRule` was considered and
rejected: it would demand a commit of every document annotation in four profiles
that have no commit to give, and the shape it produces — one document's
frontmatter listing reviews of *other* things — has no reader.

## Decision

**A review record is a concept type of its own**, published as `assurance.reviews`
in a new `assurance` family, with `REV-N` handles. Three consequences are
load-bearing:

**The identity of what was reviewed is `subject` plus `component`.** `subject` is
a Mori URI — the most specific canonical artifact where one exists, the containing
project where it does not — and `component` carries the identifier the codebase
uses for the part when the URI names the container. `subjectKind` states which of
the two the pair names. Identity is matched, never inferred.

**`reviewedSha` is required and `coverage` says what was read at it.**
`coverage: incremental` demands `baseSha`, and `previousReview` is recommended
under `--strict` once it does.

**The profile does not splice `reviews`, alone in the catalog.** A review of a
review has no reader. A person who reads a model's review records it as an OKF
v0.2 `verified` entry under a `human:` actor, and a genuine second examination is
a second record naming the same subject.

The `effort` vocabulary moves to `Profile/ModelReview.dhall`, which both
`ReviewRule.dhall` and the new profile read, and gains `max`.

## Rationale

The two shapes are not competing spellings of one thing; they are the same
information at different scopes, and both scopes have real uses. An improvement
request that says who checked it wants an annotation. A team asking "when did
anyone last look at the Order aggregate, and how hard" wants a corpus.

`assurance` is a new family rather than a fifth coordination profile because the
coordination family states claims — what a consumer needs, what a producer
provides, where the two fail to meet — and a review states that someone checked.
Filing it under coordination would widen that family's meaning until it meant
"anything about work".

`coverage` exists because okf conditions a rule on a closed set of values and
cannot condition on the presence of one. Without it, `baseSha` could only be
optional, and a thorough review would be indistinguishable from a glance at a
diff — which are worth very different amounts to whoever reads the record next.

## Consequences

`assurance.reviews` declares neither a house `status` nor OKF v0.2's, departing
from [ADR-1](0001-house-status-diverges-from-okf-v0-2.md)'s rule that a profile
without a house vocabulary takes OKF's. A review is an event: it is not
redrafted, and a later review of the same subject supersedes it by existing.
`stale_after` is likewise absent, because a re-review policy belongs to the
repository being reviewed rather than to one record of having reviewed it. Both
are additive if that proves wrong — an `optional` rule is a pure relaxation.

Adding `max` to the shared `effort` vocabulary widens four existing profiles.
Widening a closed vocabulary is backward compatible in one direction only: a
corpus written against the older list stays valid, and a corpus using `max`
fails against a pin older than v0.11.0.

Two keys now record identity that okf cannot check. `component` is free text, so
two spellings of one component are two histories as far as any reader can tell;
`reviewedSha` is unconstrained, so a branch name written there validates cleanly
and rots. Both are stated in the profile and are the right place for a
repository-local check.
