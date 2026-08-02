--| Profile for repository-owned Architecture Decision Records with stable ADR-N handles.
let Profile = ../../Profile/Type.dhall

let FrontmatterRules = ../../Profile/FrontmatterRules.dhall

let TypeRule = ../../Profile/TypeRule.dhall

let okf = ../../Profile/okf.dhall

let FieldRule = okf.defaults.FieldRule

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

in  Profile::{
    , name = "architecture-decision-records"
    , description = Some
        "Flat repository-owned architecture decisions with stable ADR handles."
    , frontmatter = FrontmatterRules::{
      , required =
        [ scalar "type" "The Architecture Decision Record concept type."
        , scalar "title" "Decision title without the ADR number."
        , FieldRule::{
          , field = "docId"
          , description = Some "Bundle-scoped stable ADR-N handle."
          , cardinality = Cardinality.Scalar
          , format = Some (FieldFormat.DocumentHandle "ADR")
          }
        , scalar "status" "Repository-native decision status."
        , FieldRule::{
          , field = "date"
          , description = Some "Original calendar date of the decision."
          , cardinality = Cardinality.Scalar
          , format = Some FieldFormat.Date
          }
        , scalar "description" "One-sentence summary of the decision."
        ,     v02.generated
          //  { description = Some
                  "§5.2. Who produced this decision record's current content, and when."
              }
        ]
      , -- Nothing is recommended. Under `--strict` a recommended-and-absent
        -- field is an error, and the three provenance fields below are absent
        -- from essentially every real ADR corpus: a live decision that has never
        -- been superseded has nothing to record. They are `optional` instead, so
        -- their reference constraints still apply whenever they are present.
        recommended = [] : List FieldRule.Type
      , optional =
        [ FieldRule::{
          , field = "supersedes"
          , description = Some "Earlier ADR handles replaced by this decision."
          , reference = Some HandleReferenceRule::{
            , localPrefix = "ADR"
            , externalUriSchemes = [ "mori" ]
            }
          }
        , FieldRule::{
          , field = "supersededBy"
          , description = Some "Later ADR handle replacing this decision."
          , cardinality = Cardinality.Scalar
          , reference = Some HandleReferenceRule::{
            , localPrefix = "ADR"
            , externalUriSchemes = [ "mori" ]
            }
          }
        , scalar
            "originatingPlan"
            "Plan that produced the decision, when recorded."
        ,     v02.verified
          //  { description = Some
                  "§5.2. Independent confirmations that this decision record is accurate."
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
    , -- The house `status` key above keeps its repository-native vocabulary and
      -- deliberately does not adopt OKF v0.2 §5.4's draft/stable/deprecated, nor
      -- `stale_after`. See the header of ../../Profile/V02.dhall for the policy
      -- and its reasoning.
      okfVersion = "0.2"
    , requireBundleVersion = Some "0.2"
    , allowUnknownTypes = False
    , idField = Some "docId"
    , types =
      [ TypeRule::{
        , type = "Architecture Decision Record"
        , description = Some
            "A durable record of one architecture decision and its rationale."
        , pathPattern = Some "*"
        , idPrefix = Some "ADR"
        }
      ]
    }
