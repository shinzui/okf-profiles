let S =
      https://raw.githubusercontent.com/shinzui/seihou-schema/0e1b875efcf2b4e4b98d93595ea627290459e3ad/package.dhall
        sha256:356829d4e2b333ce157615dd7eccd0cd4765f3ef0d94ef637fa8c97398d3b92c

in  S.Blueprint::{
    , name = "adopt-capabilities"
    , version = Some "0.9.2"
    , description = Some
        "Author a profile-governed capability catalog at docs/capabilities/ describing what a repository provides to a consumer today: stable CAP-N handles, a compatibility promise separate from availability, required evidence a reader can open, enforced profile validation, and Mori bundle registration."
    , prompt = ./prompt.md as Text
    , files =
      [ S.Blueprint.BlueprintFile::{
        , src = "capabilities-profile.dhall"
        , description = Some
            "Version-pinned local descriptor to install as docs/capabilities/profile.dhall in the target repository."
        }
      , S.Blueprint.BlueprintFile::{
        , src = "authoring-reference.md"
        , description = Some
            "Profile contract, the granularity rule, the evidence discipline, why there is no `planned` status, the Mori declaration, and the validation sequence."
        }
      ]
    , migrations = [] : List S.BlueprintMigration.Type
    , allowedTools = Some
      [ "Read"
      , "Edit"
      , "Write"
      , "Bash(dhall *)"
      , "Bash(git *)"
      , "Bash(find *)"
      , "Bash(grep *)"
      , "Bash(make *)"
      , "Bash(mori *)"
      , "Bash(okf *)"
      , "Bash(rg *)"
      ]
    , tags = [ "capabilities", "coordination", "mori", "okf" ]
    }
