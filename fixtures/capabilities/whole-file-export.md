---
type: Capability
title: Whole-file export
description: Export a dataset as one buffered file.
generated:
  by: human:nadeem
  at: "2026-08-08T00:00:00Z"
reviews:
  - kind: human
    reviewer: human:nadeem
    reviewed_at: "2026-08-08T00:10:00Z"
    document_timestamp: "2026-08-08T00:00:00Z"
    scope: content-and-metadata
    outcome: approved
    context: >-
      Verified each evidence entry resolves and states what it proves.
capabilityId: CAP-3
provider: mori://example/platform
status: deprecated
stability: stable
since: "0.9.0"
packages:
  - example-export
interface:
  - Example.Export.WholeFile
replacedBy:
  - CAP-1
evidence:
  - kind: test
    resource: test/WholeFileSpec.hs
    proves: A dataset exports as a single file.
---

# Whole-file export

Superseded by [CAP-1 — streaming export](streaming-export.md), which does not
buffer the whole result.
