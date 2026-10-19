---
type: Breadboard
title: Checkout — breadboard
description: How checkout works before what it looks like.
generated:
  by: human:fixture-author
  at: "2026-10-19T09:00:00Z"
designId: BB-2
status: draft
brief: BRIEF-3
places:
  - name: checkout
    kind: surface
    description: The checkout page.
  - name: cart
    kind: external
    description: The cart.
affordances:
  - name: pay-button
    place: checkout
    does: pays for the cart
connections:
  - from: cart
    to: checkout
    jobs: [pay]
visibility:
  - affordance: pay-button
    viewer: member
    rule: shown
  - affordance: pay-button
    viewer: guest
    rule: shown
reviews:
  - kind: human
    reviewer: human:fixture-reviewer
    reviewed_at: "2026-10-19T10:00:00Z"
    document_timestamp: "2026-10-19T09:00:00Z"
    scope: content-and-metadata
    outcome: changes-requested
    context: Read against the surface's jobs and features.
---

# Checkout — breadboard

Draft.
