---
type: "Improvement Request"
title: "Make profile policy sweeps observable and reduce redundant fixture scans"
description: "Retain ADR-9 constraint coverage while reporting live progress and avoiding expensive repeated scans of known unobservable policy relaxations."
requestId: "IR-11"
status: "proposed"
generated: {"by": "codex-cli/gpt-6.1-sol", "at": "2026-10-23T22:58:57Z"}
origin: "mori://tan/tan-product-management/plans/4-add-strategy-messaging-and-launch-profiles-to-okf-profiles"
reviews: [{"kind": "model", "reviewer": "openai/gpt-6.1-sol", "provider": "openai", "model": "gpt-6.1-sol", "effort": "high", "reviewed_at": "2026-10-23T22:58:57Z", "document_timestamp": "2026-10-23T22:58:57Z", "scope": "content-and-metadata", "outcome": "commented", "context": "Author proposal from repeated release verification cost; not an independent review or a claim that the tool is broken."}]
---

# Make profile policy sweeps observable and reduce redundant fixture scans

## Observed cost

The required `scripts/sweep-profile-rules.py` preserves useful ADR-9 coverage but repeatedly scans the complete fixture corpus for shared-family, composite and unconstrained optional-policy relaxations. The consumer release work in `mori://tan/tan-product-management/plans/3-add-campaign-and-audience-profiles-to-okf-profiles` and `mori://tan/tan-product-management/plans/4-add-strategy-messaging-and-launch-profiles-to-okf-profiles` encountered the same material delay. Redirected stdout remains buffered until a large block or process exit. This is an improvement request, not a broken-provision claim.

## Desired outcome

Keep the existing baseline, per-fixture advisory counts, strict acceptance controls and complete constrained-policy inventory. Stream progress when redirected. Report each relaxation with its witness, failure, or explicitly classified documented exception. Reduce redundant work through a field-indexed witness strategy or other measured optimization, retaining a conclusive exhaustive fallback when needed. An optional bounded worker pool must preserve deterministic results, reliable executable resolution and useful errors.

## Acceptance criteria

- The three released campaign-family sweeps and the three strategy-family sweeps report the same constrained-policy witnesses and explicit exception classes as the serial baseline.
- Baseline fixture faults or acceptance failures still stop the run; optimization never labels an untested constraint protected.
- Redirected output shows completed work promptly and includes elapsed time and a machine-readable final summary.
- A representative large corpus demonstrates lower wall time or a clearly explained work budget, without weakening ADR-9.

No sweep implementation or acceptance requirement is changed by filing this request. Producer profiles and release validation remain independent of this future tooling work.
