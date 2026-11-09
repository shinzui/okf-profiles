---
type: Architecture Decision Record
title: Reader analytics require a verified subject
description: The profile reader records selected page visits through runtime-configured Kansoku only after the protected server verifies an opaque user subject.
docId: ADR-24
status: Accepted
date: 2026-11-09
generated:
  by: codex-cli/gpt-6.1-sol
  at: "2026-11-09T18:07:03Z"
---

# Reader analytics require a verified subject

## Context

The protected Labs reader needs the same Kansoku tracking as other intranet sites.
The publication boundary in [ADR-23](0023-generated-reference-crosses-an-explicit-publication-boundary.md)
still determines eligible documents. Search text, section fragments and unpublished
paths do not describe separate page visits.

## Decision

Reuse the lifecycle and identity contract established by
`mori://tan/tan-product-management/plans/26-record-hub-page-reads-in-kansoku-analytics`.
Serve validated public configuration at `/analytics-config.json`; missing or invalid
`DOCS_ANALYTICS_CONFIG` disables tracking. Load the SDK only after enabled configuration
and a verified subject from `/api/analytics/identity`. Trust Nagare's forwarded user only
when the protected deployment explicitly sets `DOCS_TRUST_FORWARDED_USER=1`.
The development identity override is ignored in production.

Use source service `okf-profiles` and a dedicated public write key. Metrics service
tokens remain operator-only. Identify with the opaque subject and no personal traits.
Capture each settled catalog or selected document visit once per URL and subject,
plus sessions, page leaves, Web Vitals and sanitized client errors. Remove queries,
fragments, referrer and UTM fields from every event. Search, disclosures and section
navigation do not produce page views. Identity failures stop collection; analytics
failures do not prevent reading.

Use memory storage, no persisted delivery queue, and respect Do Not Track and Global
Privacy Control. Revalidate identity on return to the tab and retire clients when the
subject changes. Pin the published `kansoku-js` 0.1.1 snapshot, including its license
and lazy chunks, with npm integrity and per-file checksums so offline Nix builds do
not need a second dependency fetch.

## Consequences

The reader supports the existing account's analytics without embedding deployment
credentials in its image. Runtime configuration can disable capture without code
changes; a new deployment revision must read the updated managed environment.
Reloading loses unsent in-memory events, an intentional privacy and availability
tradeoff. Trusting forwarded identity requires the Nagare login boundary and an origin
that cannot be reached by untrusted callers with forged identity headers.
