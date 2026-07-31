--| okf's canonical published profile schema, pinned to a specific okf commit.
--
-- This is the single place the upstream schema URL + integrity hash live; the
-- sibling schema files (TypeRule.dhall, FrontmatterRules.dhall, Type.dhall) take
-- their record *types* from here and add only local `default` records. To track a
-- newer okf, bump the commit ref below and re-run `dhall freeze --inplace Profile/okf.dhall`.
--
-- The dependency is one-way: okf owns the schema, okf-profiles consumes it.
https://raw.githubusercontent.com/shinzui/okf/774379a09ba13d23a6b0747ae2078fd3b6d78c4d/okf-core/dhall/package.dhall
  sha256:4221ba7fc778aea894c8ef43e7309625a0bf565f59b14163bd16360d88e2bc0a
