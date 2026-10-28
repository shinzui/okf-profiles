---
type: "Improvement Request"
title: "Close the load-bearing sweep gaps recorded as deferred exceptions"
description: "Add the rejection cases that the first native catalog sweep found missing, starting with home suites for the shared reviews and v0.2 families, and delete each deferred sweep exception as its relaxation gains a witness."
requestId: "IR-12"
status: "proposed"
generated: {"by": "claude-code/claude-opus-5-5", "at": "2026-10-28T18:10:38Z"}
origin: "mori://shinzui/okf-profiles/plans/13-make-profile-policy-sweeps-observable-and-run-them-natively-in-okf"
dependencies: [{"ref": "mori://shinzui/okf-profiles/okf/improvement-requests/concepts/IR-11", "kind": "soft", "reason": "IR-11 adopts the native sweep and records these gaps as deferred exceptions; this request removes them."}]
acceptanceCriteria: [{"id": "AC-1", "statement": "The shared reviews members spliced from Profile/ReviewRule.dhall have a home suite whose sweep protects each member, and consuming suites list them as shared-family rather than deferred.", "verification": "Sweep the home suite and every consuming suite with okf profile sweep and inspect the manifests."}, {"id": "AC-2", "statement": "fixtures/okf-v0-2-invalid protects every relaxation of the v0.2 families that it can observe, so its own manifest holds no deferred entry.", "verification": "Run okf profile sweep profiles/okf-v0-2.dhall --accept fixtures/okf-v0-2 --cases fixtures/okf-v0-2-invalid."}, {"id": "AC-3", "statement": "No sweep-exceptions.json in the catalog names this request.", "verification": "Search fixtures/*-invalid/sweep-exceptions.json for IR-12 and run scripts/sweep-all-profiles.sh."}]
reviews: [{"kind": "model", "reviewer": "anthropic/claude-opus-5-5", "provider": "anthropic", "model": "claude-opus-5-5", "effort": "unspecified", "reviewed_at": "2026-10-28T18:10:38Z", "document_timestamp": "2026-10-28T18:10:38Z", "scope": "content-and-metadata", "outcome": "commented", "context": "Author record of gaps found while implementing the origin plan; not an independent review. The harness did not expose the run's effort setting."}]
---

# Close the load-bearing sweep gaps recorded as deferred exceptions

## Observed gaps

The first native load-bearing sweep of the whole catalog (`okf profile sweep`, run by `scripts/sweep-all-profiles.sh` under the origin plan) found relaxations that no rejection case notices. To make the sweep a gate without hiding them, each one is listed in its suite's `sweep-exceptions.json` with class `deferred` and this request's URI. On 2026-10-28 there were 612 such entries across 14 suites. About half (301) are members of the shared `reviews` family from `Profile/ReviewRule.dhall`, which every consuming profile splices and no suite tests member by member; that block has no home suite at all. Most of the rest are v0.2 members (`generated.at`, `generated.by` presence, `verified` members, `sources` author and last-modified) that the v0.2 home suite `fixtures/okf-v0-2-invalid` does not test either, and profile-specific gaps in the older suites: `use-cases` (74), `designs` (65), the house variant of designs (65, shared with designs), `jobs` (47), `product-research` (47).

## Desired outcome

Each deferred relaxation gains a witness under ADR-9 (one fault per rejection case, with an `expected.json` entry), or is reclassified with evidence: `shared-family` when a home suite protects it, `overlapping-rule` when another rule governs the same value. Fix the shared families at their home first, because one home fixture settles the same entry in every consuming suite. okf reports an entry whose relaxation gained a witness as a failing stale exception, so each fixture added must delete its entries in the same change.

## Acceptance criteria

- AC-1: the shared reviews members have a home suite that protects each one, and consuming suites list them as `shared-family`.
- AC-2: the v0.2 home suite protects every relaxation it can observe and keeps no `deferred` entry.
- AC-3: no `sweep-exceptions.json` names this request.
