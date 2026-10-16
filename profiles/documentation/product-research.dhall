--| Profile for customer and product discovery research with stable PR-N handles.
--
-- ## Product research is not technical research
--
-- `documentation.researchDocuments` records technical investigations about
-- building software: which library, which runtime, which design. This profile
-- records what was learned about customers: who was studied, how, what was
-- observed, and what the authors concluded from it. The two have different
-- lifecycles and different handles (`RES-N` and `PR-N`), and neither is
-- converted into the other.
--
--
-- ## Studies and findings are separate concepts sharing one namespace
--
-- A `Product Research Study` is a bounded research activity: a question, a
-- method, a population, and a context. A `Product Research Finding` is one
-- separately citable result of a study. A finding keeps `observation` (what was
-- seen) apart from `interpretation` (the conclusion drawn), so a reader can
-- disagree with the second without disputing the first.
--
-- Both types use `productResearchId` and the `PR` prefix, so one bundle-wide
-- allocator issues their handles while `type` keeps them distinguishable;
-- `documentation.specifications` is the precedent for two types sharing one
-- prefix. A study stores no list of its findings: that inverse is derived from
-- each finding's `studyRef`.
--
--
-- ## What a finding claims about a job
--
-- `jobAssessments` records whether this finding `supports`, `challenges`, or is
-- `inconclusive` about one named claim concerning one canonical job. It does
-- not decide the job's overall `validationStatus`; the job's own `assessment`
-- does that, citing findings explicitly. `measurements` records observed values
-- of a job's measurable outcome, in that outcome's unit.
--
-- okf can check each member's shape but cannot check that a `value` is a finite
-- number, that `periodStart` precedes `periodEnd`, or that `studyRef` names a
-- study rather than another finding. The opt-in
-- `scripts/check-product-discovery.py` gate checks those, and everything else
-- that needs another concept, until okf and Mori own them.
--
--
-- ## References to other profiles are external only
--
-- Jobs live in a bundle governed by `coordination.jobs`. okf requires a
-- reference rule's `localPrefix` to be an `idPrefix` this profile declares, so
-- job references use `PR` with `allowLocal = False` and a JOB-N
-- `externalUriPattern`. `studyRef` and `supersededBy` may be local, because
-- studies and findings normally share a bundle.
--
--
-- ## Presence classes
--
-- Nothing is recommended (ADR-8): a planned study has no findings, no
-- sources, and no review. `reviews` is optional, as in
-- `documentation.specifications`. Raw material such as interview recordings
-- may live outside the bundle and be cited through `sources`; do not copy
-- sensitive transcripts into a concept.
--
-- No `guidance` is declared (ADR-12).
--
--
-- ## `legacyTimestamp` is deliberately absent
--
-- This profile is introduced at v0.2 and no v0.1 product-research corpus
-- exists.
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

let scalar =
      \(name : Text) ->
      \(description : Text) ->
        FieldRule::{
        , field = name
        , description = Some description
        , cardinality = Cardinality.Scalar
        }

let nestedScalar =
      \(name : Text) ->
      \(description : Text) ->
        NestedFieldRule::{
        , field = name
        , description = Some description
        , cardinality = Cardinality.Scalar
        }

let conceptUri =
      \(prefix : Text) ->
        "mori://[^/]+/[^/]+/okf/[^/]+/concepts/${prefix}-[1-9][0-9]*"

-- `PR` is the only prefix this profile declares, so it is the `localPrefix` of
-- every reference, including the job references that are never local.
let externalOnly =
      \(prefix : Text) ->
        Some
          HandleReferenceRule::{
          , localPrefix = "PR"
          , externalUriSchemes = [ "mori" ]
          , allowLocal = False
          , externalUriPattern = Some (conceptUri prefix)
          }

let localOrExternalPR =
      Some
        HandleReferenceRule::{
        , localPrefix = "PR"
        , externalUriSchemes = [ "mori" ]
        , allowSelf = False
        , allowLocal = True
        , externalUriPattern = Some (conceptUri "PR")
        }

let rfc3339 =
      \(name : Text) ->
      \(description : Text) ->
        scalar name description // { format = Some FieldFormat.Rfc3339Utc }

let nestedRfc3339 =
      \(name : Text) ->
      \(description : Text) ->
            nestedScalar name description
        //  { format = Some FieldFormat.Rfc3339Utc }

let productResearchId =
      FieldRule::{
      , field = "productResearchId"
      , description = Some "Bundle-scoped stable PR-N handle."
      , cardinality = Cardinality.Scalar
      , format = Some (FieldFormat.DocumentHandle "PR")
      }

let jobRef =
          nestedScalar "jobRef" "Canonical Mori URI of the job concerned."
      //  { reference = externalOnly "JOB" }

let whenStatus =
      \(hasValue : List Text) -> Some { field = "status", hasValue }

