let S =
      https://raw.githubusercontent.com/shinzui/seihou-schema/49ff1e5b353b171b1b52946f478623ee4423ea93/package.dhall
        sha256:cadacb688dd31ec39feb7f2fe599973a1ad58ef8fcc8ed1100bf3da22a1222cb

in  S.Blueprint::{
    , name = "adopt-transitions"
    , version = Some "0.20.0"
    , description = Some
        "Adopt declared platform transitions with stable TR handles, participant identities, responsibility movement and scoped retirement requirements."
    , prompt = ./prompt.md as Text
    , files =
      [ S.Blueprint.BlueprintFile::{
        , src = "transitions-profile.dhall"
        , description = Some
            "Self-contained snapshot of the unreleased coordination.transitions contract."
        }
      , S.Blueprint.BlueprintFile::{
        , src = "migration-reference.md"
        , description = Some
            "Transition authoring contract and migration guidance."
        }
      ]
    , migrations = [] : List S.BlueprintMigration.Type
    , allowedTools = Some
      [ "Read"
      , "Edit"
      , "Write"
      , "Bash(date *)"
      , "Bash(dhall *)"
      , "Bash(git *)"
      , "Bash(just *)"
      , "Bash(make *)"
      , "Bash(mori *)"
      , "Bash(okf *)"
      , "Bash(rg *)"
      ]
    , tags = [ "adoption", "coordination", "transitions", "mori", "okf" ]
    }
