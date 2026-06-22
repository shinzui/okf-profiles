--| The schema for a profile's frontmatter expectations.
--
-- * `required`    keys that must be present and non-empty on every concept.
-- * `recommended` keys that are encouraged but not enforced (informational;
--                 okf-core reports only `required` keys as violations).
--
-- Mirrors the `FrontmatterRules` decoder in okf-core's `Okf.Profile`.
{ required : List Text
, recommended : List Text
}
