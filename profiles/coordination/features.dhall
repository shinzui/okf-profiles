--| Profile for independently addressable product features with stable FEAT-N handles.
--
-- ## What a feature is
--
-- A feature is one coherent product behavior that can advance from discovery
-- to delivery and can appear in more than one use case. Its `FEAT-N` handle
-- does not depend on its title, its owning repository, or any screen layout,
-- so a use case, a request, a bug, and a future product-management UI can all
-- name it stably.
--
-- It sits beside the rest of the coordination family without replacing any of
-- it:
--
--   * a use case is a scenario; it names the features it relies on through
--     `featureRefs` and stores no copy of their delivery state;
--   * a capability is a producer's claim about behavior that already exists.
--     `capabilityRefs` names capabilities contributing to this feature. That
--     is not a claim that they deliver all of it, and missing producer behavior
--     is an improvement request, never a planned capability;
--   * a specification governs, or is proposed to govern, the feature's
--     contract. `specificationRefs` names it; a linked draft specification is
--     not a ratified obligation, and delivery does not prove conformance;
--   * an improvement request is repository work. `improvementRequests` names
--     requests delivering parts of this feature, and a request may point back
--     through its own `origin`. Neither direction is required.
--
-- No inverse lists are stored: where a feature is used, which bugs affect it,
-- and which requests originate from it are derived from the other side.
--
--
-- ## Acceptance criteria are scoped to their feature
--
-- `acceptanceCriteria` reuses the improvement-request shape: record-local
-- `AC-N` ids with a `statement` and a `verification`. A criterion is
-- identified by its owning feature URI plus its id, so a feature's `AC-1` and
-- a request's `AC-1` are unrelated, and satisfying one never satisfies the
-- other. `verification` names the expected procedure or evidence; it is not a
-- claim that the check already passed.
--
--
-- ## Delivery is not outcome
--
-- `deliveredAt` and `deliveryEvidence` show that the behavior was implemented
-- and accepted. They do not show that a customer job is better served; that is
-- a product-research question, and a delivered feature never changes a job's
-- `validationStatus`.
--
--
-- ## References to other profiles are external only
--
-- okf requires a reference rule's `localPrefix` to be an `idPrefix` this
-- profile declares, so every reference uses `FEAT` with `allowLocal = False`
-- and constrains its target family through `externalUriPattern`. Declaring a
-- foreign prefix such as `CAP` here would be a profile load failure. `owners`
-- is a list of Mori project URIs: a format, not a concept reference, so it
-- carries no reference rule. Whether a referenced concept exists and has the
-- right type needs the other bundle; the opt-in
-- `scripts/check-product-discovery.py` gate checks it until Mori does.
--
--
-- ## Presence classes
--
-- Nothing is recommended (ADR-8). A `discovered` feature may have no owners and
-- no criteria; both become required once a feature is `planned`,
-- `in-progress`, `blocked`, or `delivered`. A technical enabling feature may
-- name no job, and must not invent one to fill `jobRefs`. `priority` is a
-- producer's declared ordering signal for a UI, never a computed score.
--
-- No `guidance` is declared (ADR-12).
--
--
-- ## `legacyTimestamp` is deliberately absent
--
-- This profile is introduced at v0.2 and no v0.1 feature corpus exists.
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

-- `FEAT` is the only prefix this profile declares, so it is the `localPrefix`
-- of every reference, all of which name concepts in other bundles.
let externalOnly =
      \(prefix : Text) ->
        Some
          HandleReferenceRule::{
          , localPrefix = "FEAT"
          , externalUriSchemes = [ "mori" ]
          , allowLocal = False
          , externalUriPattern = Some (conceptUri prefix)
          }

let referenceList =
      \(name : Text) ->
      \(prefix : Text) ->
      \(description : Text) ->
        FieldRule::{
        , field = name
        , description = Some description
        , cardinality = Cardinality.List
        , reference = externalOnly prefix
        }

let whenStatus =
      \(hasValue : List Text) -> Some { field = "status", hasValue }

let committed = whenStatus [ "planned", "in-progress", "blocked", "delivered" ]

