---
type: Runbook
title: Review one architecture change
description: Compare owner evidence and target architecture for one named project.
docId: RB-3
owner: platform curator
projects: [mori://example/delivery]
environments: [local-checkout]
trigger: A changed owner artifact or a scheduled reconciliation review.
effects: [read-only, repository-change]
tags: [architecture, review]
status: stable
related: [mori://example/delivery/docs/architecture]
stale_after: 2027-10-05
sources:
  - resource: mori://example/delivery/docs/architecture
verified:
  by: process:fictional-fixture-review
  at: 2026-10-05T00:00:00Z
supersedes: [mori://example/legacy/okf/runbooks/concepts/RB-1]
generated:
  by: process:runbook-profile-fixtures
  at: 2026-10-05T00:00:00Z
---

# Review one architecture change

## Prerequisites

Choose the exact project and target slice; confirm access to their declared evidence.

## Procedure

Compare canonical evidence, retain unknowns, record the review and run repository checks. This is a fictional
fixture, not an executable production command.

## Verification

Confirm classifications cite owner evidence and the repository checks pass.

## Stop and recovery

Stop on invalid evidence. Correct only the review changes; preserve owner artifacts.

## Escalation

Contact the platform curator with the baseline, exact deployment identity,
observed failure and actions already attempted.
