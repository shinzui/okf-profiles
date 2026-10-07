let S =
      https://raw.githubusercontent.com/shinzui/seihou-schema/49ff1e5b353b171b1b52946f478623ee4423ea93/package.dhall
        sha256:cadacb688dd31ec39feb7f2fe599973a1ad58ef8fcc8ed1100bf3da22a1222cb

in  S.Blueprint::{
    , name = "adopt-runbooks"
    , version = Some "0.20.0"
    , description = Some
        "Adopt operational procedures with stable RB handles, explicit ownership, applicability and effects, preserving evidence and existing navigation."
    , prompt = ./prompt.md as Text
    , files =
      [ S.Blueprint.BlueprintFile::{
        , src = "runbooks-profile.dhall"
        , description = Some
            "Self-contained snapshot of the unreleased documentation.runbooks contract."
        }
      , S.Blueprint.BlueprintFile::{
        , src = "migration-reference.md"
        , description = Some
            "Operational authoring contract and migration guidance."
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
    , tags =
      [ "adoption", "documentation", "runbooks", "operations", "mori", "okf" ]
    }
