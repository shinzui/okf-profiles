---
type: Improvement Request
title: Add a shared Deployment and Infrastructure Asset profile
description: >-
  Define queryable service-owned deployment assets that separate runtime, cloud
  provisioner, Kubernetes resource source, controller, environments, ownership,
  lifecycle, cutover, rollback, and validation evidence.
timestamp: "2026-08-19T18:04:00Z"
generated:
  by: openai-codex/gpt-5
  at: "2026-08-19T18:04:00Z"
requestId: IR-4
status: proposed
origin: mori://tan/tan-platform/plans/4-define-platform-architecture-assets-and-upstream-gaps
reviews:
  - kind: model
    reviewer: process:openai-codex
    reviewed_at: "2026-08-23T21:20:05Z"
    document_timestamp: "2026-08-19T18:04:00Z"
    scope: content-and-metadata
    outcome: approved
    provider: openai
    model: gpt-5
    effort: unspecified
    context: >-
      Reviewed for profile conformance, internal consistency, and canonical
      cross-repository references; every concrete Mori URI resolved in the
      registry during the v0.12.0 release audit.
verified:
  by: process:openai-codex
  at: "2026-08-23T21:20:05Z"
---

# Improvement Request: Add a Shared Deployment and Infrastructure Asset Profile

## Status

**Proposed.** The TAN architecture experiment represented Helm/Terraform, Argo
CD/Kustomize, Pulumi, and hybrid services in owner documents, but current shared
profiles cannot validate or query their component boundaries.

## Problem

Infrastructure generation is not one tool label. A service can run on GKE, provision
GCP resources with Terraform or Pulumi, author Kubernetes resources with Helm,
Kustomize, or Pulumi, and reconcile them with Argo CD, Pulumi, or another release path.
During migration, old and new assets may coexist with distinct resource scopes and
lifecycles.

Architecture Standard concepts requested by
`mori://shinzui/okf-profiles/okf/improvement-requests/concepts/IR-1` can state the target
rule, and a service document can list the observed components. Neither provides shared,
typed fields for a fleet query such as “which service workloads are still reconciled by
Argo CD?” or validates that one resource set has one controller, an owner, cutover,
rollback, and evidence. Inferring tool names from paths or prose would turn conventions
into undocumented schema.

This gap was proven by
`mori://tan/tan-platform/docs/architecture-upstream-capability-gaps`, raised while
implementing
`mori://tan/tan-platform/plans/4-define-platform-architecture-assets-and-upstream-gaps`.

## Requested Change

Publish an additive Deployment/Infrastructure Asset profile family that can represent:

- a service delivery contract with canonical service/project owner, environments,
  lifecycle, and target runtime;
- independently identified assets for cloud-resource provisioning, Kubernetes-resource
  authoring, and deployment reconciliation;
- tool and version, canonical source/evidence reference, owning repository, environment,
  resource scope, lifecycle, predecessor/successor, and active-authority state for every
  asset;
- cutover and rollback evidence, preview/render/schema validation, approved apply
  identity, and observed deployment evidence; and
- explicit hybrid arrangements without collapsing them to one generation label.

Generation remains a consumer-derived classification from components. The profile must
not make `legacy`, `intermediate`, or `target` an owner-authored substitute for the
underlying facts. It should compose with Architecture Standard and conflict conventions
from
`mori://shinzui/okf-profiles/okf/improvement-requests/concepts/IR-1`.

## Acceptance

1. Valid fixtures represent a Helm/Terraform service, an Argo CD/Kustomize service, a
   Pulumi service, and a hybrid with non-overlapping resource scopes; strict validation
   passes.
2. Queries can return runtime, provisioner, Kubernetes source, controller, environments,
   owner, lifecycle, supersession, cutover, rollback, and validation evidence as
   distinct fields.
3. Invalid fixtures fail for missing owner/evidence, overlapping active controllers for
   one resource scope, missing hybrid scope, or a retired asset with no successor or
   accepted terminal rationale.
4. A platform standard can define Pulumi as target while service-owned concepts continue
   to describe legacy or intermediate reality without being relabeled.
5. The package export, documentation, fixtures, tests, changelog, and tagged release
   ship together with a pinnable semantic hash.

## Non-goals

This request does not provision infrastructure, execute Pulumi or Argo CD, prescribe a
TAN-specific tool target, or infer active assets from repository directory names.
