--| Profile for repository-owned Architecture Decision Records with stable ADR-N handles.
let Profile = ../../Profile/Type.dhall

let FrontmatterRules = ../../Profile/FrontmatterRules.dhall

let TypeRule = ../../Profile/TypeRule.dhall

let okf = ../../Profile/okf.dhall

let FieldRule = okf.defaults.FieldRule

let HandleReferenceRule = okf.defaults.HandleReferenceRule

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

in  Profile::{
    , name = "architecture-decision-records"
    , description = Some
        "Flat repository-owned architecture decisions with stable ADR handles."
    , frontmatter = FrontmatterRules::{
      , required =
        [ scalar "type" "The Architecture Decision Record concept type."
        , scalar "title" "Decision title without the ADR number."
        , FieldRule::{
          , field = "docId"
          , description = Some "Bundle-scoped stable ADR-N handle."
          , cardinality = Cardinality.Scalar
          , format = Some (FieldFormat.DocumentHandle "ADR")
          }
        , scalar "status" "Repository-native decision status."
        , FieldRule::{
          , field = "date"
          , description = Some "Original calendar date of the decision."
          , cardinality = Cardinality.Scalar
          , format = Some FieldFormat.Date
          }
        , scalar "description" "One-sentence summary of the decision."
        , FieldRule::{
          , field = "timestamp"
          , description = Some "UTC time of the last meaningful revision."
          , cardinality = Cardinality.Scalar
          , format = Some FieldFormat.Rfc3339Utc
          }
        ]
      , recommended =
        [ FieldRule::{
          , field = "supersedes"
          , description = Some "Earlier ADR handles replaced by this decision."
          , reference = Some HandleReferenceRule::{
            , localPrefix = "ADR"
            , externalUriSchemes = [ "mori" ]
            }
          }
        , FieldRule::{
          , field = "supersededBy"
          , description = Some "Later ADR handle replacing this decision."
          , cardinality = Cardinality.Scalar
          , reference = Some HandleReferenceRule::{
            , localPrefix = "ADR"
            , externalUriSchemes = [ "mori" ]
            }
          }
        , scalar
            "originatingPlan"
            "Plan that produced the decision, when recorded."
        ]
      }
    , allowUnknownTypes = False
    , idField = Some "docId"
    , types =
      [ TypeRule::{
        , type = "Architecture Decision Record"
        , description = Some
            "A durable record of one architecture decision and its rationale."
        , pathPattern = Some "*"
        , idPrefix = Some "ADR"
        }
      ]
    }
