--| Profile for controlled project vocabularies with stable TERM-N handles.
--
-- ## What a term is, and what it is not
--
-- A term defines a word: the canonical spelling a project uses for one concept,
-- a one-sentence definition, the synonyms that mean the same thing, and the
-- wording that must not be used for it. It then points to where the concept's
-- behavior is described or embodied. That pointing is the whole reason the
-- catalog exists as structured data rather than as a glossary page: typed
-- relations, discouraged wording, and code anchors are what an agent or a
-- reviewer can act on.
--
-- A terminology catalog is a controlled vocabulary, not a general ontology or
-- knowledge graph. It does not record:
--
--   * a choice and its rationale — `documentation.architectureDecisions`;
--   * an obligation a boundary must satisfy — `documentation.specifications`;
--   * a reusable solution — `documentation.patternCatalog`;
--   * a provision claim — `coordination.capabilities`;
--   * a page that helps a reader do something — `documentation.userDocumentation`.
--
-- A term links to those from its body or through a `doc` anchor. It never
-- restates them.
--
--
-- ## The house `status` vocabulary
--
-- Per ADR-1, `status` is a house vocabulary, `current` or `deprecated`, and this
-- profile does not splice OKF v0.2 §5.4's `status` or §5.5's `stale_after`.
-- OKF's `draft`/`stable` distinction has no meaning for a word: a term is either
-- the one to use or one that has been retired. A retired term must say what to
-- say instead, so `replacedBy` is demanded once `status` is `deprecated`.
--
--
-- ## Relations
--
-- `broader`, `related`, and `replaces` each accept a local `TERM-N` handle or a
-- canonical `mori://` concept URI, following ADR-11: local references use
-- handles, cross-project references use `mori://`. `sameAs` is external only.
-- An equivalent inside one bundle is an alias, not a second term, so a local
-- `sameAs` is rejected.
--
-- `narrower` is deliberately not a field. A consumer derives it as the inverse
-- of `broader`, so the two directions cannot disagree. There is likewise no
-- body/frontmatter mirror rule: the body should link related terms, but the
-- typed fields already carry the edges, and okf cannot enforce a mirror.
-- Checks that need the whole corpus or the repository — that a reference
-- resolves to a term, that `broader` has no cycle, that `replaces` and
-- `replacedBy` agree, that an anchor exists on disk, that discouraged wording is
-- not another term's name — belong to a repository-local or registry-side gate,
-- not to the profile.
--
--
-- ## Presence classes
--
-- Nothing is recommended. Per ADR-8 a field is recommended only when a well-run
-- corpus carries it, and a well-formed term routinely has no abbreviation, no
-- alias, no discouraged wording, no relation, and no anchor.
--
--
-- ## `legacyTimestamp` is deliberately absent
--
-- This profile is introduced at v0.2 and no v0.1 terminology corpus exists.
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

let termReference =
      Some
        HandleReferenceRule::{
        , localPrefix = "TERM"
        , externalUriSchemes = [ "mori" ]
        }

let termReferences =
      \(name : Text) ->
      \(description : Text) ->
        list name description // { reference = termReference }

-- `resource` is a plain scalar and deliberately NOT an okf `path` rule, for the
-- same reason as capability evidence: a path rule resolves inside the bundle,
-- and what embodies a term — a module, a source file, a user guide — is almost
-- always outside it. Resolving anchors is a repository-local check.
let anchors =
      FieldRule::{
      , field = "anchors"
      , description = Some
          "What embodies this term: a module, type, function, file, document, or absolute URI a reader can open."
      , cardinality = Cardinality.List
      , elementFields = Some NestedRules::{
        , required =
          [ NestedFieldRule::{
            , field = "kind"
            , description = Some "What sort of artifact this anchor names."
            , allowedValues =
              [ "module", "type", "function", "file", "doc", "uri" ]
            , cardinality = Cardinality.Scalar
            }
          , nestedScalar
              "resource"
              "Module name, qualified identifier, repository-relative path, or absolute URI."
          ]
        , recommended = [] : List NestedFieldRule.Type
        , optional = [ nestedScalar "note" "Why this anchor matters." ]
        }
      }

in  Profile::{
    , name = "terminology"
    , description = Some
        "Controlled project vocabulary with stable TERM handles: the canonical term, a one-sentence definition, accepted and discouraged wording, typed relations to other terms in this or another project, succession, and anchors to what embodies the term. A controlled vocabulary, not a general ontology: decisions, specifications, patterns, capabilities, and guides keep their own profiles."
    , okfVersion = "0.2"
    , requireBundleVersion = Some "0.2"
    , allowUnknownTypes = False
    , idField = Some "termId"
    , frontmatter = FrontmatterRules::{
      , required =
        [ scalar "type" "The Term concept type."
        , scalar
            "title"
            "The canonical term, spelled and cased exactly as it should be written."
        , scalar "description" "A one-sentence definition."
        ,     v02.generated
          //  { description = Some
                  "§5.2. Who produced this term's current content, and when."
              }
        ]
      , recommended = [] : List FieldRule.Type
      , optional =
        [ list "tags" "Free classification tags."
        ,     v02.verified
          //  { description = Some
                  "§5.2. Independent confirmations that this definition is accurate."
              }
        ]
      }
    , types =
      [ TypeRule::{
        , type = "Term"
        , description = Some
            "One concept of this project's vocabulary, under the one name the project uses for it."
        , frontmatter = FrontmatterRules::{
          , required =
            [ FieldRule::{
              , field = "termId"
              , description = Some "Bundle-scoped stable TERM-N handle."
              , cardinality = Cardinality.Scalar
              , format = Some (FieldFormat.DocumentHandle "TERM")
              }
            , FieldRule::{
              , field = "status"
              , description = Some
                  "Whether this is the term to use or a retired one."
              , allowedValues = [ "current", "deprecated" ]
              , cardinality = Cardinality.Scalar
              }
            , -- Conditionally required is spelled `required` + `when`: okf
              -- rejects a `when` on an optional field.
                  scalar
                    "replacedBy"
                    "The term to use instead. Demanded once `status` is `deprecated`."
              //  { reference = termReference
                  , when = Some { field = "status", hasValue = [ "deprecated" ] }
                  }
            ]
          , optional =
            [ scalar "abbreviation" "An accepted short form of the term."
            , scalar
                "scope"
                "The subsystem or bounded context in which this meaning holds."
            , list "aliases" "Accepted synonyms with identical meaning."
            , list
                "discouraged"
                "Wording that must not be used for this concept. The body says why."
            , termReferences
                "broader"
                "More general terms this term specialises."
            , termReferences
                "related"
                "Associated terms that are neither broader nor equivalent."
            , termReferences "replaces" "Terms this term succeeds."
            ,     list
                    "sameAs"
                    "The same concept published by another project, as canonical Mori term URIs."
              //  { reference = Some HandleReferenceRule::{
                    , localPrefix = "TERM"
                    , externalUriSchemes = [ "mori" ]
                    , allowLocal = False
                    , externalUriPattern = Some
                        "mori://[^/]+/[^/]+/okf/[^/]+/concepts/TERM-[1-9][0-9]*"
                    }
                  }
            , anchors
            ]
          }
        , pathPattern = Some "*"
        , idPrefix = Some "TERM"
        }
      ]
    }
