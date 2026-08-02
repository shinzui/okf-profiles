---
type: PostgreSQL View
title: daily_totals
description: Order count and revenue per calendar day, excluding cancelled orders.
resource: postgresql://example/sales/daily_totals
generated:
  by: process:schema-sync
  at: "2026-07-30T00:00:00Z"
verified:
  by: human:nadeem
  at: "2026-07-31T00:00:00Z"
timestamp: "2026-07-30T00:00:00Z"
---

# daily_totals

Order count and revenue per calendar day. A human confirmed that the exclusion of
cancelled orders matches the view definition, so the concept carries both the
machine and the human trust path. It also retains the superseded v0.1 `timestamp`
key, which the profile still format-checks whenever it is present.

## Schema

| Column | Type | Description |
|---|---|---|
| day | date | Calendar day the orders were placed on |
| order_count | bigint | Orders placed that day, excluding cancellations |
| revenue_cents | bigint | Revenue for the day in minor units |
