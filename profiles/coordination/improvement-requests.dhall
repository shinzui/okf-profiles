--| Profile for cross-repository improvement requests with stable IR-N handles.
let Profile = ../../Profile/Type.dhall

let FrontmatterRules = ../../Profile/FrontmatterRules.dhall

let TypeRule = ../../Profile/TypeRule.dhall

let okf = ../../Profile/okf.dhall

let FieldRule = okf.defaults.FieldRule

let HandleReferenceRule = okf.defaults.HandleReferenceRule

let Cardinality = okf.Cardinality

let FieldFormat = okf.FieldFormat

let reviewRule = ../../Profile/ReviewRule.dhall

let v02 = ../../Profile/V02.dhall

let condition =
      \(field : Text) -> \(hasValue : List Text) -> { field, hasValue }

let scalar =
      \(name : Text) ->
      \(description : Text) ->
        FieldRule::{
        , field = name
        , description = Some description
        , cardinality = Cardinality.Scalar
        }

in  Profile::{
    , name = "cross-repository-improvement-requests"
    , description = Some
        "Cross-repository improvement proposals with stable IR handles and review provenance. The house `reviews` family and OKF `verified` coexist: `reviews` records far more than `verified` can, so an approving `reviews` entry should also be mirrored into `verified` to keep the derived trust tier accurate."
    , frontmatter = FrontmatterRules::{
      , required =
        [ scalar "type" "The Improvement Request concept type."
        , scalar "title" "Short statement of the requested improvement."
        , scalar
            "description"
            "Concise explanation of the problem and desired outcome."
        ,     v02.generated
          //  { description = Some
                  "§5.2. Who produced this request's current content, and when."
              }
        , FieldRule::{
          , field = "requestId"
          , description = Some "Bundle-scoped stable IR-N handle."
          , cardinality = Cardinality.Scalar
          , format = Some (FieldFormat.DocumentHandle "IR")
          }
        , FieldRule::{
          , field = "status"
          , description = Some "Lifecycle decision for the request."
          , allowedValues =
            [ "proposed"
            , "accepted"
            , "in-progress"
            , "completed"
            , "rejected"
            , "withdrawn"
            , "superseded"
            ]
          , cardinality = Cardinality.Scalar
          }
        , FieldRule::{
          , field = "origin"
          , description = Some
              "Mori URI of the project or artifact raising the request."
          , cardinality = Cardinality.Scalar
          , format = Some (FieldFormat.UriWithScheme "mori")
          }
        , FieldRule::{
          , field = "completedAt"
          , description = Some
              "UTC time at which acceptance evidence proved the request complete."
          , cardinality = Cardinality.Scalar
          , format = Some FieldFormat.Rfc3339Utc
          , when = Some (condition "status" [ "completed" ])
          }
        , FieldRule::{
          , field = "supersededBy"
          , description = Some "Later request that replaces this request."
          , cardinality = Cardinality.Scalar
          , reference = Some HandleReferenceRule::{
            , localPrefix = "IR"
            , externalUriSchemes = [ "mori" ]
            }
          , when = Some (condition "status" [ "superseded" ])
          }
        ]
      , -- `reviews` is the only unconditional recommendation left: a coordination
        -- corpus that records no review provenance at all is deficient, and
        -- `--strict` should say so. `resolution` is conditional, so it is only
        -- demanded once a request reaches a terminal state — a proposed request
        -- with no resolution is not reported.
        recommended =
        [ reviewRule
        , FieldRule::{
          , field = "resolution"
          , description = Some
              "Evidence or rationale recorded when a request reaches a terminal state."
          , cardinality = Cardinality.Scalar
          , when = Some
              ( condition
                  "status"
                  [ "completed", "rejected", "withdrawn", "superseded" ]
              )
          }
        ]
      , optional =
        [ -- Ordinarily absent: a request that has not yet been planned has no
          -- target plan, so demanding it under `--strict` would report a normal
          -- state as a deficiency.
          FieldRule::{
          , field = "targetPlan"
          , description = Some
              "Repository-relative path or Mori URI of the implementation plan."
          , cardinality = Cardinality.Scalar
          }
        ,     v02.verified
          //  { description = Some
                  "§5.2. Independent confirmations that this request is accurate. Mirror an approving `reviews` entry here."
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
    , -- The house `status` key above keeps its request lifecycle vocabulary and
      -- deliberately does not adopt OKF v0.2 §5.4's draft/stable/deprecated, nor
      -- `stale_after`. See the header of ../../Profile/V02.dhall for the policy
      -- and its reasoning.
      okfVersion = "0.2"
    , requireBundleVersion = Some "0.2"
    , allowUnknownTypes = False
    , idField = Some "requestId"
    , types =
      [ TypeRule::{
        , type = "Improvement Request"
        , description = Some
            "A request whose implementation may span repository ownership boundaries."
        , pathPattern = Some "*"
        , idPrefix = Some "IR"
        }
      ]
    }
