--| Profile for normative specifications with stable SPEC-N handles.
--
-- A specification states what an owning boundary MUST do. That is what
-- separates this profile from its three documentation siblings, and the
-- separation is the reason it exists rather than being an override on one of
-- them:
--
--   * `architectureDecisions` records a choice and its rationale at a point in
--     time. A decision is finished when it is made; a specification keeps being
--     true, or is superseded.
--   * `researchDocuments` records evidence, alternatives, and conclusions
--     within a bounded question. Research describes what *is*; a specification
--     prescribes what must be.
--   * `userDocumentation` helps a reader accomplish something. A `Reference`
--     page describes an interface as built; a specification binds an
--     implementation that may not exist yet.
--
-- Two fields carry the distinction and neither sibling has anywhere to put
-- them: `specVersion`, the version of the contract that was ratified, and
-- `normativeScope`, which parts of the prose actually bind. Both are demanded
-- on a `Specification` once `status` reaches `ratified`, because a ratified
-- specification that cannot say what binds, at which version, has not been
-- ratified in any usable sense. Before ratification both are optional: a draft
-- legitimately has neither. They are declared on the type rather than
-- profile-wide because they describe the specification text, which a
-- `Specification Pointer` does not carry.
--
-- `normativeScope` lists the binding parts. Anything the document says that is
-- not covered by an entry is informative. There is deliberately no companion
-- list of non-binding sections: a complement is derivable, and two lists can
-- disagree.
--
-- The `Specification Pointer` type covers the common portfolio case where a
-- boundary is accepted in one repository while the authoritative specification
-- lives in the repository that owns it. A pointer is not a weaker
-- specification; it is a specification whose text is elsewhere, and it carries
-- `authoritativeSpec` to say where. Both types share one `SPEC-N` prefix, so a
-- document that is promoted out of a repository — or absorbed back into one —
-- keeps its handle and every durable reference to it. This follows ADR-11's
-- rule that identity is decoupled from classification.
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

let specReference =
      \(name : Text) ->
      \(description : Text) ->
        FieldRule::{
        , field = name
        , description = Some description
        , reference = Some HandleReferenceRule::{
          , localPrefix = "SPEC"
          , externalUriSchemes = [ "mori" ]
          }
        }

let ratified = Some { field = "status", hasValue = [ "ratified" ] }

in  Profile::{
    , name = "specifications"
    , description = Some
        "Normative specifications with stable SPEC handles: which boundary is obliged to satisfy the contract, which parts of it bind, at which version, and what proves conformance. The `Specification Pointer` type covers a subject specified authoritatively in another repository."
    , frontmatter = FrontmatterRules::{
      , required =
        [ scalar
            "type"
            "Whether this document is the specification or a pointer to one owned elsewhere."
        , scalar "title" "Human-readable specification title."
        , scalar
            "description"
            "Concise statement of what this specification governs."
        , FieldRule::{
          , field = "specId"
          , description = Some "Bundle-scoped stable SPEC-N handle."
          , cardinality = Cardinality.Scalar
          , format = Some (FieldFormat.DocumentHandle "SPEC")
          }
        , FieldRule::{
          , field = "status"
          , description = Some "Ratification state of the specification."
          , allowedValues =
            [ "draft", "proposed", "ratified", "superseded", "withdrawn" ]
          , cardinality = Cardinality.Scalar
          }
        , -- Deliberately `Uri` and not `UriWithScheme "mori"`. The obliged
          -- boundary is named by whatever canonical identity scheme the
          -- consuming organization uses; `mori://` satisfies this rule without
          -- the profile mandating a particular registry. A list, because one
          -- specification may bind several boundaries at once.
          FieldRule::{
          , field = "owner"
          , description = Some
              "Canonical URI of each boundary obliged to satisfy this specification."
          , cardinality = Cardinality.List
          , format = Some FieldFormat.Uri
          }
        ,     v02.generated
          //  { description = Some
                  "§5.2. Who produced this specification's current content, and when."
              }
        ,     specReference
                "supersededBy"
                "Later specification replacing this one."
          //  { cardinality = Cardinality.Scalar
              , when = Some { field = "status", hasValue = [ "superseded" ] }
              }
        ]
      , -- Nothing is recommended. Under `--strict` a recommended-and-absent
        -- field is an error, and the obvious candidate — `reviews` — fails
        -- ADR-8's test: a draft specification that nobody has reviewed yet is
        -- complete and correct for what it is. Ratification review is recorded
        -- through `reviews` and `verified` when it happens, and demanded by
        -- neither, because a corpus adopting this profile retroactively cannot
        -- truthfully supply review records it never kept.
        recommended = [] : List FieldRule.Type
      , optional =
        [ FieldRule::{
          , field = "conformance"
          , description = Some
              "Versioned contract, fixture package, or suite that proves conformance to this specification."
          , cardinality = Cardinality.List
          , format = Some FieldFormat.Uri
          }
        ,     specReference
                "supersedes"
                "Earlier specifications replaced by this one."
          //  { cardinality = Cardinality.List }
        , -- Coexists with `verified` rather than replacing it; see Policy two
          -- in the header of ../../Profile/V02.dhall.
          reviewRule
        ,     v02.sources
          //  { description = Some
                  "§5.1. Prior art, requirements, and evidence this specification was derived from."
              }
        ,     v02.verified
          //  { description = Some
                  "§5.2. Independent confirmations that this specification is accurate. Mirror approving `reviews` entries here."
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
    , -- The house `status` key above keeps its ratification vocabulary and
      -- deliberately does not adopt OKF v0.2 §5.4's draft/stable/deprecated,
      -- nor `stale_after`. Its allowing `draft` is a coincidence, not partial
      -- conformance: `ratified` is the state OKF has no word for. See the
      -- header of ../../Profile/V02.dhall for the policy and its reasoning.
      okfVersion = "0.2"
    , requireBundleVersion = Some "0.2"
    , allowUnknownTypes = False
    , idField = Some "specId"
    , types =
      [ TypeRule::{
        , type = "Specification"
        , description = Some
            "A durable statement of required behavior that an owning boundary must satisfy."
        , pathPattern = Some "**"
        , idPrefix = Some "SPEC"
        , -- The two rules that distinguish a specification from a decision
          -- record or a research document, demanded exactly when ratification
          -- makes them answerable. They describe the specification *text*, so
          -- they live on this type rather than profile-wide: a pointer holds no
          -- text to scope or version, and states the version through the
          -- authoritative document it names.
          frontmatter = FrontmatterRules::{
          , required =
            [     scalar
                    "specVersion"
                    "Version of the contract this document ratifies, as implementations cite it."
              //  { when = ratified }
            ,     FieldRule::{
                  , field = "normativeScope"
                  , description = Some
                      "The parts of this document that bind. Anything not named here is informative."
                  , cardinality = Cardinality.List
                  }
              //  { when = ratified }
            ]
          }
        }
      , TypeRule::{
        , type = "Specification Pointer"
        , description = Some
            "A specification whose authoritative text is owned by another repository, recorded here with the ownership it establishes."
        , pathPattern = Some "**"
        , idPrefix = Some "SPEC"
        , frontmatter = FrontmatterRules::{
          , required =
            [ FieldRule::{
              , field = "authoritativeSpec"
              , description = Some
                  "Canonical URI of the document that authoritatively specifies this subject."
              , cardinality = Cardinality.Scalar
              , format = Some FieldFormat.Uri
              }
            ]
          }
        }
      ]
    }
