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
  [ { name = "adopt-architecture-decisions"
    , version = Some "0.1.3"
    , path = "blueprints/adopt-architecture-decisions"
    , description = Some
        "Adapt an existing docs/adr corpus to the shared OKF architecture-decision profile, stable ADR-N handles, enforced profile validation, and Mori bundle addressing"
    , tags = [ "adr", "documentation", "migration", "mori", "okf" ]
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
