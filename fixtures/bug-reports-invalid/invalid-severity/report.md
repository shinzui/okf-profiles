---
type: Bug Report
title: Rejection fixture
description: This report grades severity by urgency rather than by consequence.
generated:
  by: human:nadeem
  at: "2026-08-11T00:00:00Z"
bugId: BUG-1
status: reported
severity: high
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

`high` is a priority. It says how much the reporter minds, not what happens to a
consumer, and it is not comparable across two repositories.
