--| Shared ADR profile. Bump the tag and semantic hash together when upgrading.
--
-- This descriptor is a plain pinned import. It carries no override, because
-- v0.8.0 folded the one this file used to layer into the upstream profile:
-- `supersedes`, `supersededBy`, and `originatingPlan` are `optional` as
-- shipped, so the local reclassification became a no-op. If you are upgrading a
-- descriptor installed at v0.7.0, delete the `//` override it carries; deleting
-- it changes nothing about which documents pass.
--
-- The profile targets Open Knowledge Format v0.2. Every concept must carry a
-- `generated` mapping whose `by` is an OKF §7 actor (`human:<id>`,
-- `process:<id>`, or `<producer>/<version>`), and the bundle root must declare
-- `okf_version: "0.2"` -- write it with
-- `okf index docs/adr --write --okf-version 0.2`. The superseded v0.1
-- `timestamp` key is `optional`: keep it if you have it, its format is still
-- checked, and its absence is never reported.
--
-- !! UNFROZEN IMPORT -- MUST BE FROZEN BEFORE RELEASE !!
--
-- This import has no `sha256:` integrity hash because the v0.8.0 tag does not
-- exist on the remote until the release is cut. Freeze it immediately after
-- tagging:
--
--     dhall freeze blueprints/adopt-architecture-decisions/files/architecture-decisions-profile.dhall
--
-- Never hand-write a `sha256:` value to fill this in, and never delete a hash
-- from a frozen import to make it resolve.
let Profiles =
      https://raw.githubusercontent.com/shinzui/okf-profiles/v0.8.0/package.dhall

in  Profiles.documentation.architectureDecisions
