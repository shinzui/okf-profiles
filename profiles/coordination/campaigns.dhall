--| Campaigns are coordinated work with a lifecycle, beside features and designs.
-- Readouts reuse product-research Studies and Findings; reviews use ReviewRule.
-- External-only references use this profile’s CMP prefix as the engine requires,
-- then constrain the foreign handle by a canonical URI pattern. Nothing is
-- recommended: draft campaigns may have no review or evidence. Status is a house
-- vocabulary, so OKF status/staleAfter are absent (ADR-1). legacyTimestamp is absent
-- because this shared profile starts at v0.2. Unsupported conjunctions and target
-- types are enforced by the opt-in check-gtm.py, not a wider schema.
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
          , localPrefix = "CMP"
          , allowLocal = False
          , externalUriSchemes = [ "mori" ]
          , externalUriPattern = Some (conceptUri prefix)
          }

let hypothesis = ../../Profile/Hypothesis.dhall

in  Profile::{
    , name = "campaigns"
    , description = Some
        "Campaigns and their emails coordinate purpose, audience, delivery and research evaluation."
    , okfVersion = "0.2"
    , requireBundleVersion = Some "0.2"
    , allowUnknownTypes = False
    , idField = Some "campaignId"
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
        , type = "Campaign"
        , description = Some
            "Coordinated work carrying a hypothesis, announcement, or engagement purpose."
        , idPrefix = Some "CMP"
        , pathPattern = Some "*/campaign"
        , frontmatter = FrontmatterRules::{
          , required =
            [ FieldRule::{
              , field = "campaignId"
              , description = Some "Bundle-scoped stable CMP-N handle."
              , cardinality = Cardinality.Scalar
              , format = Some (FieldFormat.DocumentHandle "CMP")
              }
            , FieldRule::{
              , field = "purpose"
              , description = Some
                  "Primary purpose of the coordinated campaign."
              , cardinality = Cardinality.Scalar
              , allowedValues = [ "hypothesis", "announcement", "engagement" ]
              }
            , FieldRule::{
              , field = "status"
              , description = Some "Campaign coordination lifecycle."
              , cardinality = Cardinality.Scalar
              , allowedValues =
                [ "drafting"
                , "in-review"
                , "approved"
                , "sending"
                , "measuring"
                , "read-out"
                , "cancelled"
                ]
              }
            , FieldRule::{
              , field = "owners"
              , description = Some
                  "Actors or canonical Mori URIs accountable for the campaign."
              , cardinality = Cardinality.List
              }
            ,     hypothesis
              //  { when = Some
                    { field = "purpose", hasValue = [ "hypothesis" ] }
                  }
            , FieldRule::{
              , field = "announcement"
              , description = Some
                  "Announced features and intended availability."
              , cardinality = Cardinality.Any
              , when = Some { field = "purpose", hasValue = [ "announcement" ] }
              , objectFields = Some NestedRules::{
                , required =
                  [ NestedFieldRule::{
                    , field = "featureRefs"
                    , description = Some
                        "Canonical URIs of the announced Features."
                    , cardinality = Cardinality.List
                    , reference = externalOnly "FEAT"
                    }
                  , NestedFieldRule::{
                    , field = "liveBy"
                    , description = Some "Intended availability deadline."
                    , cardinality = Cardinality.Scalar
                    , format = Some FieldFormat.Rfc3339Utc
                    }
                  ]
                , optional = [] : List NestedFieldRule.Type
                }
              }
            , FieldRule::{
              , field = "engagement"
              , description = Some "Behavior this campaign seeks and why."
              , cardinality = Cardinality.Any
              , when = Some { field = "purpose", hasValue = [ "engagement" ] }
              , objectFields = Some NestedRules::{
                , required =
                  [ NestedFieldRule::{
                    , field = "behavior"
                    , description = Some "The behavior to encourage."
                    , cardinality = Cardinality.Scalar
                    }
                  , NestedFieldRule::{
                    , field = "why"
                    , description = Some "Why the behavior matters."
                    , cardinality = Cardinality.Scalar
                    }
                  ]
                , optional = [] : List NestedFieldRule.Type
                }
              }
            , FieldRule::{
              , field = "readout"
              , description = Some
                  "Decision and research findings evaluating the campaign."
              , cardinality = Cardinality.Any
              , when = Some { field = "status", hasValue = [ "read-out" ] }
              , objectFields = Some NestedRules::{
                , required =
                  [ NestedFieldRule::{
                    , field = "decision"
                    , description = Some
                        "Decision taken in light of the findings."
                    , cardinality = Cardinality.Scalar
                    }
                  , NestedFieldRule::{
                    , field = "findingRefs"
                    , description = Some "Canonical result Finding URIs."
                    , cardinality = Cardinality.List
                    , reference = externalOnly "PR"
                    }
                  ]
                , optional = [] : List NestedFieldRule.Type
                }
              }
            , FieldRule::{
              , field = "cancellationReason"
              , description = Some "Why the campaign was cancelled."
              , cardinality = Cardinality.Scalar
              , when = Some { field = "status", hasValue = [ "cancelled" ] }
              }
            ]
          , optional =
            [ FieldRule::{
              , field = "secondaryPurposes"
              , description = Some
                  "Additional purposes whose blocks also apply."
              , cardinality = Cardinality.List
              , allowedValues = [ "hypothesis", "announcement", "engagement" ]
              }
            , FieldRule::{
              , field = "audienceRefs"
              , description = Some "Canonical audience Segment URIs."
              , cardinality = Cardinality.List
              , reference = externalOnly "SEG"
              }
            , FieldRule::{
              , field = "audience"
              , description = Some
                  "Inline audience definitions for a corpus without a Segment bundle."
              , cardinality = Cardinality.List
              , elementFields = Some NestedRules::{
                , required =
                  [ NestedFieldRule::{
                    , field = "segment"
                    , description = Some "Segment name."
                    , cardinality = Cardinality.Scalar
                    }
                  , NestedFieldRule::{
                    , field = "definition"
                    , description = Some "Queryable population definition."
                    , cardinality = Cardinality.Scalar
                    }
                  , NestedFieldRule::{
                    , field = "size"
                    , description = Some "Population size at the stated time."
                    , cardinality = Cardinality.Scalar
                    }
                  , NestedFieldRule::{
                    , field = "asOf"
                    , description = Some "Time the population size describes."
                    , cardinality = Cardinality.Scalar
                    , format = Some FieldFormat.Rfc3339Utc
                    }
                  ]
                , optional = [] : List NestedFieldRule.Type
                }
              }
            , FieldRule::{
              , field = "primaryMetric"
              , description = Some
                  "Primary evaluation metric; observed values belong in findings or claim checks."
              , cardinality = Cardinality.Any
              , objectFields = Some NestedRules::{
                , required =
                  [ NestedFieldRule::{
                    , field = "name"
                    , description = Some "Stable name for this metric."
                    , cardinality = Cardinality.Scalar
                    }
                  , NestedFieldRule::{
                    , field = "metric"
                    , description = Some "What is counted or measured."
                    , cardinality = Cardinality.Scalar
                    }
                  , NestedFieldRule::{
                    , field = "unit"
                    , description = Some "Unit of measurement."
                    , cardinality = Cardinality.Scalar
                    }
                  , NestedFieldRule::{
                    , field = "direction"
                    , description = Some "Desired direction of change."
                    , cardinality = Cardinality.Scalar
                    , allowedValues = [ "increase", "decrease", "maintain" ]
                    }
                  , NestedFieldRule::{
                    , field = "method"
                    , description = Some "How the metric is obtained."
                    , cardinality = Cardinality.Scalar
                    }
                  , NestedFieldRule::{
                    , field = "population"
                    , description = Some "Population described by the metric."
                    , cardinality = Cardinality.Scalar
                    }
                  , NestedFieldRule::{
                    , field = "period"
                    , description = Some "Observation period for the baseline."
                    , cardinality = Cardinality.Scalar
                    }
                  ]
                , optional =
                  [ NestedFieldRule::{
                    , field = "baseline"
                    , description = Some
                        "Numeric starting value; evidence, not a target."
                    , cardinality = Cardinality.Scalar
                    }
                  ]
                }
              }
            , FieldRule::{
              , field = "window"
              , description = Some "Campaign evaluation interval."
              , cardinality = Cardinality.Any
              , objectFields = Some NestedRules::{
                , required =
                  [ NestedFieldRule::{
                    , field = "from"
                    , description = Some "Start of the evaluation window."
                    , cardinality = Cardinality.Scalar
                    , format = Some FieldFormat.Rfc3339Utc
                    }
                  , NestedFieldRule::{
                    , field = "to"
                    , description = Some "End of the evaluation window."
                    , cardinality = Cardinality.Scalar
                    , format = Some FieldFormat.Rfc3339Utc
                    }
                  ]
                , optional = [] : List NestedFieldRule.Type
                }
              }
            , FieldRule::{
              , field = "outcomeRefs"
              , description = Some
                  "Named job outcomes this work is intended to move."
              , cardinality = Cardinality.List
              , elementFields = Some NestedRules::{
                , required =
                  [ NestedFieldRule::{
                    , field = "jobRef"
                    , description = Some "Canonical job URI."
                    , cardinality = Cardinality.Scalar
                    , reference = externalOnly "JOB"
                    }
                  , NestedFieldRule::{
                    , field = "outcomeName"
                    , description = Some
                        "Name of an outcome declared by that job."
                    , cardinality = Cardinality.Scalar
                    }
                  ]
                , optional = [] : List NestedFieldRule.Type
                }
              }
            , FieldRule::{
              , field = "jobRefs"
              , description = Some "Customer jobs this campaign serves."
              , cardinality = Cardinality.List
              , reference = externalOnly "JOB"
              }
            , FieldRule::{
              , field = "studyRef"
              , description = Some "Canonical experiment Study URI."
              , cardinality = Cardinality.Scalar
              , reference = externalOnly "PR"
              }
            , FieldRule::{
              , field = "launchRef"
              , description = Some "Canonical Launch URI."
              , cardinality = Cardinality.Scalar
              , reference = externalOnly "LAUNCH"
              }
            , FieldRule::{
              , field = "chapters"
              , description = Some "Chapter labels in scope."
              , cardinality = Cardinality.List
              }
            ]
          }
        , guidance = Some
            "Approval and sending require the responsible owners’ actual review and send evidence; dates alone never promote the lifecycle. The opt-in check-gtm.py verifies secondary purpose blocks, experiment-study targets, result-finding targets, metric context and reference targets that descriptors cannot express."
        }
      , TypeRule::{
        , type = "Campaign Email"
        , description = Some
            "One email or regional variant in a coordinated campaign."
        , idPrefix = Some "EMAIL"
        , pathPattern = Some "*/emails/*"
        , frontmatter = FrontmatterRules::{
          , required =
            [ FieldRule::{
              , field = "campaignId"
              , description = Some "Bundle-scoped stable EMAIL-N handle."
              , cardinality = Cardinality.Scalar
              , format = Some (FieldFormat.DocumentHandle "EMAIL")
              }
            , FieldRule::{
              , field = "campaignRef"
              , description = Some "Campaign this email belongs to."
              , cardinality = Cardinality.Scalar
              , reference = Some HandleReferenceRule::{
                , localPrefix = "CMP"
                , externalUriSchemes = [ "mori" ]
                , externalUriPattern = Some (conceptUri "CMP")
                }
              }
            , FieldRule::{
              , field = "sequence"
              , description = Some
                  "Ordering within the campaign; variants may share it."
              , cardinality = Cardinality.Scalar
              }
            , FieldRule::{
              , field = "status"
              , description = Some "Email preparation and send lifecycle."
              , cardinality = Cardinality.Scalar
              , allowedValues =
                [ "draft", "approved", "scheduled", "sent", "cancelled" ]
              }
            , FieldRule::{
              , field = "sentAt"
              , description = Some "Actual send time."
              , cardinality = Cardinality.Scalar
              , format = Some FieldFormat.Rfc3339Utc
              , when = Some { field = "status", hasValue = [ "sent" ] }
              }
            ]
          , optional =
            [ FieldRule::{
              , field = "subject"
              , description = Some "Chosen subject line."
              , cardinality = Cardinality.Scalar
              }
            , FieldRule::{
              , field = "subjectVariants"
              , description = Some "Producer-owned subject variants."
              , cardinality = Cardinality.Any
              }
            , FieldRule::{
              , field = "cta"
              , description = Some "Call to action."
              , cardinality = Cardinality.Scalar
              }
            , FieldRule::{
              , field = "sendBy"
              , description = Some "Planned send deadline."
              , cardinality = Cardinality.Scalar
              , format = Some FieldFormat.Rfc3339Utc
              }
            , FieldRule::{
              , field = "audienceRefs"
              , description = Some "Audience Segment URIs."
              , cardinality = Cardinality.List
              , reference = externalOnly "SEG"
              }
            , FieldRule::{
              , field = "landingPageRef"
              , description = Some "Canonical Landing Page URI."
              , cardinality = Cardinality.Scalar
              , reference = externalOnly "LP"
              }
            ]
          }
        }
      ]
    }
