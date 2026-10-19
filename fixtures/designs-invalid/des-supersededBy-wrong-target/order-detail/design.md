---
type: Detailed Design
title: Order detail — detailed design
description: The order detail page's chosen direction, every affordance state and the final screens.
generated:
  by: human:fixture-author
  at: "2026-10-19T09:00:00Z"
designId: DES-1
status: retired
supersededBy: mori://example/shop/okf/designs/concepts/BB-9
breadboard: BB-1
states:
  - affordance: arrival
    states: [with-data, not-shipped]
  - affordance: items
    states: [with-data]
  - affordance: payment-reference
    states: [with-data, absent-for-buyer]
designArtifacts:
  - kind: figma
    resource: https://www.figma.com/file/example/order-detail
    note: Final screens, desktop and phone.
  - kind: screenshot
    resource: screens/s2-phone.png
decisions:
  - id: D-3
    date: 2026-10-19
    by: designer
    statement: Arrival is a single sentence, never a progress bar.
reviews:
  - kind: human
    reviewer: human:fixture-reviewer
    reviewed_at: "2026-10-19T10:00:00Z"
    document_timestamp: "2026-10-19T09:00:00Z"
    scope: content-and-metadata
    outcome: approved
    context: Read against the surface's jobs and features.
verified:
  by: human:fixture-reviewer
  at: "2026-10-19T10:00:00Z"
---

# Order detail — detailed design

S3 equals S1 for a support agent, plus the payment reference.

## Design handoff

| Screen | Scenario |
| ------ | -------- |
| Open, desktop | S1 |
| Shipped, phone | S2 |
| Shipped gift, support | S4 |
