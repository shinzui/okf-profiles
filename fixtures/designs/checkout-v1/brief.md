---
type: Design Brief
title: Checkout (first version)
description: The first checkout brief, replaced when guest checkout was added.
generated:
  by: human:fixture-author
  at: "2026-10-19T09:00:00Z"
designId: BRIEF-2
status: retired
supersededBy: BRIEF-3
surface: /checkout
origin: mori://example/shop
viewers:
  - name: buyer
    definition: A signed-in customer paying for a cart.
jobs:
  - name: pay
    jobRef: mori://example/shop/okf/jobs/concepts/JOB-3
reviews:
  - kind: human
    reviewer: human:fixture-reviewer
    reviewed_at: "2026-10-19T10:00:00Z"
    document_timestamp: "2026-10-19T09:00:00Z"
    scope: content-and-metadata
    outcome: approved
    context: Read against the surface's jobs and features.
---

# Checkout (first version)

Replaced by BRIEF-3.
