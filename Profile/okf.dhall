--| okf's canonical published profile schema, pinned to a specific okf commit.
--
-- This is the single place the upstream schema URL + integrity hash live; the
-- sibling schema files (TypeRule.dhall, FrontmatterRules.dhall, Type.dhall) take
-- their record *types* from here and add only local `default` records. To track a
-- newer okf, bump the commit ref below and re-run `dhall freeze --inplace Profile/okf.dhall`.
--
-- The dependency is one-way: okf owns the schema, okf-profiles consumes it.
https://raw.githubusercontent.com/shinzui/okf/88ceed847f8578fe1584e9290e60c82b28e4f0d2/okf-core/dhall/package.dhall
  sha256:bfbaa6e7654bbdc09a0e2fbe36c429ed3c6fa7a313aa0821560dbbffe905c908
