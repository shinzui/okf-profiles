---
type: PostgreSQL Table
title: orders
description: This table describes itself in prose but never lists its columns.
resource: postgresql://example/sales/orders
generated:
  by: process:schema-sync
  at: "2026-07-30T00:00:00Z"
---

# orders

The `PostgreSQL Table` type rule sets `requireSchemaSection = True`, so a table
concept must carry a `# Schema` section listing Column, Type, Nullable, and
Description. A prose description of the table is not a substitute for its column
contract.
