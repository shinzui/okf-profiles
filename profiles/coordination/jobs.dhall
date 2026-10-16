--| Profile for canonical customer jobs with stable JOB-N handles.
--
-- ## What a job is
--
-- A job, in the Jobs-to-be-Done sense, is the progress a person is trying to
-- make in a particular situation, stated independently of any product, screen,
-- or implementation. A job stays `active` when one attempted solution fails:
-- the failure is evidence about the solution, not about whether the customer
-- still wants to make progress.
--
-- A use case may still carry an inline `jobs` record describing one scenario's
-- actor and circumstances. That record is a scenario snapshot; a `Job` concept
-- is the canonical statement the snapshot links to through `jobs[].jobRef`.
--
--
-- ## Research support is a declaration, not a computation
--
-- `validationStatus` says what the authors currently believe about whether
-- research supports this statement of the job: `untested`, `supported`,
-- `mixed`, or `challenged`. Anything other than `untested` demands an
-- `assessment` naming the product-research findings it synthesises and the
-- reasoning that connects them. Support is never derived by counting finding
-- stances, and it is never inferred from `verified`, which confirms that the
-- document is accurate rather than that the job is real.
--
--
-- ## Outcomes may be qualitative
--
-- Each outcome needs only a `name` and a `description`. The measurement
-- members (`metric`, `unit`, `direction`, `method`, `baseline`, `target`,
-- `population`, `period`) are optional because many jobs are understood
-- before anyone can measure them. okf cannot express "all of these or none of
-- these" between nested members, nor a general finite-number format, so the
-- opt-in `scripts/check-product-discovery.py` gate enforces that a measured
-- outcome names its metric, unit, direction, and method together, and that
-- `baseline` and `target` are finite numbers. A `target` is an aspiration and
-- never an observation; an observed value belongs in a finding's
-- `measurements`.
--
--
-- ## References to other profiles are external only
--
-- `assessment.findingRefs` names product-research findings, which live in a
-- bundle governed by `documentation.productResearch`. okf requires a reference
-- rule's `localPrefix` to be an `idPrefix` this profile declares, so the rule
-- uses `JOB` with `allowLocal = False` and constrains the target family with
-- `externalUriPattern`. Declaring a foreign `PR` prefix here would be a
-- profile load failure. Whether a cited finding exists, is a finding rather
-- than a study, and actually assesses this job is a cross-bundle question that
-- okf leaves to Mori; until Mori resolves it, the opt-in gate does.
--
--
-- ## Presence classes
--
-- Nothing is recommended. Per ADR-8 a field is recommended only when a
-- well-run corpus carries it, and an untested draft job routinely has no
-- review, no sources, and no assessment. `reviews` is optional for the same
-- reason `documentation.specifications` makes it optional: a draft nobody has
-- reviewed yet is complete for what it is.
--
-- No `guidance` is declared (ADR-12): there is no observed authoring failure
-- to correct yet.
--
--
-- ## `legacyTimestamp` is deliberately absent
--
-- This profile is introduced at v0.2 and no v0.1 job corpus exists.
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

-- A concept URI in some producer's bundle; the bundle name is the producer's
-- choice, so it is never hard-coded.
let conceptUri =
      \(prefix : Text) ->
        "mori://[^/]+/[^/]+/okf/[^/]+/concepts/${prefix}-[1-9][0-9]*"

-- `JOB` is the only prefix this profile declares, so it is the `localPrefix`
-- of every reference, including ones that may never be local.
let externalOnly =
      \(prefix : Text) ->
        Some
          HandleReferenceRule::{
          , localPrefix = "JOB"
          , externalUriSchemes = [ "mori" ]
          , allowLocal = False
          , externalUriPattern = Some (conceptUri prefix)
          }

