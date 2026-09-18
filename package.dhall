--| Entry point for the okf-profiles package.
--
-- Import this from any project to get the profile schema types and the
-- ready-made profiles. With a versioned, hash-pinned remote import:
--
--     let okf =
--           https://raw.githubusercontent.com/shinzui/okf-profiles/v0.17.0/package.dhall
--             sha256:a947f6c753b6a41f33a5898de8dd25124037eb8420dcf4baf5822fbd43207bd1
--
--     in  okf.postgresql // { name = "acme-warehouse" }
--
-- v0.17.0 requires okf 0.9.0.0 or later. See README.md for how to generate the real hash (`dhall freeze`) and for the
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
