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
            "Profile schema records ({ Type, default }) plus documentation, JTBD use-case, improvement-request, and PostgreSQL profile families"
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
      , Schema.DocRef::{
        , key = "migrate-okf-bundles-to-v0-2-blueprint"
        , kind = Schema.DocKind.Runbook
        , audience = Schema.DocAudience.User
        , description = Some
            "How the cross-family blueprint detects a repository's profiled OKF bundles and migrates each to OKF v0.2"
        , location =
            Schema.DocLocation.LocalFile
              "blueprints/migrate-okf-bundles-to-v0-2/README.md"
        }
      , Schema.DocRef::{
        , key = "okf-profiles-changelog"
        , kind = Schema.DocKind.Reference
        , audience = Schema.DocAudience.User
        , description = Some
            "Release history, with what breaks for a consumer corpus in each release and how to migrate"
        , location = Schema.DocLocation.LocalFile "CHANGELOG.md"
        }
      ]
    , templates =
      [ Schema.SeihouTemplate::{
        , name = "adopt-architecture-decisions"
        , version = Some "0.8.0"
        , description = Some
            "Adapt an existing docs/adr corpus to the shared OKF architecture-decision profile, stable ADR-N handles, enforced profile validation, and Mori bundle addressing"
        , modulePath = "blueprints/adopt-architecture-decisions"
        , tags = [ "adr", "documentation", "migration", "mori", "okf" ]
        }
      , Schema.SeihouTemplate::{
        , name = "migrate-okf-bundles-to-v0-2"
        , version = Some "0.8.0"
        , description = Some
            "Detect whichever profiled OKF bundles a repository has and migrate each to Open Knowledge Format v0.2: add the generated provenance family, declare okf_version in each bundle root, reshape sources where the shape changed, and repin local descriptors"
        , modulePath = "blueprints/migrate-okf-bundles-to-v0-2"
        , tags =
          [ "coordination"
          , "documentation"
          , "migration"
          , "mori"
          , "okf"
          , "postgresql"
          ]
        }
      ]
    , okfBundles =
      [ Schema.OkfBundle::{
        , name = "adrs"
        , path = "docs/adr"
        , okfVersion = "0.2"
        , profile = Some "docs/adr/profile.dhall"
        , description = Some
            "Decisions governing this catalog: the house status divergence, the atomic v0.2 flip, presence-class policy, and what makes a rejection fixture a test"
        }
      ]
    }
