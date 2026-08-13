--| Profile for records of what was reviewed, by whom, and at which commit.
--
-- ## What a review record is, and what it is not
--
-- A review record is an *examination claim*: at one named commit, one named
-- reviewer looked at one named artifact for one named set of concerns, and this
-- is what came of it. It is evidence about work rather than a description of the
-- work, which is what places it in the assurance family rather than in
-- coordination or documentation:
--
--   * A review record is NOT its findings. A finding worth acting on becomes a
--     bug report or an improvement request in the repository that owns the
--     artifact, and `produced` links to it. The body carries the analysis; the
--     record carries the fact of the examination and the conditions it ran
--     under.
--   * A reading that cannot say where it stopped is NOT a review record. The
--     reviewer, the commit, and the concerns examined are all required, because
--     a record missing any of the three cannot answer the question this corpus
--     exists for — *what is already covered, and from which commit does the next
--     review start?*
--   * Granularity: one record is one subject examined at one commit. A sweep
--     across four components is four records, because a later reader asks about
--     one component at a time and a single record would claim depth on each that
--     the sweep did not have.
--
-- The house `reviews` frontmatter family in `../../Profile/ReviewRule.dhall` is
-- the same information at a different scope — an annotation recording that the
-- document carrying it was reviewed. Both exist, and a repository will use both:
-- `reviews` where the review is metadata about a document, this profile where
-- the review is the artifact being kept. They share their model vocabulary
-- through `../../Profile/ModelReview.dhall` so the grades cannot drift apart.
--
--
-- ## `subject`, `subjectKind`, and `component`
--
-- `subject` is a Mori URI naming the most specific canonical artifact available:
-- `mori://shinzui/mori/plans/172-…` where a plan has one, the project URI where
-- the reviewed thing has no artifact URI of its own. `component` carries the
-- name of the part when `subject` names the container instead:
--
--     subject: mori://example/keiro          subject: mori://example/keiro
--     subjectKind: project                   subjectKind: aggregate
--                                            component: Keiro.Domain.Order
--
-- Both keys together are the *identity* of the reviewed thing, and identity is
-- what makes a corpus of reviews worth more than a pile of them: the next
-- review of the Order aggregate finds its predecessor by matching them and
-- starts from that record's `reviewedSha`. Two spellings of the same component
-- are two subjects as far as any reader can tell, so `component` takes the
-- identifier the codebase itself uses — a package name, a module path, a
-- migration filename — and never a prose description of it.
--
-- `subjectKind` is what the identity *names*, and is assigned by looking at what
-- was read rather than by judging its importance:
--
--   * `project`   — everything the repository publishes, reviewed as one.
--   * `component` — a named part that ships as a unit: a package, a module, a
--                   service, a library component.
--   * `aggregate` — a consistency boundary inside a service or package, smaller
--                   than the component containing it.
--   * `migration` — a schema or data migration, reviewed as a unit.
--   * `plan`      — a planning artifact rather than code. It covers both a plan
--                   and a master plan, because the Mori URI already discriminates
--                   them (`/plans/` against `/masterplans/`) and a reader
--                   filtering for planning work wants both.
--
-- Where none of the five fits, widen this list deliberately rather than
-- stretching a value: a `subjectKind` that means two things stops answering the
-- query it exists for.
--
--
-- ## `reviewedSha`, `coverage`, and `baseSha`
--
-- A date says when someone looked; only a commit says what they looked at. The
-- pair is what makes the *next* review cheap — it starts from `reviewedSha`
-- rather than from nothing — so the sha is required and is the full 40-character
-- commit hash. A branch or tag name moves, and a moved reference silently
-- converts a precise record into a false one.
--
-- `coverage` says what was read at that commit, and exists because okf can
-- condition a rule on a value but not on the presence of one:
--
--   * `full`        — the whole subject was examined at `reviewedSha`.
--   * `incremental` — only `baseSha..reviewedSha` was examined, so `baseSha` is
--                     required and everything before it rests on an earlier
--                     review.
--
-- Without the distinction a reader cannot tell a thorough review from a glance
-- at a diff, and the two are worth very different amounts. `previousReview` is
-- recommended under `--strict` once a review is incremental: an increment that
-- names no predecessor leaves the chain broken at exactly the point a reader
-- needs it, and a well-run corpus continues from the last review of the same
-- subject rather than from an arbitrary commit.
--
--
-- ## `reviewerKind`, `reviewer`, and the model triple
--
-- `reviewer` is an OKF §7 actor, so mirroring it into `verified.by` is a copy
-- rather than the hand translation ADR-4 warns is easy to get wrong:
-- `human:nadeem` for a person, `process:<agent>` or `<producer>/<version>` for
-- an agent. For a model review it names the *harness* that ran the review, and
-- `provider` / `model` / `effort` name what ran inside it — an agent is
-- retargeted at a new model far more often than it is replaced, and a corpus
-- that conflated the two could not answer either question.
--
-- `reviewerKind` is the discriminator, and is a separate key rather than derived
-- from the `human:` prefix because okf conditions a rule on closed scalar values
-- and cannot test a prefix. It gates the model triple: a human review demands
-- none of the three, and a model review demands all three, because a model
-- review with no model recorded cannot be repeated or compared.
--
--
-- ## `dimensions` is what was looked for, not what was found
--
-- A review's worth is bounded by what it examined, and that is not recoverable
-- from its outcome: an `approved` correctness review says nothing about whether
-- anyone considered security. Each entry is assigned by observation — did the
-- reviewer actually look for this — and a dimension nobody examined is left off,
-- which is the entire point of recording them.
--
--   * `correctness`   — does it do what it claims: logic, edge cases, failure
--                       handling, concurrency.
--   * `security`      — can it be made to do something it must not.
--   * `performance`   — resource cost and how it scales.
--   * `design`        — structure, reuse, and whether the work sits at the right
--                       altitude.
--   * `test-coverage` — whether the tests would catch a regression.
--   * `documentation` — whether the prose matches the behavior.
--   * `operability`   — what happens in production: migration safety, rollback,
--                       observability.
--
--
-- ## A human's second look is `verified`, and this profile splices no `reviews`
--
-- OKF v0.2 §5.2 already has the key for "a person read this and stands behind
-- it": a `verified` entry whose `by` carries the §7 `human:` prefix, which §5.3
-- makes the sole discriminator of the human-reviewed trust tier. A model review
-- that a person then read and agreed with is exactly one such entry, and `okf
-- trust` reports the tier from it.
--
-- The house `reviews` family is deliberately NOT spliced here, alone in the
-- catalog. On every other profile it records that the document was reviewed; on
-- this one the document *is* the review, so a `reviews` key would record reviews
-- of a review — a shape with no reader. Sign-off goes to `verified`, and a
-- genuine second examination is a second record naming the same subject.
--
--
-- ## No `status`, and no `stale_after`
--
-- Both are deliberately absent, which is a departure from the rule in ADR-1 that
-- a profile declaring no house `status` takes OKF v0.2 §5.4's. A review is an
-- event and not a document with a lifecycle: it is never redrafted, and it does
-- not decay into `deprecated` — a later review of the same subject supersedes it
-- by existing, which the `subject` / `component` / `reviewedSha` triple already
-- says without a key to maintain. `stale_after` would encode a re-review policy,
-- and a policy belongs to the repository being reviewed rather than to one
-- record of having reviewed it. Both are additive if that judgment proves wrong:
-- adding an `optional` rule is a pure relaxation for an existing corpus.
--
--
-- ## `legacyTimestamp` is deliberately absent
--
-- `v02.legacyTimestamp` exists so a half-migrated v0.1 corpus keeps validating.
-- This profile is introduced at v0.2 and no v0.1 review corpus exists, so there
-- is nothing to keep validating. Add the rule to `optional` if one ever appears.
let Profile = ../../Profile/Type.dhall

