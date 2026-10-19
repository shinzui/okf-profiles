--| Builder for the designs profile: design work for one surface (a page or a
-- self-contained part of one), split by the question each phase answers.
-- ADR-19 records the boundaries this profile draws.
--
-- `designs.dhall` applies this with no house conventions and is the export a
-- consumer normally selects. A house that wants a closed list of viewer axes
-- calls the builder itself:
--
--     Profiles.coordination.designsFor
--       { viewerAxisNames = [ "plan", "device" ] }
--
-- One folder per surface:
--
--   <surface>/brief       Design Brief     BRIEF-N   why / what
--   <surface>/breadboard  Breadboard       BB-N      how — structure
--   <surface>/design      Detailed Design  DES-N     how — presentation
--
--
-- ## Implementation is not a phase here
--
-- The fourth phase, implementation, is tracked where the catalog already
-- tracks delivery: the `coordination.features` a breadboard's affordances name
-- (status, owners, acceptance criteria, delivery evidence), the work that
-- builds them, and the checks against the brief's success criteria. Storing an
-- `implemented` status here would copy delivery state that the features own
-- (ADR-17).
--
--
-- ## Jobs and features are referenced, never restated
--
-- Customer jobs and their outcomes are canonical `coordination.jobs` concepts.
-- A brief links them (`jobs[].jobRef`, `outcomeRefs`) and gives each a short
-- local name; it never restates the statement. Affordances name the
-- `coordination.features` that deliver them. Every reference into another
-- bundle is external only, with the target prefix fixed by
-- `externalUriPattern` (ADR-17).
--
-- A surface's own chain — `brief` on a breadboard, `breadboard` on a detailed
-- design — is local handles only (ADR-19). `supersededBy` may also name a
-- concept in another bundle, by canonical URI with the same prefix.
--
--
-- ## Viewers, subject states, axes and scenarios
--
-- The brief declares who looks (viewers), the states the thing shown can be in
-- (subject states), the switches that modulate either (viewer and subject
-- axes) and the scenarios the surface must work in, at least one per viewer ×
-- subject state. The breadboard says what each viewer gets. The detailed
-- design draws scenarios and says, in one line each, which drawn scenario an
-- undrawn one equals.
--
-- Viewer axes are the attributes every viewer has on every page of a product —
-- a plan, a role, a device — so every brief must answer each of them. Which
-- attributes those are is a house decision, so the names are open unless the
-- house closes them through `viewerAxisNames`; a closed list is what stops a
-- brief from misspelling one. Subject axes are page-specific and always open.
--
-- These cross-document invariants — viewer names declared by the brief,
-- affordances and places declared by the breadboard, scenario coverage — are
-- not expressible in a descriptor. The type guidance names them so an author
-- reads them, per ADR-18.
--
--
-- ## Decisions and questions are shared by a surface's documents
--
-- Decision ids (D-N) and question ids (Q-N) are unique across a surface's three
-- documents, so "D-18" means one thing in a commit message. Each entry lives in
-- the document whose phase it settles.
--
--
-- ## Not a spec language
--
-- This profile gives agents the context for the work. Conditions and
-- exceptions go in prose (`note`, `rules`, the body) rather than in new fields.
--
--
-- ## Presence classes and status
--
-- Each type declares a house `status` (Policy one in `Profile/V02.dhall`), so
-- none takes OKF's `status` or `stale_after`. `reviews` is the only
-- unconditional recommendation (ADR-8); decisions, open questions and subject
-- axes are optional, because a complete document can lack each of them, except
-- that a detailed design records its chosen direction in `decisions` from
-- `chosen` on. Approval moves a document to `validated` or `designed`;
-- `verified` is then required and mirrors the approving `reviews` entry
-- (ADR-4).
--
-- `legacyTimestamp` is deliberately absent: the profile is introduced at v0.2.
let Profile = ../../Profile/Type.dhall

let FrontmatterRules = ../../Profile/FrontmatterRules.dhall

let TypeRule = ../../Profile/TypeRule.dhall

let okf = ../../Profile/okf.dhall

let FieldRule = okf.defaults.FieldRule

let Nested = okf.defaults.NestedFieldRule

let HandleReferenceRule = okf.defaults.HandleReferenceRule

let Cardinality = okf.Cardinality

let FieldFormat = okf.FieldFormat

let reviewRule = ../../Profile/ReviewRule.dhall

let v02 = ../../Profile/V02.dhall

let House = { viewerAxisNames : List Text }

