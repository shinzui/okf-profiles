---
type: Attested Computation
title: Steady-window latency and throughput summary
description: How Kenshou derives operation percentiles, throughput, and evidence grade from samples and series.
status: stable
runtime: kenshou
parameters:
  - name: runDirectory
    type: path
    required: true
executor:
  resource: /references/executors/kenshou-run.sh
  receipt: [run-spec.json, run-result.json, manifest.json]
attester:
  resource: /references/attesters/kenshou-attest.sh
generated:
  by: codex/gpt-6
  at: 2026-09-26T19:50:17Z
algorithm: kenshou-summary
algorithmVersion: 1
appliesTo: [benchmark, soak]
computationId: VC-2
implementation: Kenshou.Measure.Summary
inputs: [samples, series, run-result]
produces: summary
computation: /references/computation.txt
---

This definition demonstrates how a result is computed from linked data and checked independently.
