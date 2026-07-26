--| okf's canonical published profile schema, pinned to a specific okf commit.
--
-- This is the single place the upstream schema URL + integrity hash live; the
-- sibling schema files (TypeRule.dhall, FrontmatterRules.dhall, Type.dhall) take
-- their record *types* from here and add only local `default` records. To track a
-- newer okf, bump the commit ref below and re-run `dhall freeze --inplace Profile/okf.dhall`.
--
-- The dependency is one-way: okf owns the schema, okf-profiles consumes it.
https://raw.githubusercontent.com/shinzui/okf/c66a51cc337ce2b08662f5809668fa4585609e13/okf-core/dhall/package.dhall
  sha256:f4e2e6c0bb2c10d97e52648ce4b053e0f47963fee300428538db01ab625ecce2
