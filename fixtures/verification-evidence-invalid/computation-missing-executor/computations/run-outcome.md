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
attester:
  resource: /references/attesters/kenshou-attest.sh
generated:
  by: codex/gpt-6
  at: 2026-09-26T19:50:17Z
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
