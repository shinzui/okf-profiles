--| House profile for tan PostgreSQL databases as OKF bundles.
--
-- Extends the shared `shinzui-postgresql` profile (schemas, tables, views) with one extra
-- type that the base profile lacks:
--
-- * `Event Stream` — an abstract event-sourcing stream (aggregate category) at
--   `streams/<category>`. No `resource:` scheme (it is not a single physical table); it is
--   a logical stream of events inside `message_store.messages`.
--
-- Read-model projections and scratch/backup tables are NOT separate types: they are
-- physically PostgreSQL tables (`type: PostgreSQL Table`, living under
-- `schemas/<schema>/tables/<table>`). Their role is recorded in frontmatter — a convention
-- this profile now validates with type-specific field rules:
--
--   derivation : projection | event-store | operational | scratch
--   lifecycle  : durable | ephemeral
--   domain     : true | false
--   sourceStreams : [<event-stream category>, …]   (when derivation = projection)
let Profile = ../Profile/Type.dhall

let TypeRule = ../Profile/TypeRule.dhall

let okf = ../Profile/okf.dhall

let FieldRule = okf.defaults.FieldRule

let Cardinality = okf.Cardinality

let base = ./postgresql.dhall

in        base
      //  { name = "tan-postgresql"
          , description = Some
              "Tan PostgreSQL conventions, including table roles and logical event streams."
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
                  "One physical table classified by derivation, lifecycle, and domain role."
              , frontmatter =
                { required =
                  [ FieldRule::{
                    , field = "derivation"
                    , description = Some "How the table's data is produced."
                    , allowedValues =
                      [ "projection", "event-store", "operational", "scratch" ]
                    , cardinality = Cardinality.Scalar
                    }
                  , FieldRule::{
                    , field = "lifecycle"
                    , description = Some
                        "Whether the table is durable or disposable."
                    , allowedValues = [ "durable", "ephemeral" ]
                    , cardinality = Cardinality.Scalar
                    }
                  , FieldRule::{
                    , field = "domain"
                    , description = Some
                        "Whether the table stores domain state."
                    , cardinality = Cardinality.Scalar
                    }
                  , FieldRule::{
                    , field = "sourceStreams"
                    , description = Some
                        "Event-stream categories feeding a projection table."
                    , cardinality = Cardinality.List
                    , when = Some
                      { field = "derivation", hasValue = [ "projection" ] }
                    }
                  ]
                , recommended = [] : List FieldRule.Type
                , optional = [] : List FieldRule.Type
                }
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
            , TypeRule::{
              , type = "Event Stream"
              , description = Some
                  "One logical event-sourcing aggregate category."
              , pathPattern = Some "streams/*"
              }
            ]
          }
    : Profile.Type
