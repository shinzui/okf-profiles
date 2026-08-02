---
type: PostgreSQL Table
title: orders
description: This table uses a house lifecycle word where OKF v0.2 defines the vocabulary.
resource: postgresql://example/public/orders
generated:
  by: process:schema-sync
  at: "2026-07-30T00:00:00Z"
status: current
derivation: projection
lifecycle: durable
domain: true
sourceStreams: [order]
---

# orders

Unlike the five profiles that keep a house lifecycle vocabulary on the `status`
key, the PostgreSQL profiles adopt OKF v0.2 §5.4's `draft` / `stable` /
`deprecated` in full. `current` is a pattern-catalog word, not one of the three,
so it is rejected here.

## Schema

| Column | Type | Nullable | Description |
|---|---|---|---|
| id | uuid | no | Order identifier |
