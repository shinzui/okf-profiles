---
type: Capability
title: Rejection fixture
description: status is planned.
generated:
  by: human:nadeem
  at: "2026-08-08T00:00:00Z"
capabilityId: CAP-1
provider: mori://example/platform
status: planned
stability: stable
since: "1.2.0"
packages:
  - example-export
evidence:
  - kind: test
    resource: test/ExportSpec.hs
    proves: The capability works.
---

# Rejection fixture

status is planned, which the profile deliberately does not allow: an absent capability is an improvement request.