let outcomes =
      FieldRule::{
      , field = "outcomes"
      , description = Some
          "Desired results that show the job's progress, qualitative or measured."
      , cardinality = Cardinality.List
      , elementFields = Some NestedRules::{
        , required =
          [ nestedScalar "name" "Stable outcome name, unique within this job."
          , nestedScalar
              "description"
              "What the actor would observe when this outcome is achieved."
          ]
        , optional =
          [ nestedScalar "metric" "What is measured to track this outcome."
          , nestedScalar "unit" "Unit every baseline, target, and measurement uses."
          ,     nestedScalar
                  "direction"
                  "Which way the metric should move: `increase`, `decrease`, or `maintain`."
            //  { allowedValues = [ "increase", "decrease", "maintain" ] }
          , nestedScalar "method" "How the metric is obtained."
          , nestedScalar
              "baseline"
              "Measured starting value in `unit`, documented by a `sources` entry."
          , nestedScalar
              "target"
              "Aspired value in `unit`; never an observation."
          , nestedScalar "population" "Whose behavior the baseline describes."
          , nestedScalar "period" "When the baseline was observed."
          ]
        }
      , uniqueBy = Some "name"
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
    , name = "jobs"
    , description = Some
        "Canonical Jobs-to-be-Done statements with stable JOB handles: the progress an actor seeks in a situation, qualitative or measured outcomes, and an explicit research assessment citing product-research findings. States customer progress, never a solution."
    , okfVersion = "0.2"
    , requireBundleVersion = Some "0.2"
    , allowUnknownTypes = False
    , idField = Some "jobId"
    , frontmatter = FrontmatterRules::{
      , required =
        [ scalar "type" "The Job concept type."
        , scalar "title" "Short name for the progress the actor seeks."
        , scalar "description" "One sentence stating the job."
        ,     v02.generated
          //  { description = Some
                  "§5.2. Who produced this job's current content, and when."
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
    , -- `status` and `validationStatus` are house vocabularies (ADR-1); this
      -- profile does not splice OKF v0.2 §5.4's `status` or `stale_after`. See
      -- the header of ../../Profile/V02.dhall.
      types =
      [ TypeRule::{
        , type = "Job"
        , description = Some
            "Progress an actor seeks in a situation, independent of any solution."
        , frontmatter = FrontmatterRules::{
          , required =
            [ FieldRule::{
              , field = "jobId"
              , description = Some "Bundle-scoped stable JOB-N handle."
              , cardinality = Cardinality.Scalar
              , format = Some (FieldFormat.DocumentHandle "JOB")
              }
            , scalar "actor" "Person or role trying to make progress."
            , scalar "situation" "Circumstance in which the job arises."
            , scalar "motivation" "Progress the actor wants to make."
            ,     scalar
                    "status"
                    "Lifecycle of this job statement: `draft`, `active`, or `retired`."
              //  { allowedValues = [ "draft", "active", "retired" ] }
            ,     scalar
                    "validationStatus"
                    "Declared research support: `untested`, `supported`, `mixed`, or `challenged`."
              //  { allowedValues =
                    [ "untested", "supported", "mixed", "challenged" ]
                  }
            , outcomes
            , assessment
            ]
          , optional =
            [ scalar
                "functionalContext"
                "Practical task constraints surrounding the job."
            , scalar
                "emotionalContext"
                "How the actor wants to feel, or avoid feeling."
            , scalar
                "socialContext"
                "How the actor wants to be perceived by others."
            , FieldRule::{
              , field = "relatedJobs"
              , description = Some
                  "Related local JOB handles or canonical Mori job URIs."
              , cardinality = Cardinality.List
              , reference = Some HandleReferenceRule::{
                , localPrefix = "JOB"
                , externalUriSchemes = [ "mori" ]
                , allowSelf = False
                , allowLocal = True
                , externalUriPattern = Some (conceptUri "JOB")
                }
              }
            ,     v02.sources
              //  { description = Some
                      "§5.1. Evidence this job statement and any baseline were derived from."
                  }
            ]
          }
        , pathPattern = Some "*"
        , idPrefix = Some "JOB"
        }
      ]
    }
