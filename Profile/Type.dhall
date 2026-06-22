--| Schema for a complete OKF house profile.
--
-- A profile is a declarative description of how a team uses the Open Knowledge
-- Format (OKF): which `type:` strings are allowed, which frontmatter keys are
-- required, what `resource:` URI scheme each type needs, where each type's files
-- must live, and what columns a `# Schema` table must have.
--
-- Profiles are NOT part of the OKF standard. A bundle that deviates from a
-- profile remains fully OKF-conformant; profiles are house conventions layered
-- on top, checked (advisory by default) with `okf validate --profile`.
--
-- Exported as a `{ Type, default }` record so values are built with completion:
-- `Profile::{ name = "…", types = [ … ] }`. Only `name` is mandatory; `okfVersion`,
-- `allowUnknownTypes`, `frontmatter`, and `types` have defaults. Adding a new field
-- later (to the type and to `default`) does not break existing `Profile::{ … }`
-- values. See README.md ("Schema evolution").
--
-- The type mirrors the `ProfileSpec` decoder in okf-core's `Okf.Profile`. After okf
-- is published, it becomes a pinned remote import of okf's canonical schema.
let TypeRule = ./TypeRule.dhall

let FrontmatterRules = ./FrontmatterRules.dhall

let profileType =
      { name : Text
      , okfVersion : Text
      , frontmatter : FrontmatterRules.Type
      , allowUnknownTypes : Bool
      , types : List TypeRule.Type
      }

let defaults =
      { okfVersion = "0.1"
      , frontmatter = FrontmatterRules.default
      , allowUnknownTypes = False
      , types = [] : List TypeRule.Type
      }

in  { Type = profileType, default = defaults }
