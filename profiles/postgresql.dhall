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
-- The value is annotated against ./Profile/Type.dhall so any edit or downstream
-- override is type-checked against the schema.
let Profile = ../Profile/Type.dhall

let TypeRule = ../Profile/TypeRule.dhall

in    { name = "shinzui-postgresql"
      , okfVersion = "0.1"
      , frontmatter =
        { required = [ "type", "title" ]
        , recommended = [ "description", "timestamp", "resource" ]
        }
      , allowUnknownTypes = False
      , types =
        [ { type = "PostgreSQL Schema"
          , pathPattern = Some "schemas/*"
          , resourceScheme = Some "postgresql"
          , requireSchemaSection = False
          , schemaColumns = [] : List Text
          }
        , { type = "PostgreSQL Table"
          , pathPattern = Some "schemas/*/tables/*"
          , resourceScheme = Some "postgresql"
          , requireSchemaSection = True
          , schemaColumns = [ "Column", "Type", "Nullable", "Description" ]
          }
        , { type = "PostgreSQL View"
          , pathPattern = Some "schemas/*/views/*"
          , resourceScheme = Some "postgresql"
          , requireSchemaSection = True
          , schemaColumns = [ "Column", "Type", "Description" ]
          }
        ]
      }
    : Profile
