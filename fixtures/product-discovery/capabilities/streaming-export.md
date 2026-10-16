---
type: Capability
title: Streaming export
description: Export a closed period's results as a stream a consumer can page through.
generated:
  by: human:fixture-author
  at: "2026-10-16T09:00:00Z"
reviews:
  - kind: human
    reviewer: human:fixture-author
    reviewed_at: "2026-10-16T09:30:00Z"
    document_timestamp: "2026-10-16T09:00:00Z"
    scope: content-and-metadata
    outcome: approved
    context: Verified each evidence entry resolves and states what it proves.
capabilityId: CAP-1
provider: mori://example/export-service
status: shipped
stability: stable
since: "2.0.0"
packages:
  - export-service
interface:
  - Export.Stream
evidence:
  - kind: test
    resource: test/ExportStreamSpec.hs
    proves: A period larger than memory exports without buffering the whole result.
---

# Streaming export

A provision claim by the export service. FEAT-1 names it as contributing
behavior; this record stores no list of features that use it.
