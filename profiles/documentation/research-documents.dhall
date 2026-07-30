--| Profile for repository-owned research documents with stable RES-N handles.
let Profile = ../../Profile/Type.dhall

let FrontmatterRules = ../../Profile/FrontmatterRules.dhall

let TypeRule = ../../Profile/TypeRule.dhall

let okf = ../../Profile/okf.dhall

let FieldRule = okf.defaults.FieldRule

let HandleReferenceRule = okf.defaults.HandleReferenceRule

let Cardinality = okf.Cardinality

let FieldFormat = okf.FieldFormat

let reviewRule = ../../Profile/ReviewRule.dhall

let scalar =
      \(name : Text) ->
      \(description : Text) ->
        FieldRule::{
        , field = name
        , description = Some description
        , cardinality = Cardinality.Scalar
        }

in  Profile::{
    , name = "research-documents"
    , description = Some
        "Repository-owned research records with stable RES handles and structured review provenance."
    , frontmatter = FrontmatterRules::{
      , required =
        [ scalar "type" "The Research Document concept type."
        , scalar "title" "Human-readable research title."
        , scalar "description" "Concise statement of the research purpose."
        , FieldRule::{
          , field = "timestamp"
          , description = Some "UTC time of the last meaningful revision."
          , cardinality = Cardinality.Scalar
          , format = Some FieldFormat.Rfc3339Utc
          }
        , FieldRule::{
          , field = "researchId"
          , description = Some "Bundle-scoped stable RES-N handle."
          , cardinality = Cardinality.Scalar
          , format = Some (FieldFormat.DocumentHandle "RES")
          }
        , FieldRule::{
          , field = "status"
          , description = Some "Lifecycle state of the research record."
          , allowedValues = [ "active", "complete", "superseded" ]
          , cardinality = Cardinality.Scalar
          }
        , scalar
            "scope"
            "Question boundary and evidence considered by the research."
        , FieldRule::{
          , field = "supersededBy"
          , description = Some "Later research replacing this record."
          , cardinality = Cardinality.Scalar
          , reference = Some HandleReferenceRule::{
            , localPrefix = "RES"
            , externalUriSchemes = [ "mori" ]
            }
          , when = Some { field = "status", hasValue = [ "superseded" ] }
          }
        ]
      , recommended =
        [ reviewRule
        , FieldRule::{
          , field = "sources"
          , description = Some "Evidence sources used by the research."
          , cardinality = Cardinality.List
          }
        , FieldRule::{
          , field = "relatedPlans"
          , description = Some "Plans informed by this research."
          , cardinality = Cardinality.List
          }
        , FieldRule::{
          , field = "relatedDecisions"
          , description = Some
              "Architecture decisions informed by this research."
          , cardinality = Cardinality.List
          }
        , FieldRule::{
          , field = "supersedes"
          , description = Some "Earlier research replaced by this record."
          , reference = Some HandleReferenceRule::{
            , localPrefix = "RES"
            , externalUriSchemes = [ "mori" ]
            }
          }
        ]
      }
    , allowUnknownTypes = False
    , idField = Some "researchId"
    , types =
      [ TypeRule::{
        , type = "Research Document"
        , description = Some
            "A durable record of evidence, alternatives, and conclusions within a bounded scope."
        , pathPattern = Some "**"
        , idPrefix = Some "RES"
        }
      ]
    }
