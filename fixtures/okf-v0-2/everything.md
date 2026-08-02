---
type: Reference
title: Every v0.2 family at once
description: A concept populating all six OKF v0.2 frontmatter families, used to prove each rule in the okf-v0-2 reference profile is reachable.
generated:
  by: human:nadeem
  at: 2026-07-30T00:00:00Z
verified:
  - by: process:ddd-schema-check
    at: 2026-07-31T00:00:00Z
  - by: human:nadeem
    at: 2026-08-01T00:00:00Z
status: stable
stale_after: 2027-08-01
usage_window:
  from: 2026-05-01
  to: 2026-07-30
sources:
  - id: ddd-schema
    resource: mori://shinzui/mori
    title: The Mori DDD schema at mori/ddd.dhall
    author: human:nadeem
    usage_count: 40
    last_modified: 2026-05-02
  - id: query-population
    resource: all queries in BigQuery project acme-analytics
    title: Observed warehouse query population
    author: process:query-sampler
    usage_count: 5000
    last_modified: 2026-07-29
---

# Every v0.2 family at once

This concept exists so that the reference profile's rules are all exercised by at
least one passing document. It carries `generated`, `verified` as a two-element
list, `status`, `stale_after`, a document-level `usage_window`, and a `sources`
list whose entries populate every member the profile knows about.

The aggregate record mirrors the schema verbatim[^ddd-schema], and the shape of a
typical warehouse query was taken from the observed population rather than from
any single query[^query-population].

Both `sources` entries are cited, because core strict authoring checks the
footnote-to-`sources` join in both directions: an entry carrying an `id` that no
footnote cites is reported as a lint, and so is a footnote label naming no entry.

[^ddd-schema]: The aggregate record in the DDD schema.

[^query-population]: The sampled warehouse query population.
