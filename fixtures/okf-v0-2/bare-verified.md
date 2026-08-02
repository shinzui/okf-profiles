---
type: Note
title: Verified written as a bare mapping
description: A concept spelling verified as one bare mapping rather than a list, which OKF v0.2 permits and a consumer must read as a one-element list.
generated:
  by: okf-authoring-agent/1.4
  at: 2026-07-30T00:00:00Z
verified:
  by: human:nadeem
  at: 2026-07-31T00:00:00Z
status: draft
---

# Verified written as a bare mapping

OKF v0.2 §5.2 permits `verified` either as a list of mappings or as one bare
mapping, and requires a consumer to treat the bare mapping as a one-element list.
The reference profile declares both spellings against the same member rules, so
either is accepted and both are checked.

Without this concept the bare-mapping branch would go untested: `everything.md`
uses the list spelling, so a profile that had lost its object-member rules would
still pass the rest of the bundle.

The `generated.by` value here is the third actor shape, `<producer>/<version>`.
