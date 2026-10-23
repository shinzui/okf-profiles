---
type: "Improvement Request"
title: "Add campaign, claim-check and audience profiles"
description: "Publish coordinated campaign and audience types and checked-claim assurance with research readouts and a portable interim relationship gate."
generated: {"by": "openai/gpt-6.1-sol", "at": "2026-10-23T20:24:58Z"}
requestId: "IR-9"
status: "completed"
completedAt: "2026-10-23T22:36:53Z"
resolution: "Published v0.24.0 at commit 8cba3593323251219038aad42fb36645c7dd1bc0; remote semantic hash d0ce31021b2cb2cc6f191fd1d895bbf1ca8aad7f0e41f7c992cf972f2c2df800 and all three exported profiles verified."
amended: [{by: "codex-cli/gpt-6.1-sol", at: "2026-10-23T22:36:53Z", change: "Verify the published release and complete the consumer handoff."}]
origin: "mori://tan/tan-product-management/plans/3-add-campaign-and-audience-profiles-to-okf-profiles"
reviews: [{"kind": "model", "reviewer": "openai/gpt-6.1-sol", "provider": "openai", "model": "gpt-6.1-sol", "effort": "high", "reviewed_at": "2026-10-23T20:24:58Z", "document_timestamp": "2026-10-23T20:24:58Z", "scope": "content-and-metadata", "outcome": "commented", "context": "Author contract review against the real consumer campaign, catalog taxonomy, ADR-17 and engine field-condition limits; no independent approval implied."}]
---

# Add campaign, claim-check and audience profiles

The consumer initiative needs `coordination.campaigns` (CMP/EMAIL), `coordination.audiences` (SEG/PERSONA) and `assurance.claimChecks` (CLM). Reuse `documentation.productResearch` for experiment Studies and Findings and the shared reviews annotation. Add a reusable Hypothesis building block for the later strategy consumer.

Acceptance requires strict positive fixtures, single-fault negative fixtures and the ADR-9 sweep, generated docs, a converted copy of the real South Bay campaign, and a verified published release. The opt-in `scripts/check-gtm.py` gate owns unsupported checks temporarily: concept-local rules belong upstream to `mori://shinzui/okf/okf/improvement-requests/concepts/IR-9`, reference resolution to `mori://shinzui/mori/okf/improvement-requests/concepts/IR-38`. Neither tool is widened in this work.

No new Readout or Review type, Attested Computation definition, pricing/offer profile or competitive-analysis profile is introduced. Competitive findings and experiments use product research. Notion metadata remains producer-owned extra frontmatter.
