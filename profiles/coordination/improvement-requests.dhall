--| Profile for cross-repository improvement requests with stable IR-N handles.
let Profile = ../../Profile/Type.dhall

let FrontmatterRules = ../../Profile/FrontmatterRules.dhall

let TypeRule = ../../Profile/TypeRule.dhall

let okf = ../../Profile/okf.dhall

let FieldRule = okf.defaults.FieldRule

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
    , name = "cross-repository-improvement-requests"
    , description = Some
        "Cross-repository improvement proposals with stable IR handles and review provenance."
    , frontmatter = FrontmatterRules::{
      , required =
        [ scalar "type" "The Improvement Request concept type."
        , scalar "title" "Short statement of the requested improvement."
        , scalar
            "description"
            "Concise explanation of the problem and desired outcome."
        , FieldRule::{
          , field = "timestamp"
          , description = Some "UTC time of the last meaningful revision."
          , cardinality = Cardinality.Scalar
          , format = Some FieldFormat.Rfc3339Utc
          }
        , FieldRule::{
          , field = "requestId"
          , description = Some "Bundle-scoped stable IR-N handle."
          , cardinality = Cardinality.Scalar
          , format = Some (FieldFormat.DocumentHandle "IR")
          }
        , FieldRule::{
          , field = "status"
          , description = Some "Lifecycle decision for the request."
          , allowedValues = [ "proposed", "accepted", "rejected", "withdrawn" ]
          , cardinality = Cardinality.Scalar
          }
        , FieldRule::{
          , field = "origin"
          , description = Some
              "Mori URI of the project or artifact raising the request."
          , cardinality = Cardinality.Scalar
          , format = Some (FieldFormat.UriWithScheme "mori")
          }
        ]
      , recommended =
        [ reviewRule
        , FieldRule::{
          , field = "targetPlan"
          , description = Some
              "Repository-relative path or Mori URI of the implementation plan."
          , cardinality = Cardinality.Scalar
          }
        ]
      }
    , allowUnknownTypes = False
    , idField = Some "requestId"
    , types =
      [ TypeRule::{
        , type = "Improvement Request"
        , description = Some
            "A request whose implementation may span repository ownership boundaries."
        , pathPattern = Some "*"
        , idPrefix = Some "IR"
        }
      ]
    }
