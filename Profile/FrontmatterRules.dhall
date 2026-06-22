--| Schema for a profile's frontmatter expectations.
--
-- Exported as a `{ Type, default }` record for completion (`FrontmatterRules::{ … }`).
--
-- * `required`    keys that must be present and non-empty on every concept.
-- * `recommended` keys that are encouraged but not enforced (informational;
--                 okf-core reports only `required` keys as violations).
--
-- The type mirrors the `FrontmatterRules` decoder in okf-core's `Okf.Profile`.
let rulesType =
      { required : List Text
      , recommended : List Text
      }

let defaults =
      { required = [] : List Text
      , recommended = [] : List Text
      }

in  { Type = rulesType, default = defaults }
