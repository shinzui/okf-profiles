---
type: Capability
title: Rejection fixture
description: The record carries no generated provenance.
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

# Rejection fixture

The record carries no generated provenance.
