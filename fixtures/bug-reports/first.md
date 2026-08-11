---
type: Bug Report
title: Resumed export replays the last acknowledged page
description: Resumption restarts at the last acknowledged page instead of after it, duplicating rows.
generated:
  by: human:nadeem
  at: "2026-08-11T00:00:00Z"
bugId: BUG-1
status: confirmed
severity: data-loss
origin: mori://example/warehouse
affects: mori://example/platform
affectedVersion: "1.2.0"
lastWorkingVersion: "1.1.0"
capability: mori://example/platform/okf/capabilities/concepts/CAP-2
observed: The first page after resumption is the page that was already acknowledged, so every acknowledged page is delivered twice.
expected: Resumption continues after the last acknowledged page. The resumable-export capability claims a consumer can resume an interrupted export from its last acknowledged page.
reproduction:
  - Start an export of a dataset large enough to span at least three pages.
  - Acknowledge page 1, then terminate the consumer before page 2 arrives.
  - Restart the consumer with the cursor returned by the acknowledgement.
  - Observe that the first page delivered is page 1 again.
reviews:
  - kind: human
    reviewer: human:nadeem
    reviewed_at: "2026-08-11T00:10:00Z"
    document_timestamp: "2026-08-11T00:00:00Z"
    scope: content-and-metadata
    outcome: approved
    context: >-
      Reproduced against the affected release before the report was filed.
---

# Resumed export replays the last acknowledged page

This conforming fixture proves the first stable bug handle and the shape of a
live report: a defect the owning repository has reproduced, graded by what it
does to a consumer rather than by how urgent it feels, and pointed at the
capability whose claim it contradicts.

It is `data-loss` rather than `unusable` because the export completes and the
consumer is given no signal that anything went wrong — the rows simply arrive
twice. An outage would be `unusable`, and it would be the milder of the two.

`lastWorkingVersion` is what makes this a regression: the behavior was correct in
1.1.0 and is wrong in 1.2.0. It carries no terminal fields, so neither
`fixedVersion` nor `resolution` is demanded of it under `--strict`.
