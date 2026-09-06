---
type: Failure Mode
title: Nightly reindex leaves the search cluster with two primaries
description: A reindex that overruns its window is observed to leave duplicate primaries, with no mechanism yet established.
generated:
  by: process:incident-intake
  at: "2026-09-02T00:00:00Z"
failureModeId: FM-2
status: observed
scope: platform
signature: Two shards report as primary for the same index immediately after a nightly reindex that ran past its window.
occurrences:
  - "mori://example/platform — 2026-08-28"
  - "mori://example/platform — 2026-09-01"
diagnosis:
  - "Read the cluster's shard allocation immediately after the window closes; two primaries for one index is the state in question."
  - "Correlate against the reindex job's finish time — the state has only been seen when the job overran."
reviews:
  - kind: model
    reviewer: example-agent
    reviewed_at: "2026-09-02T00:10:00Z"
    document_timestamp: "2026-09-02T00:00:00Z"
    scope: technical-accuracy
    outcome: commented
    provider: example-provider
    model: example-model-1
    effort: medium
    context: >-
      Recorded from two sightings. No mechanism has been established, so the
      entry claims none.
---

# Nightly reindex leaves the search cluster with two primaries

This conforming fixture proves the early state. `status` is `observed`, so
neither `rootCause` nor `control` is demanded: the profile does not let a
suspicion be dressed as a diagnosis, and an entry that named a mechanism here
would stop the next reader from looking for the real one.

It earns its place in the catalog on recurrence alone — twice in five days — which
is what separates it from a research document about a single incident.

`eliminated` is absent rather than empty, and `--strict` does not ask for it:
the rule is gated on a status that claims a mechanism, so an entry still at
`observed` has had nothing to rule out yet. Demanding it here would report the
honest early state as a deficiency and invite invented content, which is the one
thing that key cannot survive.
