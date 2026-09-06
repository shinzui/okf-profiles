--| Profile for recurring failure modes: what went wrong, how to recognise it
-- next time, and which explanations have already been ruled out.
--
-- ## What a failure mode is, and what it is not
--
-- A failure mode is a *diagnosis that outlived its incident*. It exists because
-- the same symptom appeared in more than one place, cost real time to identify
-- each time, and will appear again. The record's whole job is to make the second
-- and third diagnosis cheap.
--
--   * A defect in behavior one repository already claims to provide is NOT a
--     failure mode. That is a `coordination.bugReports` entry, scoped to one
--     repository with one reproduction. A failure mode is what you write when
--     the same symptom crosses repositories, or when the cause sits in a
--     toolchain, a runtime, or a habit rather than in anybody's source.
--   * A single incident nobody expects to see again is NOT a failure mode
--     either. Write it down when it recurs, or when the mechanism guarantees it
--     will. Until then the honest artifact is a research document.
--   * A cause nobody has isolated is not one yet: `status` starts at `observed`,
--     and `rootCause` is not demanded until `diagnosed`. A catalog that lets
--     suspicion masquerade as diagnosis is worse than no catalog, because the
--     next reader stops looking.
--   * Granularity: one failure mode is one mechanism. Two symptoms with one
--     mechanism are one entry with two `occurrences`; two mechanisms that happen
--     to look alike are two entries, and `signature` is what tells them apart.
--
--
-- ## `eliminated` is the field this profile exists for
--
-- Every other key here has an analogue in some tracker somewhere. This one
-- rarely does, and it is where the time actually goes: the expensive part of a
-- recurring diagnosis is not finding the cause, it is re-walking the plausible
-- explanations that are wrong. A record that says only "the cause was X" leaves
-- the next reader to re-test the four theories that preceded X.
--
-- An entry is only worth writing if it names the check that disproved it. "It
-- wasn't the timeout" is a memory; "`timeout 2 bash -c 'bash -c \"sleep 90 &
-- wait\"'` kills the sleep, so GNU timeout does signal the process group" is a
-- result the next reader can trust without re-running it — and can re-run in
-- seconds if they doubt it. Entries without a check belong in the body.
--
--
-- ## `signature` is for recognition, `diagnosis` is for confirmation
--
-- They are separate keys because they answer different questions at different
-- costs. `signature` is what a reader matches against a live symptom in seconds,
-- from what is already on their screen. `diagnosis` is the ordered set of checks
-- that decide it, cheapest first, run once the signature matches.
--
-- Collapsing the two produces a record nobody consults during an incident,
-- because matching it requires running something.
--
--
-- ## The house `status` vocabulary
--
-- Per ADR-1 this profile declares its own lifecycle on `status` and does not
-- splice OKF v0.2 §5.4. The question is "how far has this been driven to
-- ground", which is not the draft/stable/deprecated question v0.2 asks.
--
--   * `observed`   — the symptom is recorded; the mechanism is not established.
--   * `diagnosed`  — the mechanism is established and `rootCause` says what it is.
--   * `mitigated`  — a control exists that reduces the cost, not the frequency.
--   * `prevented`  — a control exists that stops it recurring, and it is applied.
--   * `accepted`   — understood, and deliberately left in place. `control` then
--                    records what makes that tolerable.
--
-- `prevented` is a claim about the world, not about intent: it means the control
-- is deployed everywhere the mode can occur. A fix that exists in one repository
-- while the mode can still fire in six others is `mitigated`.
--
--
-- ## `scope` decides where the fix has to live
--
-- The reason a failure mode recurs is almost always that the fix was applied at
-- the wrong altitude. `scope` records the altitude the mechanism actually sits
-- at, which is what makes the record actionable rather than merely interesting:
--
--   * `project`   — one repository's code or configuration.
--   * `fleet`     — a convention shared across repositories: an agent
--                   instruction, a justfile recipe, a template.
--   * `toolchain` — a compiler, runtime, or CLI behaving as designed, where the
--                   fix is to stop relying on the assumption that it does not.
--   * `platform`  — the machine or OS.
--
-- A mode whose `scope` is `fleet` and whose `control` names one repository is
-- the commonest way an entry gets written and then recurs anyway.
--
--
-- ## `occurrences` carries the recurrence, and is what earns the entry
--
-- One entry per sighting, newest last, each naming where and when. Two sightings
-- is the threshold for writing the record at all, so a single-element list
-- should be rare and is worth a second look: either the mechanism guarantees
-- recurrence, or this is a research document wearing the wrong type.
--
-- `mori://` URIs rather than repository names, because the corpus is queried
-- across projects and a bare name does not resolve.
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

let understood =
      condition
        "status"
        [ "diagnosed", "mitigated", "prevented", "accepted" ]

let controlled = condition "status" [ "mitigated", "prevented", "accepted" ]

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

