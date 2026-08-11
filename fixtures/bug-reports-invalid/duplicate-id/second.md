---
type: Bug Report
title: Second rejection fixture
description: Two reports claim the same handle.
generated:
  by: human:nadeem
  at: "2026-08-11T00:01:00Z"
bugId: BUG-1
status: reported
severity: degraded
origin: mori://example/ledger
affects: mori://example/platform
affectedVersion: "1.2.0"
observed: The export writes the file to the wrong directory.
expected: The export writes the file to the requested destination.
reproduction:
  - Request a whole-file export to a nested destination.
  - Observe the file at the parent directory instead.
---

# Second rejection fixture

This report and its sibling both claim `BUG-1`, so neither handle is stable.
