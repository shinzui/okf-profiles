--| Profile for consumer-facing catalogs of what a repository provides today.
--
-- ## What a capability is, and what it is not
--
-- A capability is a *provision claim*: something this repository's code does
-- today, that a consumer can adopt on its own, backed by evidence a reader can
-- open. It completes the coordination family's triangle — a use case describes
-- what a consumer needs, a capability describes what a producer provides, and an
-- improvement request describes the gap between them:
--
--   * A capability that does not exist yet is NOT a capability record. It is an
--     improvement request. There is deliberately no `planned` status here, and
--     that omission is the profile's single most load-bearing decision.
--   * A capability that only exists when several repositories cooperate is NOT a
--     capability record either — no single repository can assert it or prove it.
--     It belongs to the consuming repository as a use-case feature.
--   * Granularity: one capability is one thing a consumer can adopt AND verify
--     independently. Where two candidates always ship together and are proven by
--     the same evidence, they are one capability. A catalog with one record per
--     exported module is a worse copy of the API reference.
--   * A record must read correctly to someone who has never heard of the
--     repositories that happen to consume it. In practice this test does more
--     than filter vocabulary: a claim that cannot be phrased without naming a
--     sibling service is usually a composition claim in disguise.
--
-- Where a capability grows materially in a later release, record the growth as a
-- new capability that `requires` the old one, rather than moving an older `since`
-- forward. Both alternatives misinform a consumer pinning an older version.
--
--
-- ## The house `status` vocabulary
--
-- Per ADR-1, this profile declares a house lifecycle vocabulary on `status` and
-- therefore does NOT splice OKF v0.2 §5.4's `status` or §5.5's `stale_after`.
-- `shipped` / `deprecated` / `withdrawn` answer "can a consumer use this right
-- now", which is not the draft/stable/deprecated question v0.2 asks.
--
-- `stability` is deliberately a separate key rather than more `status` values: a
-- shipped capability in a pre-1.0 project is available *and* unstable, and a
-- consumer choosing a dependency needs both answers. In a project with a uniform
-- compatibility promise the key is uniform too, and carries its signal to an
-- outside reader rather than between records.
--
--
-- ## `legacyTimestamp` is deliberately absent
--
-- `v02.legacyTimestamp` exists so a half-migrated v0.1 corpus keeps validating.
-- This profile is introduced at v0.2 and no v0.1 capability corpus exists, so
-- there is nothing to keep validating. Add the rule to `optional` if one ever
-- appears.
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

let capabilityReference =
      \(name : Text) ->
      \(description : Text) ->
        FieldRule::{
        , field = name
        , description = Some description
        , cardinality = Cardinality.List
        , reference = Some HandleReferenceRule::{
          , localPrefix = "CAP"
          , externalUriSchemes = [ "mori" ]
          }
        }

-- Evidence is what separates a capability record from a marketing bullet: every
-- claim names an artifact a reader can open and check.
--
-- `resource` is a plain scalar and deliberately NOT an okf `path` rule. A path
-- rule resolves against the bundle's own concept tree, and a path naming a `.md`
-- file must name a concept inside the bundle. Capability evidence is inherently
-- repository-wide — test modules, package targets, user guides outside the
-- bundle — so declaring `path` here would reject exactly the evidence that
-- matters most. The cost is that resources are unchecked by okf; a
-- repository-local CI check is the right place to resolve them.
let evidence =
      FieldRule::{
      , field = "evidence"
      , description = Some
          "Artifacts proving this capability works today. A record with no evidence is an improvement request, not a capability."
      , cardinality = Cardinality.List
      , elementFields = Some NestedRules::{
        , required =
          [ NestedFieldRule::{
            , field = "kind"
            , description = Some "What sort of proof this entry is."
            , allowedValues =
              [ "test"
              , "conformance"
              , "example"
              , "benchmark"
              , "module"
              , "guide"
              ]
            , cardinality = Cardinality.Scalar
            }
          , nestedScalar
              "resource"
              "Repository-relative path, package target, module name, or absolute URL a reader can open."
          ]
        , recommended =
          [ nestedScalar
              "proves"
              "What a reader learns by opening it. Without this an evidence entry is a bare path."
          ]
        , optional = [] : List NestedFieldRule.Type
        }
      }

