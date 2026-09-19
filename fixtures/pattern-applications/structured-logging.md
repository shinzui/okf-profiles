---
type: Pattern Application
title: Structured logging exception for billing
description: Billing accepts a bounded exception to the structured-logging standard during its logger migration.
generated:
  by: human:alice
  at: 2026-09-19T00:00:00Z
applicationId: PA-3
service: mori://acme/billing
pattern: mori://acme/patterns/okf/patterns/concepts/PAT-4
decision: exception
rationale: The standard applies, but the legacy settlement worker still emits plain-text logs.
exception:
  authority: human:alice
  scope: The settlement worker only; the API process already conforms.
  reason: The worker is being replaced, and porting its logger would be discarded work.
  reviewCondition: When the replacement worker ships, or on 2027-03-31, whichever comes first.
---

# Structured logging exception for billing

The exception covers one process and expires with its replacement.
