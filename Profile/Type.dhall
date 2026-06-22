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
-- The record *type* comes from okf's canonical schema (./okf.dhall); this file
-- adds only the `default` record so values are built with completion:
-- `Profile::{ name = "…", types = [ … ] }`. Only `name` is mandatory. See
-- README.md ("Schema evolution").
let okf = ./okf.dhall

let TypeRule = ./TypeRule.dhall

let FrontmatterRules = ./FrontmatterRules.dhall

let defaults =
      { okfVersion = "0.1"
      , frontmatter = FrontmatterRules.default
      , allowUnknownTypes = False
      , types = [] : List TypeRule.Type
      }

in  { Type = okf.Profile, default = defaults }
