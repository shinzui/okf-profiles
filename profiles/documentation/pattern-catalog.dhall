--| Profile for a Mori-addressable catalog of implementation patterns and standards.
--
-- ## Narrative and assessable guidance
--
-- Most catalog documents are narrative: a `Standard` or `Pattern` whose
-- requirements live in prose. Those types carry no handle and gain no new
-- obligation from this profile.
--
-- A maintainer who wants services to report conformance against a document
-- promotes it to `Assessable Standard` or `Assessable Pattern`. Only those two
-- types carry the bundle-scoped `PAT-N` handle in `patternId`, a structured
-- `applicability` scope, and a non-empty list of stable `criteria`. The types
-- are opt-in because okf demands an id from every document of a type that
-- declares an `idPrefix`: putting `PAT` on `Standard` and `Pattern` themselves
-- would break every existing catalog at once.
--
-- A criterion declares the kind of evidence that settles it, never a command.
-- A shared catalog is not authorized to execute code in an adopting service;
-- the service binds criteria to its own allow-listed checks in a
-- `coordination.patternApplications` record. Applicability hints help discover
-- candidate services and never settle applicability: the service's
-- application record does.
--
-- Checks that need more than one document — that every deterministic criterion
-- of an applicable pattern has a check binding, that a retired criterion id is
-- never reused for a new meaning — belong to a registry-side projection, not to
-- the profile. A missing binding is an unassessed criterion, not a profile
-- violation.
let Profile = ../../Profile/Type.dhall

let FrontmatterRules = ../../Profile/FrontmatterRules.dhall

let TypeRule = ../../Profile/TypeRule.dhall

let okf = ../../Profile/okf.dhall

let FieldRule = okf.defaults.FieldRule

let Cardinality = okf.Cardinality

let FieldFormat = okf.FieldFormat

let NestedRules = okf.defaults.NestedRules

let NestedFieldRule = okf.defaults.NestedFieldRule

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

let nestedList =
      \(name : Text) ->
      \(description : Text) ->
        NestedFieldRule::{
        , field = name
        , description = Some description
        , cardinality = Cardinality.List
        }

let rule =
      \(conceptType : Text) ->
      \(path : Text) ->
        TypeRule::{
        , type = conceptType
        , description = Some ("A catalog " ++ conceptType ++ " document.")
        , pathPattern = Some path
        , resourceScheme = Some "mori"
        }

-- Whether a candidate service is in scope. `scope` is the human statement;
-- the optional hints are deterministic discovery aids only.
let applicability =
      FieldRule::{
      , field = "applicability"
      , description = Some
          "Where this guidance applies: a human scope statement plus optional deterministic discovery hints. Hints nominate candidate services; a service's pattern application decides."
      , objectFields = Some NestedRules::{
        , required =
          [ nestedScalar
              "scope"
              "The services, components, or situations this guidance governs, in plain language."
          ]
        , recommended = [] : List NestedFieldRule.Type
        , optional =
          [ nestedList
              "projectTypes"
              "Mori project types that are candidates, such as `service` or `library`."
          , nestedList
              "languages"
              "Implementation languages that are candidates, such as `haskell`."
          ,     nestedList
                  "dependenciesAny"
                  "Canonical Mori project URIs; a project depending on any of them is a candidate."
            //  { format = Some (FieldFormat.UriWithScheme "mori") }
          ]
        }
      }

-- One stable, separately reportable requirement. A criterion id is never
-- reused for a different meaning; a changed requirement gets a new id.
let criteria =
      FieldRule::{
      , field = "criteria"
      , description = Some
          "Stable, separately reportable requirements. Each names the kind of evidence that settles it, never a command to run."
      , cardinality = Cardinality.List
      , elementFields = Some NestedRules::{
        , required =
          [ nestedScalar
              "id"
              "Stable document-local criterion id in lowercase-hyphenated form, such as `separate-live-and-ready`. Never reused for a different meaning."
          , nestedScalar
              "statement"
              "The observable requirement a conforming service satisfies."
          ,     nestedScalar
                  "evidenceKind"
                  "What settles the criterion: `test` (an executable test outcome), `report` (a generated machine-readable report), `static-check` (a deterministic analysis), or `review` (human or agent judgment, never a deterministic pass)."
            //  { allowedValues =
                  [ "test", "report", "static-check", "review" ]
                }
          ,     nestedScalar
                  "severity"
                  "`required` for an obligation a conforming service must meet; `advisory` for one it should meet."
            //  { allowedValues = [ "required", "advisory" ] }
          ]
        , recommended = [] : List NestedFieldRule.Type
        , optional = [] : List NestedFieldRule.Type
        }
      , uniqueBy = Some "id"
      }

