--| Profile for a Mori-addressable catalog of implementation patterns and standards.
let Profile = ../../Profile/Type.dhall

let FrontmatterRules = ../../Profile/FrontmatterRules.dhall

let TypeRule = ../../Profile/TypeRule.dhall

let okf = ../../Profile/okf.dhall

let FieldRule = okf.defaults.FieldRule

let Cardinality = okf.Cardinality

let FieldFormat = okf.FieldFormat

let v02 = ../../Profile/V02.dhall

let scalar =
      \(name : Text) ->
      \(description : Text) ->
        FieldRule::{
        , field = name
        , description = Some description
        , cardinality = Cardinality.Scalar
        }

let rule =
      \(conceptType : Text) ->
      \(path : Text) ->
        TypeRule::{
        , type = conceptType
        , description = Some ("A catalog " ++ conceptType ++ " document.")
        , pathPattern = Some path
        , resourceScheme = Some "mori"
        }

in  Profile::{
    , name = "mori-documentation-pattern-catalog"
    , description = Some
        "Mori-addressable implementation patterns, standards, guides, and operational documentation."
    , frontmatter = FrontmatterRules::{
      , required =
        [ scalar "type" "The documentation category governed by a type rule."
        , scalar "title" "Human-readable document title."
        , scalar "description" "Concise statement of the document's purpose."
        ,     v02.generated
          //  { description = Some
                  "§5.2. Who produced this document's current content, and when."
              }
        , FieldRule::{
          , field = "resource"
          , description = Some "Canonical Mori URI for this document."
          , cardinality = Cardinality.Scalar
          , format = Some (FieldFormat.UriWithScheme "mori")
          }
        , FieldRule::{
          , field = "tags"
          , description = Some "Search and discovery terms."
          , cardinality = Cardinality.List
          }
        , FieldRule::{
          , field = "status"
          , description = Some "Publication state of this guidance."
          , allowedValues = [ "current", "deprecated" ]
          , cardinality = Cardinality.Scalar
          }
        ]
      , -- Nothing is recommended. Under `--strict` a recommended-and-absent
        -- field is an error, and both fields below are ordinarily absent: most
        -- catalog documents supersede nothing and cite no external source.
        recommended = [] : List FieldRule.Type
      , optional =
        [ -- Was a bare list of URI strings; now the OKF v0.2 §5.1
          -- list-of-records shape, where the former URI becomes each entry's
          -- required `resource` member. This is breaking for a consumer corpus.
          --
          -- Note this is unrelated to the top-level `resource` key above, which
          -- is OKF §4.1's canonical Mori URI for the document itself.
          v02.sources
        , FieldRule::{
          , field = "supersedes"
          , description = Some "Earlier guidance replaced by this document."
          }
        ,     v02.verified
          //  { description = Some
                  "§5.2. Independent confirmations that this guidance is accurate."
              }
        , -- The superseded v0.1 key, kept so an unmigrated catalog keeps
          -- validating. `optional` means its absence is never reported while its
          -- format is still checked whenever it is present.
              v02.legacyTimestamp
          //  { description = Some
                  "Superseded v0.1 revision timestamp. Prefer `generated.at`."
              }
        ]
      }
    , -- The house `status` key above keeps its `current`/`deprecated`
      -- vocabulary and deliberately does not adopt OKF v0.2 §5.4's
      -- draft/stable/deprecated, nor `stale_after`. See the header of
      -- ../../Profile/V02.dhall for the policy and its reasoning.
      okfVersion = "0.2"
    , requireBundleVersion = Some "0.2"
    , types =
      [ rule "Navigation" "getting-started"
      , rule "Overview" "*/overview"
      , rule "Standard" "*/**"
      , rule "Guide" "*/**"
      , rule "Pattern" "*/**"
      , rule "Runbook" "*/**"
      , rule "Reference" "*/**"
      , rule "Gotcha" "*/**"
      ]
    }
