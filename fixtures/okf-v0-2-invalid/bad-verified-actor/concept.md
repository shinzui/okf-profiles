---
type: Note
title: A verified entry whose actor is malformed
description: The verified list carries an entry whose by value is a bare name, matching none of the three actor shapes OKF v0.2 section 7 defines.
generated:
  by: human:nadeem
  at: 2026-07-30T00:00:00Z
verified:
  - by: schema-check
    at: 2026-07-31T00:00:00Z
---

# A verified entry whose actor is malformed

`verified` shares its member rules with `generated`, so `by` is checked against
the `actor` format here too. This fixture uses the *list* spelling, exercising
the `elementFields` branch of the `recordOrList` rule; `bare-verified.md` in the
acceptance bundle exercises the `objectFields` branch.
