--| The schema for a complete OKF house profile.
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
-- * `name`              identifier for the profile, used in tool output.
-- * `okfVersion`        the OKF specification version the profile targets.
-- * `frontmatter`       global frontmatter expectations (see FrontmatterRules).
-- * `allowUnknownTypes` when False, any concept whose `type:` is not covered by a
--                       rule is reported as a violation.
-- * `types`             one rule per governed `type:` string (see TypeRule).
--
-- Mirrors the `ProfileSpec` decoder in okf-core's `Okf.Profile`. Keep the two in
-- sync; see README.md ("Compatibility").
let TypeRule = ./TypeRule.dhall

let FrontmatterRules = ./FrontmatterRules.dhall

in  { name : Text
    , okfVersion : Text
    , frontmatter : FrontmatterRules
    , allowUnknownTypes : Bool
    , types : List TypeRule
    }
