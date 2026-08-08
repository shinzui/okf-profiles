---
type: Capability
title: Rejection fixture
description: An evidence entry has no resource.
generated:
  by: human:nadeem
  at: "2026-08-08T00:00:00Z"
capabilityId: CAP-1
provider: mori://example/platform
status: shipped
stability: stable
since: "1.2.0"
packages:
  - example-export
evidence:
  - kind: test
    proves: The capability works.
---

# Rejection fixture

An evidence entry names a kind but no resource, so nothing can be opened.
