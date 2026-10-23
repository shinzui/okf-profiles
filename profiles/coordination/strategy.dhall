--| Strategy coordinates intended outcomes and work, beside campaigns and features.
-- Key results reuse job measurement members and store aspirations, not observed
-- current values. Assessments cite Findings or Claim Checks. Strategic Theme is
-- separate from Use Case Theme. No engineering-project, pricing or competitor type
-- is introduced. House status replaces OKF status/staleAfter; no legacyTimestamp.
-- Nothing is recommended: untested drafts legitimately lack reviews and evidence.
-- References crossing profiles are canonical and external-only; local references
-- join the three strategy types. check-gtm.py owns unsupported cross-record checks.
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
          , localPrefix = "THEME"
          , allowLocal = False
          , externalUriSchemes = [ "mori" ]
          , externalUriPattern = Some (conceptUri prefix)
          }

let hypothesis = ../../Profile/Hypothesis.dhall

in  Profile::{
    , name = "strategy"
    , description = Some
        "Strategic Themes group time-bounded Objectives and coordinated Initiatives."
    , okfVersion = "0.2"
    , requireBundleVersion = Some "0.2"
    , allowUnknownTypes = False
    , idField = Some "strategyId"
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
        , type = "Strategic Theme"
        , description = Some
            "A persistent strategic direction grouping objectives and initiatives."
        , idPrefix = Some "THEME"
        , pathPattern = Some "themes/*"
        , frontmatter = FrontmatterRules::{
          , required =
            [ FieldRule::{
              , field = "strategyId"
              , description = Some "Bundle-scoped stable THEME-N handle."
              , cardinality = Cardinality.Scalar
              , format = Some (FieldFormat.DocumentHandle "THEME")
              }
            , FieldRule::{
              , field = "status"
              , description = Some "Strategic theme lifecycle."
              , cardinality = Cardinality.Scalar
              , allowedValues = [ "active", "retired" ]
              }
            ]
          , optional = [] : List FieldRule.Type
          }
        }
      , TypeRule::{
        , type = "Objective"
        , description = Some
            "A time-bounded intended outcome with explicit key-result targets."
        , idPrefix = Some "OBJ"
        , pathPattern = Some "objectives/*"
        , frontmatter = FrontmatterRules::{
          , required =
            [ FieldRule::{
              , field = "strategyId"
              , description = Some "Bundle-scoped stable OBJ-N handle."
              , cardinality = Cardinality.Scalar
              , format = Some (FieldFormat.DocumentHandle "OBJ")
              }
            , FieldRule::{
              , field = "periodStart"
              , description = Some "UTC start of the objective period."
              , cardinality = Cardinality.Scalar
              , format = Some FieldFormat.Rfc3339Utc
              }
            , FieldRule::{
              , field = "periodEnd"
              , description = Some "UTC end of the objective period."
              , cardinality = Cardinality.Scalar
              , format = Some FieldFormat.Rfc3339Utc
              }
            , FieldRule::{
              , field = "status"
              , description = Some "Objective commitment and result lifecycle."
              , cardinality = Cardinality.Scalar
              , allowedValues =
                [ "draft", "committed", "achieved", "missed", "dropped" ]
              }
            , FieldRule::{
              , field = "keyResults"
              , description = Some
                  "Objective-local targets; observed values belong in cited evidence."
              , cardinality = Cardinality.List
              , elementFields = Some NestedRules::{
                , required =
                  [ NestedFieldRule::{
                    , field = "id"
                    , description = Some "Objective-local KR-N handle."
                    , cardinality = Cardinality.Scalar
                    , format = Some (FieldFormat.DocumentHandle "KR")
                    }
                  , NestedFieldRule::{
                    , field = "metric"
                    , description = Some "What is measured."
                    , cardinality = Cardinality.Scalar
                    }
                  , NestedFieldRule::{
                    , field = "unit"
                    , description = Some "Unit of the target."
                    , cardinality = Cardinality.Scalar
                    }
                  , NestedFieldRule::{
                    , field = "direction"
                    , description = Some "Desired direction of change."
                    , cardinality = Cardinality.Scalar
                    , allowedValues = [ "increase", "decrease", "maintain" ]
                    }
                  , NestedFieldRule::{
                    , field = "target"
                    , description = Some
                        "Finite numeric aspiration, never an observed value."
                    , cardinality = Cardinality.Scalar
                    }
                  ]
                , optional =
                  [ NestedFieldRule::{
                    , field = "method"
                    , description = Some "How the result will be measured."
                    , cardinality = Cardinality.Scalar
                    }
                  , NestedFieldRule::{
                    , field = "baseline"
                    , description = Some "Finite numeric starting point."
                    , cardinality = Cardinality.Scalar
                    }
                  , NestedFieldRule::{
                    , field = "population"
                    , description = Some "Population the target describes."
                    , cardinality = Cardinality.Scalar
                    }
                  , NestedFieldRule::{
                    , field = "jobRef"
                    , description = Some
                        "Canonical job URI for an outcome pair."
                    , cardinality = Cardinality.Scalar
                    , reference = externalOnly "JOB"
                    }
                  , NestedFieldRule::{
                    , field = "outcomeName"
                    , description = Some
                        "Name of an outcome on the referenced job."
                    , cardinality = Cardinality.Scalar
                    }
                  ]
                }
              , uniqueBy = Some "id"
              }
            , FieldRule::{
              , field = "assessment"
              , description = Some
                  "Evidence-based assessment of the objective result."
              , cardinality = Cardinality.Any
              , when = Some
                { field = "status", hasValue = [ "achieved", "missed" ] }
              , objectFields = Some NestedRules::{
                , required =
                  [ NestedFieldRule::{
                    , field = "rationale"
                    , description = Some
                        "Why the evidence justifies the declared result."
                    , cardinality = Cardinality.Scalar
                    }
                  , NestedFieldRule::{
                    , field = "assessedAt"
                    , description = Some "UTC assessment time."
                    , cardinality = Cardinality.Scalar
                    , format = Some FieldFormat.Rfc3339Utc
                    }
                  , NestedFieldRule::{
                    , field = "evidenceRefs"
                    , description = Some
                        "Canonical Finding or Claim Check URIs."
                    , cardinality = Cardinality.List
                    , reference = externalOnly "(PR|CLM)"
                    }
                  ]
                , optional = [] : List NestedFieldRule.Type
                }
              }
            , FieldRule::{
              , field = "dropReason"
              , description = Some "Why the objective was dropped."
              , cardinality = Cardinality.Scalar
              , when = Some { field = "status", hasValue = [ "dropped" ] }
              }
            ]
          , optional =
            [ FieldRule::{
              , field = "owners"
              , description = Some "Accountable actors."
              , cardinality = Cardinality.List
              , format = Some FieldFormat.Actor
              }
            , FieldRule::{
              , field = "themeRef"
              , description = Some "Strategic Theme for this objective."
              , cardinality = Cardinality.Scalar
              , reference = Some HandleReferenceRule::{
                , localPrefix = "THEME"
                , externalUriSchemes = [ "mori" ]
                , externalUriPattern = Some (conceptUri "THEME")
                }
              }
            ]
          }
        , guidance = Some
            "Achieved or missed is an author assessment of cited evidence, never inferred from delivery. The opt-in check-gtm.py checks numeric targets, ordered periods and key-result outcome pairs and resolves assessment evidence to Findings or Claim Checks."
        }
      , TypeRule::{
        , type = "Initiative"
        , description = Some
            "Coordinated product, growth, marketing or operations work; not an engineering implementation project."
        , idPrefix = Some "INIT"
        , pathPattern = Some "initiatives/*"
        , frontmatter = FrontmatterRules::{
          , required =
            [ FieldRule::{
              , field = "strategyId"
              , description = Some "Bundle-scoped stable INIT-N handle."
              , cardinality = Cardinality.Scalar
              , format = Some (FieldFormat.DocumentHandle "INIT")
              }
            , FieldRule::{
              , field = "kind"
              , description = Some "Kind of coordinated work."
              , cardinality = Cardinality.Scalar
              , allowedValues =
                [ "product", "growth", "marketing", "operations" ]
              }
            , FieldRule::{
              , field = "status"
              , description = Some
                  "Initiative commitment and execution lifecycle."
              , cardinality = Cardinality.Scalar
              , allowedValues =
                [ "proposed", "committed", "active", "done", "killed" ]
              }
            , FieldRule::{
              , field = "themeRef"
              , description = Some "Strategic Theme guiding this initiative."
              , cardinality = Cardinality.Scalar
              , reference = Some HandleReferenceRule::{
                , localPrefix = "THEME"
                , externalUriSchemes = [ "mori" ]
                , externalUriPattern = Some (conceptUri "THEME")
                }
              }
            , FieldRule::{
              , field = "killedReason"
              , description = Some "Why the initiative was killed."
              , cardinality = Cardinality.Scalar
              , when = Some { field = "status", hasValue = [ "killed" ] }
              }
            , FieldRule::{
              , field = "outcome"
              , description = Some
                  "What resulted from the completed initiative."
              , cardinality = Cardinality.Scalar
              , when = Some { field = "status", hasValue = [ "done" ] }
              }
            ]
          , optional =
            [ FieldRule::{
              , field = "objectiveRefs"
              , description = Some "Objectives this initiative serves."
              , cardinality = Cardinality.List
              , reference = Some HandleReferenceRule::{
                , localPrefix = "OBJ"
                , externalUriSchemes = [ "mori" ]
                , externalUriPattern = Some (conceptUri "OBJ")
                }
              }
            , FieldRule::{
              , field = "keyResultRefs"
              , description = Some
                  "Objective-local key results this initiative serves."
              , cardinality = Cardinality.List
              , elementFields = Some NestedRules::{
                , required =
                  [ NestedFieldRule::{
                    , field = "objectiveRef"
                    , description = Some "Objective holding the key result."
                    , cardinality = Cardinality.Scalar
                    , reference = Some HandleReferenceRule::{
                      , localPrefix = "OBJ"
                      , externalUriSchemes = [ "mori" ]
                      , externalUriPattern = Some (conceptUri "OBJ")
                      }
                    }
                  , NestedFieldRule::{
                    , field = "krId"
                    , description = Some "Key-result id on that objective."
                    , cardinality = Cardinality.Scalar
                    , format = Some (FieldFormat.DocumentHandle "KR")
                    }
                  ]
                , optional = [] : List NestedFieldRule.Type
                }
              }
            , hypothesis
            , FieldRule::{
              , field = "studyRef"
              , description = Some "Canonical experiment Study URI."
              , cardinality = Cardinality.Scalar
              , reference = externalOnly "PR"
              }
            , FieldRule::{
              , field = "owners"
              , description = Some "Accountable actors."
              , cardinality = Cardinality.List
              , format = Some FieldFormat.Actor
              }
            , FieldRule::{
              , field = "featureRefs"
              , description = Some "Features contributing product behavior."
              , cardinality = Cardinality.List
              , reference = externalOnly "FEAT"
              }
            , FieldRule::{
              , field = "campaignRefs"
              , description = Some
                  "Campaigns contributing coordinated GTM work."
              , cardinality = Cardinality.List
              , reference = externalOnly "CMP"
              }
            , FieldRule::{
              , field = "segmentRefs"
              , description = Some "Audience Segments served."
              , cardinality = Cardinality.List
              , reference = externalOnly "SEG"
              }
            , FieldRule::{
              , field = "launchRefs"
              , description = Some "Related launches."
              , cardinality = Cardinality.List
              , reference = externalOnly "LAUNCH"
              }
            , FieldRule::{
              , field = "dependsOn"
              , description = Some "Initiatives that must precede this work."
              , cardinality = Cardinality.List
              , reference = Some HandleReferenceRule::{
                , localPrefix = "INIT"
                , externalUriSchemes = [ "mori" ]
                , externalUriPattern = Some (conceptUri "INIT")
                }
              }
            , FieldRule::{
              , field = "parentInitiativeRef"
              , description = Some "Broader Initiative containing this work."
              , cardinality = Cardinality.Scalar
              , reference = Some HandleReferenceRule::{
                , localPrefix = "INIT"
                , externalUriSchemes = [ "mori" ]
                , externalUriPattern = Some (conceptUri "INIT")
                }
              }
            , FieldRule::{
              , field = "wave"
              , description = Some "Producer-defined sequencing wave."
              , cardinality = Cardinality.Scalar
              }
            , FieldRule::{
              , field = "size"
              , description = Some "Producer-defined size estimate."
              , cardinality = Cardinality.Scalar
              }
            ]
          }
        , guidance = Some
            "The opt-in check-gtm.py resolves objective-local key-result ids and requires studyRef to name an experiment Study; initiative delivery does not establish customer outcome."
        }
      ]
    }
