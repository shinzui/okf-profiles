--| Profile for a friction log: the cost of doing work in a repository, recorded
-- before it is known to be a defect or a request.
--
-- ## What a friction entry is, and what it is not
--
-- A friction entry records that a surface — a document, an interface, a tool,
-- an environment, or a house process — cost an implementer material effort
-- while doing planned work. It states what was attempted, what happened
-- instead, what it cost, and what the implementer did about it. It makes no
-- claim about who is wrong, which is exactly what separates it from its two
-- coordination siblings:
--
--   * A bug report is a *broken provision claim*. Friction becomes a bug
--     report once the recording repository can say which published claim is
--     contradicted and how to reproduce it. Until then it stays friction.
--   * An improvement request is a *gap* a producer should close. Friction
--     becomes a request once someone can state the outcome they want.
--
-- Friction is therefore the intake queue in front of both: raw, first-person,
-- and cheap to write, so that a surface's owner can see across every consuming
-- repository where it costs the most before any of it has been triaged.
-- `status` records the triage outcome and `promotedTo` names the artifact that
-- took over.
--
-- A plan's Surprises & Discoveries section is a different thing again: it
-- holds findings that changed the plan or explain a non-obvious result.
-- Friction that also changed a plan is recorded in both places, each citing
-- the other.
--
-- Granularity: one entry is one surface costing effort once. The same surface
-- costing effort again under another plan is a second entry, because
-- recurrence is the signal this family exists to surface. `duplicateOf` is for
-- two entries describing the same occurrence, not the same cause.
--
--
-- ## `impact` is an observable consequence, not a mood
--
-- The four values are ordered by what happened to the work, and are assigned
-- by observation:
--
--   * `blocked`   — the planned path could not proceed; a human or a change
--                   outside the repository was needed.
--   * `detour`    — the work proceeded only through a workaround, which the
--                   entry must name.
--   * `slowdown`  — the intended path worked, but cost material time through
--                   retries, re-reading, or trial and error.
--   * `nuisance`  — no material cost; recorded because it will recur.
--
-- Priority is deliberately absent, for the reason `bug-reports` gives: it
-- changes with the schedule and has no place in a cross-repository record.
--
--
-- ## `kind` names the surface, not the cause
--
-- `kind` says what sort of thing cost the effort, so a surface's owner can
-- filter a corpus to what they own. It is not a root cause: a `documentation`
-- entry may turn out to be an interface defect, and promotion is where that
-- is recorded.
--
--
-- ## `origin` and `affects`
--
-- `origin` is the Mori URI of the project in which the friction was
-- experienced. `affects` is the URI of the project or artifact whose surface
-- cost the effort. They differ in the case this family exists for: a consumer
-- recording friction with a dependency. `affects` admits any absolute URI
-- rather than only `mori://`, because friction is often with a tool a house
-- does not register; a registered subject is always named by its canonical
-- Mori URI, and a house that registers everything it depends on may narrow
-- the format in its local descriptor.
--
--
-- ## Presence classes
--
-- Nothing is recommended (ADR-8). `workaround` is demanded once `impact` is
-- `detour`, because a detour is defined by having one. `promotedTo`,
-- `duplicateOf` and `resolution` are demanded by the status that gives each
-- its meaning.
--
-- `reviews` and `verified` are optional rather than recommended, which
-- departs from the other coordination profiles on purpose. An entry is a
-- first-person observation that is correct the moment it is written, and
-- demanding review provenance on every entry under `--strict` would price the
-- log out of the habit it exists to create. Triage, not review, is this
-- family's quality gate, and it is recorded in `status`.
--
-- `amended` records later changes that leave the entry standing — a status
-- change at triage — so `generated` keeps who observed the friction, as
-- `documentation.architectureDecisions` does for a decision.
--
--
-- ## The house `status` vocabulary
--
-- Per ADR-1 this profile declares a house lifecycle vocabulary on `status` and
-- therefore does NOT splice OKF v0.2 §5.4's `status` or §5.5's `stale_after`.
--
--
-- ## `legacyTimestamp` is deliberately absent
--
-- This profile is introduced at v0.2 and no v0.1 friction corpus exists.
let Profile = ../../Profile/Type.dhall

let FrontmatterRules = ../../Profile/FrontmatterRules.dhall

let TypeRule = ../../Profile/TypeRule.dhall

let okf = ../../Profile/okf.dhall

let FieldRule = okf.defaults.FieldRule

let NestedRules = okf.defaults.NestedRules

let Nested = okf.defaults.NestedFieldRule

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

-- One mapping per later change, newest last. `by` and `at` take the
-- `generated` formats so the two families read the same way.
let amended =
      FieldRule::{
      , field = "amended"
      , description = Some
          "Later changes that leave the entry standing, such as a status change at triage, newest last. `generated` keeps who observed the friction."
      , cardinality = Cardinality.List
      , elementFields = Some NestedRules::{
        , required =
          [ Nested::{
            , field = "by"
            , description = Some
                "§7. The actor responsible: `<producer>/<version>`, `human:<id>`, or `process:<id>`."
            , cardinality = Cardinality.Scalar
            , format = Some FieldFormat.Actor
            }
          , Nested::{
            , field = "at"
            , description = Some
                "UTC RFC3339 timestamp, ending in `Z`, for when this happened."
            , cardinality = Cardinality.Scalar
            , format = Some FieldFormat.Rfc3339Utc
            }
          , Nested::{
            , field = "change"
            , description = Some "What changed, in one sentence."
            , cardinality = Cardinality.Scalar
            }
          ]
        }
      }

