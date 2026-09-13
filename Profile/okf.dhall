--| okf's canonical published profile schema, pinned to a specific okf commit.
--
-- Currently pinned to okf 0.9.0.0 (commit bdf8893ccf0dfbd77fd68fe3c58348b5e49809c7),
-- the release that adds optional `guidance` to profiles and type rules. The field
-- defaults to `None Text`, so completed catalog values stay source-compatible, but
-- the widened record type needs the 0.9.0.0 decoder to load.
--
-- This is the single place the upstream schema URL + integrity hash live; the
-- sibling schema files (TypeRule.dhall, FrontmatterRules.dhall, Type.dhall) take
-- their record *types* from here and add only local `default` records. To track a
-- newer okf, bump the commit ref below and re-run `dhall freeze Profile/okf.dhall`.
--
-- The dependency is one-way: okf owns the schema, okf-profiles consumes it.
https://raw.githubusercontent.com/shinzui/okf/bdf8893ccf0dfbd77fd68fe3c58348b5e49809c7/okf-core/dhall/package.dhall
  sha256:6bdf781d3bafac7098196fc3ed152e94d34807bd79845d024a07fb94297c7fc3
