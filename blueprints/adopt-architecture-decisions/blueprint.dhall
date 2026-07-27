let S =
      https://raw.githubusercontent.com/shinzui/seihou-schema/a0fba0d17b43b14bfdf6d0bf98f1b7ff7af4ebab/package.dhall
        sha256:36250d32d50cec0ea8c74926684ffb8b20f6d0b4f2152930dfa04a1ff108ef3f

in  S.Blueprint::{
    , name = "adopt-architecture-decisions"
    , version = Some "0.1.2"
    , description = Some
        "Adapt an existing docs/adr corpus to the shared OKF architecture-decision profile, preserving project-specific history while adding stable ADR-N handles, strict validation, Mori bundle registration, and rename-stable cross-repository references."
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
