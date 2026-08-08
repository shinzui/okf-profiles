---
type: Capability
title: Rejection fixture
description: capabilityId uses the wrong prefix.
generated:
  by: human:nadeem
  at: "2026-08-08T00:00:00Z"
capabilityId: CAPABILITY-1
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

capabilityId is CAPABILITY-1 rather than the CAP-N handle the profile demands.
