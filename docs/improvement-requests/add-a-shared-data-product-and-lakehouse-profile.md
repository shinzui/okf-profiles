---
type: Improvement Request
title: Add a shared Data Product and Lakehouse profile
description: >-
  Define reusable owner-governed concepts for analytical data products, DuckLake
  locations, exposed datasets, source lineage, freshness, classification, consumers,
  lifecycle, and executable evidence.
timestamp: "2026-08-19T18:04:00Z"
generated:
  by: openai-codex/gpt-5
  at: "2026-08-19T18:04:00Z"
requestId: IR-3
status: proposed
origin: mori://tan/tan-platform/plans/4-define-platform-architecture-assets-and-upstream-gaps
---

# Improvement Request: Add a Shared Data Product and Lakehouse Profile

## Status

**Proposed.** The TAN architecture capability experiment could describe DuckLake's
physical sources with the existing PostgreSQL profiles, but could not preserve the
analytical product contract without encoding it in unvalidated prose.

## Problem

`mori://shinzui/okf-profiles` currently distinguishes PostgreSQL schemas, tables, views,
and TAN event streams. Those are storage facts. They do not identify a data product or
dataset contract, and have no governed fields for product ownership, bounded-context
alignment, DuckLake catalog/storage location, source lineage, freshness, classification,
consumers, quality, or operating evidence.

A generic OKF document can retain those words, but different service repositories can
rename or omit them and Mori can only find the prose by text search. A physical table
also cannot safely stand in for the product: one product may expose multiple datasets
derived from several streams, with an evolution and freshness contract independent of
the operational source schema.

This gap was proven by
`mori://tan/tan-platform/docs/architecture-upstream-capability-gaps`, raised while
implementing
`mori://tan/tan-platform/plans/4-define-platform-architecture-assets-and-upstream-gaps`.

## Requested Change

Publish an additive Data Product/Lakehouse profile family with at least:

- **Data Product** — stable product identity, canonical owning project, owning bounded
  context, lifecycle, DuckLake catalog/storage identity, source references, exposed
  datasets, consumers, classification/access policy, freshness objective, quality
  evidence, runbook, and supersession;
- **Dataset** — stable identity within a product, schema/contract evidence, evolution and
  compatibility policy, source lineage, freshness objective, classification, consumers,
  and executable validation evidence; and
- typed relationships from products and datasets to existing PostgreSQL/Event Stream
  concepts rather than duplicating their physical definitions.

Cross-project references use canonical `mori://` URIs. The profile should compose with
the architecture assets requested by
`mori://shinzui/okf-profiles/okf/improvement-requests/concepts/IR-1` for ownership,
lifecycle, evidence, supersession, and conflict conventions without making a data
product merely another Database concept.

## Acceptance

1. A valid fixture declares one service-owned DuckLake product with two datasets, two
   source streams, a bounded-context link, freshness objectives, classifications,
   consumers, quality checks, lifecycle, evidence, and runbook; strict validation
   passes.
2. A dataset missing its product, owner, contract evidence, freshness objective, or
   classification fails with a focused diagnostic.
3. A product can cite physical PostgreSQL and Event Stream concepts without copying
   their schema definitions.
4. A consumer query can distinguish products, datasets, operational databases, and
   source streams and can retrieve the product owner, freshness, classification,
   consumers, and evidence from profile-declared fields.
5. Supersession and conflicting claims remain explicit, and a system repository can
   reference a service-owned product without becoming its owner.
6. The package export, documentation, valid/invalid fixtures, tests, changelog, and a
   tagged release ship together with a pinnable semantic hash.

## Non-goals

This request does not implement DuckLake, discover datasets from storage, compute
freshness, replace the PostgreSQL profiles, or centralize service-owned analytical data
in a platform repository.
