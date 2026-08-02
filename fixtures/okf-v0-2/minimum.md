---
type: Note
title: The minimum that passes
description: A concept carrying only the four keys the reference profile requires, proving the five optional v0.2 families really are optional.
generated:
  by: process:fixture-writer
  at: 2026-07-30T00:00:00Z
---

# The minimum that passes

Every OKF v0.2 family except `generated` is optional in this profile, and OKF
specification §11 forbids treating a missing optional family as a deficiency.
This concept therefore declares none of them and still passes under `--strict`.

It also exercises the `process:<id>` actor form, which is one of the three shapes
§7 permits. The other two, `human:<id>` and `<producer>/<version>`, appear in
`everything.md` and `bare-verified.md` respectively.
