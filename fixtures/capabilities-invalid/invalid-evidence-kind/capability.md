---
type: Capability
title: Rejection fixture
description: An evidence entry has an unknown kind.
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
  - kind: blog
    resource: https://example.com/post
    proves: Nothing a reader can check.
---

# Rejection fixture

An evidence entry declares kind blog, outside the closed vocabulary.
