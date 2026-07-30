---
type: PostgreSQL Table
title: orders
resource: postgresql://example/public/orders
derivation: copied-sometimes
lifecycle: forever
domain: [true]
---

# orders

## Schema

| Column | Type | Nullable | Description |
|---|---|---|---|
| id | uuid | no | Order identifier |
