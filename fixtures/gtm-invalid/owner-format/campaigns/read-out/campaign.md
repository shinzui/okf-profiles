---
type: "Campaign"
title: "Read-out campaign"
description: "Synthetic fixture for Read-out campaign."
generated: {"by": "human:fixture-author", "at": "2026-10-23T20:30:00Z"}
campaignId: "CMP-5"
purpose: "hypothesis"
status: "read-out"
hypothesis: {"problem": "Low early-post volume.", "belief": "Showing relevant demand prompts earlier posts.", "prediction": "Early posts increase in the evaluation window.", "falsifiedIf": "Posts do not exceed the matched baseline."}
studyRef: "mori://example/gtm/okf/research/concepts/PR-1"
readout: {"decision": "Revise the campaign.", "findingRefs": ["mori://example/gtm/okf/research/concepts/PR-2"]}
owners: ["human:campaign-owner", "mori://example/marketing"]
audienceRefs: ["mori://example/gtm/okf/audiences/concepts/SEG-1"]
audience: [{"segment": "chapter", "definition": "Active members in the chapter.", "size": 20, "asOf": "2026-10-23T20:30:00Z"}]
primaryMetric: {"name": "early-posts", "metric": "count of early property posts", "unit": "posts", "direction": "increase", "method": "aggregate SQL count", "baseline": 1, "population": "active chapter members", "period": "matched eight-week baseline"}
window: {"from": "2026-10-01T00:00:00Z", "to": "2026-12-01T00:00:00Z"}
jobRefs: ["mori://example/product/okf/jobs/concepts/JOB-1"]
outcomeRefs: [{"jobRef": "mori://example/product/okf/jobs/concepts/JOB-1", "outcomeName": "time-to-share"}]
chapters: ["Example chapter"]
reviews: [{"kind": "human", "reviewer": "human:fixture-reviewer", "reviewed_at": "2026-10-23T20:30:00Z", "document_timestamp": "2026-10-23T20:30:00Z", "scope": "content-and-metadata", "outcome": "commented", "context": "Synthetic contract fixture, not production campaign evidence."}]
verified: {"by": "human:fixture-author", "at": "2026-10-23T20:30:00Z"}
sources: [{"resource": "Synthetic fixture evidence", "title": "Fixture evidence"}]
tags: ["fixture"]
---

# Read-out campaign

Synthetic contract fixture.
