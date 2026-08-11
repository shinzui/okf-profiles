--| Profile for defect reports against a repository's published behavior.
--
-- ## What a bug report is, and what it is not
--
-- A bug report is a *broken provision claim*: something this repository already
-- says it does, observably does not do. That is the whole line, and it is what
-- places the type in the coordination family rather than in documentation:
--
--   * Behavior that was never provided is NOT a bug. It is an improvement
--     request. "The exporter cannot resume" is a bug only if resumable export is
--     something the producer claims today; otherwise it is a request for it.
--   * A defect nobody can reach from the outside is NOT a bug report either. A
--     report names a version, an observation, and steps — if none of those can be
--     written down, what exists is a suspicion, and the right artifact is a
--     research document until it can be reproduced.
--   * Granularity: one report is one wrong behavior with one reproduction. Two
--     symptoms that share a reproduction are one report; two reproductions are
--     two reports even where the cause turns out to be shared. Merging them later
--     is cheap, and `duplicateOf` is how it is recorded.
--
-- `capability` makes the broken claim explicit where the producer publishes a
-- `coordination.capabilities` catalog: the report names the `CAP-N` handle it
-- contradicts. It is optional because not every repository has one, and because a
-- defect can break behavior that was documented rather than catalogued.
--
--
-- ## `observed` and `expected` are frontmatter, not prose
--
-- Both could live in the body, and in most trackers they do. They are keys here
-- because a corpus is queried: "every unusable defect where the expectation came
-- from a published guide" is a question a reader should be able to ask across
-- repositories without reading three hundred bodies. The body is for the
-- analysis; the keys are for the claim.
--
--
-- ## The house `status` vocabulary
--
-- Per ADR-1 this profile declares a house lifecycle vocabulary on `status` and
-- therefore does NOT splice OKF v0.2 §5.4's `status` or §5.5's `stale_after`.
-- Its question is "where has this defect got to", which is not the
-- draft/stable/deprecated question v0.2 asks of a document.
--
-- `confirmed` means the *owning* repository reproduced it, not that the reporter
-- is sure. That is the one transition an outside reporter cannot make, and
-- keeping it decidable is what stops the vocabulary collapsing into a mood.
--
-- Five statuses are terminal — `fixed`, `wont-fix`, `duplicate`, `not-a-bug`,
-- `cannot-reproduce` — and each demands `resolution` under `--strict`. A closed
-- report whose closing reason lives only in a chat log is the failure mode this
-- catches.
--
--
-- ## `severity` is an observable consequence, not a priority
--
-- The four values are ordered by what actually happens to a consumer, and are
-- assigned by observation rather than judgment:
--
--   * `data-loss`  — persisted data is destroyed, or a result is silently wrong.
--   * `unusable`   — the behavior cannot be had at all, and no workaround exists.
--   * `degraded`   — it works, but only via a workaround or with reduced function.
--   * `cosmetic`   — the output reads wrong; the behavior underneath is right.
--
-- `data-loss` outranks `unusable` deliberately: an outage is visible and a silently
-- wrong number is not. Where two values could apply, take the most severe that
-- actually occurs — and if that feels wrong, check whether two defects are being
-- reported as one.
--
-- Severity is not priority. Priority weighs severity against reach, cost, and
-- what else is in flight; it changes with the schedule, differs per consumer, and
-- has no place in a cross-repository record.
--
--
-- ## The three version keys
--
-- `affectedVersion`, `fixedVersion`, and `lastWorkingVersion` all take the same
-- fixed vocabulary: a bare released version, `unreleased` for the default branch
-- only, or `unknown` with the reason in the body. The profile cannot enforce it —
-- the values are free text — but a version field a consumer compares
-- mechanically is destroyed by commentary appended to it, so the history goes in
-- the body and the key stays a version.
--
-- `lastWorkingVersion` is what makes a report a regression, and is optional
-- because most defects were never absent.
--
--
-- ## `legacyTimestamp` is deliberately absent
--
-- `v02.legacyTimestamp` exists so a half-migrated v0.1 corpus keeps validating.
-- This profile is introduced at v0.2 and no v0.1 bug-report corpus exists, so
-- there is nothing to keep validating. Add the rule to `optional` if one ever
-- appears.
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

let terminal =
      condition
        "status"
        [ "fixed", "wont-fix", "duplicate", "not-a-bug", "cannot-reproduce" ]

let scalar =
      \(name : Text) ->
      \(description : Text) ->
        FieldRule::{
        , field = name
        , description = Some description
        , cardinality = Cardinality.Scalar
        }

let moriUri =
      \(name : Text) ->
      \(description : Text) ->
            scalar name description
        //  { format = Some (FieldFormat.UriWithScheme "mori") }

