--| Shared rule for optional review provenance used by coordination and research
-- profiles. When `reviews` is present, every element has a bounded record shape;
-- model reviews additionally require provider, model, and effort metadata.
let okf = ./okf.dhall

let FieldRule = okf.defaults.FieldRule

let NestedFieldRule = okf.defaults.NestedFieldRule

let Cardinality = okf.Cardinality

let FieldFormat = okf.FieldFormat

let condition =
      \(field : Text) -> \(hasValue : List Text) -> { field, hasValue }

let modelOnly = Some (condition "kind" [ "model" ])

in  FieldRule::{
    , field = "reviews"
    , description = Some
        "Chronological human or model review provenance for this document revision."
    , cardinality = Cardinality.List
    , elementFields = Some
      { required =
        [ NestedFieldRule::{
          , field = "kind"
          , description = Some "Whether a human or model performed the review."
          , allowedValues = [ "human", "model" ]
          , cardinality = Cardinality.Scalar
          }
        , NestedFieldRule::{
          , field = "reviewer"
          , description = Some
              "Stable identity of the reviewing person or agent."
          , cardinality = Cardinality.Scalar
          }
        , NestedFieldRule::{
          , field = "reviewed_at"
          , description = Some "UTC time at which the review completed."
          , cardinality = Cardinality.Scalar
          , format = Some FieldFormat.Rfc3339Utc
          }
        , NestedFieldRule::{
          , field = "document_timestamp"
          , description = Some
              "Document revision timestamp covered by the review."
          , cardinality = Cardinality.Scalar
          , format = Some FieldFormat.Rfc3339Utc
          }
        , NestedFieldRule::{
          , field = "scope"
          , description = Some "Aspect of the document covered by the review."
          , allowedValues =
            [ "content"
            , "technical-accuracy"
            , "editorial"
            , "catalog-metadata"
            , "content-and-metadata"
            ]
          , cardinality = Cardinality.Scalar
          }
        , NestedFieldRule::{
          , field = "outcome"
          , description = Some "Result recorded by the reviewer."
          , allowedValues = [ "approved", "changes-requested", "commented" ]
          , cardinality = Cardinality.Scalar
          }
        , NestedFieldRule::{
          , field = "context"
          , description = Some
              "Evidence and repository context used for the review."
          , cardinality = Cardinality.Scalar
          }
        , NestedFieldRule::{
          , field = "provider"
          , description = Some "Serving provider for a model review."
          , cardinality = Cardinality.Scalar
          , when = modelOnly
          }
        , NestedFieldRule::{
          , field = "model"
          , description = Some "Most specific available model identifier."
          , cardinality = Cardinality.Scalar
          , when = modelOnly
          }
        , NestedFieldRule::{
          , field = "effort"
          , description = Some "Provider-reported reasoning or thinking effort."
          , allowedValues = [ "low", "medium", "high", "xhigh", "unspecified" ]
          , cardinality = Cardinality.Scalar
          , when = modelOnly
          }
        ]
      , recommended = [] : List NestedFieldRule.Type
      , optional = [] : List NestedFieldRule.Type
      }
    }
