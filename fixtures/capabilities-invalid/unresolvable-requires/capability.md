---
type: Capability
title: Rejection fixture
description: requires names a handle that does not exist.
generated:
  by: human:nadeem
  at: "2026-08-08T00:00:00Z"
capabilityId: CAP-1
requires:
  - CAP-99
provider: mori://example/platform
status: shipped
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

requires names CAP-99, which is not a capability in this bundle.
