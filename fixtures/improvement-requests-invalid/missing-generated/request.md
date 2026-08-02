---
type: Improvement Request
title: A request with no provenance
description: This request records everything except who produced it.
requestId: IR-1
status: proposed
origin: mori://example/origin
---

# A request with no provenance

OKF v0.2 makes `generated` a required family on this profile. A request that
records no producer is rejected, even though the superseded `timestamp` key it
would once have carried is still accepted when present.
