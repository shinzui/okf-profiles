---
type: PostgreSQL Table
title: orders
description: This table declares a staleness date that is not a calendar date.
resource: postgresql://example/public/orders
generated:
  by: process:schema-sync
  at: "2026-07-30T00:00:00Z"
stale_after: 2027-13-45
derivation: projection
lifecycle: durable
domain: true
sourceStreams: [order]
---

# orders

`stale_after` is optional, but whenever it is present it must be a calendar
date. There is no thirteenth month and no forty-fifth day, so OKF v0.2 §5.5's
date format rejects this.

## Schema

| Column | Type | Nullable | Description |
|---|---|---|---|
| id | uuid | no | Order identifier |
