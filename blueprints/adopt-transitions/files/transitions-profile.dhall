let Cardinality = < Any | List | Scalar >

let FieldFormat =
      < Actor
      | Boolean
      | Date
      | DocumentHandle : Text
      | HumanActor
      | Integer
      | NonNegativeInteger
      | Rfc3339Utc
      | Uri
      | UriWithScheme : Text
      >

let PathReferenceRule = { allowSelf : Bool, externalUriSchemes : List Text }

let HandleReferenceRule =
      { allowLocal : Bool
      , allowSelf : Bool
      , externalUriPattern : Optional Text
      , externalUriSchemes : List Text
      , localPrefix : Text
      }

let FieldCondition = { field : Text, hasValue : List Text }

let NestedFieldRule =
      { allowedValues : List Text
      , cardinality : Cardinality
      , description : Optional Text
      , field : Text
      , format : Optional FieldFormat
      , path : Optional PathReferenceRule
      , reference : Optional HandleReferenceRule
      , when : Optional FieldCondition
      }

let NestedRules =
      { optional : List NestedFieldRule
      , recommended : List NestedFieldRule
      , required : List NestedFieldRule
      }

let FieldRule =
      { allowedValues : List Text
      , cardinality : Cardinality
      , description : Optional Text
      , elementFields : Optional NestedRules
      , field : Text
      , format : Optional FieldFormat
      , objectFields : Optional NestedRules
      , path : Optional PathReferenceRule
      , reference : Optional HandleReferenceRule
      , uniqueBy : Optional Text
      , when : Optional FieldCondition
      }

