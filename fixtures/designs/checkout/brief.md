---
type: Design Brief
title: Checkout
description: Why checkout exists and who pays through it, signed in or as a guest.
generated:
  by: human:fixture-author
  at: "2026-10-19T09:00:00Z"
designId: BRIEF-3
status: draft
surface: /checkout
origin: mori://example/shop
viewers:
  - name: member
    definition: A signed-in customer.
  - name: guest
    definition: A customer paying without an account.
jobs:
  - name: pay
    jobRef: mori://example/shop/okf/jobs/concepts/JOB-3
    viewers: [member, guest]
reviews:
  - kind: human
    reviewer: human:fixture-reviewer
    reviewed_at: "2026-10-19T10:00:00Z"
    document_timestamp: "2026-10-19T09:00:00Z"
    scope: content-and-metadata
    outcome: changes-requested
    context: Read against the surface's jobs and features.
---

# Checkout

A draft: scenarios and success criteria come before validation.
