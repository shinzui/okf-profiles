---
type: Bug Report
title: Rejection fixture
description: The contradicted capability is named by a bare handle.
generated:
  by: human:nadeem
  at: "2026-08-11T00:00:00Z"
bugId: BUG-1
status: reported
severity: unusable
origin: mori://example/warehouse
affects: mori://example/platform
affectedVersion: "1.2.0"
capability: CAP-2
observed: The export exits without writing a file.
expected: The export writes the file, as the resumable-export capability claims.
reproduction:
  - Request a whole-file export to a writable destination.
  - Observe that no file appears there.
---

# Rejection fixture

`CAP-2` is a handle in someone else's bundle. It resolves against nothing here,
so the key takes the Mori URI that addresses that bundle's concept.
