---
type: Bug Report
title: Rejection fixture
description: This report is otherwise complete but its verified.by is a bare name.
generated:
  by: human:nadeem
  at: "2026-08-11T00:00:00Z"
verified:
  by: nadeem
  at: "2026-08-11T00:05:00Z"
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
---

# Rejection fixture

`verified` is optional, so its absence is never reported — but the actor format
still applies to the value whenever the key is present.
