--| Profile for a service's decisions about which assessable patterns apply to it.
--
-- ## What a pattern application is
--
-- A catalog maintainer owns an assessable pattern: its stable `PAT-N` handle,
-- its applicability scope, and its criteria (`documentation.patternCatalog`).
-- The service that might adopt it owns the answer to "does this apply to us,
-- and how do we prove it?" A pattern application records that answer as one
-- reviewable document per service and pattern, with a bundle-scoped `PA-N`
-- handle in `applicationId`.
--
-- The `decision` is one of:
--
--   * `applicable` — the service commits to the pattern's criteria. It may bind
--     criterion ids to local, allow-listed check targets in `checks`;
--   * `not-applicable` — the pattern does not govern this service, and the
--     `rationale` says why;
--   * `exception` — the pattern applies but the service is knowingly not
--     meeting it. An `exception` record naming the human authority, the bounded
--     scope, the reason, and the condition that reopens it is then required;
--   * `needs-triage` — nobody has decided yet.
--
-- None of these is conformance. Conformance is evidence about one criterion at
-- an exact service and catalog revision, and it lives outside the document.
-- A scorecard derived from these records must keep `not-applicable`,
-- `exception`, and `needs-triage` apart from a conforming criterion.
--
--
-- ## Checks name local targets, never commands
--
-- A `checks` entry maps a criterion id from the pattern to a target name the
-- service itself defines and allow-lists, such as a Kotei pipeline target. The
-- shared catalog never supplies what runs. Whether every deterministic
-- criterion of an applicable pattern has a binding, and whether a bound id
-- still exists in the pattern, needs both documents, so it belongs to a
-- registry-side projection rather than this profile: a missing binding is an
-- unassessed criterion, not a profile violation.
--
--
-- ## Presence classes
--
-- Nothing is recommended. Per ADR-8 a field is recommended only when a
-- well-run corpus carries it, and a `not-applicable` or `needs-triage` record
-- routinely has no checks and no exception.
--
--
-- ## `legacyTimestamp` is deliberately absent
--
-- This profile is introduced at v0.2 and no v0.1 application corpus exists.
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

let v02 = ../../Profile/V02.dhall

let scalar =
      \(name : Text) ->
      \(description : Text) ->
        FieldRule::{
        , field = name
        , description = Some description
        , cardinality = Cardinality.Scalar
        }

let list =
      \(name : Text) ->
      \(description : Text) ->
        FieldRule::{
        , field = name
        , description = Some description
        , cardinality = Cardinality.List
        }

let nestedScalar =
      \(name : Text) ->
      \(description : Text) ->
        NestedFieldRule::{
        , field = name
        , description = Some description
        , cardinality = Cardinality.Scalar
        }

-- Both references are external only: an application lives in the service's
-- repository, while the pattern lives in a catalog elsewhere, so neither can
-- be a local handle. okf requires `localPrefix` to name a prefix this profile
-- declares, so both use `PA`; it is never consulted because `allowLocal` is
-- false. Declaring them as references is also what lets a registry index
-- `service` and `pattern` as typed edges.
let externalOnly =
      \(pattern : Text) ->
        Some
          HandleReferenceRule::{
          , localPrefix = "PA"
          , externalUriSchemes = [ "mori" ]
          , allowLocal = False
          , externalUriPattern = Some pattern
          }

let checks =
      FieldRule::{
      , field = "checks"
      , description = Some
          "Bindings from a pattern criterion id to a check target this service defines and allow-lists. Never a command copied from the catalog."
      , cardinality = Cardinality.List
      , elementFields = Some NestedRules::{
        , required =
          [ nestedScalar
              "criterion"
              "A criterion id declared by the applied pattern."
          , nestedScalar
              "target"
              "The name of a service-owned, allow-listed check target, such as a Kotei pipeline target."
          ]
        , recommended = [] : List NestedFieldRule.Type
        , optional = [] : List NestedFieldRule.Type
        }
      , uniqueBy = Some "criterion"
      }

-- Conditionally required is spelled `required` + `when`: okf rejects a `when`
-- on an optional field.
let exception =
      FieldRule::{
      , field = "exception"
      , description = Some
          "Who accepted not meeting an applicable pattern, over what bounded scope, why, and what reopens the decision. Demanded once `decision` is `exception`."
      , objectFields = Some NestedRules::{
        , required =
          [     nestedScalar
                  "authority"
                  "The human who accepted the exception, as an OKF §7 human actor such as `human:alice`."
            //  { format = Some FieldFormat.HumanActor }
          , nestedScalar
              "scope"
              "Exactly which criteria, components, or situations the exception covers."
          , nestedScalar "reason" "Why the service does not meet the pattern."
          , nestedScalar
              "reviewCondition"
              "The date or event that reopens this decision."
          ]
        , recommended = [] : List NestedFieldRule.Type
        , optional = [] : List NestedFieldRule.Type
        }
      , when = Some { field = "decision", hasValue = [ "exception" ] }
      }

in  Profile::{
    , name = "pattern-applications"
    , description = Some
        "A service's reviewable decisions about which assessable catalog patterns govern it: stable PA handles, the service and pattern as canonical Mori URIs, an applicable / not-applicable / exception / needs-triage decision with rationale, service-owned check bindings, and bounded exceptions. Records applicability, never conformance."
    , okfVersion = "0.2"
    , requireBundleVersion = Some "0.2"
    , allowUnknownTypes = False
    , idField = Some "applicationId"
    , frontmatter = FrontmatterRules::{
      , required =
        [ scalar "type" "The Pattern Application concept type."
        , scalar "title" "Human-readable application title."
        , scalar
            "description"
            "One sentence stating the decision and the pattern it concerns."
        ,     v02.generated
          //  { description = Some
                  "§5.2. Who produced this application's current content, and when."
              }
        ]
      , recommended = [] : List FieldRule.Type
      , optional =
        [ list "tags" "Free classification tags."
        ,     v02.verified
          //  { description = Some
                  "§5.2. Independent confirmations that this decision is accurate."
              }
        ]
      }
    , types =
      [ TypeRule::{
        , type = "Pattern Application"
        , description = Some
            "One service's decision about one assessable catalog pattern."
        , frontmatter = FrontmatterRules::{
          , required =
            [ FieldRule::{
              , field = "applicationId"
              , description = Some "Bundle-scoped stable PA-N handle."
              , cardinality = Cardinality.Scalar
              , format = Some (FieldFormat.DocumentHandle "PA")
              }
            ,     scalar
                    "service"
                    "Canonical Mori project URI of the service this decision governs, such as `mori://acme/billing`."
              //  { reference =
                      externalOnly "mori://[^/]+/[^/]+"
                  }
            ,     scalar
                    "pattern"
                    "Canonical Mori URI of the assessable pattern, such as `mori://acme/patterns/okf/patterns/concepts/PAT-3`."
              //  { reference =
                      externalOnly
                        "mori://[^/]+/[^/]+/okf/[^/]+/concepts/PAT-[1-9][0-9]*"
                  }
            ,     scalar
                    "decision"
                    "Whether the pattern governs this service: `applicable`, `not-applicable`, `exception`, or `needs-triage`."
              //  { allowedValues =
                    [ "applicable", "not-applicable", "exception", "needs-triage" ]
                  }
            , scalar
                "rationale"
                "Why this decision holds for this service."
            , exception
            ]
          , recommended = [] : List FieldRule.Type
          , optional = [ checks ]
          }
        , pathPattern = Some "*"
        , idPrefix = Some "PA"
        }
      ]
    }
