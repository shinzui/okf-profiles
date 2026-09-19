let S =
      https://raw.githubusercontent.com/shinzui/seihou-schema/49ff1e5b353b171b1b52946f478623ee4423ea93/package.dhall
        sha256:cadacb688dd31ec39feb7f2fe599973a1ad58ef8fcc8ed1100bf3da22a1222cb

in  S.Blueprint::{
    , name = "adopt-terminology"
    , version = Some "0.18.0"
    , description = Some
        "Audit project vocabulary and author a comprehensive, concept-first terminology catalog with stable TERM handles, topic tags, evidence-backed definitions, strict validation, and Mori discovery."
    , prompt = ./prompt.md as Text
    , files =
      [ S.Blueprint.BlueprintFile::{
        , src = "terminology-profile.dhall"
        , description = Some
            "Frozen documentation.terminology selector targeting the released v0.18.0 contract."
        }
      , S.Blueprint.BlueprintFile::{
        , src = "authoring-reference.md"
        , description = Some
            "Term metadata, reader-oriented writing, categorization, identity, provenance, Mori registration, and validation rules."
        }
      , S.Blueprint.BlueprintFile::{
        , src = "coverage-review.md"
        , description = Some
            "Coverage matrix, observed adoption lessons, and behavioral acceptance scenarios for first adoption and repeat runs."
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
    , tags = [ "adoption", "documentation", "terminology", "mori", "okf" ]
    }
