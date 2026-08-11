---
type: Bug Report
title: Rejection fixture
description: The bundle root declares no OKF dialect.
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
---

# Rejection fixture

The root `index.md` declares no `okf_version`, which this profile requires at 0.2
or later. The house convention is stricter than the format: §12 makes the
declaration a MAY.
