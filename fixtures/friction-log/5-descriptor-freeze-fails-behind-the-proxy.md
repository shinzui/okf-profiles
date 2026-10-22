---
type: Friction Entry
title: Descriptor freeze fails behind the proxy
description: A second account of the catalog tag that did not yet exist, mistaken at first for a proxy failure.
generated:
  by: human:fixture-author
  at: "2026-10-14T16:45:00Z"
frictionId: FRIC-5
status: duplicate
duplicateOf: FRIC-1
impact: slowdown
kind: environment
origin: mori://example/warehouse
affects: https://example.com/tools/dhall
plan: docs/plans/4-adopt-the-catalog-profile.md
---

# Descriptor freeze fails behind the proxy

This fixture proves the `duplicate` status with a local handle reference, and
an `affects` that is an ordinary URL rather than a Mori URI: the implementer
blamed the Dhall tool and the office proxy, neither of which the house
registers. At triage it was the same occurrence FRIC-1 records, so it is a
duplicate rather than a second entry, while its own account is kept.

## Attempted

Run `dhall freeze` on the same descriptor from a second machine.

## Encountered

The same `Remote file not found`, read as a proxy problem until FRIC-1 was
found.
