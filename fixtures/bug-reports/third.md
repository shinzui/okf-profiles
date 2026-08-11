---
type: Bug Report
title: Resumed export duplicates rows for a consumer paging with a cursor
description: A second report of the replay defect, filed from a different consumer before the first was found.
generated:
  by: human:nadeem
  at: "2026-08-11T00:03:00Z"
bugId: BUG-3
status: duplicate
severity: data-loss
origin: mori://example/ledger
affects: mori://example/platform
affectedVersion: "1.2.0"
duplicateOf: BUG-1
resolution: Same defect and same reproduction as BUG-1, reached through the cursor API rather than the page API.
observed: Rows acknowledged before an interruption are inserted a second time when the consumer resumes from its stored cursor.
expected: A resumed export delivers each row exactly once, as the resumable-export capability claims.
reproduction:
  - Page an export with a stored cursor and acknowledge the first page.
  - Interrupt the consumer, then restart it from the stored cursor.
  - Observe duplicate rows for the acknowledged page in the destination table.
reviews:
  - kind: human
    reviewer: human:nadeem
    reviewed_at: "2026-08-11T00:04:00Z"
    document_timestamp: "2026-08-11T00:03:00Z"
    scope: content-and-metadata
    outcome: approved
    context: >-
      Compared against BUG-1 step by step before merging the two.
---

# Resumed export duplicates rows for a consumer paging with a cursor

This conforming fixture proves the local handle reference: `duplicateOf` resolves
[BUG-1](first.md) inside this bundle, and `allowSelf` is off, so a report cannot
duplicate itself. An external report would name a `mori://` URI here instead,
which okf accepts without resolving.

It exists as its own record rather than as an edit to BUG-1 because the two
arrived through different APIs from different consumers. Two reproductions are
two reports even where the cause turns out to be shared; merging them afterwards
is cheap, and this is what the merge looks like.
