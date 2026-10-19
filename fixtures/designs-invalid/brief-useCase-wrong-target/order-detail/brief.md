---
type: Design Brief
title: Order detail
description: Why the order detail page exists, who views it for which jobs, the states an order can be in, and the scenarios and criteria it is judged by.
generated:
  by: human:fixture-author
  at: "2026-10-19T09:00:00Z"
designId: BRIEF-1
status: validated
surface: /orders/[id]
origin: mori://example/shop
useCases:
  - mori://example/shop/okf/use-cases/concepts/FEAT-1
tags: [orders]
viewers:
  - name: buyer
    definition: The customer who placed the order.
    computedFrom: viewer id equals the order's customer id.
  - name: support
    definition: A support agent helping the buyer.
jobs:
  - name: track
    jobRef: mori://example/shop/okf/jobs/concepts/JOB-1
    viewers: [buyer, support]
  - name: return
    jobRef: mori://example/shop/okf/jobs/concepts/JOB-2
    viewers: [buyer]
subjectStates:
  - name: open
    definition: Paid and not yet handed to the carrier.
  - name: shipped
    definition: Handed to the carrier, with a tracking number.
outcomeRefs:
  - jobRef: mori://example/shop/okf/jobs/concepts/JOB-1
    outcomeName: knows-arrival
viewerAxes:
  - name: device
    applies: applies
    because: Most buyers open the page from the shipping email on a phone.
    rules: The arrival estimate is on the first screen on a phone.
  - name: plan
    applies: does-not-apply
    because: Every buyer gets the same order page.
subjectAxes:
  - name: gift
    applies: applies
    because: Gift orders hide prices from the recipient's packing slip.
    rules: The page marks the order as a gift.
scenarios:
  - id: S1
    viewer: buyer
    state: open
    jobs: [track]
    fixture: Ana opens her order of two books from the confirmation email; paid an hour ago, not yet shipped.
  - id: S2
    viewer: buyer
    state: shipped
    axes: [device]
    jobs: [track, return]
    fixture: Ana opens the same order from the shipping email on her phone; tracking number assigned yesterday.
  - id: S3
    viewer: support
    state: open
    jobs: [track]
    fixture: Ben in support opens Ana's order from the support queue after she asks where it is.
  - id: S4
    viewer: support
    state: shipped
    axes: [gift]
    fixture: Ben opens a shipped gift order from the support queue.
successCriteria:
  - id: SC-1
    statement: A buyer arriving from either email sees when the order arrives on the first screen.
    verification: Final screens and the shipped page for S1 and S2 on desktop and phone.
decisions:
  - id: D-1
    date: 2026-10-18
    by: product owner
    statement: Support sees what the buyer sees, plus the payment reference.
openQuestions:
  - id: Q-1
    question: Does a gift recipient ever open this page?
    owner: product owner
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

# Order detail

**Problem.** Buyers write to support to ask where an order is, because the
page shows line items before the arrival estimate.

**Who it's for.** Buyers and the support agents helping them.

**Non-goals.** Editing an order.
