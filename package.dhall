--| Entry point for the okf-profiles package.
--
-- Import this from any project to get the profile schema types and the
-- ready-made profiles. With a versioned, hash-pinned remote import:
--
--     let okf =
--           https://raw.githubusercontent.com/shinzui/okf-profiles/v0.19.0/package.dhall
--             sha256:85176d78369b6d73c9f13c30277903b629d6bf048a4c7d71fc26e68b99c3eaa6
--
--     in  okf.postgresql // { name = "acme-warehouse" }
--
-- v0.19.0 requires okf 0.9.0.0 or later. See README.md for how to generate the real hash (`dhall freeze`) and for the
-- public-repo / pinning rationale.
let okf = ./Profile/okf.dhall

in  { Profile = okf.defaults.Profile
    , TypeRule = okf.defaults.TypeRule
    , FrontmatterRules = okf.defaults.FrontmatterRules
    , FieldRule = okf.defaults.FieldRule
    , NestedRules = okf.defaults.NestedRules
    , NestedFieldRule = okf.defaults.NestedFieldRule
    , HandleReferenceRule = okf.defaults.HandleReferenceRule
    , PathReferenceRule = okf.defaults.PathReferenceRule
    , FieldCondition = okf.FieldCondition
    , Cardinality = okf.Cardinality
    , FieldFormat = okf.FieldFormat
    , mk = okf.mk
    , reviewRule = ./Profile/ReviewRule.dhall
    , modelReview = ./Profile/ModelReview.dhall
    , v02 = ./Profile/V02.dhall
    , assurance = ./profiles/assurance/package.dhall
    , coordination = ./profiles/coordination/package.dhall
    , documentation = ./profiles/documentation/package.dhall
    , okfV02 = ./profiles/okf-v0-2.dhall
    , postgresql = ./profiles/postgresql.dhall
    , tanPostgresql = ./profiles/tan-postgresql.dhall
    }
