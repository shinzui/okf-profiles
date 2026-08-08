---
type: Capability
title: Resumable export
description: Resume an interrupted export from its last acknowledged page.
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
capabilityId: CAP-2
provider: mori://example/platform
status: shipped
stability: experimental
since: "1.4.0"
packages:
  - example-export
interface:
  - Example.Export.Resume
requires:
  - CAP-1
evidence:
  - kind: test
    resource: test/ResumeSpec.hs
    proves: An export killed mid-run resumes from the last acknowledged page.
---

# Resumable export

**Builds on:** [CAP-1 — streaming export](streaming-export.md).

An interrupted export resumes from its last acknowledged page rather than
restarting.
