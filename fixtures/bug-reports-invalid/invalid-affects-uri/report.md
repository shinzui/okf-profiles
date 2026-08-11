---
type: Bug Report
title: Rejection fixture
description: The defective project is named by a bare package name.
generated:
  by: human:nadeem
  at: "2026-08-11T00:00:00Z"
bugId: BUG-1
status: reported
severity: unusable
origin: mori://example/warehouse
affects: example-export
affectedVersion: "1.2.0"
observed: The export exits without writing a file.
expected: The export writes the file, as the user guide's walkthrough shows.
reproduction:
  - Request a whole-file export to a writable destination.
  - Observe that no file appears there.
---

# Rejection fixture

`example-export` is a package name, which means something only to whoever already
knows the repository the report came from. Routing a defect to its owner is the
whole job of this key.
