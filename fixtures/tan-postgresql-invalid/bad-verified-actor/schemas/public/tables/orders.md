---
type: PostgreSQL Table
title: orders
description: This table carries valid provenance and a malformed verified entry.
resource: postgresql://example/public/orders
generated:
  by: process:schema-sync
  at: "2026-07-30T00:00:00Z"
verified:
  - by: nadeem
    at: "2026-07-31T00:00:00Z"
derivation: projection
lifecycle: durable
domain: true
sourceStreams: [order]
---

# orders

`verified` is optional, but whenever it is present each entry's `by` member is
checked against the same OKF v0.2 §7 actor format as `generated.by`. A bare
`nadeem` is not `human:nadeem`.

## Schema

| Column | Type | Nullable | Description |
|---|---|---|---|
| id | uuid | no | Order identifier |
