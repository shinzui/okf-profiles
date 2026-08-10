---
type: Improvement Request
title: Add a shared architecture-asset profile family
description: >-
  Define reusable, profile-governed concepts for databases, domain events,
  integration events, and standards with canonical ownership, lifecycle,
  contract evidence, consumers, DDD links, and explicit conflicting claims.
timestamp: "2026-08-10T13:20:17Z"
generated:
  by: openai-codex/gpt-5
  at: "2026-08-10T13:20:17Z"
requestId: IR-1
status: proposed
origin: mori://shinzui/kikan
---

# Improvement Request: Add a Shared Architecture-Asset Profile Family

## Status

**Proposed.** `mori://shinzui/okf-profiles` already publishes the shared architecture-decision
and PostgreSQL profile families. It does not publish a common vocabulary for the system-level
assets that `mori://shinzui/kikan/okf/use-cases/concepts/UC-11` requires a permanent architect to
query across independently owned microservice repositories.

## Context

Mori can register and search OKF concepts across projects, preserve their validated frontmatter,
and link concepts through the stored graph. OKF profiles can require typed fields, stable handles,
references, and evidence. The missing part is a reusable profile that tells every service and system
repository how to describe the same architecture asset kinds.

Without a shared profile, one repository may call a public message an event, another a topic, and a
third a contract; owner, lifecycle, schema evidence, and consumer links become optional prose. A
platform architect then has to infer whether similarly named records describe one asset, independent
assets, or conflicting claims. The system repository is also tempted to copy service-owned facts
instead of referencing them.

The profile must preserve the ownership rule: a service repository owns its database, private domain
events, and produced integration-event contract. A system repository may catalog cross-system policy,
consumers, standards, and target-state relationships, but does not silently become the owner of the
service asset.

## Requested Change

Publish an additive architecture-asset profile family with at least these concept types:

- **Database** — one service-owned logical database or data boundary, distinct from its physical
  PostgreSQL schemas and tables;
- **Domain Event** — a private event in one bounded context, linked to its declaring DDD context and
  aggregate where applicable;
- **Integration Event** — a public contract with one producing owner, version/schema evidence, and
  declared consumers;
- **Architecture Standard** — a system-scoped rule or convention with applicability, evidence,
  lifecycle, exceptions, and supersession.

Reuse the existing architecture-decision profile through references rather than defining a second ADR
type. Compose with the existing PostgreSQL profile for physical database detail instead of duplicating
schema/table/view concepts.

Every architecture asset must support or require, as appropriate:

- one stable asset handle and a canonical owning project URI;
- lifecycle with at least emerging/experimental/active/maintenance/deprecated/sunset semantics, with
  effective dates and successor references where relevant;
- canonical source, contract, schema, or decision evidence at a resolvable URI;
- links to owning bounded contexts, aggregates, messages, or other DDD artifacts;
- producer and consumer project references for public contracts;
- supersession, replacement, compatibility, and migration relationships;
- environment or applicability scope where a claim is not universal; and
- an explicit way to record a conflicting claim without selecting a winner before adjudication.

Choose stable handle prefixes or one shared asset-id vocabulary so each concept has an unambiguous
`mori://…/okf/<bundle>/concepts/<handle>` URI. Cross-project fields accept canonical `mori://` URIs;
repository-local relationships may use profile-declared local handles.

Ship the profile as a versioned package export with documentation, one valid multi-type fixture,
invalid fixtures for every load-bearing ownership/reference/lifecycle rule, and a validation script.
Document how a service repository adopts the profile and how a system repository references rather
than copies a service-owned asset.

## Acceptance

1. A service fixture registers one database, one private domain event, and one produced integration
   event linked to its DDD context and evidence; strict profile validation passes.
2. A system fixture registers one architecture standard and consumer/policy links to the service
   event without claiming ownership of that event.
3. Mori concept lookup returns the stable asset identity, one declared owner, lifecycle, evidence,
   DDD links, producer/consumers, and supersession or conflict records from preserved frontmatter and
   graph links.
4. Invalid fixtures fail for a missing owner, malformed cross-project URI, missing required contract
   evidence, illegal lifecycle value, invalid successor, and a public integration event with no
   producing owner.
5. Two fixtures can make conflicting claims about one referenced asset without either claim being
   silently promoted to truth; the conflict remains queryable for adjudication.
6. The root package and `mori.dhall` export the profile, documentation explains versioning and
   adoption, the changelog records the addition, and a tagged release gives consumers a pinnable URL
   and semantic hash.

## Non-goals

This request does not add a second project registry, infer consumers from runtime traffic, or make the
system repository authoritative for service-owned facts. It does not replace Mori's DDD extension,
the architecture-decision profile, or the PostgreSQL physical-schema profile. Automated extraction
from code or brokers can be proposed separately; the first contract is declared and evidence-backed.

## Dependencies

- `mori://shinzui/okf` for profile validation and OKF concept semantics.
- `mori://shinzui/mori` for bundle registration, concept indexing, canonical references, and DDD
  artifact resolution.
- `mori://shinzui/mori/okf/improvement-requests/concepts/IR-9` and
  `mori://shinzui/mori/okf/improvement-requests/concepts/IR-10` for bounded-context lifecycle and the
  system-level context map that consume these assets.
- `mori://shinzui/kikan/okf/use-cases/concepts/UC-11` for the federated ownership and consultation
  contract.
