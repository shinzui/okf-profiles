---
type: "Campaign"
title: "Engagement campaign"
description: "Synthetic fixture for Engagement campaign."
generated: {"by": "human:fixture-author", "at": "2026-10-23T20:30:00Z"}
campaignId: "CMP-3"
purpose: "engagement"
status: "drafting"
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

# Synthetic fixture
