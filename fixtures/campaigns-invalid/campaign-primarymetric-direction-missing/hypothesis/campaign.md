---
type: "Campaign"
title: "Hypothesis campaign"
description: "Synthetic fixture for Hypothesis campaign."
generated: {"by": "human:fixture-author", "at": "2026-10-23T20:30:00Z"}
campaignId: "CMP-1"
purpose: "hypothesis"
status: "measuring"
hypothesis: {"problem": "Low early-post volume.", "belief": "Showing relevant demand prompts earlier posts.", "prediction": "Early posts increase in the evaluation window.", "falsifiedIf": "Posts do not exceed the matched baseline."}
studyRef: "mori://example/gtm/okf/research/concepts/PR-1"
secondaryPurposes: ["announcement", "engagement"]
announcement: {"featureRefs": ["mori://example/gtm/okf/features/concepts/FEAT-1"], "liveBy": "2026-10-23T20:30:00Z"}
engagement: {"behavior": "Post before public exposure.", "why": "Give neighboring agents time to respond."}
notionId: "fixture-id"
notionUrl: "https://example.invalid/fixture"
owners: ["human:campaign-owner", "mori://example/marketing"]
audienceRefs: ["mori://example/gtm/okf/audiences/concepts/SEG-1"]
audience: [{"segment": "chapter", "definition": "Active members in the chapter.", "size": 20, "asOf": "2026-10-23T20:30:00Z"}]
primaryMetric: {"name": "early-posts", "metric": "count of early property posts", "unit": "posts", "method": "aggregate SQL count", "baseline": 1, "population": "active chapter members", "period": "matched eight-week baseline"}
window: {"from": "2026-10-01T00:00:00Z", "to": "2026-12-01T00:00:00Z"}
jobRefs: ["mori://example/product/okf/jobs/concepts/JOB-1"]
outcomeRefs: [{"jobRef": "mori://example/product/okf/jobs/concepts/JOB-1", "outcomeName": "time-to-share"}]
chapters: ["Example chapter"]
reviews: [{"kind": "human", "reviewer": "human:fixture-reviewer", "reviewed_at": "2026-10-23T20:30:00Z", "document_timestamp": "2026-10-23T20:30:00Z", "scope": "content-and-metadata", "outcome": "commented", "context": "Synthetic contract fixture, not production campaign evidence."}]
verified: {"by": "human:fixture-author", "at": "2026-10-23T20:30:00Z"}
sources: [{"resource": "Synthetic fixture evidence", "title": "Fixture evidence"}]
tags: ["fixture"]
---

# Synthetic fixture