let scalar =
      \(name : Text) ->
      \(description : Text) ->
        FieldRule::{
        , field = name
        , description = Some description
        , cardinality = Cardinality.Scalar
        }

let nscalar =
      \(name : Text) ->
      \(description : Text) ->
        Nested::{
        , field = name
        , description = Some description
        , cardinality = Cardinality.Scalar
        }

let nlist =
      \(name : Text) ->
      \(description : Text) ->
        Nested::{
        , field = name
        , description = Some description
        , cardinality = Cardinality.List
        }

let none = [] : List Nested.Type

let records =
      \(name : Text) ->
      \(description : Text) ->
      \(key : Optional Text) ->
      \(required : List Nested.Type) ->
      \(optional : List Nested.Type) ->
        FieldRule::{
        , field = name
        , description = Some description
        , cardinality = Cardinality.List
        , elementFields = Some { required, recommended = none, optional }
        , uniqueBy = key
        }

let whenStatus =
      \(hasValue : List Text) -> Some { field = "status", hasValue }

-- A concept URI in some producer's bundle; the bundle name is the producer's
-- choice, so it is never hard-coded.
let conceptUri =
      \(prefix : Text) ->
        "mori://[^/]+/[^/]+/okf/[^/]+/concepts/${prefix}-[1-9][0-9]*"

-- okf requires a reference's `localPrefix` to be a prefix this profile
-- declares, so references into other bundles borrow one and forbid local
-- values (ADR-17).
let externalOnly =
      \(localPrefix : Text) ->
      \(prefix : Text) ->
        Some
          HandleReferenceRule::{
          , localPrefix
          , externalUriSchemes = [ "mori" ]
          , allowLocal = False
          , externalUriPattern = Some (conceptUri prefix)
          }

-- A surface's three documents live in one folder and chain by local handle
-- (ADR-19), so `brief` and `breadboard` take no external URI.
let localOnly =
      \(prefix : Text) ->
        Some
          HandleReferenceRule::{
          , localPrefix = prefix
          , externalUriSchemes = [] : List Text
          , allowSelf = False
          }

-- A replacement can live in another bundle once a surface moves, so
-- `supersededBy` also takes a canonical concept URI with the same prefix.
let localOrConcept =
      \(prefix : Text) ->
        Some
          HandleReferenceRule::{
          , localPrefix = prefix
          , externalUriSchemes = [ "mori" ]
          , allowSelf = False
          , externalUriPattern = Some (conceptUri prefix)
          }

let designId =
      \(prefix : Text) ->
        FieldRule::{
        , field = "designId"
        , description = Some "Bundle-scoped stable ${prefix}-N handle."
        , cardinality = Cardinality.Scalar
        , format = Some (FieldFormat.DocumentHandle prefix)
        }

let status =
      \(values : List Text) ->
        FieldRule::{
        , field = "status"
        , description = Some "Workflow step. See the type guidance."
        , allowedValues = values
        , cardinality = Cardinality.Scalar
        }

let supersededBy =
      \(prefix : Text) ->
        FieldRule::{
        , field = "supersededBy"
        , description = Some "Later document replacing this one."
        , cardinality = Cardinality.Scalar
        , reference = localOrConcept prefix
        , when = whenStatus [ "retired" ]
        }

let verifiedWhen =
      \(values : List Text) ->
            v02.verified
        //  { description = Some "The approving review, mirrored from `reviews`."
            , when = whenStatus values
            }

-- Shared by all three types ------------------------------------------------

let decisions =
      records
        "decisions"
        "Settled questions a later phase must not reopen. D-N ids are unique across the surface's three documents."
        (Some "id")
        [     nscalar "id" "D-N handle."
          //  { format = Some (FieldFormat.DocumentHandle "D") }
        , nscalar "statement" "The decision."
        , Nested::{
          , field = "date"
          , description = Some "When it was decided."
          , cardinality = Cardinality.Scalar
          , format = Some FieldFormat.Date
          }
        ]
        [ nscalar "by" "Who decided." ]

let openQuestions =
      records
        "openQuestions"
        "Questions still open, each with an owner. Q-N ids are unique across the surface's three documents."
        (Some "id")
        [     nscalar "id" "Q-N handle."
          //  { format = Some (FieldFormat.DocumentHandle "Q") }
        , nscalar "question" "The question."
        , nscalar "owner" "Who answers it."
        ]
        none

-- Design Brief: why / what ------------------------------------------------

