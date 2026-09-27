---
type: Attested Computation
title: Paired benchmark comparison
description: How Kenshou compares compatible baseline and candidate runs under a versioned policy.
status: stable
runtime: kenshou
parameters:
  - name: baselineRuns
    type: paths
    required: true
  - name: candidateRuns
    type: paths
    required: true
executor:
  resource: /references/executors/kenshou-run.sh
  receipt: [run-spec.json, run-result.json, manifest.json]
attester:
  resource: /references/attesters/kenshou-attest.sh
generated:
  by: codex/gpt-6
  at: 2026-09-26T19:50:17Z
algorithm: paired-bootstrap-t-envelope
algorithmVersion: 1
appliesTo: [benchmark]
computationId: VC-3
implementation: Kenshou.Measure.Compare
inputs: [run-result, samples, comparison]
produces: comparison
supersedes: VC-2
---

This definition demonstrates how a result is computed from linked data and checked independently.

# Computation

```text
example input -> example verdict
```
