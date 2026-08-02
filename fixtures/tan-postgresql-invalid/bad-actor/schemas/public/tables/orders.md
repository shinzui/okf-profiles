---
type: PostgreSQL Table
title: orders
description: This table is otherwise complete but its generated.by is a bare name.
resource: postgresql://example/public/orders
generated:
  by: schema-sync
  at: "2026-07-30T00:00:00Z"
derivation: projection
lifecycle: durable
domain: true
sourceStreams: [order]
---

# orders

`schema-sync` is none of `process:schema-sync`, `human:schema-sync`, or a
`<producer>/<version>` pair, so the OKF v0.2 §7 actor format rejects it.
`generated` is only recommended on this profile, but its member formats are
checked whenever it is present.

## Schema

| Column | Type | Nullable | Description |
|---|---|---|---|
| id | uuid | no | Order identifier |
