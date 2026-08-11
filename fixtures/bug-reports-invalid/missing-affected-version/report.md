---
type: Bug Report
title: Rejection fixture
description: This report never says which version it was observed in.
generated:
  by: human:nadeem
  at: "2026-08-11T00:00:00Z"
bugId: BUG-1
status: reported
severity: unusable
origin: mori://example/warehouse
affects: mori://example/platform
observed: The export exits without writing a file.
expected: The export writes the file, as the user guide's walkthrough shows.
reproduction:
  - Request a whole-file export to a writable destination.
  - Observe that no file appears there.
---

# Rejection fixture

`affectedVersion` is absent, so no reader can tell whether the defect applies to
the release they are on.
