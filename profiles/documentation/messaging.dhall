--| Messaging is documentation: an explanation to a customer, not another feature,
-- research finding or measurement record. Every factual proof point links a Claim
-- Check or Finding. Audience-any-of and target-type rules run in check-gtm.py.
-- House status replaces OKF status/staleAfter; nothing is recommended because a
-- draft may be unreviewed. Foreign references are canonical and external-only;
-- Positioning references may be local. Matrix coordinates are flat scalar labels.
-- No pricing/offer, competitor or engineering-project type is introduced.
let Profile = ../../Profile/Type.dhall

let FrontmatterRules = ../../Profile/FrontmatterRules.dhall

let TypeRule = ../../Profile/TypeRule.dhall

let okf = ../../Profile/okf.dhall

let FieldRule = okf.defaults.FieldRule

let NestedRules = okf.defaults.NestedRules

let NestedFieldRule = okf.defaults.NestedFieldRule

let HandleReferenceRule = okf.defaults.HandleReferenceRule

let Cardinality = okf.Cardinality

let FieldFormat = okf.FieldFormat

let reviewRule = ../../Profile/ReviewRule.dhall

let v02 = ../../Profile/V02.dhall

let conceptUri =
      \(prefix : Text) ->
        "mori://[^/]+/[^/]+/okf/[^/]+/concepts/${prefix}-[1-9][0-9]*"

let externalOnly =
      \(prefix : Text) ->
        Some
          HandleReferenceRule::{
          , localPrefix = "POS"
          , allowLocal = False
          , externalUriSchemes = [ "mori" ]
          , externalUriPattern = Some (conceptUri prefix)
          }

