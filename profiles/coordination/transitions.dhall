-- Declared intent only. Observation envelopes and retirement verdicts belong to Mori.
let Profile = ../../Profile/Type.dhall

let Frontmatter = ../../Profile/FrontmatterRules.dhall

let TypeRule = ../../Profile/TypeRule.dhall

let okf = ../../Profile/okf.dhall

let F = okf.defaults.FieldRule

let N = okf.defaults.NestedFieldRule

let R = okf.defaults.NestedRules

let C = okf.Cardinality

let Format = okf.FieldFormat

let v02 = ../../Profile/V02.dhall

let reviews = ../../Profile/ReviewRule.dhall

in  Profile::{
    , name = "transitions"
    , description = Some
        "Declared platform responsibility movement with TR-N handles; phase describes intent, never proves predecessor retirement."
    , guidance = Some
        "Use canonical project roots and typed capability/context/flow/use-case URIs. Requirements may be absent or empty. Their environments default to all; acceptance defaults false; itemized defaults true for consumer-migration, event-obligation and responsibility-transfer, otherwise false. Responsibility-transfer is always itemized and has no responsibility field. Mori validates lowercase slugs, fixed maxAge durations, requirements[].owner role/party (a depth-two object), exactly one successor identity, to iff move, cross-list keys, retained duties, environment subsets, registry ownership and reference kinds. The profile engine cannot express these joins, forbidden conditional fields, regexes or recursive owner records. Capability status can raise caution but supplies no retirement evidence. Run mori transitions validate after strict profile enforcement."
    , okfVersion = "0.2"
    , requireBundleVersion = Some "0.2"
    , allowUnknownTypes = False
    , idField = Some "transitionId"
    , frontmatter = Frontmatter::{
      , required =
        [ F::{
          , field = "type"
          , description = Some "Transition concept type."
          , cardinality = C.Scalar
          }
        , F::{
          , field = "title"
          , description = Some "Transition name."
          , cardinality = C.Scalar
          }
        , F::{
          , field = "description"
          , description = Some "One-sentence intent."
          , cardinality = C.Scalar
          }
        , v02.generated
        ]
      , recommended = [ reviews ]
      , optional = [ v02.legacyTimestamp ]
      }
    , types =
      [ TypeRule::{
        , type = "Transition"
        , pathPattern = Some "*"
        , idPrefix = Some "TR"
        , frontmatter = Frontmatter::{
          , required =
            [ F::{
              , field = "transitionId"
              , description = Some "Positive unpadded TR-N handle."
              , cardinality = C.Scalar
              , format = Some (Format.DocumentHandle "TR")
              }
            , F::{
              , field = "coordinator"
              , description = Some "Owning coordinator project root."
              , cardinality = C.Scalar
              , format = Some (Format.UriWithScheme "mori")
              }
            , F::{
              , field = "kind"
              , cardinality = C.Scalar
              , allowedValues =
                [ "split"
                , "absorption"
                , "replacement"
                , "consolidation"
                , "extraction"
                ]
              }
            , F::{
              , field = "phase"
              , cardinality = C.Scalar
              , allowedValues =
                [ "planned"
                , "in-progress"
                , "validating"
                , "complete"
                , "abandoned"
                ]
              }
            , F::{
              , field = "environments"
              , cardinality = C.List
              , description = Some "Nonempty lowercase environment slugs."
              }
            , F::{
              , field = "accountable"
              , description = Some "Accountable parties."
              , cardinality = C.List
              , elementFields = Some R::{
                , required =
                  [ N::{
                    , field = "role"
                    , description = Some "Accountable role."
                    , cardinality = C.Scalar
                    }
                  , N::{
                    , field = "party"
                    , description = Some
                        "Owner identity; unassigned is explicit uncertainty."
                    , cardinality = C.Scalar
                    }
                  ]
                , optional = [] : List N.Type
                }
              }
            , F::{
              , field = "predecessors"
              , description = Some
                  "Services participating before responsibility movement."
              , cardinality = C.List
              , elementFields = Some R::{
                , required =
                  [ N::{
                    , field = "project"
                    , description = Some "Canonical predecessor project root."
                    , cardinality = C.Scalar
                    , format = Some (Format.UriWithScheme "mori")
                    }
                  , N::{
                    , field = "disposition"
                    , description = Some "Retire or retain."
                    , cardinality = C.Scalar
                    , allowedValues = [ "retire", "retain" ]
                    }
                  ]
                , optional = [] : List N.Type
                }
              , uniqueBy = Some "project"
              }
            , F::{
              , field = "successors"
              , description = Some
                  "Known project or explicitly pending identity; exactly one is checked by Mori."
              , cardinality = C.List
              , elementFields = Some R::{
                , required =
                  [ N::{
                    , field = "key"
                    , description = Some "Unique lowercase successor key."
                    , cardinality = C.Scalar
                    }
                  ]
                , optional =
                  [ N::{
                    , field = "project"
                    , description = Some "Canonical successor project root."
                    , cardinality = C.Scalar
                    , format = Some (Format.UriWithScheme "mori")
                    }
                  , N::{
                    , field = "pendingIdentity"
                    , description = Some
                        "Unsettled successor identity; no invented project."
                    , cardinality = C.Scalar
                    }
                  ]
                }
              , uniqueBy = Some "key"
              }
            , F::{
              , field = "responsibilities"
              , description = Some "Declared duties and their dispositions."
              , cardinality = C.List
              , elementFields = Some R::{
                , required =
                  [ N::{
                    , field = "key"
                    , description = Some "Unique lowercase responsibility key."
                    , cardinality = C.Scalar
                    }
                  , N::{
                    , field = "title"
                    , description = Some "Human-readable duty."
                    , cardinality = C.Scalar
                    }
                  , N::{
                    , field = "from"
                    , description = Some "Listed predecessor project root."
                    , cardinality = C.Scalar
                    , format = Some (Format.UriWithScheme "mori")
                    }
                  , N::{
                    , field = "disposition"
                    , description = Some "Move, discontinue or retain."
                    , cardinality = C.Scalar
                    , allowedValues = [ "move", "discontinue", "retain" ]
                    }
                  , N::{
                    , field = "to"
                    , description = Some
                        "Listed successor key, required for move."
                    , cardinality = C.Scalar
                    , when = Some
                      { field = "disposition", hasValue = [ "move" ] }
                    }
                  ]
                , optional =
                  [ N::{
                    , field = "owner"
                    , description = Some "Responsible party."
                    , cardinality = C.Scalar
                    }
                  , N::{
                    , field = "capabilityRefs"
                    , description = Some "Capability concept URIs; read only."
                    , cardinality = C.List
                    , format = Some (Format.UriWithScheme "mori")
                    }
                  , N::{
                    , field = "contextRefs"
                    , description = Some "Typed DDD context URIs."
                    , cardinality = C.List
                    , format = Some (Format.UriWithScheme "mori")
                    }
                  , N::{
                    , field = "flowRefs"
                    , description = Some "Typed DDD flow URIs."
                    , cardinality = C.List
                    , format = Some (Format.UriWithScheme "mori")
                    }
                  , N::{
                    , field = "useCaseRefs"
                    , description = Some "Use Case concept URIs."
                    , cardinality = C.List
                    , format = Some (Format.UriWithScheme "mori")
                    }
                  ]
                }
              , uniqueBy = Some "key"
              }
            ]
          , optional =
            [ F::{
              , field = "phaseSource"
              , description = Some "Source for the declared phase."
              , cardinality = C.Scalar
              }
            , F::{
              , field = "requirements"
              , description = Some
                  "Optional retirement requirements; absence never establishes readiness. Mori validates each owner object."
              , cardinality = C.List
              , elementFields = Some R::{
                , required =
                  [ N::{
                    , field = "key"
                    , description = Some "Unique lowercase requirement key."
                    , cardinality = C.Scalar
                    }
                  , N::{
                    , field = "predecessor"
                    , description = Some "Listed predecessor project root."
                    , cardinality = C.Scalar
                    , format = Some (Format.UriWithScheme "mori")
                    }
                  , N::{
                    , field = "kind"
                    , description = Some "Obligation category."
                    , cardinality = C.Scalar
                    , allowedValues =
                      [ "consumer-migration"
                      , "responsibility-transfer"
                      , "routing-cutover"
                      , "in-flight-drain"
                      , "data-obligation"
                      , "event-obligation"
                      , "rollback"
                      , "operational-continuity"
                      , "ownership"
                      , "other"
                      ]
                    }
                  , N::{
                    , field = "statement"
                    , description = Some "What must be established."
                    , cardinality = C.Scalar
                    }
                  , N::{
                    , field = "minimumBasis"
                    , description = Some "Minimum factual evidence strength."
                    , cardinality = C.Scalar
                    , allowedValues =
                      [ "declared", "source-observed", "runtime-observed" ]
                    }
                  ]
                , optional =
                  [ N::{
                    , field = "owner"
                    , description = Some
                        "Required object with role and party by the Mori gate; nested mappings exceed the profile engine depth."
                    , cardinality = C.Any
                    }
                  , N::{
                    , field = "environments"
                    , description = Some
                        "Subset of transition environments; defaults to all."
                    , cardinality = C.List
                    }
                  , N::{
                    , field = "requiresAcceptance"
                    , description = Some "Defaults to false."
                    , cardinality = C.Scalar
                    , format = Some Format.Boolean
                    }
                  , N::{
                    , field = "itemized"
                    , description = Some
                        "Defaults true for consumer-migration, event-obligation and responsibility-transfer; otherwise false."
                    , cardinality = C.Scalar
                    , format = Some Format.Boolean
                    }
                  , N::{
                    , field = "responsibility"
                    , description = Some
                        "Optional listed duty key; forbidden for responsibility-transfer."
                    , cardinality = C.Scalar
                    }
                  , N::{
                    , field = "maxAge"
                    , description = Some
                        "Owner-selected fixed duration; Mori parses and checks it."
                    , cardinality = C.Scalar
                    }
                  ]
                }
              , uniqueBy = Some "key"
              }
            ]
          }
        }
      ]
    }
