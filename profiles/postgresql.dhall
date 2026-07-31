--| House profile for representing PostgreSQL database schemas as OKF bundles.
--
-- Conventions encoded here:
--
-- * `type:` vocabulary — `PostgreSQL Schema`, `PostgreSQL Table`, `PostgreSQL View`.
-- * Layout — schemas at `schemas/<schema>`, tables at `schemas/<schema>/tables/<table>`,
--   views at `schemas/<schema>/views/<view>`.
-- * `resource:` — a `postgresql://` URI on every concept.
-- * Tables and views carry a `# Schema` section; tables list
--   Column / Type / Nullable / Description, views Column / Type / Description.
--
-- Built with record completion (`Profile::{…}`, `TypeRule::{…}`): unset fields take
-- the schema defaults, so this value survives backward-compatible schema growth.
let Profile = ../Profile/Type.dhall

let TypeRule = ../Profile/TypeRule.dhall

let okf = ../Profile/okf.dhall

let FieldRule = okf.defaults.FieldRule

let Cardinality = okf.Cardinality

let FieldFormat = okf.FieldFormat

let scalar =
      \(name : Text) ->
      \(description : Text) ->
        FieldRule::{
        , field = name
        , description = Some description
        , cardinality = Cardinality.Scalar
        }

in  Profile::{
    , name = "shinzui-postgresql"
    , description = Some
        "Conventions for documenting PostgreSQL schemas, tables, and views as an OKF bundle."
    , frontmatter =
      { required =
        [ scalar
            "type"
            "The exact PostgreSQL concept type governed by this profile."
        , scalar "title" "Human-readable name of the database object."
        ]
      , recommended =
        [ scalar
            "description"
            "One or two sentences explaining the object's purpose."
        , FieldRule::{
          , field = "timestamp"
          , description = Some
              "UTC time when this description was last confirmed accurate."
          , cardinality = Cardinality.Scalar
          , format = Some FieldFormat.Rfc3339Utc
          }
        , FieldRule::{
          , field = "resource"
          , description = Some "postgresql:// URI locating the live object."
          , cardinality = Cardinality.Scalar
          , format = Some (FieldFormat.UriWithScheme "postgresql")
          }
        ]
      , optional = [] : List FieldRule.Type
      }
    , allowUnknownTypes = False
    , types =
      [ TypeRule::{
        , type = "PostgreSQL Schema"
        , description = Some
            "One PostgreSQL namespace and the objects it groups."
        , pathPattern = Some "schemas/*"
        , resourceScheme = Some "postgresql"
        }
      , TypeRule::{
        , type = "PostgreSQL Table"
        , description = Some
            "One physical table, including its column contract."
        , pathPattern = Some "schemas/*/tables/*"
        , resourceScheme = Some "postgresql"
        , requireSchemaSection = True
        , schemaColumns = [ "Column", "Type", "Nullable", "Description" ]
        }
      , TypeRule::{
        , type = "PostgreSQL View"
        , description = Some "One view and the columns it projects."
        , pathPattern = Some "schemas/*/views/*"
        , resourceScheme = Some "postgresql"
        , requireSchemaSection = True
        , schemaColumns = [ "Column", "Type", "Description" ]
        }
      ]
    }
