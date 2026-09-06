---
type: Failure Mode
title: Scheduled exports stop silently when the credential rotates
description: A rotated credential leaves the exporter running and reporting success while every upload is rejected.
generated:
  by: human:nadeem
  at: "2026-09-01T00:00:00Z"
failureModeId: FM-1
status: prevented
scope: fleet
signature: The exporter's log shows a normal run summary with a non-zero row count, and the destination bucket has no new object for that hour.
occurrences:
  - "mori://example/warehouse — 2026-06-14, noticed after four days"
  - "mori://example/platform — 2026-08-02, noticed the same day"
diagnosis:
  - "Compare the run summary's row count against the destination listing for the same hour; a summary with no object is this mode."
  - "Re-run one upload with the exporter's own credential; a 403 here and a success in the summary confirms the swallowed rejection."
eliminated:
  - "A partitioning bug dropping the last hour — replaying the previous day's manifest reproduces the same empty destination, so the window is not the variable."
  - "Clock skew between exporter and destination — both report the same instant from `date -u`, so the hour boundary is not misaligned."
rootCause: The upload path treats any HTTP response as delivery and only inspects the body on a transport error, so a 403 from a rotated credential is counted as a written object. The run summary is computed from rows read, never from rows acknowledged.
control: The exporter asserts the destination object exists before it writes a summary, and the summary reports acknowledged rows rather than read rows. Deployed in both consumers.
detection: An alert on any run whose acknowledged count is below its read count, which fires on the first bad run rather than on the first complaint.
cost: Four days of silently missing exports in the first occurrence, and a full re-export to repair the gap.
verified:
  - by: human:nadeem
    at: "2026-09-01T00:30:00Z"
reviews:
  - kind: human
    reviewer: human:nadeem
    reviewed_at: "2026-09-01T00:30:00Z"
    document_timestamp: "2026-09-01T00:00:00Z"
    scope: content-and-metadata
    outcome: approved
    context: >-
      Both occurrences reproduced against the exporter before the control was
      accepted as preventive.
---

# Scheduled exports stop silently when the credential rotates

This conforming fixture proves the first stable failure-mode handle and the shape
of a fully driven-to-ground entry: a mechanism, the control that stops it, and
the standing signal that says whether the control is still working.

It is `prevented` rather than `mitigated` because the control is deployed in both
places the mode can fire. Had it shipped in the warehouse alone while the
platform kept the old upload path, the honest status would be `mitigated` — the
frequency would be unchanged in one of the two repositories that has already seen
it.

`scope` is `fleet` because the defect is in a shared upload convention rather
than in either consumer's own code, which is what makes "deployed in both" the
bar for `prevented`.