in  Profile::{
    , name = "failure-modes"
    , description = Some
        "Recurring failure modes with stable FM handles: the signature that identifies one on sight, the checks that confirm it, the explanations already disproved, and the control that stops it. A defect in one repository's published behavior is a bug report, not a failure mode. The house `reviews` family and OKF `verified` coexist: an approving `reviews` entry should also be mirrored into `verified` to keep the derived trust tier accurate."
    , okfVersion = "0.2"
    , requireBundleVersion = Some "0.2"
    , allowUnknownTypes = False
    , idField = Some "failureModeId"
    , frontmatter = FrontmatterRules::{
      , required =
        [ scalar "type" "The Failure Mode concept type."
        , scalar "title" "Short statement of the mechanism, not of one incident."
        , scalar
            "description"
            "One sentence a reader can match against a live symptom without opening the body."
        ,     v02.generated
          //  { description = Some
                  "§5.2. Who produced this entry's current content, and when."
              }
        , FieldRule::{
          , field = "failureModeId"
          , description = Some "Bundle-scoped stable FM-N handle."
          , cardinality = Cardinality.Scalar
          , format = Some (FieldFormat.DocumentHandle "FM")
          }
        , FieldRule::{
          , field = "status"
          , description = Some
              "How far this has been driven to ground. `prevented` means the control is deployed everywhere the mode can fire, not merely written."
          , allowedValues =
            [ "observed", "diagnosed", "mitigated", "prevented", "accepted" ]
          , cardinality = Cardinality.Scalar
          }
        , -- The altitude the mechanism sits at, which is the altitude its fix
          -- has to live at. See the header: a fleet-scoped mode fixed in one
          -- repository is the commonest way an entry recurs after being written.
          FieldRule::{
          , field = "scope"
          , description = Some
              "Where the mechanism lives, and therefore where a durable fix must go."
          , allowedValues = [ "project", "fleet", "toolchain", "platform" ]
          , cardinality = Cardinality.Scalar
          }
        , scalar
            "signature"
            "What a reader matches against a live symptom in seconds, from what is already on screen. Not a diagnostic procedure."
        , list
            "occurrences"
            "One entry per sighting, newest last, each naming the Mori URI where it fired and the date."
        , list
            "diagnosis"
            "Ordered checks that confirm this mode once the signature matches, cheapest first."
        , -- Conditionally required, which okf spells `required` plus `when`: the
          -- demand only applies once the status claims a mechanism is known.
          scalar
            "rootCause"
            "The mechanism, stated so that someone who has never seen it can predict when it fires."
          //  { when = Some understood }
        , scalar
            "control"
            "The change that stops this recurring, or — under `accepted` — what makes living with it tolerable."
          //  { when = Some controlled }
        ]
      , -- `eliminated` is recommended rather than required because a mode can be
        -- diagnosed on the first try with nothing to rule out, and it is gated
        -- on `understood` because an entry still at `observed` has had nothing
        -- to rule out *yet*. Demanding it there would report the honest early
        -- state as a deficiency and invite invented content, which is the one
        -- thing this key cannot survive. Once a mechanism is claimed, the
        -- alternatives discarded on the way to it are what the next reader most
        -- needs and `--strict` should ask for them.
        recommended =
        [ reviewRule
        , list
            "eliminated"
            "Explanations tested and disproved, each naming the check that disproved it. An entry without a check belongs in the body."
          //  { when = Some understood }
        , -- Demanded once a control exists, because a control nobody can see
          -- firing is indistinguishable from one that silently stopped working.
          scalar
            "detection"
            "The standing, cheap signal that surfaces this early — the thing to watch rather than to remember."
          //  { when = Some controlled }
        ]
      , optional =
        [ -- Ordinarily absent: most modes are not instances of a filed defect.
          -- A Mori URI rather than a `BUG-N` handle reference, because the bug
          -- report lives in another bundle in another repository, and declaring
          -- a `BUG` prefix here that this profile does not type is a profile
          -- load failure.
          FieldRule::{
          , field = "bugReport"
          , description = Some
              "Mori URI of a bug report that is one instance of this mode, where a repository owns the defect."
          , cardinality = Cardinality.Scalar
          , format = Some (FieldFormat.UriWithScheme "mori")
          }
        , scalar
            "cost"
            "What each undiagnosed occurrence has cost, stated observably — machine-hours lost, work blocked. Ranks the catalog by what is worth preventing."
        , FieldRule::{
          , field = "supersededBy"
          , description = Some
              "The entry that replaces this one, as a local FM-N handle or an external Mori URI, once a sharper mechanism subsumes it."
          , cardinality = Cardinality.Scalar
          , reference = Some HandleReferenceRule::{
            , localPrefix = "FM"
            , externalUriSchemes = [ "mori" ]
            }
          }
        ,     v02.verified
          //  { description = Some
                  "§5.2. Independent confirmations that this diagnosis holds. Mirror an approving `reviews` entry here."
              }
        ]
      }
    , types =
      [ TypeRule::{
        , type = "Failure Mode"
        , description = Some
            "One mechanism, with the signature that identifies it and the control that stops it."
        , pathPattern = Some "*"
        , idPrefix = Some "FM"
        }
      ]
    }
