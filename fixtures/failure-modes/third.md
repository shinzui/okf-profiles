---
type: Failure Mode
title: Retry storm after a dependency timeout
description: An earlier and coarser account of the retry amplification now recorded more precisely as FM-1's acknowledgement gap.
generated:
  by: human:nadeem
  at: "2026-08-20T00:00:00Z"
failureModeId: FM-3
status: accepted
scope: project
signature: Request volume to one dependency rises by an order of magnitude within a minute of that dependency slowing down.
occurrences:
  - "mori://example/platform — 2026-05-03"
diagnosis:
  - "Plot outbound request volume against the dependency's latency; amplification that begins when latency rises is this mode."
eliminated:
  - "A traffic spike arriving from outside — inbound request volume is flat across the whole window, so the amplification is generated internally."
  - "One layer retrying more than its configuration allows — each layer's counter shows exactly three attempts, so the multiplication is compositional rather than a single misconfiguration."
rootCause: Each layer retries three times without coordination, so a slow dependency multiplies one user request into twenty-seven.
control: Accepted deliberately for now. The retry budget is bounded per request and the dependency is capacity-planned for the amplified peak, so the amplification is survivable while the coordination work is unscheduled.
detection: An alert on outbound request volume exceeding four times the inbound rate for any dependency.
bugReport: mori://example/platform
supersededBy: FM-1
reviews:
  - kind: human
    reviewer: human:nadeem
    reviewed_at: "2026-08-20T00:20:00Z"
    document_timestamp: "2026-08-20T00:00:00Z"
    scope: content
    outcome: approved
    context: >-
      Accepted deliberately after the retry budget was bounded and the
      dependency capacity-planned for the amplified peak.
---

# Retry storm after a dependency timeout

This conforming fixture proves three optional keys at once: `bugReport` pointing
at a defect a repository owns, `supersededBy` resolving as a local handle against
this bundle's own index, and `control` carrying its `accepted` reading — what
makes living with the mode tolerable, rather than what stops it.

`accepted` demands `control` for the same reason `prevented` does. A mode
knowingly left in place with nothing written about why is indistinguishable from
one nobody got round to fixing, and the distinction is the entire content of the
status.