in  Profile::{
    , name = "friction-log"
    , description = Some
        "The cost of doing work in a repository, recorded before it is known to be a defect or a request: one entry per surface that cost an implementer effort, with a stable FRIC handle, an impact graded by what happened to the work, the kind of surface, who felt it and whose surface it was, and a triage status naming the artifact that took it over. Behavior known to be wrong is a bug report; a gap someone can state is an improvement request."
    , okfVersion = "0.2"
    , requireBundleVersion = Some "0.2"
    , allowUnknownTypes = False
    , idField = Some "frictionId"
    , frontmatter = FrontmatterRules::{
      , required =
        [ scalar "type" "The Friction Entry concept type."
        , scalar "title" "Short statement of what cost effort."
        , scalar
            "description"
            "One sentence naming the surface and the cost, evaluable without the body."
        ,     v02.generated
          //  { description = Some
                  "§5.2. Who observed the friction and wrote this entry, and when."
              }
        , FieldRule::{
          , field = "frictionId"
          , description = Some "Bundle-scoped stable FRIC-N handle."
          , cardinality = Cardinality.Scalar
          , format = Some (FieldFormat.DocumentHandle "FRIC")
          }
        , FieldRule::{
          , field = "status"
          , description = Some "Where triage has got to."
          , allowedValues =
            [ "logged", "promoted", "resolved", "accepted", "duplicate" ]
          , cardinality = Cardinality.Scalar
          }
        , -- Consequence, not priority. Take the most severe value that actually
          -- occurred; see the header for what each one means.
          FieldRule::{
          , field = "impact"
          , description = Some
              "What happened to the work, most severe first."
          , allowedValues = [ "blocked", "detour", "slowdown", "nuisance" ]
          , cardinality = Cardinality.Scalar
          }
        , FieldRule::{
          , field = "kind"
          , description = Some "The sort of surface that cost the effort."
          , allowedValues =
            [ "documentation", "interface", "tooling", "environment", "process" ]
          , cardinality = Cardinality.Scalar
          }
        ,     scalar
                "origin"
                "Mori URI of the project in which the friction was experienced."
          //  { format = Some (FieldFormat.UriWithScheme "mori") }
        , -- Any absolute URI, not only `mori://`: see the header.
              scalar
                "affects"
                "URI of the project or artifact whose surface cost the effort: its canonical Mori URI when registered, otherwise its canonical URL."
          //  { format = Some FieldFormat.Uri }
        , -- The next four are conditionally required, which okf spells
          -- `required` plus `when`: a `when` condition gates a presence demand,
          -- and an `optional` rule makes no demand to gate. Each stays checked
          -- whenever it is present under any other value.
              scalar
                "workaround"
                "What the implementer did instead. Demanded once `impact` is `detour`."
          //  { when = Some (condition "impact" [ "detour" ]) }
        ,     scalar
                "promotedTo"
                "URI of the bug report, improvement request, plan, or external issue that now tracks this friction. Demanded once `status` is `promoted`."
          //  { format = Some FieldFormat.Uri
              , when = Some (condition "status" [ "promoted" ])
              }
        , FieldRule::{
          , field = "duplicateOf"
          , description = Some
              "The entry this one duplicates, as a local FRIC-N handle or an external Mori URI. Demanded once `status` is `duplicate`."
          , cardinality = Cardinality.Scalar
          , reference = Some HandleReferenceRule::{
            , localPrefix = "FRIC"
            , externalUriSchemes = [ "mori" ]
            }
          , when = Some (condition "status" [ "duplicate" ])
          }
        ,     scalar
                "resolution"
                "How the cause went away, or why the house lives with it. Demanded once `status` is `resolved` or `accepted`."
          //  { when = Some (condition "status" [ "resolved", "accepted" ]) }
        ]
      , optional =
        [ scalar
            "affectedVersion"
            "Released version of the affecting surface the friction was met with; `unreleased` or `unknown` otherwise."
        , scalar
            "plan"
            "Repository-relative path or Mori URI of the plan being implemented when the friction occurred."
        , FieldRule::{
          , field = "tags"
          , description = Some "Producer-defined search and grouping tags."
          , cardinality = Cardinality.List
          }
        , amended
        , reviewRule
        ,     v02.verified
          //  { description = Some
                  "§5.2. Independent confirmations that this entry is accurate. A list of mappings, or one bare mapping."
              }
        ]
      }
    , types =
      [ TypeRule::{
        , type = "Friction Entry"
        , description = Some
            "One surface costing an implementer effort once, recorded before triage."
        , -- Two sentences, each one of ADR-18's kinds: the first is lifecycle
          -- meaning and who signs it off; the second is where body prose goes.
          guidance = Some
            ''
            An entry is `logged` when written and moves only at triage by the recording repository: to `promoted` once the artifact in `promotedTo` tracks it, to `resolved` once its cause is gone, to `accepted` once the house decides to live with it, or to `duplicate`.
            What was attempted and what happened instead, with evidence, go in the body under `## Attempted` and `## Encountered`.
            ''
        , pathPattern = Some "*"
        , idPrefix = Some "FRIC"
        }
      ]
    }
