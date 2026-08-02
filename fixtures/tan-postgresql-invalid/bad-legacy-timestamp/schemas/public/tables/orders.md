---
type: PostgreSQL Table
title: orders
description: This table carries v0.2 provenance and a legacy timestamp that is not RFC3339 UTC.
resource: postgresql://example/public/orders
generated:
  by: process:schema-sync
  at: "2026-07-30T00:00:00Z"
timestamp: "2026-07-30"
derivation: projection
lifecycle: durable
domain: true
sourceStreams: [order]
---

# orders

Demoting `timestamp` to the `optional` list stops its *absence* being reported
but does not stop its *format* being checked. A date alone is not an RFC3339 UTC
instant, so this table is rejected even though the key is optional.

## Schema

| Column | Type | Nullable | Description |
|---|---|---|---|
| id | uuid | no | Order identifier |
