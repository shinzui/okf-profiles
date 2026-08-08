---
type: Capability
title: Rejection fixture
description: A deprecated capability with no forward path.
generated:
  by: human:nadeem
  at: "2026-08-08T00:00:00Z"
capabilityId: CAP-1
provider: mori://example/platform
status: deprecated
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

status is deprecated but no replacedBy is given, leaving a consumer with no forward path.
