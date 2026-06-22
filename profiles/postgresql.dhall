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

in  Profile::{
    , name = "shinzui-postgresql"
    , frontmatter =
      { required = [ "type", "title" ]
      , recommended = [ "description", "timestamp", "resource" ]
      }
    , types =
      [ TypeRule::{
        , type = "PostgreSQL Schema"
        , pathPattern = Some "schemas/*"
        , resourceScheme = Some "postgresql"
        }
      , TypeRule::{
        , type = "PostgreSQL Table"
        , pathPattern = Some "schemas/*/tables/*"
        , resourceScheme = Some "postgresql"
        , requireSchemaSection = True
        , schemaColumns = [ "Column", "Type", "Nullable", "Description" ]
        }
      , TypeRule::{
        , type = "PostgreSQL View"
        , pathPattern = Some "schemas/*/views/*"
        , resourceScheme = Some "postgresql"
        , requireSchemaSection = True
        , schemaColumns = [ "Column", "Type", "Description" ]
        }
      ]
    }
