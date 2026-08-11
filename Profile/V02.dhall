--| The six OKF v0.2 frontmatter families, described once for the whole catalog.
--
-- Every profile in this repository that adopts OKF v0.2 splices its rules from
-- here rather than re-authoring them, so that a correction lands in one place
-- instead of drifting across seven files. Import it and name what you need:
--
--     let v02 = ../../Profile/V02.dhall
--
--     in  Profile::{ okfVersion = "0.2", frontmatter = FrontmatterRules::{
--         , required = [ …, v02.generated ]
--         , optional = [ v02.verified, v02.legacyTimestamp ]
--         } }
--
-- A consuming profile may reword a rule with the `//` operator:
--
--     v02.generated // { description = Some "How this decision record was produced." }
--
-- but must not redefine the constraint. If a shared value is wrong for one
-- profile it is wrong for all of them: fix it here and re-verify every consumer.
--
-- Descriptions are deliberately short. okf echoes a rule's description back
-- inside its missing-field diagnostic, so a paragraph there produces an
-- unreadable error line; explanations belong in comments like this one. They are
-- also worded to make sense in *any* profile in this catalog, since all of them
-- surface the same text.
--
-- The assembled, standalone form of these values ships as `../profiles/okf-v0-2.dhall`
-- (exported as `okfV02`), a format-level reference profile for a team with no
-- house conventions.
--
--
-- ## Policy one: where the house `status` key collides, the house key wins
--
-- OKF v0.2 §5.4 gives `status` the vocabulary `draft` / `stable` / `deprecated`.
-- Seven profiles in this repository use the same key name for a house lifecycle
-- vocabulary — five that predate v0.2, and two introduced after it that answer a
-- question v0.2's vocabulary cannot:
--
--   * `documentation.architectureDecisions` — `Accepted`, and siblings
--   * `documentation.patternCatalog`        — `current`, `deprecated`
--   * `documentation.researchDocuments`     — `active`, `complete`, `superseded`
--   * `coordination.improvementRequests`    — `proposed`, `accepted`, `in-progress`,
--                                             `completed`, `rejected`, `withdrawn`,
--                                             `superseded`
--   * `coordination.useCases`               — `draft`, `validated`, `planned`,
--                                             `in-progress`, `delivered`, `retired`
--   * `coordination.capabilities`           — `shipped`, `deprecated`, `withdrawn`
--   * `coordination.bugReports`             — `reported`, `confirmed`, `in-progress`,
--                                             `fixed`, `wont-fix`, `duplicate`,
--                                             `not-a-bug`, `cannot-reproduce`
--
-- Those seven keep their house vocabulary and do **not** splice in `status` or
-- `staleAfter` from this module. This is sanctioned rather than tolerated: a
-- profile key name does not imply the OKF core key of that name, and okf never
-- rejects a profile over it. What okf checks instead is value *formats*, because
-- a format has no house-convention reading.
--
-- Renaming the house key was considered and rejected — it would break every
-- consumer corpus, every cross-repository citation, and every downstream query,
-- for no conformance gain. The accepted consequence is that `okf trust` prints
-- the house value verbatim as a status it does not recognise.
--
-- Profiles with no collision — `postgresql`, `tanPostgresql`, and the `okfV02`
-- reference profile — do declare both `status` and `staleAfter`.
--
--
-- ## Policy two: the house `reviews` family and OKF `verified` coexist
--
-- `./ReviewRule.dhall` defines a rich house review record — reviewer identity,
-- review scope, outcome, serving provider, model identifier, reasoning effort,
-- and evidence context — used by `coordination.improvementRequests`,
-- `coordination.useCases`, and `documentation.researchDocuments`. OKF `verified`
-- records only `by` and `at`.
--
-- Neither is a superset of the other, so neither replaces the other. Dropping
-- `reviews` would destroy information three profiles already collect; omitting
-- `verified` would leave `okf trust` reporting every concept as `unverified`
-- even where a human approved it. Both are declared, and a producer that records
-- an approving `reviews` entry should mirror it into `verified` so the derived
-- trust tier is accurate.
--
--
-- ## Do not declare a `trust` key
--
-- A document's trust tier is computed on every read from `verified` and is never
-- written into a bundle. A document carrying `trust:` is carrying an ordinary
-- extension field that okf ignores.
let okf = ./okf.dhall

let FieldRule = okf.defaults.FieldRule

let NestedRules = okf.defaults.NestedRules

let Cardinality = okf.Cardinality

let FieldFormat = okf.FieldFormat

let field = okf.mk.FieldRule

let nested = okf.mk.NestedFieldRule

-- §5.2. `by` is REQUIRED within a trust record; `at` is the timestamp. The same
-- member rules describe `generated` and each `verified` entry, so they are
-- written once and shared.
let trustMembers =
      NestedRules::{
      , required =
        [ -- §7 states that producers MUST use the `human:` prefix for
          -- hand-authored content, because §5.3 makes that prefix the sole
          -- discriminator between the machine-confirmed and human-reviewed
          -- trust tiers. The `actor` format checks the shape; a profile that
          -- wants to demand the human tier uses `nested.humanActor` instead.
              nested.documented
                "by"
                "§7. The actor responsible: `<producer>/<version>`, `human:<id>`, or `process:<id>`."
          //  { format = Some FieldFormat.Actor }
        ]
      , recommended =
        [     nested.documented
                "at"
                "UTC RFC3339 timestamp, ending in `Z`, for when this happened."
          //  { format = Some FieldFormat.Rfc3339Utc }
        ]
      }

