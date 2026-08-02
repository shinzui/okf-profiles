---
type: Guide
title: Sources written in the retired v0.1 shape
description: This document writes sources as a bare list of URI strings rather than the v0.2 list of records.
generated:
  by: human:nadeem
  at: 2026-07-22T00:00:00Z
sources:
  - mori://example/runtime
resource: mori://example/patterns/docs/bad-source-shape
tags: [runtime]
status: current
---

# Sources written in the retired v0.1 shape

OKF v0.2 §5.1 defines `sources` as a list of records whose `resource` member is
required. A bare URI string is the shape this profile used to accept, and is
exactly what a consumer corpus must migrate away from.