let viewers =
      records
        "viewers"
        "The kinds of viewer this surface distinguishes, declared per brief. Every `viewer` value in this brief and in its breadboard must be one of these names."
        (Some "name")
        [ nscalar "name" "Short identifier used by jobs, scenarios and visibility."
        , nscalar "definition" "Who this is, in one sentence."
        ]
        [ nscalar "computedFrom" "How the app decides a viewer is this kind." ]

let jobs =
      records
        "jobs"
        "The canonical jobs this surface serves, each under a short local name, and which viewers hold it. Where they arrive from is the breadboard's `connections`."
        (Some "name")
        [ nscalar "name" "Short local name used by scenarios and connections."
        ,     nscalar "jobRef" "Canonical Mori URI of the JOB concept."
          //  { reference = externalOnly "BRIEF" "JOB" }
        ]
        [ nlist "viewers" "Viewer names that hold this job." ]

let subjectStates =
      records
        "subjectStates"
        "The states the thing shown can be in, declared per brief — how much of a profile is filled in; open, shipped or cancelled for an order. Omit it when the subject has none, as on a form."
        (Some "name")
        [ nscalar "name" "Short identifier used by scenarios."
        , nscalar "definition" "What the subject has in this state, in facts that can be checked against the data, in one sentence."
        ]
        none

let outcomeRefs =
      records
        "outcomeRefs"
        "The job outcomes this surface is meant to move — the desired outcomes, owned by the jobs."
        (None Text)
        [     nscalar "jobRef" "Canonical Mori URI of a job in `jobs`."
          //  { reference = externalOnly "BRIEF" "JOB" }
        , nscalar "outcomeName" "Name of an outcome declared by that job."
        ]
        none

let successCriteria =
      records
        "successCriteria"
        "How the shipped surface is judged: observable conditions, each with how it will be checked. Implementation verifies these."
        (Some "id")
        [     nscalar "id" "Brief-local SC-N handle."
          //  { format = Some (FieldFormat.DocumentHandle "SC") }
        , nscalar "statement" "Observable condition that must hold."
        , nscalar "verification" "Procedure or evidence that will prove it."
        ]
        none

let applies =
      Nested::{
      , field = "applies"
      , description = Some
          "Whether this axis changes the surface. Words, not booleans: YAML would read yes/no as true/false."
      , allowedValues = [ "applies", "does-not-apply", "open" ]
      , cardinality = Cardinality.Scalar
      }

-- An empty `viewerAxisNames` leaves `name` open: okf treats an empty
-- `allowedValues` as no constraint.
let viewerAxes =
      \(house : House) ->
        records
          "viewerAxes"
          "Attributes of the viewer that every surface must consider, each answered explicitly: does it change this surface, and why. `does-not-apply` with a reason is a complete answer; silence is not."
          (Some "name")
          [ Nested::{
            , field = "name"
            , description = Some "Which viewer attribute."
            , allowedValues = house.viewerAxisNames
            , cardinality = Cardinality.Scalar
            }
          , applies
          , nscalar "because" "Why it applies or does not — the evidence, not the conclusion."
          ]
          [ nscalar "rules" "What changes when it applies, or which scenarios and open questions carry it." ]

let subjectAxes =
      records
        "subjectAxes"
        "Attributes of the thing being viewed, or of the context, that modulate this surface: independent switches that combine freely, unlike subject states. Page-specific, so names are open."
        (Some "name")
        [ nscalar "name" "Which attribute of the subject or context."
        , applies
        , nscalar "because" "Why it applies — the evidence."
        ]
        [ nscalar "rules" "What changes when it applies, or which scenarios and open questions carry it." ]

let scenarios =
      records
        "scenarios"
        "The situations the surface must work in, each with a concrete fixture: at least one per viewer × subject state, plus one for any axis that needs its own look. Later phases are checked against these."
        (Some "id")
        [ nscalar "id" "Short handle such as S1; stable once given."
        , nscalar "viewer" "A declared viewer name."
        , nscalar
            "fixture"
            "Who is looking, what data exists and what is missing, and the entry point — never what the page shows."
        ]
        [ nscalar "state" "A declared subject state."
        , nlist "axes" "Declared viewer and subject axes this scenario exercises."
        , nlist "jobs" "Local job names this scenario exercises."
        ]

