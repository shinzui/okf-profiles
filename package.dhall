--| Entry point for the okf-profiles package.
--
-- Import this from any project to get the profile schema types and the
-- ready-made profiles. With a versioned, hash-pinned remote import:
--
--     let okf =
--           https://raw.githubusercontent.com/shinzui/okf-profiles/v0.1.0/package.dhall
--             sha256:0000000000000000000000000000000000000000000000000000000000000000
--
--     in  okf.postgresql // { name = "acme-warehouse" }
--
-- See README.md for how to generate the real hash (`dhall freeze`) and for the
-- public-repo / pinning rationale.
{ Profile = ./Profile/Type.dhall
, TypeRule = ./Profile/TypeRule.dhall
, FrontmatterRules = ./Profile/FrontmatterRules.dhall
, postgresql = ./profiles/postgresql.dhall
, tanPostgresql = ./profiles/tan-postgresql.dhall
}
