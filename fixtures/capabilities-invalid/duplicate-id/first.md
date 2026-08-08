---
type: Capability
title: Duplicate handle (first)
description: Two capabilities share the CAP-1 handle.
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
    resource: test/ExportSpec.hs
    proves: The capability works.
---

# Duplicate handle (first)

Both concepts claim CAP-1.
