let Schema =
      https://raw.githubusercontent.com/shinzui/mori-schema/93104153ecf8817547229a867302a70a25c4b3d8/package.dhall
        sha256:5e00bba267f27069df1d3caadfec2ec6a8c4e797ce652d78c09528f981b71b42

in  Schema.Project::{
    , project = Schema.ProjectIdentity::{
      , name = "okf-profiles"
      , namespace = "shinzui"
      , type = Schema.PackageType.Library
      , language = Schema.Language.Dhall
      , lifecycle = Schema.Lifecycle.Active
      , description = Some
          "Authoritative, versioned OKF house profiles authored in Dhall and importable from any project"
      , domains = [ "documentation" ]
      }
    , repos =
      [ Schema.Repo::{
        , name = "okf-profiles"
        , github = Some "shinzui/okf-profiles"
        }
      ]
    , packages =
      [ Schema.Package::{
        , name = "okf-profiles"
        , type = Schema.PackageType.Library
        , language = Schema.Language.Dhall
        , path = Some "."
        , description = Some
            "Profile schema records ({ Type, default }) plus the documentation, coordination, and PostgreSQL profile families"
        }
      ]
    , dependencies = [ "shinzui/okf", "shinzui/seihou" ]
    , docs =
      [ Schema.DocRef::{
        , key = "okf-profiles-readme"
        , kind = Schema.DocKind.Guide
        , audience = Schema.DocAudience.User
        , description = Some
            "Consuming, overriding, and versioning profiles; schema evolution and release process"
        , location = Schema.DocLocation.LocalFile "README.md"
        }
      , Schema.DocRef::{
        , key = "adopt-architecture-decisions-blueprint"
        , kind = Schema.DocKind.Runbook
        , audience = Schema.DocAudience.User
        , description = Some
            "How the adaptive ADR-adoption blueprint migrates an existing docs/adr corpus"
        , location =
            Schema.DocLocation.LocalFile
              "blueprints/adopt-architecture-decisions/README.md"
        }
      ]
    , templates =
      [ Schema.SeihouTemplate::{
        , name = "adopt-architecture-decisions"
        , version = Some "0.1.3"
        , description = Some
            "Adapt an existing docs/adr corpus to the shared OKF architecture-decision profile, stable ADR-N handles, enforced profile validation, and Mori bundle addressing"
        , modulePath = "blueprints/adopt-architecture-decisions"
        , tags = [ "adr", "documentation", "migration", "mori", "okf" ]
        }
      ]
    }
