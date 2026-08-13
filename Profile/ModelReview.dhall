--| The model-review metadata vocabulary, written once for the whole catalog.
--
-- Two places in this repository record how a model produced a review, and they
-- must not drift apart:
--
--   * `./ReviewRule.dhall` — the house `reviews` frontmatter family, where an
--     entry describes a review *of the document carrying it*.
--   * `../profiles/assurance/reviews.dhall` — the `assurance.reviews` profile,
--     where the whole concept *is* one review.
--
-- The two cannot share a rule: a member of a list element is a
-- `NestedFieldRule` and a top-level key is a `FieldRule`, and those record types
-- are deliberately different. What they can share is the part a reader querying
-- across both depends on — the vocabulary and the wording — so it lives here, on
-- the same reasoning ADR-5 gives for the v0.2 field families.
--
--
-- ## The `effort` vocabulary
--
-- Five graded values and one escape hatch, ordered from least to most:
--
--     low < medium < high < xhigh < max
--
-- These are the settings a harness exposes, not a measurement. `effort` records
-- what the review was *asked* for, because that is the only value a producer can
-- state without inventing one. Two providers' `high` are not comparable, which
-- is why `provider` and `model` are recorded beside it, and why none of the
-- three carries its meaning alone.
--
-- `unspecified` covers the two cases where no grade exists to record: a provider
-- that exposes no effort setting, and a model that does no extended thinking at
-- all. A review run at a grade this list does not name is a reason to widen the
-- list, not to write `unspecified`.
--
-- Widening is additive and safe: an existing corpus stays valid, and every
-- profile splicing `./ReviewRule.dhall` picks the new value up when it repins.
{ efforts = [ "low", "medium", "high", "xhigh", "max", "unspecified" ]
, providerDescription = "Serving provider for a model review."
, modelDescription = "Most specific available model identifier."
, effortDescription = "Reasoning or thinking effort the review was run at."
}
