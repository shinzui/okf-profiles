let S =
      https://raw.githubusercontent.com/shinzui/seihou-schema/0e1b875efcf2b4e4b98d93595ea627290459e3ad/package.dhall
        sha256:356829d4e2b333ce157615dd7eccd0cd4765f3ef0d94ef637fa8c97398d3b92c

in  S.Blueprint::{
    , name = "adopt-improvement-request-contracts"
    , version = Some "0.12.0"
    , description = Some
        "Optionally promote explicit improvement-request dependencies and acceptance conditions from prose into the validated dependencies and acceptanceCriteria frontmatter introduced by okf-profiles v0.12.0, preserving stable handles, source prose, and ambiguous material for human resolution."
    , prompt = ./prompt.md as Text
    , files =
      [ S.Blueprint.BlueprintFile::{
        , src = "contract-reference.md"
        , description = Some
            "The v0.12.0 structured dependency and acceptance-criterion contract, safe promotion rules, descriptor pin, and validation commands."
        }
      ]
    , -- This is an optional adoption playbook, not work required when crossing
      -- a profile release boundary. Existing bundles remain valid at v0.12.0.
      migrations = [] : List S.BlueprintMigration.Type
    , allowedTools = Some
      [ "Read"
      , "Edit"
      , "Write"
      , "Bash(dhall *)"
      , "Bash(git *)"
      , "Bash(make *)"
      , "Bash(mori *)"
      , "Bash(okf *)"
      , "Bash(rg *)"
      ]
    , tags =
      [ "adoption"
      , "coordination"
      , "improvement-requests"
      , "mori"
      , "okf"
      ]
    }