in  Profile::{
    , name = "capabilities"
    , description = Some
        "Consumer-facing catalog of what a repository provides today: stable CAP-N handles, an explicit compatibility promise, and evidence. Provision claims only — absent capabilities are improvement requests, and capabilities that span repositories are use-case features owned by the consumer. The house `reviews` family and OKF `verified` coexist: `reviews` records far more than `verified` can, so an approving `reviews` entry should also be mirrored into `verified` to keep the derived trust tier accurate."
    , okfVersion = "0.2"
    , requireBundleVersion = Some "0.2"
    , allowUnknownTypes = False
    , idField = Some "capabilityId"
    , frontmatter = FrontmatterRules::{
      , required =
        [ scalar "type" "The Capability concept type."
        , scalar "title" "Human-readable capability name."
        , scalar
            "description"
            "One sentence a consumer can evaluate without reading the body."
        ,     v02.generated
          //  { description = Some
                  "§5.2. Who produced this capability record's current content, and when."
              }
        ]
      , recommended = [ reviewRule ]
      , optional =
        [ list "tags" "Producer-defined search and grouping tags."
        , list
            "links"
            "Additional navigation links retained as producer metadata."
        ,     v02.verified
          //  { description = Some
                  "§5.2. Independent confirmations that this content is accurate. Mirror an approving `reviews` entry here."
              }
        ]
      }
    , types =
      [ TypeRule::{
        , type = "Capability"
        , description = Some
            "One thing this repository's code does today that a consumer can adopt and verify independently."
        , frontmatter = FrontmatterRules::{
          , required =
            [ FieldRule::{
              , field = "capabilityId"
              , description = Some "Bundle-scoped stable CAP-N handle."
              , cardinality = Cardinality.Scalar
              , format = Some (FieldFormat.DocumentHandle "CAP")
              }
            , FieldRule::{
              , field = "provider"
              , description = Some
                  "Mori project URI that provides this capability. Redundant within one bundle, load-bearing once capabilities are aggregated across repositories."
              , cardinality = Cardinality.Scalar
              , format = Some (FieldFormat.UriWithScheme "mori")
              }
            , -- No `planned`: a capability that does not exist yet is an
              -- improvement request. See the header.
              FieldRule::{
              , field = "status"
              , description = Some
                  "Whether a consumer can use this capability right now."
              , allowedValues = [ "shipped", "deprecated", "withdrawn" ]
              , cardinality = Cardinality.Scalar
              }
            , FieldRule::{
              , field = "stability"
              , description = Some
                  "Compatibility promise. `experimental` may change without a major bump."
              , allowedValues = [ "experimental", "stable" ]
              , cardinality = Cardinality.Scalar
              }
            , scalar
                "since"
                "Released version in which this first became available to a consumer. `unreleased` when it exists only on the default branch."
            , list
                "packages"
                "Packages, artifacts, or deployables a consumer depends on to get this capability."
            , evidence
            , -- Demanded only once the capability is on its way out: a retirement
              -- with no forward path is the failure mode worth catching, and a
              -- live capability has nothing to say here.
              --
              -- This rule lives in `required` rather than `optional` because okf
              -- rejects a `when` condition on an optional field: `when` gates a
              -- presence demand, and `optional` makes no demand to gate.
              -- Conditionally-required is spelled `required` + `when`.
                  capabilityReference
                    "replacedBy"
                    "Where a consumer should go instead. Demanded once `status` is `deprecated` or `withdrawn`."
              //  { when = Some { field = "status"
                                , hasValue = [ "deprecated", "withdrawn" ]
                                }
                  }
            ]
          , recommended =
            [ list
                "interface"
                "Entry points a consumer actually touches: module names, endpoints, or commands."
            ]
          , optional =
            [ -- okf derives concept-to-concept graph edges from Markdown *body*
              -- links only; frontmatter is preserved and checked but never
              -- becomes an edge. A `requires` entry that is not also a body link
              -- validates cleanly and is invisible to `okf graph`. Declare each
              -- requirement twice: here, where it is typed and can name an
              -- external Mori URI, and as a body link, where it becomes an edge.
              -- okf cannot enforce the mirror; a repository-local check should.
              capabilityReference
                "requires"
                "Capabilities this one builds on, as local CAP-N handles or external Mori capability URIs. Mirror each entry as a body link so it becomes a graph edge."
            ]
          }
        , pathPattern = Some "*"
        , idPrefix = Some "CAP"
        }
      ]
    }
