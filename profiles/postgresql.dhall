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

let v02 = ../Profile/V02.dhall

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
        "Conventions for documenting PostgreSQL schemas, tables, and views as an OKF bundle. Targets OKF v0.2: provenance goes in `generated`, independent confirmation in `verified`, and lifecycle in `status` and `stale_after` — a database description decays whether or not anyone edits it."
    , frontmatter =
      { required =
        [ scalar
            "type"
            "The exact PostgreSQL concept type governed by this profile."
        , scalar "title" "Human-readable name of the database object."
        ]
      , -- `generated` is recommended rather than required, beside `description`
        -- and `resource`. This is the most permissive profile in the catalog by
        -- design — a large database is documented incrementally and a
        -- partially-documented bundle is still useful — so promoting provenance
        -- to required would invert that stance for one key. okf's own migrated
        -- `docs/profiles/postgresql.dhall` makes the same choice.
        recommended =
        [ scalar
            "description"
            "One or two sentences explaining the object's purpose."
        ,     v02.generated
          //  { description = Some
                  "§5.2. Who or what produced this description, and when it was last confirmed accurate."
              }
        , FieldRule::{
          , field = "resource"
          , description = Some "postgresql:// URI locating the live object."
          , cardinality = Cardinality.Scalar
          , format = Some (FieldFormat.UriWithScheme "postgresql")
          }
        ]
      , -- Unlike the profiles that carry a house lifecycle vocabulary on the
        -- `status` key, neither PostgreSQL profile declares one, so there is no
        -- collision and OKF v0.2 §5.4 `status` and §5.5 `stale_after` are
        -- adopted in full. See the header of ../Profile/V02.dhall for the policy,
        -- the current list, and why those profiles take the opposite branch.
        optional =
        [     v02.verified
          //  { description = Some
                  "§5.2. Independent confirmations that this description still matches the live object."
              }
        , v02.status
        ,     v02.staleAfter
          //  { description = Some
                  "§5.5. Date after which this description should be re-confirmed against the live object."
              }
        , -- The superseded v0.1 key. okf reads it whenever `generated` is
          -- absent, so an unmigrated corpus keeps validating; `optional` means
          -- its absence is never reported while its format is still checked
          -- whenever it is present. Declaring `okfVersion = "0.2"` with this
          -- rule in `required` or `recommended` is a hard profile load failure.
              v02.legacyTimestamp
          //  { description = Some
                  "Superseded v0.1 confirmation timestamp. Prefer `generated.at`."
              }
        ]
      }
    , okfVersion = "0.2"
    , -- A house convention, not a rule of the format: specification §12 makes
      -- the bundle's `okf_version` declaration a MAY, so okf never demands one.
      -- This profile's rules are written for v0.2, so a bundle it governs should
      -- say it is a v0.2 bundle. Write it with
      -- `okf index BUNDLE --write --okf-version 0.2`.
      requireBundleVersion = Some "0.2"
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
