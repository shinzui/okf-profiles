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
        "Operational procedures with stable RB handles, accountable ownership, applicability, triggers and declared effects."
    , frontmatter =
      { optional =
        [ { allowedValues = [] : List Text
          , cardinality = Cardinality.List
          , description = Some
              "§5.1. What this content was derived from, one entry per source."
          , elementFields = Some
            { optional =
              [ { allowedValues = [] : List Text
                , cardinality = Cardinality.Any
                , description = Some
                    "§5.1. Short label for this entry, used to cite it from a footnote in the body."
                , field = "id"
                , format = None FieldFormat
                , path = None PathReferenceRule
                , reference = None HandleReferenceRule
                , when = None FieldCondition
                }
              , { allowedValues = [] : List Text
                , cardinality = Cardinality.Any
                , description = Some "§5.1. Human-readable name for the source."
                , field = "title"
                , format = None FieldFormat
                , path = None PathReferenceRule
                , reference = None HandleReferenceRule
                , when = None FieldCondition
                }
              , { allowedValues = [] : List Text
                , cardinality = Cardinality.Any
                , description = Some
                    "§5.1. Who or what produced the source, per the §7 actor convention."
                , field = "author"
                , format = Some FieldFormat.Actor
                , path = None PathReferenceRule
                , reference = None HandleReferenceRule
                , when = None FieldCondition
                }
              , { allowedValues = [] : List Text
                , cardinality = Cardinality.Any
                , description = Some
                    "§5.1. How many times the source was drawn on. A count, so never negative."
                , field = "usage_count"
                , format = Some FieldFormat.NonNegativeInteger
                , path = None PathReferenceRule
                , reference = None HandleReferenceRule
                , when = None FieldCondition
                }
              , { allowedValues = [] : List Text
                , cardinality = Cardinality.Any
                , description = Some
                    "§5.1. Calendar date the source itself last changed."
                , field = "last_modified"
                , format = Some FieldFormat.Date
                , path = None PathReferenceRule
                , reference = None HandleReferenceRule
                , when = None FieldCondition
                }
              ]
            , recommended = [] : List NestedFieldRule
            , required =
              [ { allowedValues = [] : List Text
                , cardinality = Cardinality.Any
                , description = Some
                    "§5.1. What the source is: a followable artifact, or a scope descriptor."
                , field = "resource"
                , format = None FieldFormat
                , path = None PathReferenceRule
                , reference = None HandleReferenceRule
                , when = None FieldCondition
                }
              ]
            }
          , field = "sources"
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
              "§5.2. Independent confirmations that the content is accurate. A list of mappings, or one bare mapping."
          , elementFields = Some
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
          , field = "verified"
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
        , { allowedValues = [] : List Text
          , cardinality = Cardinality.Scalar
          , description = Some
              "§5.5. Calendar date after which the content should be re-confirmed."
          , elementFields = None NestedRules
          , field = "stale_after"
          , format = Some FieldFormat.Date
          , objectFields = None NestedRules
          , path = None PathReferenceRule
          , reference = None HandleReferenceRule
          , uniqueBy = None Text
          , when = None FieldCondition
          }
        , { allowedValues = [] : List Text
          , cardinality = Cardinality.List
          , description = Some
              "Supporting alerts, dashboards, failure modes or other operational evidence."
          , elementFields = None NestedRules
          , field = "related"
          , format = Some (FieldFormat.UriWithScheme "mori")
          , objectFields = None NestedRules
          , path = None PathReferenceRule
          , reference = None HandleReferenceRule
          , uniqueBy = None Text
          , when = None FieldCondition
          }
        , { allowedValues = [] : List Text
          , cardinality = Cardinality.List
          , description = Some "Earlier runbooks replaced by this procedure."
          , elementFields = None NestedRules
          , field = "supersedes"
          , format = None FieldFormat
          , objectFields = None NestedRules
          , path = None PathReferenceRule
          , reference = Some
            { allowLocal = True
            , allowSelf = False
            , externalUriPattern = None Text
            , externalUriSchemes = [ "mori" ]
            , localPrefix = "RB"
            }
          , uniqueBy = None Text
          , when = None FieldCondition
          }
        , { allowedValues = [] : List Text
          , cardinality = Cardinality.Scalar
          , description = Some "Later runbook replacing this procedure."
          , elementFields = None NestedRules
          , field = "supersededBy"
          , format = None FieldFormat
          , objectFields = None NestedRules
          , path = None PathReferenceRule
          , reference = Some
            { allowLocal = True
            , allowSelf = False
            , externalUriPattern = None Text
            , externalUriSchemes = [ "mori" ]
            , localPrefix = "RB"
            }
          , uniqueBy = None Text
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
          , description = Some "The operational document type."
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
          , description = Some "Human-readable procedure title."
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
          , description = Some "Purpose and scope of the procedure."
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
          , cardinality = Cardinality.Scalar
          , description = Some "Bundle-scoped stable RB-N handle."
          , elementFields = None NestedRules
          , field = "docId"
          , format = Some (FieldFormat.DocumentHandle "RB")
          , objectFields = None NestedRules
          , path = None PathReferenceRule
          , reference = None HandleReferenceRule
          , uniqueBy = None Text
          , when = None FieldCondition
          }
        , { allowedValues = [] : List Text
          , cardinality = Cardinality.Scalar
          , description = Some
              "Accountable person, team or role that maintains the procedure and receives escalations."
          , elementFields = None NestedRules
          , field = "owner"
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
              "Canonical Mori URIs for the projects or artifacts affected by this procedure."
          , elementFields = None NestedRules
          , field = "projects"
          , format = Some (FieldFormat.UriWithScheme "mori")
          , objectFields = None NestedRules
          , path = None PathReferenceRule
          , reference = None HandleReferenceRule
          , uniqueBy = None Text
          , when = None FieldCondition
          }
        , { allowedValues = [] : List Text
          , cardinality = Cardinality.List
          , description = Some
              "Explicit applicable environments; vocabulary is owned by the repository."
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
          , cardinality = Cardinality.Scalar
          , description = Some
              "Event or symptom that makes this procedure applicable."
          , elementFields = None NestedRules
          , field = "trigger"
          , format = None FieldFormat
          , objectFields = None NestedRules
          , path = None PathReferenceRule
          , reference = None HandleReferenceRule
          , uniqueBy = None Text
          , when = None FieldCondition
          }
        , { allowedValues =
            [ "read-only"
            , "repository-change"
            , "registry-change"
            , "service-change"
            , "data-change"
            ]
          , cardinality = Cardinality.List
          , description = Some
              "Possible effects of following the procedure, including conditional branches; this grants no authority."
          , elementFields = None NestedRules
          , field = "effects"
          , format = None FieldFormat
          , objectFields = None NestedRules
          , path = None PathReferenceRule
          , reference = None HandleReferenceRule
          , uniqueBy = None Text
          , when = None FieldCondition
          }
        , { allowedValues = [] : List Text
          , cardinality = Cardinality.List
          , description = Some "Search and discovery terms."
          , elementFields = None NestedRules
          , field = "tags"
          , format = None FieldFormat
          , objectFields = None NestedRules
          , path = None PathReferenceRule
          , reference = None HandleReferenceRule
          , uniqueBy = None Text
          , when = None FieldCondition
          }
        , { allowedValues = [ "draft", "stable", "deprecated" ]
          , cardinality = Cardinality.Scalar
          , description = Some
              "Documentation lifecycle: draft, stable or deprecated; this does not certify an operational exercise."
          , elementFields = None NestedRules
          , field = "status"
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
    , guidance = None Text
    , idField = Some "docId"
    , name = "runbooks"
    , okfVersion = "0.2"
    , requireBundleVersion = Some "0.2"
    , types =
      [ { description = Some
            "An operational procedure whose ordering, prerequisites, verification, stop conditions, recovery and escalation matter."
        , frontmatter =
          { optional =
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
          }
        , guidance = None Text
        , idPrefix = Some "RB"
        , pathPattern = None Text
        , requireSchemaSection = False
        , resourceScheme = None Text
        , schemaColumns = [] : List Text
        , type = "Runbook"
        }
      ]
    }
