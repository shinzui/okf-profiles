--| Launches use the feature acceptance shape for readiness and the shared sources
-- shape for launch evidence. A planned date never proves publication or outcome.
-- Landing Pages link designs rather than duplicating layout. House lifecycles
-- replace OKF status/staleAfter; drafts need no review or evidence, so nothing is
-- recommended. All foreign references are canonical and external-only; LAUNCH and
-- LP references may be local within this profile. No legacyTimestamp exists.
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
          , localPrefix = "LAUNCH"
          , allowLocal = False
          , externalUriSchemes = [ "mori" ]
          , externalUriPattern = Some (conceptUri prefix)
          }

in  Profile::{
    , name = "launches"
    , description = Some
        "Launches coordinate go-live events; Landing Pages name the surfaces and their evidence."
    , okfVersion = "0.2"
    , requireBundleVersion = Some "0.2"
    , allowUnknownTypes = False
    , idField = Some "launchId"
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
        , type = "Launch"
        , description = Some
            "Coordinated go-live work with a deadline and explicit readiness conditions."
        , idPrefix = Some "LAUNCH"
        , pathPattern = Some "launches/*"
        , frontmatter = FrontmatterRules::{
          , required =
            [ FieldRule::{
              , field = "launchId"
              , description = Some "Bundle-scoped stable LAUNCH-N handle."
              , cardinality = Cardinality.Scalar
              , format = Some (FieldFormat.DocumentHandle "LAUNCH")
              }
            , FieldRule::{
              , field = "status"
              , description = Some "Launch coordination lifecycle."
              , cardinality = Cardinality.Scalar
              , allowedValues = [ "planned", "ready", "launched", "cancelled" ]
              }
            , FieldRule::{
              , field = "liveBy"
              , description = Some "Intended UTC go-live deadline."
              , cardinality = Cardinality.Scalar
              , format = Some FieldFormat.Rfc3339Utc
              }
            , FieldRule::{
              , field = "readiness"
              , description = Some
                  "Conditions for release and how each will be verified; not a pass declaration."
              , cardinality = Cardinality.List
              , when = Some
                { field = "status", hasValue = [ "ready", "launched" ] }
              , elementFields = Some NestedRules::{
                , required =
                  [ NestedFieldRule::{
                    , field = "id"
                    , description = Some "Launch-local AC-N condition handle."
                    , cardinality = Cardinality.Scalar
                    , format = Some (FieldFormat.DocumentHandle "AC")
                    }
                  , NestedFieldRule::{
                    , field = "statement"
                    , description = Some "Observable readiness condition."
                    , cardinality = Cardinality.Scalar
                    }
                  , NestedFieldRule::{
                    , field = "verification"
                    , description = Some
                        "Procedure or evidence that will verify the condition."
                    , cardinality = Cardinality.Scalar
                    }
                  ]
                , optional = [] : List NestedFieldRule.Type
                }
              , uniqueBy = Some "id"
              }
            , FieldRule::{
              , field = "launchedAt"
              , description = Some "Actual UTC launch time."
              , cardinality = Cardinality.Scalar
              , format = Some FieldFormat.Rfc3339Utc
              , when = Some { field = "status", hasValue = [ "launched" ] }
              }
            ,     v02.sources
              //  { field = "launchEvidence"
                  , description = Some
                      "Evidence of the actual launch, in the shared sources shape."
                  , when = Some { field = "status", hasValue = [ "launched" ] }
                  }
            , FieldRule::{
              , field = "cancellationReason"
              , description = Some "Why the launch was cancelled."
              , cardinality = Cardinality.Scalar
              , when = Some { field = "status", hasValue = [ "cancelled" ] }
              }
            ]
          , optional =
            [ FieldRule::{
              , field = "featureRefs"
              , description = Some "Features in the launch."
              , cardinality = Cardinality.List
              , reference = externalOnly "FEAT"
              }
            , FieldRule::{
              , field = "segmentRefs"
              , description = Some "Segments addressed."
              , cardinality = Cardinality.List
              , reference = externalOnly "SEG"
              }
            , FieldRule::{
              , field = "campaignRefs"
              , description = Some "Launch campaigns."
              , cardinality = Cardinality.List
              , reference = externalOnly "CMP"
              }
            , FieldRule::{
              , field = "landingPageRefs"
              , description = Some "Related Landing Pages."
              , cardinality = Cardinality.List
              , reference = Some HandleReferenceRule::{
                , localPrefix = "LP"
                , externalUriSchemes = [ "mori" ]
                , externalUriPattern = Some (conceptUri "LP")
                }
              }
            , FieldRule::{
              , field = "initiativeRef"
              , description = Some "Initiative coordinating the launch."
              , cardinality = Cardinality.Scalar
              , reference = externalOnly "INIT"
              }
            , FieldRule::{
              , field = "chapters"
              , description = Some "Producer chapter labels in scope."
              , cardinality = Cardinality.List
              }
            ]
          }
        , guidance = Some
            "Readiness describes conditions and verification, not that they passed. Launched records a go-live event and evidence, not proof of customer outcome."
        }
      , TypeRule::{
        , type = "Landing Page"
        , description = Some
            "A published or planned GTM surface; design work stays in the designs profile."
        , idPrefix = Some "LP"
        , pathPattern = Some "landing-pages/*"
        , frontmatter = FrontmatterRules::{
          , required =
            [ FieldRule::{
              , field = "launchId"
              , description = Some "Bundle-scoped stable LP-N handle."
              , cardinality = Cardinality.Scalar
              , format = Some (FieldFormat.DocumentHandle "LP")
              }
            , FieldRule::{
              , field = "status"
              , description = Some "Landing-page publication lifecycle."
              , cardinality = Cardinality.Scalar
              , allowedValues = [ "draft", "live", "retired" ]
              }
            , FieldRule::{
              , field = "slug"
              , description = Some "Producer-owned page route."
              , cardinality = Cardinality.Scalar
              }
            , FieldRule::{
              , field = "url"
              , description = Some "Published page URL."
              , cardinality = Cardinality.Scalar
              , format = Some FieldFormat.Uri
              , when = Some { field = "status", hasValue = [ "live" ] }
              }
            , FieldRule::{
              , field = "liveAt"
              , description = Some "Actual UTC publication time."
              , cardinality = Cardinality.Scalar
              , format = Some FieldFormat.Rfc3339Utc
              , when = Some { field = "status", hasValue = [ "live" ] }
              }
            ]
          , optional =
            [ FieldRule::{
              , field = "designRefs"
              , description = Some
                  "Design Brief or Detailed Design URIs for the surface."
              , cardinality = Cardinality.List
              , reference = externalOnly "(BRIEF|DES)"
              }
            , FieldRule::{
              , field = "segmentRefs"
              , description = Some "Segments the page addresses."
              , cardinality = Cardinality.List
              , reference = externalOnly "SEG"
              }
            , FieldRule::{
              , field = "featureRefs"
              , description = Some "Product behavior the page explains."
              , cardinality = Cardinality.List
              , reference = externalOnly "FEAT"
              }
            , FieldRule::{
              , field = "initiativeRef"
              , description = Some "Initiative coordinating the page."
              , cardinality = Cardinality.Scalar
              , reference = externalOnly "INIT"
              }
            , FieldRule::{
              , field = "launchRef"
              , description = Some "Related Launch."
              , cardinality = Cardinality.Scalar
              , reference = Some HandleReferenceRule::{
                , localPrefix = "LAUNCH"
                , externalUriSchemes = [ "mori" ]
                , externalUriPattern = Some (conceptUri "LAUNCH")
                }
              }
            , FieldRule::{
              , field = "claimRefs"
              , description = Some "Claim Checks for factual copy."
              , cardinality = Cardinality.List
              , reference = externalOnly "CLM"
              }
            ]
          }
        }
      ]
    }
