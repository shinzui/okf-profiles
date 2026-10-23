--| Segments and personas describe the consumer side beside jobs. A persona is
-- not a job and never restates it. Its assessment rule is copied exactly from
-- jobs.dhall; keep the two policies in sync until factored into a shared block.
-- External-only references use SEG plus canonical foreign-handle patterns.
-- Nothing is recommended: untested drafts need no assessment or sources. House
-- status replaces OKF status/staleAfter. No legacyTimestamp exists for this new
-- v0.2 profile. Target type and query-file checks run in opt-in check-gtm.py.
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
          , localPrefix = "SEG"
          , allowLocal = False
          , externalUriSchemes = [ "mori" ]
          , externalUriPattern = Some (conceptUri prefix)
          }

let nestedScalar =
      \(name : Text) ->
      \(description : Text) ->
        NestedFieldRule::{
        , field = name
        , description = Some description
        , cardinality = Cardinality.Scalar
        }

let assessment =
      FieldRule::{
      , field = "assessment"
      , description = Some
          "The authors' synthesis of research findings behind `validationStatus`."
      , objectFields = Some NestedRules::{
        , required =
          [ nestedScalar
              "rationale"
              "Why the cited findings justify the declared validation status."
          ,     nestedScalar
                  "assessedAt"
                  "UTC RFC3339 time the assessment was made."
            //  { format = Some FieldFormat.Rfc3339Utc }
          , NestedFieldRule::{
            , field = "findingRefs"
            , description = Some
                "Canonical Mori URIs of the product-research findings assessed."
            , cardinality = Cardinality.List
            , reference = externalOnly "PR"
            }
          ]
        }
      , when = Some
        { field = "validationStatus"
        , hasValue = [ "supported", "mixed", "challenged" ]
        }
      }

in  Profile::{
    , name = "audiences"
    , description = Some
        "Segments define populations; Personas name who holds jobs without restating those jobs."
    , okfVersion = "0.2"
    , requireBundleVersion = Some "0.2"
    , allowUnknownTypes = False
    , idField = Some "audienceId"
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
        , type = "Segment"
        , description = Some
            "A precisely defined population for coordinated work."
        , idPrefix = Some "SEG"
        , pathPattern = Some "segments/*"
        , frontmatter = FrontmatterRules::{
          , required =
            [ FieldRule::{
              , field = "audienceId"
              , description = Some "Bundle-scoped stable SEG-N handle."
              , cardinality = Cardinality.Scalar
              , format = Some (FieldFormat.DocumentHandle "SEG")
              }
            , FieldRule::{
              , field = "definition"
              , description = Some
                  "Population definition precise enough to query."
              , cardinality = Cardinality.Scalar
              }
            , FieldRule::{
              , field = "status"
              , description = Some "Segment lifecycle."
              , cardinality = Cardinality.Scalar
              , allowedValues = [ "draft", "active", "retired" ]
              }
            ]
          , optional =
            [ FieldRule::{
              , field = "criteria"
              , description = Some
                  "Structured selectors with producer-owned vocabularies."
              , cardinality = Cardinality.List
              , elementFields = Some NestedRules::{
                , required =
                  [ NestedFieldRule::{
                    , field = "dimension"
                    , description = Some "Dimension being selected."
                    , cardinality = Cardinality.Scalar
                    }
                  , NestedFieldRule::{
                    , field = "operator"
                    , description = Some "Selection operation."
                    , cardinality = Cardinality.Scalar
                    }
                  , NestedFieldRule::{
                    , field = "value"
                    , description = Some "Selection value."
                    , cardinality = Cardinality.Scalar
                    }
                  ]
                , optional = [] : List NestedFieldRule.Type
                }
              }
            , FieldRule::{
              , field = "size"
              , description = Some "Segment size and how it was obtained."
              , cardinality = Cardinality.Any
              , objectFields = Some NestedRules::{
                , required =
                  [ NestedFieldRule::{
                    , field = "count"
                    , description = Some "Numeric population count."
                    , cardinality = Cardinality.Scalar
                    }
                  , NestedFieldRule::{
                    , field = "asOf"
                    , description = Some "Time of the count."
                    , cardinality = Cardinality.Scalar
                    , format = Some FieldFormat.Rfc3339Utc
                    }
                  , NestedFieldRule::{
                    , field = "method"
                    , description = Some "How the count was obtained."
                    , cardinality = Cardinality.Scalar
                    }
                  ]
                , optional = [] : List NestedFieldRule.Type
                }
              }
            , FieldRule::{
              , field = "query"
              , description = Some
                  "Repository-relative file defining membership."
              , cardinality = Cardinality.Scalar
              }
            , FieldRule::{
              , field = "termRefs"
              , description = Some "Canonical vocabulary terms."
              , cardinality = Cardinality.List
              , reference = externalOnly "TERM"
              }
            , FieldRule::{
              , field = "parentSegmentRef"
              , description = Some "Broader Segment."
              , cardinality = Cardinality.Scalar
              , reference = Some HandleReferenceRule::{
                , localPrefix = "SEG"
                , externalUriSchemes = [ "mori" ]
                , externalUriPattern = Some (conceptUri "SEG")
                }
              }
            ]
          }
        }
      , TypeRule::{
        , type = "Persona"
        , description = Some
            "A research-assessed role and context; a persona is not a job."
        , idPrefix = Some "PERSONA"
        , pathPattern = Some "personas/*"
        , frontmatter = FrontmatterRules::{
          , required =
            [ FieldRule::{
              , field = "audienceId"
              , description = Some "Bundle-scoped stable PERSONA-N handle."
              , cardinality = Cardinality.Scalar
              , format = Some (FieldFormat.DocumentHandle "PERSONA")
              }
            , FieldRule::{
              , field = "role"
              , description = Some "Role represented by the persona."
              , cardinality = Cardinality.Scalar
              }
            , FieldRule::{
              , field = "context"
              , description = Some "Circumstances in which the persona acts."
              , cardinality = Cardinality.Scalar
              }
            , FieldRule::{
              , field = "status"
              , description = Some "Persona lifecycle."
              , cardinality = Cardinality.Scalar
              , allowedValues = [ "draft", "active", "retired" ]
              }
            , FieldRule::{
              , field = "validationStatus"
              , description = Some "Research support for this persona."
              , cardinality = Cardinality.Scalar
              , allowedValues =
                [ "untested", "supported", "mixed", "challenged" ]
              }
            , assessment
            ]
          , optional =
            [ FieldRule::{
              , field = "jobRefs"
              , description = Some "Jobs held by this persona."
              , cardinality = Cardinality.List
              , reference = externalOnly "JOB"
              }
            , FieldRule::{
              , field = "segmentRefs"
              , description = Some "Segments containing this persona."
              , cardinality = Cardinality.List
              , reference = Some HandleReferenceRule::{
                , localPrefix = "SEG"
                , externalUriSchemes = [ "mori" ]
                , externalUriPattern = Some (conceptUri "SEG")
                }
              }
            , FieldRule::{
              , field = "goals"
              , description = Some "Producer-described goals."
              , cardinality = Cardinality.List
              }
            , FieldRule::{
              , field = "objections"
              , description = Some "Producer-described objections."
              , cardinality = Cardinality.List
              }
            , FieldRule::{
              , field = "channels"
              , description = Some "Channels used by the persona."
              , cardinality = Cardinality.List
              }
            ]
          }
        , guidance = Some
            "The opt-in check-gtm.py verifies that assessment references name current Findings and that other concept targets have the required types."
        }
      ]
    }
