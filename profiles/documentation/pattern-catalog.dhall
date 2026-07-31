--| Profile for a Mori-addressable catalog of implementation patterns and standards.
let Profile = ../../Profile/Type.dhall

let TypeRule = ../../Profile/TypeRule.dhall

let okf = ../../Profile/okf.dhall

let FieldRule = okf.defaults.FieldRule

let Cardinality = okf.Cardinality

let FieldFormat = okf.FieldFormat

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
    , frontmatter =
      { required =
        [ scalar "type" "The documentation category governed by a type rule."
        , scalar "title" "Human-readable document title."
        , scalar "description" "Concise statement of the document's purpose."
        , FieldRule::{
          , field = "timestamp"
          , description = Some "UTC time of the last meaningful revision."
          , cardinality = Cardinality.Scalar
          , format = Some FieldFormat.Rfc3339Utc
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
      , recommended =
        [ FieldRule::{
          , field = "sources"
          , description = Some "Source material supporting the guidance."
          , cardinality = Cardinality.List
          }
        , FieldRule::{
          , field = "supersedes"
          , description = Some "Earlier guidance replaced by this document."
          }
        ]
      , optional = [] : List FieldRule.Type
      }
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
