---
type: Capability
title: Streaming export
description: Export a dataset as a stream a consumer can page through.
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
capabilityId: CAP-1
provider: mori://example/platform
status: shipped
stability: stable
since: "1.2.0"
packages:
  - example-export
interface:
  - Example.Export
evidence:
  - kind: test
    resource: test/ExportSpec.hs
    proves: A dataset larger than memory exports without buffering the whole result.
  - kind: guide
    resource: docs/user/export.md
    proves: End-to-end walkthrough from request to paged consumption.
---

# Streaming export

Export a dataset as a stream, so memory use is bounded by page size rather than
by result size.
