---
type: Breadboard
title: Order detail — breadboard
description: How the order detail page works before what it looks like.
generated:
  by: human:fixture-author
  at: "2026-10-19T09:00:00Z"
designId: BB-1
status: validated
brief: DES-1
places:
  - name: order
    kind: surface
    description: The order detail page.
  - name: email
    kind: external
    description: The confirmation or shipping email.
  - name: support-queue
    kind: external
    description: The support tool's queue of buyer questions.
affordances:
  - name: arrival
    place: order
    does: when the order arrives, and the tracking link once shipped
    features:
      - mori://example/shop/okf/features/concepts/FEAT-1
  - name: items
    place: order
    does: what was ordered, with prices
  - name: payment-reference
    place: order
    does: the payment provider's reference for the order
connections:
  - from: email
    to: order
    jobs: [track]
  - from: support-queue
    to: order
    carries: the question's id, to link the reply
    jobs: [track]
visibility:
  - affordance: arrival
    viewer: buyer
    rule: shown
  - affordance: arrival
    viewer: support
    rule: shown
  - affordance: items
    viewer: buyer
    rule: shown
  - affordance: items
    viewer: support
    rule: collapsed
    note: Support opens the items only when the question is about them.
  - affordance: payment-reference
    viewer: buyer
    rule: hidden
  - affordance: payment-reference
    viewer: support
    rule: shown
decisions:
  - id: D-2
    date: 2026-10-19
    by: product owner
    statement: Arrival comes first for every viewer.
reviews:
  - kind: human
    reviewer: human:fixture-reviewer
    reviewed_at: "2026-10-19T10:00:00Z"
    document_timestamp: "2026-10-19T09:00:00Z"
    scope: content-and-metadata
    outcome: approved
    context: Read against the surface's jobs and features.
verified:
  - by: human:fixture-reviewer
    at: "2026-10-19T10:00:00Z"
---

# Order detail — breadboard

Arrival comes first for every viewer (D-2); items follow.
