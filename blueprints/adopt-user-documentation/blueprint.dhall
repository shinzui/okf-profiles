let S =
      https://raw.githubusercontent.com/shinzui/seihou-schema/49ff1e5b353b171b1b52946f478623ee4423ea93/package.dhall
        sha256:cadacb688dd31ec39feb7f2fe599973a1ad58ef8fcc8ed1100bf3da22a1222cb

in  S.Blueprint::{
    , name = "adopt-user-documentation"
    , version = Some "0.13.1"
    , description = Some
        "Adapt existing docs/user and docs/guides corpora to the shared user-documentation profile, preserving prose while adding reader-intent types, stable DOC-N handles, strict validation, and Mori bundle registration."
    , prompt = ./prompt.md as Text
    , files =
      [ S.Blueprint.BlueprintFile::{
        , src = "user-documentation-profile.dhall"
        , description = Some
            "Version-pinned documentation.userDocumentation descriptor to install once and share across adopted bundles."
        }
      , S.Blueprint.BlueprintFile::{
        , src = "migration-reference.md"
        , description = Some
            "The v0.13.1 profile contract, reader-intent taxonomy, identity policy, Mori declarations, and validation sequence."
        }
      ]
    , -- This is first-time adoption or idempotent reconciliation. No earlier
      -- user-documentation profile contract exists to select with --from.
      migrations = [] : List S.BlueprintMigration.Type
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
    , tags = [ "adoption", "documentation", "guides", "migration", "mori", "okf" ]
    }
