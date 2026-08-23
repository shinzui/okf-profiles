---
okf_version: "0.2"
---

# Files

- [profile.dhall](profile.dhall)

# Improvement Request

- [Add a shared Data Product and Lakehouse profile](add-a-shared-data-product-and-lakehouse-profile.md) - Define reusable owner-governed concepts for analytical data products, DuckLake locations, exposed datasets, source lineage, freshness, classification, consumers, lifecycle, and executable evidence.
- [Add a shared Deployment and Infrastructure Asset profile](add-a-shared-deployment-and-infrastructure-asset-profile.md) - Define queryable service-owned deployment assets that separate runtime, cloud provisioner, Kubernetes resource source, controller, environments, ownership, lifecycle, cutover, rollback, and validation evidence.
- [Add a shared Observability Contract profile](add-a-shared-observability-contract-profile.md) - Define service-owned observability contracts that distinguish instrumentation, export, propagation, dashboards, alerts, ownership, runbooks, lifecycle, and executable evidence.
- [Add a shared architecture-asset profile family](add-shared-architecture-asset-profile-family.md) - Define reusable, profile-governed concepts for databases, domain events, integration events, and standards with canonical ownership, lifecycle, contract evidence, consumers, DDD links, and explicit conflicting claims.
- [Model improvement-request dependencies and acceptance criteria](model-improvement-request-dependencies-and-acceptance-criteria.md) - Add typed, canonical IR-to-IR dependencies and stable structured acceptance criteria to the shared improvement-request profile so cross-repository fulfillment graphs can be validated and traversed instead of reconstructed from prose.
