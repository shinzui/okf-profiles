---
type: Note
title: A quoted usage_count
description: The usage_count value is the string "40" rather than a YAML integer, which okf declines to coerce because coercing it would hide a producer mistake.
generated:
  by: human:nadeem
  at: 2026-07-30T00:00:00Z
sources:
  - id: quoted
    resource: mori://shinzui/mori
    usage_count: "40"
---

# A quoted usage_count

`usage_count` must be a YAML integer[^quoted]. A quoted `"40"` is a string, and
okf does not coerce it.

[^quoted]: The source whose usage count is quoted.
