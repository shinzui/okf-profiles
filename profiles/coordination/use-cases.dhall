--| Profile for JTBD use cases connected to repository-owned feature work.
let Profile = ../../Profile/Type.dhall

let FrontmatterRules = ../../Profile/FrontmatterRules.dhall

let TypeRule = ../../Profile/TypeRule.dhall

let okf = ../../Profile/okf.dhall

let FieldRule = okf.defaults.FieldRule

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

let moriList =
      \(name : Text) ->
      \(description : Text) ->
        NestedFieldRule::{
        , field = name
        , description = Some description
        , cardinality = Cardinality.List
        , format = Some (FieldFormat.UriWithScheme "mori")
        }

let jobs =
      FieldRule::{
      , field = "jobs"
      , description = Some
          "Jobs-to-be-Done statements describing the actor, situation, desired progress, and observable outcome."
      , cardinality = Cardinality.List
      , elementFields = Some
        { required =
          [ nestedScalar "name" "Stable name for this job within the use case."
          , nestedScalar "actor" "Person, role, or agent trying to make progress."
          , nestedScalar "situation" "Circumstance in which the job arises."
          , nestedScalar "motivation" "Progress the actor wants to make."
          , nestedScalar "outcome" "Observable result that satisfies the job."
          ]
        , recommended = [] : List NestedFieldRule.Type
        , optional = [] : List NestedFieldRule.Type
        }
      }

let features =
      FieldRule::{
      , field = "features"
      , description = Some
          "Capabilities whose delivery makes the use case possible, with ownership and request tracking."
      , cardinality = Cardinality.List
      , elementFields = Some
        { required =
          [ nestedScalar "name" "Stable feature name within the use case."
          , nestedScalar "description" "Capability or behavior the feature supplies."
          , NestedFieldRule::{
            , field = "status"
            , description = Some "Current delivery state of the feature."
            , allowedValues =
              [ "discovered"
              , "planned"
              , "in-progress"
              , "delivered"
              , "blocked"
              , "deferred"
              ]
            , cardinality = Cardinality.Scalar
            }
          , moriList "owners" "Mori project URIs accountable for delivering the feature."
          , nestedScalar "acceptance" "Observable evidence that proves the feature is delivered."
          ]
        , recommended = [] : List NestedFieldRule.Type
        , optional =
          [ NestedFieldRule::{
            , field = "jobs"
            , description = Some "Names of the JTBD records this feature advances."
            , cardinality = Cardinality.List
            }
          , moriList
              "improvementRequests"
              "Stable Mori concept URIs of repository-owned requests delivering this feature."
          ]
        }
      }

in  Profile::{
    , name = "jtbd-use-cases"
    , description = Some
        "Jobs-to-be-Done use cases connected to typed feature delivery and repository-owned improvement requests. The house `reviews` family and OKF `verified` coexist: `reviews` records far more than `verified` can, so an approving `reviews` entry should also be mirrored into `verified` to keep the derived trust tier accurate."
    , frontmatter = FrontmatterRules::{
      , required =
        [ scalar "type" "The Use Case or Use Case Theme concept type."
        , scalar "title" "Human-readable title."
        , scalar "description" "Concise statement of the use case or theme."
        , -- Profile-wide, not inside the `Use Case` type rule: a theme concept
          -- is a document like any other and should record its producer too.
              v02.generated
          //  { description = Some
                  "§5.2. Who produced this use case or theme's current content, and when."
              }
        ]
      , recommended = [ reviewRule ]
      , optional =
        [ FieldRule::{
          , field = "tags"
          , description = Some "Producer-defined search and grouping tags."
          , cardinality = Cardinality.List
          }
        , FieldRule::{
          , field = "links"
          , description = Some "Additional navigation links retained as producer metadata."
          , cardinality = Cardinality.List
          }
        ,     v02.verified
          //  { description = Some
                  "§5.2. Independent confirmations that this content is accurate. Mirror an approving `reviews` entry here."
              }
        , -- The superseded v0.1 key. okf reads it whenever `generated` is
          -- absent, so an unmigrated corpus keeps validating; `optional` means
          -- its absence is never reported while its format is still checked
          -- whenever it is present. Declaring `okfVersion = "0.2"` with this
          -- rule in `required` or `recommended` is a hard profile load failure.
              v02.legacyTimestamp
          //  { description = Some
                  "Superseded v0.1 revision timestamp. Prefer `generated.at`."
              }
        ]
      }
    , -- The `Use Case` type rule's house `status` key keeps its delivery
      -- lifecycle vocabulary and deliberately does not adopt OKF v0.2 §5.4's
      -- draft/stable/deprecated, nor `stale_after`. Its allowing `draft` is a
      -- coincidence, not partial conformance. See the header of
      -- ../../Profile/V02.dhall for the policy and its reasoning.
      okfVersion = "0.2"
    , requireBundleVersion = Some "0.2"
    , allowUnknownTypes = False
    , idField = Some "useCaseId"
    , types =
      [ TypeRule::{
        , type = "Use Case"
        , description = Some
            "A user-value scenario expressed as JTBD records and the features needed to deliver it."
        , frontmatter = FrontmatterRules::{
          , required =
            [ FieldRule::{
              , field = "useCaseId"
              , description = Some "Bundle-scoped stable UC-N handle."
              , cardinality = Cardinality.Scalar
              , format = Some (FieldFormat.DocumentHandle "UC")
              }
            , FieldRule::{
              , field = "status"
              , description = Some "Lifecycle state of the use case."
              , allowedValues =
                [ "draft"
                , "validated"
                , "planned"
                , "in-progress"
                , "delivered"
                , "retired"
                ]
              , cardinality = Cardinality.Scalar
              }
            , FieldRule::{
              , field = "origin"
              , description = Some "Mori project URI that owns this use case."
              , cardinality = Cardinality.Scalar
              , format = Some (FieldFormat.UriWithScheme "mori")
              }
            , jobs
            , features
            ]
          , recommended =
            [ FieldRule::{
              , field = "themes"
              , description = Some "Theme slugs mirrored by body links to theme concepts."
              , cardinality = Cardinality.List
              }
            ]
          , optional =
            [ FieldRule::{
              , field = "improvementRequests"
              , description = Some
                  "Stable Mori request URIs; mirror the union of feature-level request references."
              , cardinality = Cardinality.List
              , format = Some (FieldFormat.UriWithScheme "mori")
              }
            , FieldRule::{
              , field = "relatedUseCases"
              , description = Some "Related local UC handles or external Mori use-case URIs."
              , cardinality = Cardinality.List
              , reference = Some HandleReferenceRule::{
                , localPrefix = "UC"
                , externalUriSchemes = [ "mori" ]
                }
              }
            ]
          }
        , pathPattern = Some "*"
        , idPrefix = Some "UC"
        }
      , TypeRule::{
        , type = "Use Case Theme"
        , description = Some
            "A reusable business or product theme referenced by use cases in this bundle."
        , pathPattern = Some "themes/*"
        }
      ]
    }
