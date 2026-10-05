---
type: Runbook
title: Recover a dead letter queue
description: Replay selected failed messages after isolating the cause and confirming replay safety.
docId: RB-2
owner: delivery service on-call
projects: [mori://example/delivery]
environments: [staging, production]
trigger: A growing dead letter queue after the underlying fault has been corrected.
effects: [read-only, data-change]
tags: [operations, recovery, queues]
status: draft
generated:
  by: process:runbook-profile-fixtures
  at: 2026-10-05T00:00:00Z
---

# Recover a dead letter queue

## Prerequisites

Confirm the deployment, environment and operator authority. Record replica count
and image revision. Check drain deadlines and the adapter's retry contract.

## Procedure

Export the selected messages, confirm idempotency and deduplication, replay a small
sample, verify outcomes, then proceed in bounded batches. Delete retained originals
only after confirmed durable handoff. This is a fictional
fixture, not an executable production command.

## Verification

Confirm successful handling and reconciliation of message identities; retain the export.

## Stop and recovery

Stop on duplicates, new failures or an uncertain handoff. Preserve source records and
exports; involve the data owner because replay effects may not be reversible.

## Escalation

Contact the delivery service on-call with the baseline, exact deployment identity,
observed failure and actions already attempted.