in  { allowUnknownFields = True
    , allowUnknownTypes = False
    , description = Some
        "Declared platform responsibility movement with TR-N handles; phase describes intent, never proves predecessor retirement."
    , frontmatter =
      { optional =
        [ { allowedValues = [] : List Text
          , cardinality = Cardinality.Any
          , description = Some
              "Superseded v0.1 revision timestamp. Prefer `generated.at`; keep this in `optional` only."
          , elementFields = None NestedRules
          , field = "timestamp"
          , format = Some FieldFormat.Rfc3339Utc
          , objectFields = None NestedRules
          , path = None PathReferenceRule
          , reference = None HandleReferenceRule
          , uniqueBy = None Text
          , when = None FieldCondition
          }
        ]
      , recommended =
        [ { allowedValues = [] : List Text
          , cardinality = Cardinality.List
          , description = Some
              "Chronological human or model review provenance for this document revision."
          , elementFields = Some
            { optional = [] : List NestedFieldRule
            , recommended = [] : List NestedFieldRule
            , required =
              [ { allowedValues = [ "human", "model" ]
                , cardinality = Cardinality.Scalar
                , description = Some
                    "Whether a human or model performed the review."
                , field = "kind"
                , format = None FieldFormat
                , path = None PathReferenceRule
                , reference = None HandleReferenceRule
                , when = None FieldCondition
                }
              , { allowedValues = [] : List Text
                , cardinality = Cardinality.Scalar
                , description = Some
                    "Stable identity of the reviewing person or agent."
                , field = "reviewer"
                , format = None FieldFormat
                , path = None PathReferenceRule
                , reference = None HandleReferenceRule
                , when = None FieldCondition
                }
              , { allowedValues = [] : List Text
                , cardinality = Cardinality.Scalar
                , description = Some "UTC time at which the review completed."
                , field = "reviewed_at"
                , format = Some FieldFormat.Rfc3339Utc
                , path = None PathReferenceRule
                , reference = None HandleReferenceRule
                , when = None FieldCondition
                }
              , { allowedValues = [] : List Text
                , cardinality = Cardinality.Scalar
                , description = Some
                    "Document revision timestamp covered by the review."
                , field = "document_timestamp"
                , format = Some FieldFormat.Rfc3339Utc
                , path = None PathReferenceRule
                , reference = None HandleReferenceRule
                , when = None FieldCondition
                }
              , { allowedValues =
                  [ "content"
                  , "technical-accuracy"
                  , "editorial"
                  , "catalog-metadata"
                  , "content-and-metadata"
                  ]
                , cardinality = Cardinality.Scalar
                , description = Some
                    "Aspect of the document covered by the review."
                , field = "scope"
                , format = None FieldFormat
                , path = None PathReferenceRule
                , reference = None HandleReferenceRule
                , when = None FieldCondition
                }
              , { allowedValues =
                  [ "approved", "changes-requested", "commented" ]
                , cardinality = Cardinality.Scalar
                , description = Some "Result recorded by the reviewer."
                , field = "outcome"
                , format = None FieldFormat
                , path = None PathReferenceRule
                , reference = None HandleReferenceRule
                , when = None FieldCondition
                }
              , { allowedValues = [] : List Text
                , cardinality = Cardinality.Scalar
                , description = Some
                    "Evidence and repository context used for the review."
                , field = "context"
                , format = None FieldFormat
                , path = None PathReferenceRule
                , reference = None HandleReferenceRule
                , when = None FieldCondition
                }
              , { allowedValues = [] : List Text
                , cardinality = Cardinality.Scalar
                , description = Some "Serving provider for a model review."
                , field = "provider"
                , format = None FieldFormat
                , path = None PathReferenceRule
                , reference = None HandleReferenceRule
                , when = Some { field = "kind", hasValue = [ "model" ] }
                }
              , { allowedValues = [] : List Text
                , cardinality = Cardinality.Scalar
                , description = Some "Most specific available model identifier."
                , field = "model"
                , format = None FieldFormat
                , path = None PathReferenceRule
                , reference = None HandleReferenceRule
                , when = Some { field = "kind", hasValue = [ "model" ] }
                }
              , { allowedValues =
                  [ "low", "medium", "high", "xhigh", "max", "unspecified" ]
                , cardinality = Cardinality.Scalar
                , description = Some
                    "Reasoning or thinking effort the review was run at."
                , field = "effort"
                , format = None FieldFormat
                , path = None PathReferenceRule
                , reference = None HandleReferenceRule
                , when = Some { field = "kind", hasValue = [ "model" ] }
                }
              ]
            }
          , field = "reviews"
          , format = None FieldFormat
          , objectFields = None NestedRules
          , path = None PathReferenceRule
          , reference = None HandleReferenceRule
          , uniqueBy = None Text
          , when = None FieldCondition
          }
        ]
      , required =
        [ { allowedValues = [] : List Text
          , cardinality = Cardinality.Scalar
          , description = Some "Transition concept type."
          , elementFields = None NestedRules
          , field = "type"
          , format = None FieldFormat
          , objectFields = None NestedRules
          , path = None PathReferenceRule
          , reference = None HandleReferenceRule
          , uniqueBy = None Text
          , when = None FieldCondition
          }
        , { allowedValues = [] : List Text
          , cardinality = Cardinality.Scalar
          , description = Some "Transition name."
          , elementFields = None NestedRules
          , field = "title"
          , format = None FieldFormat
          , objectFields = None NestedRules
          , path = None PathReferenceRule
          , reference = None HandleReferenceRule
          , uniqueBy = None Text
          , when = None FieldCondition
          }
        , { allowedValues = [] : List Text
          , cardinality = Cardinality.Scalar
          , description = Some "One-sentence intent."
          , elementFields = None NestedRules
          , field = "description"
          , format = None FieldFormat
          , objectFields = None NestedRules
          , path = None PathReferenceRule
          , reference = None HandleReferenceRule
          , uniqueBy = None Text
          , when = None FieldCondition
          }
        , { allowedValues = [] : List Text
          , cardinality = Cardinality.Any
          , description = Some
              "§5.2. How this content was produced. Supersedes the v0.1 `timestamp` key."
          , elementFields = None NestedRules
          , field = "generated"
          , format = None FieldFormat
          , objectFields = Some
            { optional = [] : List NestedFieldRule
            , recommended =
              [ { allowedValues = [] : List Text
                , cardinality = Cardinality.Any
                , description = Some
                    "UTC RFC3339 timestamp, ending in `Z`, for when this happened."
                , field = "at"
                , format = Some FieldFormat.Rfc3339Utc
                , path = None PathReferenceRule
                , reference = None HandleReferenceRule
                , when = None FieldCondition
                }
              ]
            , required =
              [ { allowedValues = [] : List Text
                , cardinality = Cardinality.Any
                , description = Some
                    "§7. The actor responsible: `<producer>/<version>`, `human:<id>`, or `process:<id>`."
                , field = "by"
                , format = Some FieldFormat.Actor
                , path = None PathReferenceRule
                , reference = None HandleReferenceRule
                , when = None FieldCondition
                }
              ]
            }
          , path = None PathReferenceRule
          , reference = None HandleReferenceRule
          , uniqueBy = None Text
          , when = None FieldCondition
          }
        ]
      }
    , guidance = Some
        "Use canonical project roots and typed capability/context/flow/use-case URIs. Requirements may be absent or empty. Their environments default to all; acceptance defaults false; itemized defaults true for consumer-migration, event-obligation and responsibility-transfer, otherwise false. Responsibility-transfer is always itemized and has no responsibility field. Mori validates lowercase slugs, fixed maxAge durations, requirements[].owner role/party (a depth-two object), exactly one successor identity, to iff move, cross-list keys, retained duties, environment subsets, registry ownership and reference kinds. The profile engine cannot express these joins, forbidden conditional fields, regexes or recursive owner records. Capability status can raise caution but supplies no retirement evidence. Run mori transitions validate after strict profile enforcement."
    , idField = Some "transitionId"
    , name = "transitions"
    , okfVersion = "0.2"
    , requireBundleVersion = Some "0.2"
    , types =
      [ { description = None Text
        , frontmatter =
          { optional =
            [ { allowedValues = [] : List Text
              , cardinality = Cardinality.Scalar
              , description = Some "Source for the declared phase."
              , elementFields = None NestedRules
              , field = "phaseSource"
              , format = None FieldFormat
              , objectFields = None NestedRules
              , path = None PathReferenceRule
              , reference = None HandleReferenceRule
              , uniqueBy = None Text
              , when = None FieldCondition
              }
            , { allowedValues = [] : List Text
              , cardinality = Cardinality.List
              , description = Some
                  "Optional retirement requirements; absence never establishes readiness. Mori validates each owner object."
              , elementFields = Some
                { optional =
                  [ { allowedValues = [] : List Text
                    , cardinality = Cardinality.Any
                    , description = Some
                        "Required object with role and party by the Mori gate; nested mappings exceed the profile engine depth."
                    , field = "owner"
                    , format = None FieldFormat
                    , path = None PathReferenceRule
                    , reference = None HandleReferenceRule
                    , when = None FieldCondition
                    }
                  , { allowedValues = [] : List Text
                    , cardinality = Cardinality.List
                    , description = Some
                        "Subset of transition environments; defaults to all."
                    , field = "environments"
                    , format = None FieldFormat
                    , path = None PathReferenceRule
                    , reference = None HandleReferenceRule
                    , when = None FieldCondition
                    }
                  , { allowedValues = [] : List Text
                    , cardinality = Cardinality.Scalar
                    , description = Some "Defaults to false."
                    , field = "requiresAcceptance"
                    , format = Some FieldFormat.Boolean
                    , path = None PathReferenceRule
                    , reference = None HandleReferenceRule
                    , when = None FieldCondition
                    }
                  , { allowedValues = [] : List Text
                    , cardinality = Cardinality.Scalar
                    , description = Some
                        "Defaults true for consumer-migration, event-obligation and responsibility-transfer; otherwise false."
                    , field = "itemized"
                    , format = Some FieldFormat.Boolean
                    , path = None PathReferenceRule
                    , reference = None HandleReferenceRule
                    , when = None FieldCondition
                    }
                  , { allowedValues = [] : List Text
                    , cardinality = Cardinality.Scalar
                    , description = Some
                        "Optional listed duty key; forbidden for responsibility-transfer."
                    , field = "responsibility"
                    , format = None FieldFormat
                    , path = None PathReferenceRule
                    , reference = None HandleReferenceRule
                    , when = None FieldCondition
                    }
                  , { allowedValues = [] : List Text
                    , cardinality = Cardinality.Scalar
                    , description = Some
                        "Owner-selected fixed duration; Mori parses and checks it."
                    , field = "maxAge"
                    , format = None FieldFormat
                    , path = None PathReferenceRule
                    , reference = None HandleReferenceRule
                    , when = None FieldCondition
                    }
                  ]
                , recommended =
                    [] : List
                           { allowedValues : List Text
                           , cardinality : Cardinality
                           , description : Optional Text
                           , field : Text
                           , format : Optional FieldFormat
                           , path :
                               Optional
                                 { allowSelf : Bool
                                 , externalUriSchemes : List Text
                                 }
                           , reference : Optional HandleReferenceRule
                           , when : Optional FieldCondition
                           }
                , required =
                  [ { allowedValues = [] : List Text
                    , cardinality = Cardinality.Scalar
                    , description = Some "Unique lowercase requirement key."
                    , field = "key"
                    , format = None FieldFormat
                    , path = None PathReferenceRule
                    , reference = None HandleReferenceRule
                    , when = None FieldCondition
                    }
                  , { allowedValues = [] : List Text
                    , cardinality = Cardinality.Scalar
                    , description = Some "Listed predecessor project root."
                    , field = "predecessor"
                    , format = Some (FieldFormat.UriWithScheme "mori")
                    , path = None PathReferenceRule
                    , reference = None HandleReferenceRule
                    , when = None FieldCondition
                    }
                  , { allowedValues =
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
                    , cardinality = Cardinality.Scalar
                    , description = Some "Obligation category."
                    , field = "kind"
                    , format = None FieldFormat
                    , path = None PathReferenceRule
                    , reference = None HandleReferenceRule
                    , when = None FieldCondition
                    }
                  , { allowedValues = [] : List Text
                    , cardinality = Cardinality.Scalar
                    , description = Some "What must be established."
                    , field = "statement"
                    , format = None FieldFormat
                    , path = None PathReferenceRule
                    , reference = None HandleReferenceRule
                    , when = None FieldCondition
                    }
                  , { allowedValues =
                      [ "declared", "source-observed", "runtime-observed" ]
                    , cardinality = Cardinality.Scalar
                    , description = Some "Minimum factual evidence strength."
                    , field = "minimumBasis"
                    , format = None FieldFormat
                    , path = None PathReferenceRule
                    , reference = None HandleReferenceRule
                    , when = None FieldCondition
                    }
                  ]
                }
              , field = "requirements"
              , format = None FieldFormat
              , objectFields = None NestedRules
              , path = None PathReferenceRule
              , reference = None HandleReferenceRule
              , uniqueBy = Some "key"
              , when = None FieldCondition
              }
            ]
          , recommended =
              [] : List
                     { allowedValues : List Text
                     , cardinality : Cardinality
                     , description : Optional Text
                     , elementFields :
                         Optional
                           { optional :
                               List
                                 { allowedValues : List Text
                                 , cardinality : Cardinality
                                 , description : Optional Text
                                 , field : Text
                                 , format : Optional FieldFormat
                                 , path :
                                     Optional
                                       { allowSelf : Bool
                                       , externalUriSchemes : List Text
                                       }
                                 , reference : Optional HandleReferenceRule
                                 , when : Optional FieldCondition
                                 }
                           , recommended :
                               List
                                 { allowedValues : List Text
                                 , cardinality : Cardinality
                                 , description : Optional Text
                                 , field : Text
                                 , format : Optional FieldFormat
                                 , path :
                                     Optional
                                       { allowSelf : Bool
                                       , externalUriSchemes : List Text
                                       }
                                 , reference : Optional HandleReferenceRule
                                 , when : Optional FieldCondition
                                 }
                           , required :
                               List
                                 { allowedValues : List Text
                                 , cardinality : Cardinality
                                 , description : Optional Text
                                 , field : Text
                                 , format : Optional FieldFormat
                                 , path :
                                     Optional
                                       { allowSelf : Bool
                                       , externalUriSchemes : List Text
                                       }
                                 , reference : Optional HandleReferenceRule
                                 , when : Optional FieldCondition
                                 }
                           }
                     , field : Text
                     , format : Optional FieldFormat
                     , objectFields :
                         Optional
                           { optional :
                               List
                                 { allowedValues : List Text
                                 , cardinality : Cardinality
                                 , description : Optional Text
                                 , field : Text
                                 , format : Optional FieldFormat
                                 , path :
                                     Optional
                                       { allowSelf : Bool
                                       , externalUriSchemes : List Text
                                       }
                                 , reference : Optional HandleReferenceRule
                                 , when : Optional FieldCondition
                                 }
                           , recommended :
                               List
                                 { allowedValues : List Text
                                 , cardinality : Cardinality
                                 , description : Optional Text
                                 , field : Text
                                 , format : Optional FieldFormat
                                 , path :
                                     Optional
                                       { allowSelf : Bool
                                       , externalUriSchemes : List Text
                                       }
                                 , reference : Optional HandleReferenceRule
                                 , when : Optional FieldCondition
                                 }
                           , required :
                               List
                                 { allowedValues : List Text
                                 , cardinality : Cardinality
                                 , description : Optional Text
                                 , field : Text
                                 , format : Optional FieldFormat
                                 , path :
                                     Optional
                                       { allowSelf : Bool
                                       , externalUriSchemes : List Text
                                       }
                                 , reference : Optional HandleReferenceRule
                                 , when : Optional FieldCondition
                                 }
                           }
                     , path : Optional PathReferenceRule
                     , reference : Optional HandleReferenceRule
                     , uniqueBy : Optional Text
                     , when : Optional FieldCondition
                     }
          , required =
            [ { allowedValues = [] : List Text
              , cardinality = Cardinality.Scalar
              , description = Some "Positive unpadded TR-N handle."
              , elementFields = None NestedRules
              , field = "transitionId"
              , format = Some (FieldFormat.DocumentHandle "TR")
              , objectFields = None NestedRules
              , path = None PathReferenceRule
              , reference = None HandleReferenceRule
              , uniqueBy = None Text
              , when = None FieldCondition
              }
            , { allowedValues = [] : List Text
              , cardinality = Cardinality.Scalar
              , description = Some "Owning coordinator project root."
              , elementFields = None NestedRules
              , field = "coordinator"
              , format = Some (FieldFormat.UriWithScheme "mori")
              , objectFields = None NestedRules
              , path = None PathReferenceRule
              , reference = None HandleReferenceRule
              , uniqueBy = None Text
              , when = None FieldCondition
              }
            , { allowedValues =
                [ "split"
                , "absorption"
                , "replacement"
                , "consolidation"
                , "extraction"
                ]
              , cardinality = Cardinality.Scalar
              , description = None Text
              , elementFields = None NestedRules
              , field = "kind"
              , format = None FieldFormat
              , objectFields = None NestedRules
              , path = None PathReferenceRule
              , reference = None HandleReferenceRule
              , uniqueBy = None Text
              , when = None FieldCondition
              }
            , { allowedValues =
                [ "planned"
                , "in-progress"
                , "validating"
                , "complete"
                , "abandoned"
                ]
              , cardinality = Cardinality.Scalar
              , description = None Text
              , elementFields = None NestedRules
              , field = "phase"
              , format = None FieldFormat
              , objectFields = None NestedRules
              , path = None PathReferenceRule
              , reference = None HandleReferenceRule
              , uniqueBy = None Text
              , when = None FieldCondition
              }
            , { allowedValues = [] : List Text
              , cardinality = Cardinality.List
              , description = Some "Nonempty lowercase environment slugs."
              , elementFields = None NestedRules
              , field = "environments"
              , format = None FieldFormat
              , objectFields = None NestedRules
              , path = None PathReferenceRule
              , reference = None HandleReferenceRule
              , uniqueBy = None Text
              , when = None FieldCondition
              }
            , { allowedValues = [] : List Text
              , cardinality = Cardinality.List
              , description = Some "Accountable parties."
              , elementFields = Some
                { optional =
                    [] : List
                           { allowedValues : List Text
                           , cardinality : Cardinality
                           , description : Optional Text
                           , field : Text
                           , format : Optional FieldFormat
                           , path :
                               Optional
                                 { allowSelf : Bool
                                 , externalUriSchemes : List Text
                                 }
                           , reference : Optional HandleReferenceRule
                           , when : Optional FieldCondition
                           }
                , recommended =
                    [] : List
                           { allowedValues : List Text
                           , cardinality : Cardinality
                           , description : Optional Text
                           , field : Text
                           , format : Optional FieldFormat
                           , path :
                               Optional
                                 { allowSelf : Bool
                                 , externalUriSchemes : List Text
                                 }
                           , reference : Optional HandleReferenceRule
                           , when : Optional FieldCondition
                           }
                , required =
                  [ { allowedValues = [] : List Text
                    , cardinality = Cardinality.Scalar
                    , description = Some "Accountable role."
                    , field = "role"
                    , format = None FieldFormat
                    , path = None PathReferenceRule
                    , reference = None HandleReferenceRule
                    , when = None FieldCondition
                    }
                  , { allowedValues = [] : List Text
                    , cardinality = Cardinality.Scalar
                    , description = Some
                        "Owner identity; unassigned is explicit uncertainty."
                    , field = "party"
                    , format = None FieldFormat
                    , path = None PathReferenceRule
                    , reference = None HandleReferenceRule
                    , when = None FieldCondition
                    }
                  ]
                }
              , field = "accountable"
              , format = None FieldFormat
              , objectFields = None NestedRules
              , path = None PathReferenceRule
              , reference = None HandleReferenceRule
              , uniqueBy = None Text
              , when = None FieldCondition
              }
            , { allowedValues = [] : List Text
              , cardinality = Cardinality.List
              , description = Some
                  "Services participating before responsibility movement."
              , elementFields = Some
                { optional =
                    [] : List
                           { allowedValues : List Text
                           , cardinality : Cardinality
                           , description : Optional Text
                           , field : Text
                           , format : Optional FieldFormat
                           , path :
                               Optional
                                 { allowSelf : Bool
                                 , externalUriSchemes : List Text
                                 }
                           , reference : Optional HandleReferenceRule
                           , when : Optional FieldCondition
                           }
                , recommended =
                    [] : List
                           { allowedValues : List Text
                           , cardinality : Cardinality
                           , description : Optional Text
                           , field : Text
                           , format : Optional FieldFormat
                           , path :
                               Optional
                                 { allowSelf : Bool
                                 , externalUriSchemes : List Text
                                 }
                           , reference : Optional HandleReferenceRule
                           , when : Optional FieldCondition
                           }
                , required =
                  [ { allowedValues = [] : List Text
                    , cardinality = Cardinality.Scalar
                    , description = Some "Canonical predecessor project root."
                    , field = "project"
                    , format = Some (FieldFormat.UriWithScheme "mori")
                    , path = None PathReferenceRule
                    , reference = None HandleReferenceRule
                    , when = None FieldCondition
                    }
                  , { allowedValues = [ "retire", "retain" ]
                    , cardinality = Cardinality.Scalar
                    , description = Some "Retire or retain."
                    , field = "disposition"
                    , format = None FieldFormat
                    , path = None PathReferenceRule
                    , reference = None HandleReferenceRule
                    , when = None FieldCondition
                    }
                  ]
                }
              , field = "predecessors"
              , format = None FieldFormat
              , objectFields = None NestedRules
              , path = None PathReferenceRule
              , reference = None HandleReferenceRule
              , uniqueBy = Some "project"
              , when = None FieldCondition
              }
            , { allowedValues = [] : List Text
              , cardinality = Cardinality.List
              , description = Some
                  "Known project or explicitly pending identity; exactly one is checked by Mori."
              , elementFields = Some
                { optional =
                  [ { allowedValues = [] : List Text
                    , cardinality = Cardinality.Scalar
                    , description = Some "Canonical successor project root."
                    , field = "project"
                    , format = Some (FieldFormat.UriWithScheme "mori")
                    , path = None PathReferenceRule
                    , reference = None HandleReferenceRule
                    , when = None FieldCondition
                    }
                  , { allowedValues = [] : List Text
                    , cardinality = Cardinality.Scalar
                    , description = Some
                        "Unsettled successor identity; no invented project."
                    , field = "pendingIdentity"
                    , format = None FieldFormat
                    , path = None PathReferenceRule
                    , reference = None HandleReferenceRule
                    , when = None FieldCondition
                    }
                  ]
                , recommended =
                    [] : List
                           { allowedValues : List Text
                           , cardinality : Cardinality
                           , description : Optional Text
                           , field : Text
                           , format : Optional FieldFormat
                           , path :
                               Optional
                                 { allowSelf : Bool
                                 , externalUriSchemes : List Text
                                 }
                           , reference : Optional HandleReferenceRule
                           , when : Optional FieldCondition
                           }
                , required =
                  [ { allowedValues = [] : List Text
                    , cardinality = Cardinality.Scalar
                    , description = Some "Unique lowercase successor key."
                    , field = "key"
                    , format = None FieldFormat
                    , path = None PathReferenceRule
                    , reference = None HandleReferenceRule
                    , when = None FieldCondition
                    }
                  ]
                }
              , field = "successors"
              , format = None FieldFormat
              , objectFields = None NestedRules
              , path = None PathReferenceRule
              , reference = None HandleReferenceRule
              , uniqueBy = Some "key"
              , when = None FieldCondition
              }
            , { allowedValues = [] : List Text
              , cardinality = Cardinality.List
              , description = Some "Declared duties and their dispositions."
              , elementFields = Some
                { optional =
                  [ { allowedValues = [] : List Text
                    , cardinality = Cardinality.Scalar
                    , description = Some "Responsible party."
                    , field = "owner"
                    , format = None FieldFormat
                    , path = None PathReferenceRule
                    , reference = None HandleReferenceRule
                    , when = None FieldCondition
                    }
                  , { allowedValues = [] : List Text
                    , cardinality = Cardinality.List
                    , description = Some "Capability concept URIs; read only."
                    , field = "capabilityRefs"
                    , format = Some (FieldFormat.UriWithScheme "mori")
                    , path = None PathReferenceRule
                    , reference = None HandleReferenceRule
                    , when = None FieldCondition
                    }
                  , { allowedValues = [] : List Text
                    , cardinality = Cardinality.List
                    , description = Some "Typed DDD context URIs."
                    , field = "contextRefs"
                    , format = Some (FieldFormat.UriWithScheme "mori")
                    , path = None PathReferenceRule
                    , reference = None HandleReferenceRule
                    , when = None FieldCondition
                    }
                  , { allowedValues = [] : List Text
                    , cardinality = Cardinality.List
                    , description = Some "Typed DDD flow URIs."
                    , field = "flowRefs"
                    , format = Some (FieldFormat.UriWithScheme "mori")
                    , path = None PathReferenceRule
                    , reference = None HandleReferenceRule
                    , when = None FieldCondition
                    }
                  , { allowedValues = [] : List Text
                    , cardinality = Cardinality.List
                    , description = Some "Use Case concept URIs."
                    , field = "useCaseRefs"
                    , format = Some (FieldFormat.UriWithScheme "mori")
                    , path = None PathReferenceRule
                    , reference = None HandleReferenceRule
                    , when = None FieldCondition
                    }
                  ]
                , recommended =
                    [] : List
                           { allowedValues : List Text
                           , cardinality : Cardinality
                           , description : Optional Text
                           , field : Text
                           , format : Optional FieldFormat
                           , path :
                               Optional
                                 { allowSelf : Bool
                                 , externalUriSchemes : List Text
                                 }
                           , reference : Optional HandleReferenceRule
                           , when : Optional FieldCondition
                           }
                , required =
                  [ { allowedValues = [] : List Text
                    , cardinality = Cardinality.Scalar
                    , description = Some "Unique lowercase responsibility key."
                    , field = "key"
                    , format = None FieldFormat
                    , path = None PathReferenceRule
                    , reference = None HandleReferenceRule
                    , when = None FieldCondition
                    }
                  , { allowedValues = [] : List Text
                    , cardinality = Cardinality.Scalar
                    , description = Some "Human-readable duty."
                    , field = "title"
                    , format = None FieldFormat
                    , path = None PathReferenceRule
                    , reference = None HandleReferenceRule
                    , when = None FieldCondition
                    }
                  , { allowedValues = [] : List Text
                    , cardinality = Cardinality.Scalar
                    , description = Some "Listed predecessor project root."
                    , field = "from"
                    , format = Some (FieldFormat.UriWithScheme "mori")
                    , path = None PathReferenceRule
                    , reference = None HandleReferenceRule
                    , when = None FieldCondition
                    }
                  , { allowedValues = [ "move", "discontinue", "retain" ]
                    , cardinality = Cardinality.Scalar
                    , description = Some "Move, discontinue or retain."
                    , field = "disposition"
                    , format = None FieldFormat
                    , path = None PathReferenceRule
                    , reference = None HandleReferenceRule
                    , when = None FieldCondition
                    }
                  , { allowedValues = [] : List Text
                    , cardinality = Cardinality.Scalar
                    , description = Some
                        "Listed successor key, required for move."
                    , field = "to"
                    , format = None FieldFormat
                    , path = None PathReferenceRule
                    , reference = None HandleReferenceRule
                    , when = Some
                      { field = "disposition", hasValue = [ "move" ] }
                    }
                  ]
                }
              , field = "responsibilities"
              , format = None FieldFormat
              , objectFields = None NestedRules
              , path = None PathReferenceRule
              , reference = None HandleReferenceRule
              , uniqueBy = Some "key"
              , when = None FieldCondition
              }
            ]
          }
        , guidance = None Text
        , idPrefix = Some "TR"
        , pathPattern = Some "*"
        , requireSchemaSection = False
        , resourceScheme = None Text
        , schemaColumns = [] : List Text
        , type = "Transition"
        }
      ]
    }
