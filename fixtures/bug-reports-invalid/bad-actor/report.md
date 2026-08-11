---
type: Bug Report
title: Rejection fixture
description: This report is otherwise complete but its generated.by is a bare name.
generated:
  by: nadeem
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
---

# Rejection fixture

`nadeem` is none of `human:nadeem`, `process:nadeem`, or a `<producer>/<version>`
pair, so the OKF v0.2 §7 actor format rejects it.
