--| Profile for user-facing product documentation organized by reader intent.
let Profile = ../../Profile/Type.dhall

let FrontmatterRules = ../../Profile/FrontmatterRules.dhall

let TypeRule = ../../Profile/TypeRule.dhall

let okf = ../../Profile/okf.dhall

let FieldRule = okf.defaults.FieldRule

let HandleReferenceRule = okf.defaults.HandleReferenceRule

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

let documentType =
      \(conceptType : Text) ->
      \(description : Text) ->
        TypeRule::{
        , type = conceptType
        , description = Some description
        , idPrefix = Some "DOC"
        }

let documentReference =
      \(name : Text) ->
      \(description : Text) ->
        FieldRule::{
        , field = name
        , description = Some description
        , reference = Some HandleReferenceRule::{
          , localPrefix = "DOC"
          , externalUriSchemes = [ "mori" ]
          }
        }

in  Profile::{
    , name = "user-documentation"
    , description = Some
        "User-facing product documentation with stable DOC handles and a reader-intent taxonomy for navigation, learning, task completion, explanation, lookup, and operations."
    , frontmatter = FrontmatterRules::{
      , required =
        [ scalar "type" "The page's primary reader intent."
        , scalar "title" "Human-readable page title."
        , scalar "description" "Concise statement of the page's purpose and scope."
        , FieldRule::{
          , field = "docId"
          , description = Some "Bundle-scoped stable DOC-N handle."
          , cardinality = Cardinality.Scalar
          , format = Some (FieldFormat.DocumentHandle "DOC")
          }
        , FieldRule::{
          , field = "tags"
          , description = Some "Search and discovery terms for readers and agents."
          , cardinality = Cardinality.List
          }
        ,     v02.generated
          //  { description = Some
                  "§5.2. Who produced this page's current content, and when."
              }
        ]
      , recommended = [] : List FieldRule.Type
      , optional =
        [ v02.status
        , v02.staleAfter
        ,     v02.sources
          //  { description = Some
                  "§5.1. Specifications, source code, or other evidence from which this page was derived."
              }
        , v02.usageWindow
        ,     v02.verified
          //  { description = Some
                  "§5.2. Independent confirmations that this page remains accurate."
              }
        ,     documentReference
                "supersedes"
                "Earlier documentation replaced by this page."
          //  { cardinality = Cardinality.List }
        ,     documentReference
                "supersededBy"
                "Later documentation replacing this page."
          //  { cardinality = Cardinality.Scalar }
        ,     v02.legacyTimestamp
          //  { description = Some
                  "Superseded v0.1 revision timestamp. Prefer `generated.at`."
              }
        ]
      }
    , okfVersion = "0.2"
    , requireBundleVersion = Some "0.2"
    , allowUnknownTypes = False
    , idField = Some "docId"
    , types =
      [ documentType
          "Navigation"
          "A curated entry point that routes readers to the right documentation."
      , documentType
          "Tutorial"
          "A learning-oriented sequence that helps a reader gain initial working experience."
      , documentType
          "Guide"
          "Goal-oriented instructions that help a reader complete a specific task."
      , documentType
          "Explanation"
          "Conceptual material that builds understanding, context, and decision-making judgment."
      , documentType
          "Reference"
          "Authoritative lookup material describing interfaces, contracts, options, or current state."
      , documentType
          "Runbook"
          "An operational procedure whose ordering, safety conditions, and recovery behavior matter."
      ]
    }
