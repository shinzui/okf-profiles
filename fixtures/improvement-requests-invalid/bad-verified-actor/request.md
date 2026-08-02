---
type: Improvement Request
title: A confirmation from an unnamed actor
description: This request carries valid provenance and a malformed verified entry.
generated:
  by: human:nadeem
  at: "2026-07-26T00:00:00Z"
requestId: IR-1
status: proposed
origin: mori://example/origin
verified:
  - by: example-agent
    at: "2026-07-26T00:01:00Z"
---

# A confirmation from an unnamed actor

`verified` is optional, but whenever it is present each entry's `by` member is
checked against the same OKF v0.2 §7 actor format as `generated.by`. A bare
`example-agent` is neither `process:example-agent` nor a
`<producer>/<version>` pair.