let brief =
      \(house : House) ->
        TypeRule::{
        , type = "Design Brief"
        , description = Some
            "Why the surface exists and what it must achieve: the problem, who views it and for which jobs, the states the thing shown can be in, the outcomes it should move, the constraints, the scenarios it must work in, and the criteria it is judged by. No structure, no layout."
        , guidance = Some
            ''
            The body carries what only prose can: **Problem**, **Who it's for**, **Non-goals**, **Constraints** (cite decisions), principles, tone, and the baseline data that shows which subject state is the common one.

            okf checks the shapes, not the cross-references or the scenario coverage the `scenarios` description asks for. Read them: every `jobs[].viewers` and `scenarios[].viewer` is a declared viewer; every `scenarios[].state` a declared subject state; every `scenarios[].axes` entry a declared viewer or subject axis; every `scenarios[].jobs` entry a local job name; every `outcomeRefs[].jobRef` a `jobs[].jobRef`.

            `draft` → `validated` when the surface's approver signs off.
            ''
        , pathPattern = Some "*/brief"
        , idPrefix = Some "BRIEF"
        , frontmatter = FrontmatterRules::{
          , required =
            [ designId "BRIEF"
            , status [ "draft", "validated", "retired" ]
            , scalar "surface" "Route or component the surface is, e.g. /orders/[id]."
            , FieldRule::{
              , field = "origin"
              , description = Some "Mori project URI that owns the surface."
              , cardinality = Cardinality.Scalar
              , format = Some (FieldFormat.UriWithScheme "mori")
              }
            , viewers
            , jobs
            , outcomeRefs // { when = whenStatus [ "validated" ] }
            , viewerAxes house // { when = whenStatus [ "validated" ] }
            , scenarios // { when = whenStatus [ "validated" ] }
            , successCriteria // { when = whenStatus [ "validated" ] }
            , verifiedWhen [ "validated" ]
            , supersededBy "BRIEF"
            ]
          , optional =
            [ subjectStates
            , subjectAxes
            , decisions
            , openQuestions
            , FieldRule::{
              , field = "useCases"
              , description = Some "Canonical Mori URIs of the use cases this surface realises."
              , cardinality = Cardinality.List
              , reference = externalOnly "BRIEF" "UC"
              }
            ]
          }
        }

-- Breadboard: how — structure -------------------------------------------

let places =
      records
        "places"
        "Where the viewer can be: the surface's own places and the external places that lead into it or that it leads to."
        (Some "name")
        [ nscalar "name" "Stable place name."
        , Nested::{
          , field = "kind"
          , description = Some
              "`surface` for a place this breadboard designs; `external` for one it only connects to."
          , allowedValues = [ "surface", "external" ]
          , cardinality = Cardinality.Scalar
          }
        , nscalar "description" "What the place is, in one sentence."
        ]
        none

let affordances =
      records
        "affordances"
        "What a viewer can read or do in each surface place, in words, with no layout. Each names the features that deliver it."
        (Some "name")
        [ nscalar "name" "Stable affordance name, used by visibility, connections and the detailed design."
        , nscalar "place" "A declared surface place."
        , nscalar "does" "What the viewer reads or does with it."
        ]
        [ Nested::{
          , field = "features"
          , description = Some "Canonical Mori URIs of the FEAT concepts that deliver it."
          , cardinality = Cardinality.List
          , reference = externalOnly "BB" "FEAT"
          }
        ]

let connections =
      records
        "connections"
        "How the viewer moves: from an external place or an affordance to a place. Connections from external places are the entry points and name the jobs that arrive by them."
        (None Text)
        [ nscalar "from" "A declared place or affordance."
        , nscalar "to" "A declared place."
        ]
        [ nscalar "carries" "Context passed along, such as a selected tab or filter in the URL."
        , nlist "jobs" "Brief job names that arrive by this connection."
        ]

let visibility =
      FieldRule::{
      , field = "visibility"
      , description = Some
          "Affordance × viewer, one entry each. `shown` and `hidden` are what they say; `collapsed` is present but de-emphasised (relevance, not permission); `filtered` shows the affordance with its items filtered per viewer; `prompts` turns an empty affordance into a call to fill it in. A condition or exception goes in `note`. The owner is a row like any other."
      , cardinality = Cardinality.List
      , elementFields = Some
        { required =
          [ nscalar "affordance" "A declared affordance name."
          , nscalar "viewer" "A viewer declared by the brief."
          , Nested::{
            , field = "rule"
            , description = Some "What this viewer gets."
            , allowedValues = [ "shown", "collapsed", "hidden", "filtered", "prompts" ]
            , cardinality = Cardinality.Scalar
            }
          ]
        , recommended = none
        , optional =
          [ nscalar "note" "Why, or the condition under which the rule changes."
          ]
        }
      }