let acceptanceCriteria =
      FieldRule::{
      , field = "acceptanceCriteria"
      , description = Some
          "Feature-local product acceptance conditions with AC-N ids; not request criteria."
      , cardinality = Cardinality.List
      , elementFields = Some NestedRules::{
        , required =
          [     nestedScalar
                  "id"
                  "Stable feature-local AC-N handle for this condition."
            //  { format = Some (FieldFormat.DocumentHandle "AC") }
          , nestedScalar
              "statement"
              "Observable product condition that must hold for acceptance."
          , nestedScalar
              "verification"
              "Expected procedure or evidence that will prove the condition."
          ]
        }
      , uniqueBy = Some "id"
      , when = committed
      }

let outcomeRefs =
      FieldRule::{
      , field = "outcomeRefs"
      , description = Some
          "Named outcomes of jobs in `jobRefs` that this feature is meant to move."
      , cardinality = Cardinality.List
      , elementFields = Some NestedRules::{
        , required =
          [     nestedScalar "jobRef" "Canonical Mori URI of a job in `jobRefs`."
            //  { reference = externalOnly "JOB" }
          , nestedScalar "outcomeName" "Name of an outcome declared by that job."
          ]
        }
      }

in  Profile::{
    , name = "features"
    , description = Some
        "Independently addressable product features with stable FEAT handles: customer-visible behavior, a discovery-to-delivery lifecycle, owners and feature-local AC-N acceptance criteria once committed, delivery evidence, and canonical links to jobs, capabilities, specifications, and improvement requests. Delivery is not proof of outcome or conformance."
    , okfVersion = "0.2"
    , requireBundleVersion = Some "0.2"
    , allowUnknownTypes = False
    , idField = Some "featureId"
    , frontmatter = FrontmatterRules::{
      , required =
        [ scalar "type" "The Feature concept type."
        , scalar "title" "Short, stable-sounding feature name."
        , scalar "description" "One sentence stating the feature."
        ,     v02.generated
          //  { description = Some
                  "§5.2. Who produced this feature's current content, and when."
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
    , -- `status` is a house delivery vocabulary (ADR-1); this profile does not
      -- splice OKF v0.2 §5.4's `status` or `stale_after`.
      types =
      [ TypeRule::{
        , type = "Feature"
        , description = Some
            "A coherent product behavior with its own identity and delivery lifecycle."
        , frontmatter = FrontmatterRules::{
          , required =
            [ FieldRule::{
              , field = "featureId"
              , description = Some "Bundle-scoped stable FEAT-N handle."
              , cardinality = Cardinality.Scalar
              , format = Some (FieldFormat.DocumentHandle "FEAT")
              }
            ,     scalar
                    "status"
                    "Delivery state: discovered, planned, in-progress, delivered, blocked, deferred, or retired."
              //  { allowedValues =
                    [ "discovered"
                    , "planned"
                    , "in-progress"
                    , "delivered"
                    , "blocked"
                    , "deferred"
                    , "retired"
                    ]
                  }
            , scalar
                "behavior"
                "Proposed or actual customer-visible behavior."
            , FieldRule::{
              , field = "owners"
              , description = Some
                  "Mori project URIs accountable for delivering the feature."
              , cardinality = Cardinality.List
              , format = Some (FieldFormat.UriWithScheme "mori")
              , when = committed
              }
            , acceptanceCriteria
            ,     scalar
                    "deliveredAt"
                    "UTC RFC3339 time the behavior was delivered and accepted."
              //  { format = Some FieldFormat.Rfc3339Utc
                  , when = whenStatus [ "delivered" ]
                  }
            ,     v02.sources
              //  { field = "deliveryEvidence"
                  , description = Some
                      "Evidence that the behavior was delivered, in the shape of §5.1 sources."
                  , when = whenStatus [ "delivered" ]
                  }
            ]
          , optional =
            [ referenceList
                "jobRefs"
                "JOB"
                "Canonical Mori URIs of the customer jobs this feature serves."
            , outcomeRefs
            , referenceList
                "capabilityRefs"
                "CAP"
                "Canonical Mori URIs of producer capabilities contributing behavior."
            , referenceList
                "specificationRefs"
                "SPEC"
                "Canonical Mori URIs of specifications governing this feature."
            , referenceList
                "improvementRequests"
                "IR"
                "Canonical Mori URIs of requests delivering parts of this feature."
            ,     scalar
                    "priority"
                    "Producer-declared ordering signal: low, medium, high, or critical."
              //  { allowedValues = [ "low", "medium", "high", "critical" ] }
            ]
          }
        , pathPattern = Some "*"
        , idPrefix = Some "FEAT"
        }
      ]
    }
