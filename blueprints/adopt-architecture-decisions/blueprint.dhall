let S =
      https://raw.githubusercontent.com/shinzui/seihou-schema/0e1b875efcf2b4e4b98d93595ea627290459e3ad/package.dhall
        sha256:356829d4e2b333ce157615dd7eccd0cd4765f3ef0d94ef637fa8c97398d3b92c

in  S.Blueprint::{
    , name = "adopt-architecture-decisions"
    , version = Some "0.8.0"
    , description = Some
        "Adapt an existing docs/adr corpus to the shared OKF architecture-decision profile, preserving project-specific history while adding stable ADR-N handles, enforced profile validation, Mori bundle registration, and rename-stable cross-repository references."
    , prompt = ./prompt.md as Text
    , files =
      [ S.Blueprint.BlueprintFile::{
        , src = "architecture-decisions-profile.dhall"
        , description = Some
            "Version-pinned local descriptor to install as docs/adr/profile.dhall in the target repository."
        }
      , S.Blueprint.BlueprintFile::{
        , src = "migration-reference.md"
        , description = Some
            "Profile contract, legacy-shape examples, collision policy, Mori registration shape, and validation commands."
        }
      ]
    , migrations =
      [ S.BlueprintMigration::{
        , from = "0.6.0"
        , to = "0.7.0"
        , prompt = ./migrations/0-6-to-0-7.md as Text
        }
      , S.BlueprintMigration::{
        , from = "0.7.0"
        , to = "0.8.0"
        , prompt = ./migrations/0-7-to-0-8.md as Text
        }
      ]
    , allowedTools = Some
      [ "Read"
      , "Edit"
      , "Write"
      , "Bash(dhall *)"
      , "Bash(git *)"
      , "Bash(find *)"
      , "Bash(make *)"
      , "Bash(mori *)"
      , "Bash(okf *)"
      , "Bash(rg *)"
      ]
    , tags = [ "adr", "documentation", "migration", "mori", "okf" ]
    }