let FrontmatterRules = ../../Profile/FrontmatterRules.dhall

let TypeRule = ../../Profile/TypeRule.dhall

let okf = ../../Profile/okf.dhall

let FieldRule = okf.defaults.FieldRule

let HandleReferenceRule = okf.defaults.HandleReferenceRule

let Cardinality = okf.Cardinality

let FieldFormat = okf.FieldFormat

let modelReview = ../../Profile/ModelReview.dhall

let v02 = ../../Profile/V02.dhall

let condition =
      \(field : Text) -> \(hasValue : List Text) -> { field, hasValue }

let modelOnly = condition "reviewerKind" [ "model" ]

let incremental = condition "coverage" [ "incremental" ]

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
    , name = "reviews"
    , description = Some
        "Records of an artifact having been reviewed: what was examined and under which stable identity, the commit it was examined at, who or which model examined it and at what effort, and what came of it. A finding worth acting on becomes a bug report or an improvement request; this corpus records the examination. A human who reads a model's review records that as an OKF `verified` entry under a `human:` actor, which is what `okf trust` reads to report the human-reviewed tier."
    , okfVersion = "0.2"
    , requireBundleVersion = Some "0.2"
    , allowUnknownTypes = False
    , idField = Some "reviewId"
    , frontmatter = FrontmatterRules::{
      , required =
        [ scalar "type" "The Review concept type."
        , scalar "title" "Short statement of what was reviewed and how it went."
        , scalar
            "description"
            "One sentence a reader can evaluate without opening the body."
        ,     v02.generated
          //  { description = Some
                  "§5.2. Who produced this record's current content, and when. Not the review itself — see `reviewer` and `reviewedAt`."
              }
        , FieldRule::{
          , field = "reviewId"
          , description = Some "Bundle-scoped stable REV-N handle."
          , cardinality = Cardinality.Scalar
          , format = Some (FieldFormat.DocumentHandle "REV")
          }
        , -- Identity, half of it. The pair `subject` + `component` is what a
          -- later review matches on to find this one; see the header.
          moriUri
            "subject"
            "Mori URI of what was reviewed: the most specific artifact that has one, else the project containing it."
        , FieldRule::{
          , field = "subjectKind"
          , description = Some
              "What `subject` and `component` name, assigned by what was read."
          , allowedValues =
            [ "project", "component", "aggregate", "migration", "plan" ]
          , cardinality = Cardinality.Scalar
          }
        , -- A date says when someone looked; only this says what they looked at,
          -- and it is what makes the next review cheap.
          scalar
            "reviewedSha"
            "Full 40-character commit SHA of the state reviewed. Never a branch or tag name, which move."
        , FieldRule::{
          , field = "coverage"
          , description = Some
              "Whether the whole subject was read at `reviewedSha`, or only the range since `baseSha`."
          , allowedValues = [ "full", "incremental" ]
          , cardinality = Cardinality.Scalar
          }
        , -- Conditionally required, which okf spells `required` plus `when`: a
          -- `when` gates a presence demand, and an `optional` rule makes no
          -- demand to gate.
              scalar
                "baseSha"
                "Commit the examined range starts after. Demanded once `coverage` is `incremental`."
          //  { when = Some incremental }
        , FieldRule::{
          , field = "reviewedAt"
          , description = Some "UTC time at which the review completed."
          , cardinality = Cardinality.Scalar
          , format = Some FieldFormat.Rfc3339Utc
          }
        , FieldRule::{
          , field = "reviewerKind"
          , description = Some
              "Whether a person or a model performed the review. Gates the provider, model, and effort keys."
          , allowedValues = [ "human", "model" ]
          , cardinality = Cardinality.Scalar
          }
        , -- An OKF §7 actor, so mirroring it into `verified.by` is a copy rather
          -- than the hand translation ADR-4 warns about. For a model review this
          -- is the harness, and `model` below is what ran inside it.
          FieldRule::{
          , field = "reviewer"
          , description = Some
              "§7 actor that performed the review: `human:<id>`, `process:<agent>`, or `<producer>/<version>`."
          , cardinality = Cardinality.Scalar
          , format = Some FieldFormat.Actor
          }
        , FieldRule::{
          , field = "outcome"
          , description = Some "Result the reviewer recorded."
          , allowedValues = [ "approved", "changes-requested", "commented" ]
          , cardinality = Cardinality.Scalar
          }
        , -- What was looked for, not what was found: an approving correctness
          -- review says nothing about whether anyone considered security.
          FieldRule::{
          , field = "dimensions"
          , description = Some
              "Concerns the review actually examined, one per entry. A concern nobody looked at is left off."
          , allowedValues =
            [ "correctness"
            , "security"
            , "performance"
            , "design"
            , "test-coverage"
            , "documentation"
            , "operability"
            ]
          , cardinality = Cardinality.List
          }
        ,     scalar "provider" modelReview.providerDescription
          //  { when = Some modelOnly }
        ,     scalar "model" modelReview.modelDescription
          //  { when = Some modelOnly }
        ,     FieldRule::{
              , field = "effort"
              , description = Some modelReview.effortDescription
              , allowedValues = modelReview.efforts
              , cardinality = Cardinality.Scalar
              }
          //  { when = Some modelOnly }
        ]
      , -- One conditional recommendation and nothing unconditional. The house
        -- `reviews` family, which is the catalog's one standing recommendation
        -- elsewhere, is deliberately absent here: this document *is* a review.
        -- See the header.
        recommended =
        [ FieldRule::{
          , field = "previousReview"
          , description = Some
              "The review this one continues from, as a local REV-N handle or an external Mori URI. Demanded once `coverage` is `incremental`."
          , cardinality = Cardinality.Scalar
          , reference = Some HandleReferenceRule::{
            , localPrefix = "REV"
            , externalUriSchemes = [ "mori" ]
            }
          , when = Some incremental
          }
        ]
      , optional =
        [ -- Ordinarily absent: a review of a whole project, or of an artifact
          -- with a Mori URI of its own, has no part to name.
          scalar
            "component"
            "Identifier the codebase uses for the part reviewed, when `subject` names the container. Never a prose description."
        , -- Ordinarily absent: a project's sha is unambiguous until the project
          -- has more than one repository, or until the reviewed artifact and the
          -- code under it live in different ones.
          moriUri
            "repository"
            "Mori URI of the repository `reviewedSha` belongs to, when `subject` alone does not settle it."
        , -- A list of Mori URIs rather than handle references, and not by
          -- preference: okf resolves a local handle against this bundle's own ID
          -- index and ties every declared reference prefix to a type this
          -- profile declares. Bug reports and improvement requests live in other
          -- bundles, so the reference is external in every case that matters,
          -- and declaring `BUG` here is a profile load failure.
          FieldRule::{
          , field = "produced"
          , description = Some
              "Mori URIs of records this review caused to exist: bug reports, improvement requests, plans."
          , cardinality = Cardinality.List
          , format = Some (FieldFormat.UriWithScheme "mori")
          }
        , scalar
            "context"
            "What the reviewer could see and how the review was run, where it bounds the result."
        ,     v02.verified
          //  { description = Some
                  "§5.2. Independent confirmations that this review is sound. A person who read it records `by: human:<id>` here."
              }
        ]
      }
    , types =
      [ TypeRule::{
        , type = "Review"
        , description = Some
            "One subject examined at one commit, for one named set of concerns."
        , pathPattern = Some "**"
        , idPrefix = Some "REV"
        }
      ]
    }
