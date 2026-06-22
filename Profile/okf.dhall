--| okf's canonical published profile schema, pinned to a specific okf commit.
--
-- This is the single place the upstream schema URL + integrity hash live; the
-- sibling schema files (TypeRule.dhall, FrontmatterRules.dhall, Type.dhall) take
-- their record *types* from here and add only local `default` records. To track a
-- newer okf, bump the commit ref below and re-run `dhall freeze --inplace Profile/okf.dhall`.
--
-- The dependency is one-way: okf owns the schema, okf-profiles consumes it.
https://raw.githubusercontent.com/shinzui/okf/b0e9f9283acca2009fa94ff06f9dd20b4808b0be/okf-core/dhall/package.dhall
  sha256:feb5d69ab13191bb188fa00b017f988fc3570df0c0fa86d30105f34479103790
