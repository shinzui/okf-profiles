---
type: PostgreSQL Table
title: orders
description: This table is otherwise complete but locates itself in the wrong engine.
resource: mysql://example/sales/orders
generated:
  by: process:schema-sync
  at: "2026-07-30T00:00:00Z"
---

# orders

The `PostgreSQL Table` type rule sets `resourceScheme = Some "postgresql"`, so a
`mysql://` URI is rejected however well-formed it is.

## Schema

| Column | Type | Nullable | Description |
|---|---|---|---|
| id | uuid | no | Order identifier |
