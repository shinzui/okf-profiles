--| okf's canonical published profile schema, pinned to a specific okf commit.
--
-- Currently pinned to okf 0.5.0.0 (commit 2e34d3042f0a919ed4f2c9d2db5fb89a139e25ee),
-- the release that implements OKF v0.2. That release adds `Profile.requireBundleVersion`,
-- `FieldRule.objectFields`, `FieldRule.path` with the `PathReferenceRule` record, and the
-- `actor` / `human-actor` / `integer` / `non-negative-integer` / `boolean` field formats.
--
-- This is the single place the upstream schema URL + integrity hash live; the
-- sibling schema files (TypeRule.dhall, FrontmatterRules.dhall, Type.dhall) take
-- their record *types* from here and add only local `default` records. To track a
-- newer okf, bump the commit ref below and re-run `dhall freeze Profile/okf.dhall`.
--
-- The dependency is one-way: okf owns the schema, okf-profiles consumes it.
https://raw.githubusercontent.com/shinzui/okf/2e34d3042f0a919ed4f2c9d2db5fb89a139e25ee/okf-core/dhall/package.dhall
  sha256:02a821061043976b0ec0d60745a792f5f536e5f5d0db43bc990890ab0f5af0e3
