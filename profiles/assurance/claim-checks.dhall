--| A Claim Check is assurance: it records that wording was tested against data.
-- It differs from verificationEvidence (software runs) and product-research Findings
-- (customer observations). measured is evidence for copy, not a job-outcome measure.
-- verdict is the house result vocabulary; this result record deliberately takes
-- neither OKF status nor staleAfter, as event assurance already does (ADR-15).
-- No recommended fields and no legacyTimestamp: unchecked drafts have no evidence,
-- and the shared type starts at v0.2. Foreign concept references are canonical;
-- query/computation alternatives and target types belong to check-gtm.py.
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
          , localPrefix = "CLM"
          , allowLocal = False
          , externalUriSchemes = [ "mori" ]
          , externalUriPattern = Some (conceptUri prefix)
          }

in  Profile::{
    , name = "claim-checks"
    , description = Some
        "Claim Checks record what wording was checked, by whom, against what evidence, and the result."
    , okfVersion = "0.2"
    , requireBundleVersion = Some "0.2"
    , allowUnknownTypes = False
    , idField = Some "claimId"
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
        , type = "Claim Check"
        , description = Some
            "Evidence that a specific statement was checked against data."
        , idPrefix = Some "CLM"
        , pathPattern = Some "**"
        , frontmatter = FrontmatterRules::{
          , required =
            [ FieldRule::{
              , field = "claimId"
              , description = Some "Bundle-scoped stable CLM-N handle."
              , cardinality = Cardinality.Scalar
              , format = Some (FieldFormat.DocumentHandle "CLM")
              }
            , FieldRule::{
              , field = "statement"
              , description = Some "Exact wording that was checked."
              , cardinality = Cardinality.Scalar
              }
            , FieldRule::{
              , field = "usedIn"
              , description = Some
                  "Canonical concept URIs or repository paths where the statement is used."
              , cardinality = Cardinality.List
              }
            , FieldRule::{
              , field = "verdict"
              , description = Some
                  "Result of comparing the statement with evidence."
              , cardinality = Cardinality.Scalar
              , allowedValues =
                [ "unchecked", "match", "close", "wrong", "cannot-verify" ]
              }
            , FieldRule::{
              , field = "checkedBy"
              , description = Some "Actor who performed the check."
              , cardinality = Cardinality.Scalar
              , format = Some FieldFormat.Actor
              , when = Some
                { field = "verdict"
                , hasValue = [ "match", "close", "wrong", "cannot-verify" ]
                }
              }
            , FieldRule::{
              , field = "measured"
              , description = Some "What the evidence actually establishes."
              , cardinality = Cardinality.Scalar
              , when = Some
                { field = "verdict", hasValue = [ "match", "close", "wrong" ] }
              }
            , FieldRule::{
              , field = "asOf"
              , description = Some "UTC time the measurement describes."
              , cardinality = Cardinality.Scalar
              , format = Some FieldFormat.Rfc3339Utc
              , when = Some
                { field = "verdict", hasValue = [ "match", "close", "wrong" ] }
              }
            , FieldRule::{
              , field = "suggestedWording"
              , description = Some "Accurate replacement wording."
              , cardinality = Cardinality.Scalar
              , when = Some
                { field = "verdict", hasValue = [ "close", "wrong" ] }
              }
            , FieldRule::{
              , field = "unverifiableBecause"
              , description = Some "Why this statement cannot be verified."
              , cardinality = Cardinality.Scalar
              , when = Some
                { field = "verdict", hasValue = [ "cannot-verify" ] }
              }
            ]
          , optional =
            [ FieldRule::{
              , field = "query"
              , description = Some
                  "Repository-relative file holding the checking query."
              , cardinality = Cardinality.Scalar
              }
            , FieldRule::{
              , field = "computationRef"
              , description = Some "Canonical Attested Computation URI."
              , cardinality = Cardinality.Scalar
              , format = Some (FieldFormat.UriWithScheme "mori")
              }
            , FieldRule::{
              , field = "stated"
              , description = Some "The value as stated in the copy."
              , cardinality = Cardinality.Scalar
              }
            ]
          }
        , guidance = Some
            "The opt-in check-gtm.py requires query or computation evidence for measured verdicts and verifies referenced artifact targets and local query files."
        }
      ]
    }
