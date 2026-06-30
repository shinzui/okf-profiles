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
-- this profile documents but, because OKF profiles cannot constrain per-type frontmatter
-- *values*, does not mechanically enforce:
--
--   derivation : projection | event-store | operational | scratch
--   lifecycle  : durable | ephemeral
--   domain     : true | false
--   sourceStreams : [<event-stream category>, …]   (when derivation = projection)
let Profile = ../Profile/Type.dhall

let TypeRule = ../Profile/TypeRule.dhall

let base = ./postgresql.dhall

in    base
    // { name = "tan-postgresql"
       , types =
             base.types
           # [ TypeRule::{
               , type = "Event Stream"
               , pathPattern = Some "streams/*"
               }
             ]
       }
    : Profile.Type
