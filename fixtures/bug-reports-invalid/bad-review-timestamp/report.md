---
type: Bug Report
title: Rejection fixture
description: A review entry dates itself in prose.
generated:
  by: human:nadeem
  at: "2026-08-11T00:00:00Z"
bugId: BUG-1
status: reported
severity: unusable
origin: mori://example/warehouse
affects: mori://example/platform
affectedVersion: "1.2.0"
observed: The export exits without writing a file.
expected: The export writes the file, as the user guide's walkthrough shows.
reproduction:
  - Request a whole-file export to a writable destination.
  - Observe that no file appears there.
reviews:
  - kind: human
    reviewer: human:nadeem
    reviewed_at: "yesterday"
    document_timestamp: "2026-08-11T00:00:00Z"
    scope: content
    outcome: approved
    context: Profile rejection fixture.
---

# Rejection fixture

`reviews` is recommended, so its absence is only reported under `--strict` — but
every nested rule it declares applies to the entries whenever the key is present.
