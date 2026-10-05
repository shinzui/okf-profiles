--| Operational procedures with explicit ownership, applicability and effects.
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
      \(field : Text) ->
      \(description : Text) ->
        FieldRule::{
        , field
        , description = Some description
        , cardinality = Cardinality.Scalar
        }

let list =
      \(field : Text) ->
      \(description : Text) ->
        FieldRule::{
        , field
        , description = Some description
        , cardinality = Cardinality.List
        }

let reference =
      \(field : Text) ->
      \(description : Text) ->
        FieldRule::{
        , field
        , description = Some description
        , reference = Some HandleReferenceRule::{
          , localPrefix = "RB"
          , externalUriSchemes = [ "mori" ]
          }
        }

in  Profile::{
    , name = "runbooks"
    , description = Some
        "Operational procedures with stable RB handles, accountable ownership, applicability, triggers and declared effects."
    , okfVersion = "0.2"
    , requireBundleVersion = Some "0.2"
    , allowUnknownTypes = False
    , idField = Some "docId"
    , frontmatter = FrontmatterRules::{
      , required =
        [ scalar "type" "The operational document type."
        , scalar "title" "Human-readable procedure title."
        , scalar "description" "Purpose and scope of the procedure."
        ,     scalar "docId" "Bundle-scoped stable RB-N handle."
          //  { format = Some (FieldFormat.DocumentHandle "RB") }
        , scalar
            "owner"
            "Accountable person, team or role that maintains the procedure and receives escalations."
        ,     list
                "projects"
                "Canonical Mori URIs for the projects or artifacts affected by this procedure."
          //  { format = Some (FieldFormat.UriWithScheme "mori") }
        , list
            "environments"
            "Explicit applicable environments; vocabulary is owned by the repository."
        , scalar
            "trigger"
            "Event or symptom that makes this procedure applicable."
        ,     list
                "effects"
                "Possible effects of following the procedure, including conditional branches; this grants no authority."
          //  { allowedValues =
                [ "read-only"
                , "repository-change"
                , "registry-change"
                , "service-change"
                , "data-change"
                ]
              }
        , list "tags" "Search and discovery terms."
        ,     v02.status
          //  { description = Some
                  "Documentation lifecycle: draft, stable or deprecated; this does not certify an operational exercise."
              }
        , v02.generated
        ]
      , recommended = [] : List FieldRule.Type
      , optional =
        [ v02.sources
        , v02.verified
        , v02.staleAfter
        ,     list
                "related"
                "Supporting alerts, dashboards, failure modes or other operational evidence."
          //  { format = Some (FieldFormat.UriWithScheme "mori") }
        ,     reference
                "supersedes"
                "Earlier runbooks replaced by this procedure."
          //  { cardinality = Cardinality.List }
        ,     reference "supersededBy" "Later runbook replacing this procedure."
          //  { cardinality = Cardinality.Scalar }
        ]
      }
    , types =
      [ TypeRule::{
        , type = "Runbook"
        , idPrefix = Some "RB"
        , description = Some
            "An operational procedure whose ordering, prerequisites, verification, stop conditions, recovery and escalation matter."
        }
      ]
    }
