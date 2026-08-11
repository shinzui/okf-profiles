---
type: Bug Report
title: Rejection fixture
description: A fixed report that never says which release carries the fix.
generated:
  by: human:nadeem
  at: "2026-08-11T00:00:00Z"
bugId: BUG-1
status: fixed
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

`status: fixed` with no `fixedVersion` tells a consumer their defect is someone
else's past without telling them where to go.
