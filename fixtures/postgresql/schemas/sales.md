---
type: PostgreSQL Schema
title: sales
description: Namespace holding the order tables and the reporting views over them.
resource: postgresql://example/sales
generated:
  by: process:schema-sync
  at: "2026-07-30T00:00:00Z"
status: stable
---

# sales

The sales namespace groups the tables that record orders and the views that
report on them. A schema concept is a file at `schemas/<schema>`, and its tables
and views live under a sibling `schemas/<schema>/` directory.