let breadboard =
      TypeRule::{
      , type = "Breadboard"
      , description = Some
          "How the surface works, before what it looks like: places, the affordances in each, the connections between them, and what each viewer gets."
      , guidance = Some
          ''
          The body carries **ordering rules** written over the brief's viewers, subject states and axes — for example, which affordance comes first for each viewer — not a priority table per scenario.

          okf checks the shapes, not the cross-references. Read them: every `viewer` is declared by the brief, and every `connections[].jobs` entry is a brief job name; every `affordances[].place` is a declared `surface` place; every `visibility[].affordance`, `connections[].from` and `connections[].to` is declared here.

          `draft` → `validated` when the surface's approver signs off on the structure.
          ''
      , pathPattern = Some "*/breadboard"
      , idPrefix = Some "BB"
      , frontmatter = FrontmatterRules::{
        , required =
          [ designId "BB"
          , status [ "draft", "validated", "retired" ]
          ,     scalar "brief" "The brief this breadboard answers."
            //  { reference = localOnly "BRIEF" }
          , places
          , affordances
          , connections
          , visibility
          , verifiedWhen [ "validated" ]
          , supersededBy "BB"
          ]
        , optional = [ decisions, openQuestions ]
        }
      }

-- Detailed Design: how — presentation ------------------------------------

let states =
      records
        "states"
        "The states each affordance is designed in: with-data, and empty wherever the affordance can be empty; add absent (feature not shipped) and any domain state."
        (Some "affordance")
        [ nscalar "affordance" "A breadboard affordance."
        , nlist "states" "State names; every one appears on at least one final screen."
        ]
        none

let designArtifacts =
      records
        "designArtifacts"
        "Where the design lives."
        (Some "resource")
        [ nscalar "kind" "Tool or medium, such as figma, sketch, screenshot or video."
        , nscalar "resource" "A URL, or a path relative to this concept for a file in the repository."
        ]
        [ nscalar "note" "What this artifact shows." ]

let detailedDesign =
      TypeRule::{
      , type = "Detailed Design"
      , description = Some
          "What the breadboard looks like and how it behaves: the chosen direction, layouts, visual hierarchy, components, interaction details and every affordance state, with the final screens."
      , guidance = Some
          ''
          `exploring` (rough ideas, then options) → `chosen` (the direction is recorded in `decisions`) → `designed` (the final screens are exported, the `## Design handoff` section is written and the design review is signed off).

          By `designed`, every brief scenario is either in the `## Design handoff` table, which names the scenario of each screen, or has a line in the body saying which drawn scenario it equals and what differs, and every `states[].affordance` is declared by the breadboard. okf does not check either; read them.
          ''
      , pathPattern = Some "*/design"
      , idPrefix = Some "DES"
      , frontmatter = FrontmatterRules::{
        , required =
          [ designId "DES"
          , status [ "exploring", "chosen", "designed", "retired" ]
          ,     scalar "breadboard" "The breadboard this design presents."
            //  { reference = localOnly "BB" }
          , states
          , designArtifacts // { when = whenStatus [ "chosen", "designed" ] }
          , decisions // { when = whenStatus [ "chosen", "designed" ] }
          , verifiedWhen [ "designed" ]
          , supersededBy "DES"
          ]
        , optional = [ openQuestions ]
        }
      }

in  \(house : House) ->
      Profile::{
      , name = "designs"
      , description = Some
          "Design work per surface in three linked concepts — Design Brief (why/what), Breadboard (structure), Detailed Design (presentation). Jobs and features are canonical concepts referenced by Mori URI; implementation is tracked on the features. Approval requires `verified`, mirroring the approving `reviews` entry."
      , okfVersion = "0.2"
      , requireBundleVersion = Some "0.2"
      , allowUnknownTypes = False
      , idField = Some "designId"
      , frontmatter = FrontmatterRules::{
        , required =
          [ scalar "type" "Design Brief, Breadboard or Detailed Design."
          , scalar "title" "Human-readable title, usually the surface."
          , scalar "description" "One sentence: what this document settles."
          ,     v02.generated
            //  { description = Some "§5.2. Who produced this document's current content, and when." }
          ]
        , recommended = [ reviewRule ]
        , optional =
          [ FieldRule::{ field = "tags", cardinality = Cardinality.List }
          ,     v02.verified
            //  { description = Some "§5.2. Mirror an approving `reviews` entry here." }
          ]
        }
      , types = [ brief house, breadboard, detailedDesign ]
      }
