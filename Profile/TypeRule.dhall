--| The schema for a single per-`type` rule inside an OKF house profile.
--
-- One `TypeRule` describes the conventions for concepts that carry a particular
-- `type:` frontmatter value (for example `PostgreSQL Table`):
--
-- * `type`                 the exact OKF `type:` string this rule governs.
-- * `pathPattern`          optional concept-ID glob the file must live under.
--                          `*` matches exactly one path segment; a single
--                          trailing `**` matches one or more remaining segments.
-- * `resourceScheme`       optional URI scheme the `resource:` value must use
--                          (checked as the prefix `<scheme>://`).
-- * `requireSchemaSection` whether the body must contain a `# Schema` section
--                          with a GitHub-flavored Markdown table.
-- * `schemaColumns`        required leading columns of that table's header row,
--                          compared case-insensitively as a prefix (extra
--                          trailing columns are allowed).
--
-- This record type mirrors the `TypeRule` decoder in okf-core's `Okf.Profile`
-- module. Keep the two in sync; see README.md ("Compatibility").
{ type : Text
, pathPattern : Optional Text
, resourceScheme : Optional Text
, requireSchemaSection : Bool
, schemaColumns : List Text
}
