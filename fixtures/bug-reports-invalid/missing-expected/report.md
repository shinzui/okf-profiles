---
type: Bug Report
title: Rejection fixture
description: This report says what happens but never says what should.
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
reproduction:
  - Request a whole-file export to a writable destination.
  - Observe that no file appears there.
---

# Rejection fixture

`expected` is absent, so nothing establishes that the observed behavior is wrong
rather than merely unwelcome.
