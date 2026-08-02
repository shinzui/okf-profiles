--| A reference profile for the OKF v0.2 frontmatter families.
--
-- Point `--profile` at it to check that a bundle's v0.2 families are well
-- formed, without authoring a profile of your own first:
--
--     okf validate BUNDLE --profile <this file> --strict
--
-- Exported from this repository's root package as `okfV02`, so a consumer pins
-- it by URL like any other profile in the catalog:
--
--     let okf = https://raw.githubusercontent.com/shinzui/okf-profiles/v0.8.0/package.dhall
--                 sha256:…
--
--     in  okf.okfV02
--
-- This is a *format-level* profile, not a house profile. It says how the v0.2
-- families must look when they are present and says nothing about which concept
-- types a team has, so `allowUnknownTypes` and `allowUnknownFields` are both
-- True and there are no type rules at all. Every other profile in this catalog
-- is a house profile and adds those; this one would be wrong to.
--
-- Profiles are not part of the Open Knowledge Format. A bundle that deviates
-- from this file is still fully OKF-conformant, and okf reports deviations as
-- advisories unless `--profile-enforce` is passed. What this file encodes is the
-- specification's own shape rules, not an additional layer of conformance.
--
-- The rules themselves live in `../Profile/V02.dhall`, shared with the house
-- profiles in this catalog so a correction lands in one place. Read that file's
-- header for the two catalog-wide policies on the `status` key and on the house
-- `reviews` family; neither applies here, because this profile has no house
-- conventions to collide with.
let Profile = ../Profile/Type.dhall

let TypeRule = ../Profile/TypeRule.dhall

let FrontmatterRules = ../Profile/FrontmatterRules.dhall

let okf = ../Profile/okf.dhall

let field = okf.mk.FieldRule

let v02 = ../Profile/V02.dhall

in  Profile::{
    , name = "okf-v0-2"
    , description = Some
        "Reference profile for the OKF v0.2 frontmatter families: provenance, trust, lifecycle, and sources."
    , okfVersion = "0.2"
    , frontmatter = FrontmatterRules::{
      , required =
        [ field.documented
            "type"
            "The concept type. This profile constrains no vocabulary, because OKF defines no fixed taxonomy and requires consumers to tolerate unknown types."
        , field.documented
            "title"
            "Human-readable name of the concept, as a reader would say it."
        , field.documented
            "description"
            "One or two sentences on what this concept is."
        , v02.generated
        ]
      , -- Nothing is recommended: every rule here is either required by this
        -- profile or optional per §11. `FrontmatterRules` defaults this to the
        -- empty list, but naming it says the emptiness is a decision.
        recommended = [] : List okf.defaults.FieldRule.Type
      , optional =
        [ -- All five are OPTIONAL deliberately. §11 forbids treating a missing
          -- optional family as a deficiency, so a reference profile that made
          -- `--strict` complain about an absent `verified` or `sources` would
          -- advise the opposite of the specification. A team that wants one of
          -- them demanded moves it to `required` or `recommended` in their own
          -- profile.
          v02.verified
        , v02.status
        , v02.staleAfter
        , v02.sources
        , v02.usageWindow
        ]
      }
    , allowUnknownTypes = True
    , allowUnknownFields = True
    , idField = None Text
    , -- Deliberately demanding nothing, for the same reason the families above
      -- are optional. §12 makes a bundle's `okf_version` declaration a MAY, so a
      -- format-level reference profile that required one would advise the
      -- opposite of the specification. The house profiles in this catalog have
      -- finished migrating and do write `Some "0.2"` here.
      requireBundleVersion = None Text
    , types = [] : List TypeRule.Type
    }