let study =
      TypeRule::{
      , type = "Product Research Study"
      , description = Some
          "A bounded customer research activity with a question, method, and population."
      , frontmatter = FrontmatterRules::{
        , required =
          [ productResearchId
          , scalar "question" "What the study set out to learn."
          ,     scalar
                  "method"
                  "How evidence was gathered; explain `mixed` in the body."
            //  { allowedValues =
                  [ "interview"
                  , "observation"
                  , "survey"
                  , "experiment"
                  , "analytics"
                  , "desk-research"
                  , "mixed"
                  ]
                }
          , scalar "population" "Who was studied, and how they were selected."
          , scalar "context" "Circumstances in which the study took place."
          ,     scalar
                  "status"
                  "Study lifecycle: `planned`, `active`, `complete`, or `cancelled`."
            //  { allowedValues = [ "planned", "active", "complete", "cancelled" ] }
          ,     rfc3339 "completedAt" "UTC RFC3339 time the study completed."
            //  { when = whenStatus [ "complete" ] }
          ,     scalar
                  "limitations"
                  "What the study cannot support, such as sampling or method limits."
            //  { when = whenStatus [ "complete" ] }
          ,     scalar "cancellationReason" "Why the study stopped before completing."
            //  { when = whenStatus [ "cancelled" ] }
          ]
        , optional =
          [ FieldRule::{
            , field = "jobRefs"
            , description = Some "Canonical Mori URIs of the jobs this study investigates."
            , cardinality = Cardinality.List
            , reference = externalOnly "JOB"
            }
          , rfc3339 "startedAt" "UTC RFC3339 time the study began."
          ,     v02.sources
            //  { description = Some
                    "§5.1. Protocols, recruiting material, or prior work the study drew on."
                }
          ]
        }
      , pathPattern = Some "*"
      , idPrefix = Some "PR"
      }

let jobAssessments =
      FieldRule::{
      , field = "jobAssessments"
      , description = Some
          "What this finding says about named claims concerning canonical jobs."
      , cardinality = Cardinality.List
      , elementFields = Some NestedRules::{
        , required =
          [ jobRef
          , nestedScalar "claim" "The specific claim about the job being assessed."
          ,     nestedScalar
                  "stance"
                  "`supports`, `challenges`, or `inconclusive` toward the claim."
            //  { allowedValues = [ "supports", "challenges", "inconclusive" ] }
          , nestedScalar "rationale" "Why the observation bears on the claim."
          ]
        , optional =
          [ nestedScalar
              "outcomeName"
              "Name of the job outcome the claim concerns, when it concerns one."
          ]
        }
      }

let measurements =
      FieldRule::{
      , field = "measurements"
      , description = Some
          "Observed values of a job's measurable outcome, in that outcome's unit."
      , cardinality = Cardinality.List
      , elementFields = Some NestedRules::{
        , required =
          [ nestedScalar "name" "Stable measurement name, unique within this finding."
          , jobRef
          , nestedScalar "outcomeName" "Name of the measured outcome on the job."
          , nestedScalar "value" "Observed finite number in `unit`."
          , nestedScalar "unit" "Unit of `value`; the outcome's declared unit."
          , nestedScalar "method" "How the value was obtained."
          , nestedScalar "population" "Whose behavior the value describes."
          , nestedRfc3339 "periodStart" "UTC RFC3339 start of the observed period."
          , nestedRfc3339 "periodEnd" "UTC RFC3339 end of the observed period."
          ]
        }
      , uniqueBy = Some "name"
      }

let finding =
      TypeRule::{
      , type = "Product Research Finding"
      , description = Some
          "One citable observation from a study and the interpretation drawn from it."
      , frontmatter = FrontmatterRules::{
        , required =
          [ productResearchId
          ,     scalar
                  "studyRef"
                  "Local PR-N handle or canonical Mori URI of the study producing this finding."
            //  { reference = localOrExternalPR }
          , scalar "observation" "What was seen or measured, without interpretation."
          , scalar "interpretation" "The conclusion the authors draw from the observation."
          , scalar "context" "Circumstances in which the observation was made."
          , rfc3339 "observedAt" "UTC RFC3339 time the observation was made."
          , scalar "limitations" "What this finding cannot support."
          ,     v02.sources
            //  { description = Some
                    "§5.1. Raw material the observation rests on, possibly outside the bundle."
                }
          ,     scalar
                  "status"
                  "Finding lifecycle: `current`, `superseded`, or `withdrawn`."
            //  { allowedValues = [ "current", "superseded", "withdrawn" ] }
          ,     scalar
                  "supersededBy"
                  "Local PR-N handle or canonical Mori URI of the replacing finding."
            //  { reference = localOrExternalPR, when = whenStatus [ "superseded" ] }
          ,     scalar "withdrawalReason" "Why the finding no longer stands."
            //  { when = whenStatus [ "withdrawn" ] }
          ]
        , optional = [ jobAssessments, measurements ]
        }
      , pathPattern = Some "*"
      , idPrefix = Some "PR"
      }

in  Profile::{
    , name = "product-research"
    , description = Some
        "Customer and product discovery research with stable PR handles: bounded studies, and separately citable findings that keep observation apart from interpretation and assess named claims about canonical jobs. Distinct from technical research documents."
    , okfVersion = "0.2"
    , requireBundleVersion = Some "0.2"
    , allowUnknownTypes = False
    , idField = Some "productResearchId"
    , frontmatter = FrontmatterRules::{
      , required =
        [ scalar
            "type"
            "The Product Research Study or Product Research Finding concept type."
        , scalar "title" "Human-readable title."
        , scalar "description" "One sentence stating the study or finding."
        ,     v02.generated
          //  { description = Some
                  "§5.2. Who produced this document's current content, and when."
              }
        ]
      , optional =
        [ FieldRule::{
          , field = "tags"
          , description = Some "Producer-defined search and grouping tags."
          , cardinality = Cardinality.List
          }
        , reviewRule
        ,     v02.verified
          //  { description = Some
                  "§5.2. Independent confirmations that this document is accurate. Mirror an approving `reviews` entry here."
              }
        ]
      }
    , -- Study and finding `status` are house vocabularies (ADR-1); this profile
      -- does not splice OKF v0.2 §5.4's `status` or `stale_after`.
      types = [ study, finding ]
    }
