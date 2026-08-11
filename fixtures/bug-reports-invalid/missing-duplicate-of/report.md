---
type: Bug Report
title: Rejection fixture
description: A duplicate report that never names what it duplicates.
generated:
  by: human:nadeem
  at: "2026-08-11T00:00:00Z"
bugId: BUG-1
status: duplicate
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

A duplicate with no forward path closes the second reporter's account of the
defect and gives them nothing to follow.
