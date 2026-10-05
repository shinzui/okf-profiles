---
type: Runbook
title: Restart a delivery worker
description: Restart one delivery worker and confirm processing resumes without losing the recovery path.
docId: RB-1
owner: delivery service on-call
projects: []
environments: [staging, production]
trigger: Approved maintenance or an isolated unresponsive worker.
effects: [read-only, service-change]
tags: [operations, restart]
status: draft
generated:
  by: process:runbook-profile-fixtures
  at: 2026-10-05T00:00:00Z
---

# Restart a delivery worker

## Prerequisites

Confirm the deployment, environment and operator authority. Record replica count
and image revision. Check drain deadlines and the adapter's retry contract.

## Procedure

Inspect readiness, request a graceful restart, observe rollout completion, and
confirm ready replicas and continuing acknowledgements. This is a fictional
fixture, not an executable production command.

## Verification

Compare ready replicas, processing rate and failure rate with the recorded baseline.

## Stop and recovery

Stop if readiness or acknowledgement continuity worsens. Restore the recorded image
and replica configuration using the deployment owner's recovery procedure. Forced
termination needs separate authorization and a confirmed redelivery contract.

## Escalation

Contact the delivery service on-call with the baseline, exact deployment identity,
observed failure and actions already attempted.
