--| okf's canonical published profile schema, pinned to a specific okf commit.
--
-- Currently pinned to okf 0.8.0.0 (commit 1b61d1d7adbdf8d90488805dc972801e45562c02),
-- the release that adds nested reference policies and record-list uniqueness while preserving
-- compatibility with descriptors authored against earlier schema generations.
--
-- This is the single place the upstream schema URL + integrity hash live; the
-- sibling schema files (TypeRule.dhall, FrontmatterRules.dhall, Type.dhall) take
-- their record *types* from here and add only local `default` records. To track a
-- newer okf, bump the commit ref below and re-run `dhall freeze Profile/okf.dhall`.
--
-- The dependency is one-way: okf owns the schema, okf-profiles consumes it.
https://raw.githubusercontent.com/shinzui/okf/1b61d1d7adbdf8d90488805dc972801e45562c02/okf-core/dhall/package.dhall
  sha256:0589682fe0acc109e523eeb4ef7ed2bdfa6f67185183e926f3a138cc071ac009
