---
type: PostgreSQL Table
title: orders
resource: postgresql://example/public/orders
derivation: projection
lifecycle: durable
domain: true
---

# orders

## Schema

| Column | Type | Nullable | Description |
|---|---|---|---|
| id | uuid | no | Order identifier |
