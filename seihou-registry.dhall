{ repoName = "okf-profiles"
, repoDescription = Some
    "Authoritative OKF profiles and adaptive migrations for adopting them"
, modules =
    [] : List
           { name : Text
           , version : Optional Text
           , path : Text
           , description : Optional Text
           , tags : List Text
           }
, recipes =
    [] : List
           { name : Text
           , version : Optional Text
           , path : Text
           , description : Optional Text
           , tags : List Text
           }
, blueprints =
  [ { name = "adopt-improvement-request-contracts"
    , version = Some "0.12.0"
    , path = "blueprints/adopt-improvement-request-contracts"
    , description = Some
        "Optionally promote explicit improvement-request dependencies and acceptance conditions from prose into the validated dependencies and acceptanceCriteria frontmatter introduced by okf-profiles v0.12.0, preserving stable handles and ambiguous material"
    , tags =
      [ "adoption"
      , "coordination"
      , "improvement-requests"
      , "mori"
      , "okf"
      ]
    }
  , { name = "adopt-user-documentation"
    , version = Some "0.13.1"
    , path = "blueprints/adopt-user-documentation"
    , description = Some
        "Adapt existing docs/user and docs/guides corpora to the shared user-documentation profile, preserving prose while adding reader-intent types, stable DOC-N handles, strict validation, and Mori bundle registration."
    , tags = [ "adoption", "documentation", "guides", "migration", "mori", "okf" ]
    }
  , { name = "adopt-capabilities"
    , version = Some "0.9.3"
    , path = "blueprints/adopt-capabilities"
    , description = Some
        "Author a profile-governed capability catalog describing what a repository provides to a consumer today, with stable CAP-N handles, a compatibility promise separate from availability, required evidence, enforced profile validation, and Mori bundle addressing"
    , tags = [ "capabilities", "coordination", "mori", "okf" ]
    }
  , { name = "adopt-architecture-decisions"
    , version = Some "0.8.0"
    , path = "blueprints/adopt-architecture-decisions"
    , description = Some
        "Adapt an existing docs/adr corpus to the shared OKF architecture-decision profile, stable ADR-N handles, enforced profile validation, and Mori bundle addressing"
    , tags = [ "adr", "documentation", "migration", "mori", "okf" ]
    }
  , { name = "migrate-okf-bundles-to-v0-2"
    , version = Some "0.8.0"
    , path = "blueprints/migrate-okf-bundles-to-v0-2"
    , description = Some
        "Detect whichever profiled OKF bundles a repository has and migrate each to Open Knowledge Format v0.2: add the generated provenance family, declare okf_version in each bundle root, reshape sources where the shape changed, and repin local descriptors"
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
, prompts =
    [] : List
           { name : Text
           , version : Optional Text
           , path : Text
           , description : Optional Text
           , tags : List Text
           }
}
