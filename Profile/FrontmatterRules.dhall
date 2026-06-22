--| Schema for a profile's frontmatter expectations.
--
-- The record *type* comes from okf's canonical schema (./okf.dhall); this file
-- adds only the `default` record for completion (`FrontmatterRules::{ … }`).
let okf = ./okf.dhall

let defaults =
      { required = [] : List Text
      , recommended = [] : List Text
      }

in  { Type = okf.FrontmatterRules, default = defaults }