in  Profile::{
    , name = "messaging"
    , description = Some
        "Positioning and Messages explain value to audiences with attributable proof points."
    , okfVersion = "0.2"
    , requireBundleVersion = Some "0.2"
    , allowUnknownTypes = False
    , idField = Some "messagingId"
    , frontmatter = FrontmatterRules::{
      , required =
        [ FieldRule::{
          , field = "type"
          , description = Some "The declared concept type."
          , cardinality = Cardinality.Scalar
          }
        , FieldRule::{
          , field = "title"
          , description = Some "Human-readable concept title."
          , cardinality = Cardinality.Scalar
          }
        , FieldRule::{
          , field = "description"
          , description = Some "One sentence describing the concept."
          , cardinality = Cardinality.Scalar
          }
        , v02.generated
        ]
      , optional =
        [ FieldRule::{
          , field = "tags"
          , description = Some "Producer-defined search and grouping tags."
          , cardinality = Cardinality.List
          }
        , reviewRule
        , v02.verified
        , v02.sources
        ]
      }
    , types =
      [ TypeRule::{
        , type = "Positioning"
        , description = Some
            "An explanation of differentiated value to a defined audience."
        , idPrefix = Some "POS"
        , pathPattern = Some "positioning/*"
        , frontmatter = FrontmatterRules::{
          , required =
            [ FieldRule::{
              , field = "messagingId"
              , description = Some "Bundle-scoped stable POS-N handle."
              , cardinality = Cardinality.Scalar
              , format = Some (FieldFormat.DocumentHandle "POS")
              }
            , FieldRule::{
              , field = "category"
              , description = Some "Category in which the offer is understood."
              , cardinality = Cardinality.Scalar
              }
            , FieldRule::{
              , field = "problem"
              , description = Some "Customer problem addressed."
              , cardinality = Cardinality.Scalar
              }
            , FieldRule::{
              , field = "differentiation"
              , description = Some
                  "How this approach differs from alternatives."
              , cardinality = Cardinality.Scalar
              }
            , FieldRule::{
              , field = "status"
              , description = Some "Positioning lifecycle."
              , cardinality = Cardinality.Scalar
              , allowedValues = [ "draft", "active", "retired" ]
              }
            ]
          , optional =
            [ FieldRule::{
              , field = "segmentRefs"
              , description = Some "Audience Segments addressed."
              , cardinality = Cardinality.List
              , reference = externalOnly "SEG"
              }
            , FieldRule::{
              , field = "personaRefs"
              , description = Some "Personas addressed."
              , cardinality = Cardinality.List
              , reference = externalOnly "PERSONA"
              }
            , FieldRule::{
              , field = "jobRefs"
              , description = Some "Customer jobs addressed."
              , cardinality = Cardinality.List
              , reference = externalOnly "JOB"
              }
            , FieldRule::{
              , field = "alternatives"
              , description = Some "Alternatives the audience considers."
              , cardinality = Cardinality.List
              }
            , FieldRule::{
              , field = "proofPoints"
              , description = Some "Factual support for value explanations."
              , cardinality = Cardinality.List
              , elementFields = Some NestedRules::{
                , required =
                  [ NestedFieldRule::{
                    , field = "statement"
                    , description = Some "The exact point being supported."
                    , cardinality = Cardinality.Scalar
                    }
                  , NestedFieldRule::{
                    , field = "evidenceRef"
                    , description = Some "Canonical Finding or Claim Check URI."
                    , cardinality = Cardinality.Scalar
                    , reference = externalOnly "(PR|CLM)"
                    }
                  ]
                , optional = [] : List NestedFieldRule.Type
                }
              }
            ]
          }
        , guidance = Some
            "The opt-in check-gtm.py requires an audience and resolves each proof point to a Finding or Claim Check; a Study is not a finding."
        }
      , TypeRule::{
        , type = "Message"
        , description = Some
            "Content addressed to a customer, relying on cited facts rather than declaring new ones."
        , idPrefix = Some "MSG"
        , pathPattern = Some "messages/*"
        , frontmatter = FrontmatterRules::{
          , required =
            [ FieldRule::{
              , field = "messagingId"
              , description = Some "Bundle-scoped stable MSG-N handle."
              , cardinality = Cardinality.Scalar
              , format = Some (FieldFormat.DocumentHandle "MSG")
              }
            , FieldRule::{
              , field = "desiredAction"
              , description = Some "Action the audience is invited to take."
              , cardinality = Cardinality.Scalar
              }
            , FieldRule::{
              , field = "status"
              , description = Some "Message preparation and use lifecycle."
              , cardinality = Cardinality.Scalar
              , allowedValues = [ "draft", "approved", "in-use", "retired" ]
              }
            ]
          , optional =
            [ FieldRule::{
              , field = "segmentRefs"
              , description = Some "Audience Segments addressed."
              , cardinality = Cardinality.List
              , reference = externalOnly "SEG"
              }
            , FieldRule::{
              , field = "personaRefs"
              , description = Some "Personas addressed."
              , cardinality = Cardinality.List
              , reference = externalOnly "PERSONA"
              }
            , FieldRule::{
              , field = "hook"
              , description = Some "Customer-facing value hook."
              , cardinality = Cardinality.Scalar
              }
            , FieldRule::{
              , field = "jobRef"
              , description = Some "Canonical job addressed."
              , cardinality = Cardinality.Scalar
              , reference = externalOnly "JOB"
              }
            , FieldRule::{
              , field = "positioningRef"
              , description = Some "Positioning this message expresses."
              , cardinality = Cardinality.Scalar
              , reference = Some HandleReferenceRule::{
                , localPrefix = "POS"
                , externalUriSchemes = [ "mori" ]
                , externalUriPattern = Some (conceptUri "POS")
                }
              }
            , FieldRule::{
              , field = "proofPoints"
              , description = Some "Factual support for value explanations."
              , cardinality = Cardinality.List
              , elementFields = Some NestedRules::{
                , required =
                  [ NestedFieldRule::{
                    , field = "statement"
                    , description = Some "The exact point being supported."
                    , cardinality = Cardinality.Scalar
                    }
                  , NestedFieldRule::{
                    , field = "evidenceRef"
                    , description = Some "Canonical Finding or Claim Check URI."
                    , cardinality = Cardinality.Scalar
                    , reference = externalOnly "(PR|CLM)"
                    }
                  ]
                , optional = [] : List NestedFieldRule.Type
                }
              }
            , FieldRule::{
              , field = "channel"
              , description = Some "Producer-owned delivery channel."
              , cardinality = Cardinality.Scalar
              }
            , FieldRule::{
              , field = "matrixRow"
              , description = Some "Source matrix row identifier."
              , cardinality = Cardinality.Scalar
              }
            , FieldRule::{
              , field = "matrixDimensions"
              , description = Some
                  "Source coordinates retained as scalar labels."
              , cardinality = Cardinality.List
              }
            ]
          }
        , guidance = Some
            "The opt-in check-gtm.py requires an audience and resolves proof-point evidence; approval is an accountable review decision, not inferred from validation."
        }
      ]
    }
