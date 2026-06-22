--| Schema for a single per-`type` rule inside an OKF house profile.
--
-- The record *type* comes from okf's canonical schema (./okf.dhall); this file
-- adds only the `default` record so values can be built with completion
-- (`TypeRule::{ type = "PostgreSQL Table", … }`). Only `type` is mandatory.
-- See README.md ("Schema evolution").
let okf = ./okf.dhall

let defaults =
      { pathPattern = None Text
      , resourceScheme = None Text
      , requireSchemaSection = False
      , schemaColumns = [] : List Text
      }

in  { Type = okf.TypeRule, default = defaults }
