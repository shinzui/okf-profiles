--| Profile for repository-owned research documents with stable RES-N handles.
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

let scalar =
      \(name : Text) ->
      \(description : Text) ->
        FieldRule::{
        , field = name
        , description = Some description
        , cardinality = Cardinality.Scalar
        }

in  Profile::{
    , name = "research-documents"
    , description = Some
        "Repository-owned research records with stable RES handles and structured review provenance. The house `reviews` family and OKF `verified` coexist: `reviews` records far more than `verified` can, so an approving `reviews` entry should also be mirrored into `verified` to keep the derived trust tier accurate."
    , frontmatter = FrontmatterRules::{
      , required =
        [ scalar "type" "The Research Document concept type."
        , scalar "title" "Human-readable research title."
        , scalar "description" "Concise statement of the research purpose."
        ,     v02.generated
          //  { description = Some
                  "§5.2. Who produced this research record's current content, and when."
              }
        , FieldRule::{
          , field = "researchId"
          , description = Some "Bundle-scoped stable RES-N handle."
          , cardinality = Cardinality.Scalar
          , format = Some (FieldFormat.DocumentHandle "RES")
          }
        , FieldRule::{
          , field = "status"
          , description = Some "Lifecycle state of the research record."
          , allowedValues = [ "active", "complete", "superseded" ]
          , cardinality = Cardinality.Scalar
          }
        , scalar
            "scope"
            "Question boundary and evidence considered by the research."
        , FieldRule::{
          , field = "supersededBy"
          , description = Some "Later research replacing this record."
          , cardinality = Cardinality.Scalar
          , reference = Some HandleReferenceRule::{
            , localPrefix = "RES"
            , externalUriSchemes = [ "mori" ]
            }
          , when = Some { field = "status", hasValue = [ "superseded" ] }
          }
        ]
      , -- `reviews` stays RECOMMENDED, alone among the fields that were
        -- recommended before this migration. Research is the one corpus here
        -- where review provenance is part of the work rather than incidental
        -- metadata, so a research record that nobody reviewed is genuinely
        -- worth reporting under `--strict`. The others below moved to
        -- `optional`, where absence is ordinary rather than deficient.
        recommended = [ reviewRule ]
      , optional =
        [ -- Was a bare list of URI strings; now the OKF v0.2 §5.1
          -- list-of-records shape, where the former URI becomes each entry's
          -- required `resource` member. This is breaking for a consumer corpus.
              v02.sources
          //  { description = Some "§5.1. Evidence sources used by the research."
              }
        , FieldRule::{
          , field = "relatedPlans"
          , description = Some "Plans informed by this research."
          , cardinality = Cardinality.List
          }
        , FieldRule::{
          , field = "relatedDecisions"
          , description = Some
              "Architecture decisions informed by this research."
          , cardinality = Cardinality.List
          }
        , FieldRule::{
          , field = "supersedes"
          , description = Some "Earlier research replaced by this record."
          , reference = Some HandleReferenceRule::{
            , localPrefix = "RES"
            , externalUriSchemes = [ "mori" ]
            }
          }
        , -- Coexists with the house `reviews` family above rather than
          -- replacing it: `reviews` records reviewer identity, scope, outcome,
          -- provider, model, effort, and evidence context, while `verified`
          -- records only `by` and `at`. Neither is a superset. Mirror an
          -- approving `reviews` entry into `verified` so `okf trust` reports
          -- the right tier.
              v02.verified
          //  { description = Some
                  "§5.2. Independent confirmations that this research is accurate. Mirror approving `reviews` entries here."
              }
        , -- The superseded v0.1 key, kept so an unmigrated corpus keeps
          -- validating. `optional` means its absence is never reported while
          -- its format is still checked whenever it is present.
              v02.legacyTimestamp
          //  { description = Some
                  "Superseded v0.1 revision timestamp. Prefer `generated.at`."
              }
        ]
      }
    , -- The house `status` key above keeps its
      -- `active`/`complete`/`superseded` vocabulary and deliberately does not
      -- adopt OKF v0.2 §5.4's draft/stable/deprecated, nor `stale_after`. See
      -- the header of ../../Profile/V02.dhall for the policy and its reasoning.
      okfVersion = "0.2"
    , requireBundleVersion = Some "0.2"
    , allowUnknownTypes = False
    , idField = Some "researchId"
    , types =
      [ TypeRule::{
        , type = "Research Document"
        , description = Some
            "A durable record of evidence, alternatives, and conclusions within a bounded scope."
        , pathPattern = Some "**"
        , idPrefix = Some "RES"
        }
      ]
    }