let assessableRule =
      \(conceptType : Text) ->
      \(description : Text) ->
        TypeRule::{
        , type = conceptType
        , description = Some description
        , frontmatter = FrontmatterRules::{
          , required =
            [ FieldRule::{
              , field = "patternId"
              , description = Some "Bundle-scoped stable PAT-N handle."
              , cardinality = Cardinality.Scalar
              , format = Some (FieldFormat.DocumentHandle "PAT")
              }
            , applicability
            , criteria
            ]
          , recommended = [] : List FieldRule.Type
          , optional = [] : List FieldRule.Type
          }
        , pathPattern = Some "*/**"
        , resourceScheme = Some "mori"
        , idPrefix = Some "PAT"
        }

in  Profile::{
    , name = "mori-documentation-pattern-catalog"
    , description = Some
        "Mori-addressable implementation patterns, standards, guides, and operational documentation."
    , frontmatter = FrontmatterRules::{
      , required =
        [ scalar "type" "The documentation category governed by a type rule."
        , scalar "title" "Human-readable document title."
        , scalar "description" "Concise statement of the document's purpose."
        ,     v02.generated
          //  { description = Some
                  "§5.2. Who produced this document's current content, and when."
              }
        , FieldRule::{
          , field = "resource"
          , description = Some "Canonical Mori URI for this document."
          , cardinality = Cardinality.Scalar
          , format = Some (FieldFormat.UriWithScheme "mori")
          }
        , FieldRule::{
          , field = "tags"
          , description = Some "Search and discovery terms."
          , cardinality = Cardinality.List
          }
        , FieldRule::{
          , field = "status"
          , description = Some "Publication state of this guidance."
          , allowedValues = [ "current", "deprecated" ]
          , cardinality = Cardinality.Scalar
          }
        ]
      , -- Nothing is recommended. Under `--strict` a recommended-and-absent
        -- field is an error, and both fields below are ordinarily absent: most
        -- catalog documents supersede nothing and cite no external source.
        recommended = [] : List FieldRule.Type
      , optional =
        [ -- Was a bare list of URI strings; now the OKF v0.2 §5.1
          -- list-of-records shape, where the former URI becomes each entry's
          -- required `resource` member. This is breaking for a consumer corpus.
          --
          -- Note this is unrelated to the top-level `resource` key above, which
          -- is OKF §4.1's canonical Mori URI for the document itself.
          v02.sources
        , FieldRule::{
          , field = "supersedes"
          , description = Some "Earlier guidance replaced by this document."
          }
        ,     v02.verified
          //  { description = Some
                  "§5.2. Independent confirmations that this guidance is accurate."
              }
        , -- The superseded v0.1 key, kept so an unmigrated catalog keeps
          -- validating. `optional` means its absence is never reported while its
          -- format is still checked whenever it is present.
              v02.legacyTimestamp
          //  { description = Some
                  "Superseded v0.1 revision timestamp. Prefer `generated.at`."
              }
        ]
      }
    , -- The house `status` key above keeps its `current`/`deprecated`
      -- vocabulary and deliberately does not adopt OKF v0.2 §5.4's
      -- draft/stable/deprecated, nor `stale_after`. See the header of
      -- ../../Profile/V02.dhall for the policy and its reasoning.
      okfVersion = "0.2"
    , requireBundleVersion = Some "0.2"
    , -- Only the two assessable types declare an `idPrefix`, so only they are
      -- required to carry `patternId`. A narrative `Standard` or `Pattern`
      -- still validates without one.
      idField = Some "patternId"
    , types =
      [ rule "Navigation" "getting-started"
      , rule "Overview" "*/overview"
      , rule "Standard" "*/**"
      , rule "Guide" "*/**"
      , rule "Pattern" "*/**"
      , assessableRule
          "Assessable Standard"
          "A catalog standard promoted to an assessable contract: stable PAT handle, applicability, and criteria a service can report conformance against."
      , assessableRule
          "Assessable Pattern"
          "A catalog pattern promoted to an assessable contract: stable PAT handle, applicability, and criteria a service can report conformance against."
      , rule "Runbook" "*/**"
      , rule "Reference" "*/**"
      , rule "Gotcha" "*/**"
      ]
    }
