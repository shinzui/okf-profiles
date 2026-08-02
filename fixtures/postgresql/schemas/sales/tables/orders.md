---
type: PostgreSQL Table
title: orders
description: One row per customer order, written by the ordering service.
resource: postgresql://example/sales/orders
generated:
  by: process:schema-sync
  at: "2026-07-30T00:00:00Z"
stale_after: 2027-07-30
---

# orders

One row per customer order. The description was produced by reading the live
schema, so it declares a date after which it should be re-confirmed rather than
quoted.

## Schema

| Column | Type | Nullable | Description |
|---|---|---|---|
| id | uuid | no | Order identifier |
| placed_at | timestamptz | no | When the customer placed the order |
| total_cents | bigint | no | Order total in minor units |
| cancelled_at | timestamptz | yes | When the order was cancelled, if it was |
