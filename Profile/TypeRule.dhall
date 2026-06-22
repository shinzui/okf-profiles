--| Schema for a single per-`type` rule inside an OKF house profile.
--
-- Exported as a `{ Type, default }` record so values are built with Dhall record
-- completion: `TypeRule::{ type = "PostgreSQL Table", … }`. Completion fills every
-- field that has a default, so only `type` is mandatory, and adding a new field
-- later (to the type and to `default`) does not break existing `TypeRule::{ … }`
-- values. See README.md ("Schema evolution").
--
-- Fields:
-- * `type`                 the exact OKF `type:` string this rule governs (required).
-- * `pathPattern`          optional concept-ID glob the file must live under.
--                          `*` matches exactly one path segment; a single
--                          trailing `**` matches one or more remaining segments.
-- * `resourceScheme`       optional URI scheme the `resource:` value must use.
-- * `requireSchemaSection` whether the body must contain a `# Schema` section.
-- * `schemaColumns`        required leading columns of that table's header row.
--
-- The type mirrors the `TypeRule` decoder in okf-core's `Okf.Profile`. After okf is
-- published, this becomes a pinned remote import of okf's canonical schema.
let ruleType =
      { type : Text
      , pathPattern : Optional Text
      , resourceScheme : Optional Text
      , requireSchemaSection : Bool
      , schemaColumns : List Text
      }

let defaults =
      { pathPattern = None Text
      , resourceScheme = None Text
      , requireSchemaSection = False
      , schemaColumns = [] : List Text
      }

in  { Type = ruleType, default = defaults }
