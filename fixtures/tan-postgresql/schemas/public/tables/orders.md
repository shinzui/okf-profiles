---
type: PostgreSQL Table
title: orders
description: Order projection rebuilt from the order event stream.
resource: postgresql://example/public/orders
generated:
  by: process:schema-sync
  at: "2026-07-30T00:00:00Z"
timestamp: "2026-07-30T00:00:00Z"
status: stable
stale_after: 2027-07-30
derivation: projection
lifecycle: durable
domain: true
sourceStreams: [order]
---

# orders

A projection table, described by the synchronisation process that reads the live
schema. It carries the superseded v0.1 `timestamp` alongside `generated`, which
is what keeps the demoted rule's format check exercised, and it declares the date
after which this description should not be quoted without re-confirming it
against the database.

## Schema

| Column | Type | Nullable | Description |
|---|---|---|---|
| id | uuid | no | Order identifier |
