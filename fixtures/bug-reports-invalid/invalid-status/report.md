---
type: Bug Report
title: Rejection fixture
description: This report closes with a status outside the vocabulary.
generated:
  by: human:nadeem
  at: "2026-08-11T00:00:00Z"
bugId: BUG-1
status: closed
severity: unusable
origin: mori://example/warehouse
affects: mori://example/platform
affectedVersion: "1.2.0"
observed: The export exits without writing a file.
expected: The export writes the file, as the user guide's walkthrough shows.
reproduction:
  - Request a whole-file export to a writable destination.
  - Observe that no file appears there.
---

# Rejection fixture

`closed` says a report stopped moving without saying why, which is the one thing
the five terminal statuses exist to record.
