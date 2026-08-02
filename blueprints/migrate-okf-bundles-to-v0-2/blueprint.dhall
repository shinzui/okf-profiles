let S =
      https://raw.githubusercontent.com/shinzui/seihou-schema/0e1b875efcf2b4e4b98d93595ea627290459e3ad/package.dhall
        sha256:356829d4e2b333ce157615dd7eccd0cd4765f3ef0d94ef637fa8c97398d3b92c

in  S.Blueprint::{
    , name = "migrate-okf-bundles-to-v0-2"
    , -- Aligned with the okf-profiles tag this blueprint migrates to, matching
      -- the convention adopt-architecture-decisions states: that tag is the only
      -- version a consumer can read off their own repository.
      version = Some "0.8.0"
    , description = Some
        "Detect whichever profiled OKF bundles a repository has and migrate each to Open Knowledge Format v0.2 for okf-profiles v0.8.0: add the generated provenance family with an actor-checked by member derived from existing timestamps or git history, declare okf_version in each bundle root, reshape sources on the two profiles whose shape changed, and repin local descriptors -- while leaving house status vocabularies untouched."
    , prompt = ./prompt.md as Text
    , files =
      [ S.Blueprint.BlueprintFile::{
        , src = "v0-2-migration-reference.md"
        , description = Some
            "Per-profile change contract, the OKF v0.2 actor convention, the sources reshape, the house-status divergence, and the exact wording of every new diagnostic."
        }
      , S.Blueprint.BlueprintFile::{
        , src = "profile-pins.md"
        , description = Some
            "Version-pinned import lines for each of the seven profile exports, the descriptor template, and the freezing rules."
        }
      ]
    , -- No edges: this blueprint is new at 0.8.0, so there is no earlier version
      -- of it to migrate from. A future release that changes what it installs
      -- adds an edge keyed at the last release before that change.
      migrations = [] : List S.BlueprintMigration.Type
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
    , tags =
      [ "coordination"
      , "documentation"
      , "migration"
      , "mori"
      , "okf"
      , "postgresql"
      ]
    }