in  Profile::{
    , name = "bug-reports"
    , description = Some
        "Defect reports against behavior a repository already provides, with stable BUG handles, an observable severity scale, and a reproduction a reader can follow. Behavior that was never provided is an improvement request, not a bug. The house `reviews` family and OKF `verified` coexist: `reviews` records far more than `verified` can, so an approving `reviews` entry should also be mirrored into `verified` to keep the derived trust tier accurate."
    , okfVersion = "0.2"
    , requireBundleVersion = Some "0.2"
    , allowUnknownTypes = False
    , idField = Some "bugId"
    , frontmatter = FrontmatterRules::{
      , required =
        [ scalar "type" "The Bug Report concept type."
        , scalar "title" "Short statement of the wrong behavior."
        , scalar
            "description"
            "One sentence naming what is wrong, evaluable without the body."
        ,     v02.generated
          //  { description = Some
                  "§5.2. Who produced this report's current content, and when."
              }
        , FieldRule::{
          , field = "bugId"
          , description = Some "Bundle-scoped stable BUG-N handle."
          , cardinality = Cardinality.Scalar
          , format = Some (FieldFormat.DocumentHandle "BUG")
          }
        , FieldRule::{
          , field = "status"
          , description = Some
              "Where this report has got to. `confirmed` means the owning repository reproduced it."
          , allowedValues =
            [ "reported"
            , "confirmed"
            , "in-progress"
            , "fixed"
            , "wont-fix"
            , "duplicate"
            , "not-a-bug"
            , "cannot-reproduce"
            ]
          , cardinality = Cardinality.Scalar
          }
        , -- Consequence, not priority. Take the most severe value that actually
          -- occurs; see the header for what each one means.
          FieldRule::{
          , field = "severity"
          , description = Some
              "Observable consequence for a consumer, most severe first."
          , allowedValues = [ "data-loss", "unusable", "degraded", "cosmetic" ]
          , cardinality = Cardinality.Scalar
          }
        , moriUri
            "origin"
            "Mori URI of the project or artifact that observed the defect."
        , -- Distinct from `origin`, and the two differ in exactly the case this
          -- family exists for: a consumer reporting a defect in a dependency.
          moriUri
            "affects"
            "Mori URI of the project or artifact whose behavior is wrong."
        , scalar
            "affectedVersion"
            "Released version the defect was observed in; `unreleased` or `unknown` otherwise."
        , scalar "observed" "What actually happens, stated as a fact."
        , scalar
            "expected"
            "What should happen instead, and on whose authority — a guide, a capability, a test."
        , FieldRule::{
          , field = "reproduction"
          , description = Some
              "Ordered steps a reader can follow to see it, one step per entry."
          , cardinality = Cardinality.List
          }
        , -- The next two are conditionally required, which okf spells `required`
          -- plus `when`: a `when` condition gates a presence demand, and an
          -- `optional` rule makes no demand to gate.
          scalar
            "fixedVersion"
            "Released version carrying the fix; `unreleased` while it is on the default branch only."
          //  { when = Some (condition "status" [ "fixed" ]) }
        , FieldRule::{
          , field = "duplicateOf"
          , description = Some
              "The report this one duplicates, as a local BUG-N handle or an external Mori URI."
          , cardinality = Cardinality.Scalar
          , reference = Some HandleReferenceRule::{
            , localPrefix = "BUG"
            , externalUriSchemes = [ "mori" ]
            }
          , when = Some (condition "status" [ "duplicate" ])
          }
        ]
      , -- `reviews` is the family's one unconditional recommendation: a
        -- coordination corpus that records no review provenance is deficient and
        -- `--strict` should say so. The other two are conditional, so neither is
        -- reported on a report that has no occasion for it.
        recommended =
        [ reviewRule
        , FieldRule::{
          , field = "resolution"
          , description = Some
              "Why this report closed the way it did, recorded when it reaches a terminal status."
          , cardinality = Cardinality.Scalar
          , when = Some terminal
          }
        , -- `degraded` is *defined* as "a workaround exists", so a degraded
          -- report that names none is either incomplete or mis-graded.
          scalar
            "workaround"
            "What a consumer can do meanwhile. Demanded once `severity` is `degraded`."
          //  { when = Some (condition "severity" [ "degraded" ]) }
        ]
      , optional =
        [ -- Ordinarily absent: most producers publish no capability catalog, and
          -- a defect can break behavior that was documented rather than
          -- catalogued.
          --
          -- A Mori URI rather than a `CAP-N` handle reference, and not by
          -- preference: okf resolves a local handle against this bundle's own ID
          -- index, and ties every declared reference prefix to a type this
          -- profile declares. A capability catalog is a different bundle in a
          -- different repository, so the reference is external in every case
          -- that matters, and declaring `CAP` here is a profile load failure.
          moriUri
            "capability"
            "Mori URI of the capability whose provision claim this defect contradicts."
        , -- Ordinarily absent: most defects were never absent, so demanding this
          -- under `--strict` would report a normal state as a deficiency.
          scalar
            "lastWorkingVersion"
            "Newest release where the behavior was correct. Its presence makes this a regression."
        , scalar
            "environment"
            "Where the observation was made, when the defect does not reproduce everywhere."
        ,     v02.verified
          //  { description = Some
                  "§5.2. Independent confirmations that this report is accurate. Mirror an approving `reviews` entry here."
              }
        ]
      }
    , types =
      [ TypeRule::{
        , type = "Bug Report"
        , description = Some
            "One wrong behavior, in something this repository already provides, with one reproduction."
        , pathPattern = Some "*"
        , idPrefix = Some "BUG"
        }
      ]
    }
