---
type: Bug Report
title: Rejection fixture
description: This report records no provenance for its own content.
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

`generated` is absent, so nothing says who produced this report or when.
