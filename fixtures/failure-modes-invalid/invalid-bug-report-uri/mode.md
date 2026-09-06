---
type: Failure Mode
title: Rejection fixture
description: A mode recorded only to be rejected by the profile.
generated:
  by: human:nadeem
  at: "2026-09-01T00:00:00Z"
failureModeId: FM-1
status: diagnosed
scope: project
signature: The nightly job reports success and writes no output.
occurrences:
  - "mori://example/platform - 2026-09-01"
diagnosis:
  - "Compare the job summary against the destination listing for the same window."
eliminated:
  - "A partitioning bug - replaying the previous manifest reproduces it, so the window is not the variable."
bugReport: https://example.com/issues/4
rootCause: The upload path counts any response as delivery.
---

# Rejection fixture

`bugReport` is not a `mori:` URI.
