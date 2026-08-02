---
type: Note
title: A usage_window bound that is not a calendar date
description: The usage_window from value is a month-precision string rather than the YYYY-MM-DD calendar date the Date format requires.
generated:
  by: human:nadeem
  at: 2026-07-30T00:00:00Z
usage_window:
  from: 2026-05
  to: 2026-07-30
---

# A usage_window bound that is not a calendar date

Both `usage_window` members are optional, but each is checked against the `date`
format whenever it is present.