-- §5.2. A mapping, not a list: content is produced once. Supersedes the v0.1
-- `timestamp` key per §13.1 — see `legacyTimestamp` below.
let generated =
          field.record "generated" trustMembers
      //  { description = Some
              "§5.2. How this content was produced. Supersedes the v0.1 `timestamp` key."
          }

-- §5.2 permits `verified` as a list of mappings or as one bare mapping, and
-- requires a consumer to treat the bare mapping as a one-element list.
-- `recordOrList` declares both spellings against the same member rules, so
-- either is accepted and both are checked.
--
-- Place this in a profile's `optional` list, not `recommended`: §11 forbids
-- treating a missing optional family as a deficiency, so demanding it would make
-- `--strict` complain about every unverified concept.
let verified =
          field.recordOrList "verified" trustMembers
      //  { description = Some
              "§5.2. Independent confirmations that the content is accurate. A list of mappings, or one bare mapping."
          }

-- §5.4. Absence means `stable`, so this is never demanded.
--
-- Do NOT splice this into a profile that already uses `status` for a house
-- lifecycle vocabulary — see Policy one in the header.
let status =
      FieldRule::{
      , field = "status"
      , description = Some
          "§5.4. Lifecycle state. Absence means `stable`, so this is never demanded."
      , allowedValues = [ "draft", "stable", "deprecated" ]
      , cardinality = Cardinality.Scalar
      }

-- §5.5. Advisory: okf records the date but does not compare it against the
-- clock during validation. A concept is stale when `today >= stale_after`,
-- inclusive.
let staleAfter =
      FieldRule::{
      , field = "stale_after"
      , description = Some
          "§5.5. Calendar date after which the content should be re-confirmed."
      , cardinality = Cardinality.Scalar
      , format = Some FieldFormat.Date
      }

-- §5.1. Only `resource` is required within an entry.
let sourceMembers =
      NestedRules::{
      , required =
        [ -- Deliberately no path rule. §5.1 says this names either a concrete
          -- artifact a consumer can follow or a population or scope descriptor
          -- it cannot, so demanding a resolvable path is a house convention
          -- rather than a v0.2 rule. A profile that wants one writes
          -- `nested.localOrExternalPath "resource" [ "https" ]`.
          nested.documented
            "resource"
            "§5.1. What the source is: a followable artifact, or a scope descriptor."
        ]
      , optional =
        [ nested.documented
            "id"
            "§5.1. Short label for this entry, used to cite it from a footnote in the body."
        , nested.documented "title" "§5.1. Human-readable name for the source."
        ,     nested.documented
                "author"
                "§5.1. Who or what produced the source, per the §7 actor convention."
          //  { format = Some FieldFormat.Actor }
        , -- A YAML integer, not a quoted string: coercing `"40"` would hide a
          -- producer mistake, so okf does not read it.
              nested.documented
                "usage_count"
                "§5.1. How many times the source was drawn on. A count, so never negative."
          //  { format = Some FieldFormat.NonNegativeInteger }
        ,     nested.documented
                "last_modified"
                "§5.1. Calendar date the source itself last changed."
          //  { format = Some FieldFormat.Date }
        ]
      }

let sources =
          field.recordList "sources" sourceMembers
      //  { description = Some
              "§5.1. What this content was derived from, one entry per source."
          }

-- §5.1. A sibling of `sources`, not a member of it: it frames every entry's
-- usage count.
let usageWindowMembers =
      NestedRules::{
      , optional =
        [     nested.documented "from" "§5.1. Calendar date the window opens."
          //  { format = Some FieldFormat.Date }
        ,     nested.documented "to" "§5.1. Calendar date the window closes."
          //  { format = Some FieldFormat.Date }
        ]
      }

let usageWindow =
          field.record "usage_window" usageWindowMembers
      //  { description = Some
              "§5.1. The period the sources were observed over, when one applies to the whole concept."
          }

-- The superseded v0.1 key, for placement in a profile's `optional` list ONLY.
--
-- As of okf 0.5.0.0 a profile's declared `okfVersion` is compile-checked against
-- the rules it declares. Putting this rule in `required` or `recommended`
-- alongside `okfVersion = "0.2"` is a hard profile load failure:
--
--     Failed to load profile …: invalid profile definition:
--       - profile frontmatter: declared okfVersion 0.2 supersedes the frontmatter
--         key timestamp (OKF 0.2); move it to the optional list or replace it
--         with generated
--
-- `optional` is the right presence class and is explicitly legal: the key is
-- never reported when absent, in any mode, while its RFC3339-UTC format is still
-- checked whenever it is present. okf reads `timestamp` whenever `generated` is
-- absent, silently and with no removal horizon, so keeping the rule lets a
-- half-migrated corpus keep validating without letting a malformed legacy
-- timestamp through unnoticed.
let legacyTimestamp =
          field.rfc3339Utc "timestamp"
      //  { description = Some
              "Superseded v0.1 revision timestamp. Prefer `generated.at`; keep this in `optional` only."
          }

in  { trustMembers
    , generated
    , verified
    , status
    , staleAfter
    , sourceMembers
    , sources
    , usageWindowMembers
    , usageWindow
    , legacyTimestamp
    }
