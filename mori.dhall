let Schema =
      https://raw.githubusercontent.com/shinzui/mori-schema/8560d0b0b1167dc9f6a2aa91c28f98258ef9f175/package.dhall
        sha256:cb21190627093d2c2b44a1f5cb7b812e52ab46d62224ee57f4eeb228bed45d5c

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
    , profiles =
      [ Schema.OkfProfile::{
        , name = "capabilities"
        , export = "coordination.capabilities"
        , path = Some "profiles/coordination/capabilities.dhall"
        , version = Some "v0.9.0"
        }
      , Schema.OkfProfile::{
        , name = "improvement-requests"
        , export = "coordination.improvementRequests"
        , path = Some "profiles/coordination/improvement-requests.dhall"
        , version = Some "v0.8.0"
        }
      , Schema.OkfProfile::{
        , name = "use-cases"
        , export = "coordination.useCases"
        , path = Some "profiles/coordination/use-cases.dhall"
        , version = Some "v0.8.0"
        }
      , Schema.OkfProfile::{
        , name = "architecture-decisions"
        , export = "documentation.architectureDecisions"
        , path = Some "profiles/documentation/architecture-decisions.dhall"
        , version = Some "v0.8.0"
        }
      , Schema.OkfProfile::{
        , name = "pattern-catalog"
        , export = "documentation.patternCatalog"
        , path = Some "profiles/documentation/pattern-catalog.dhall"
        , version = Some "v0.8.0"
        }
      , Schema.OkfProfile::{
        , name = "research-documents"
        , export = "documentation.researchDocuments"
        , path = Some "profiles/documentation/research-documents.dhall"
        , version = Some "v0.8.0"
        }
      , Schema.OkfProfile::{
        , name = "okf-v0-2"
        , export = "okfV02"
        , path = Some "profiles/okf-v0-2.dhall"
        , version = Some "v0.8.0"
        }
      , Schema.OkfProfile::{
        , name = "postgresql"
        , export = "postgresql"
        , path = Some "profiles/postgresql.dhall"
        , version = Some "v0.8.0"
        }
      , Schema.OkfProfile::{
        , name = "tan-postgresql"
        , export = "tanPostgresql"
        , path = Some "profiles/tan-postgresql.dhall"
        , version = Some "v0.8.0"
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
