---
type: Attested Computation
title: Run outcome and known-defect disposition
description: How the runner records a scenario outcome, an execution error, and a cohort-scoped known defect in the sealed result.
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
algorithm: run-outcome
algorithmVersion: 1
appliesTo: [correctness, concurrency, soak, benchmark]
computationId: VC-1
implementation: Kenshou.Core.Run
inputs: [run-spec, run-result, verdicts, diagnosis]
produces: outcome
---

This definition demonstrates how a result is computed from linked data and checked independently.

# Computation

```text
example input -> example verdict
```
