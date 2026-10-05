{ allowUnknownFields = True
, allowUnknownTypes = False
, description = Some
    "Operational procedures with stable RB handles, accountable ownership, applicability, triggers and declared effects."
, frontmatter =
  { optional =
    [ { allowedValues = [] : List Text
      , cardinality = < Any | List | Scalar >.List
      , description = Some
          "§5.1. What this content was derived from, one entry per source."
      , elementFields = Some
        { optional =
          [ { allowedValues = [] : List Text
            , cardinality = < Any | List | Scalar >.Any
            , description = Some
                "§5.1. Short label for this entry, used to cite it from a footnote in the body."
            , field = "id"
            , format =
                None
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
            , path = None { allowSelf : Bool, externalUriSchemes : List Text }
            , reference =
                None
                  { allowLocal : Bool
                  , allowSelf : Bool
                  , externalUriPattern : Optional Text
                  , externalUriSchemes : List Text
                  , localPrefix : Text
                  }
            , when = None { field : Text, hasValue : List Text }
            }
          , { allowedValues = [] : List Text
            , cardinality = < Any | List | Scalar >.Any
            , description = Some "§5.1. Human-readable name for the source."
            , field = "title"
            , format =
                None
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
            , path = None { allowSelf : Bool, externalUriSchemes : List Text }
            , reference =
                None
                  { allowLocal : Bool
                  , allowSelf : Bool
                  , externalUriPattern : Optional Text
                  , externalUriSchemes : List Text
                  , localPrefix : Text
                  }
            , when = None { field : Text, hasValue : List Text }
            }
          , { allowedValues = [] : List Text
            , cardinality = < Any | List | Scalar >.Any
            , description = Some
                "§5.1. Who or what produced the source, per the §7 actor convention."
            , field = "author"
            , format = Some
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
                >.Actor
            , path = None { allowSelf : Bool, externalUriSchemes : List Text }
            , reference =
                None
                  { allowLocal : Bool
                  , allowSelf : Bool
                  , externalUriPattern : Optional Text
                  , externalUriSchemes : List Text
                  , localPrefix : Text
                  }
            , when = None { field : Text, hasValue : List Text }
            }
          , { allowedValues = [] : List Text
            , cardinality = < Any | List | Scalar >.Any
            , description = Some
                "§5.1. How many times the source was drawn on. A count, so never negative."
            , field = "usage_count"
            , format = Some
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
                >.NonNegativeInteger
            , path = None { allowSelf : Bool, externalUriSchemes : List Text }
            , reference =
                None
                  { allowLocal : Bool
                  , allowSelf : Bool
                  , externalUriPattern : Optional Text
                  , externalUriSchemes : List Text
                  , localPrefix : Text
                  }
            , when = None { field : Text, hasValue : List Text }
            }
          , { allowedValues = [] : List Text
            , cardinality = < Any | List | Scalar >.Any
            , description = Some
                "§5.1. Calendar date the source itself last changed."
            , field = "last_modified"
            , format = Some
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
                >.Date
            , path = None { allowSelf : Bool, externalUriSchemes : List Text }
            , reference =
                None
                  { allowLocal : Bool
                  , allowSelf : Bool
                  , externalUriPattern : Optional Text
                  , externalUriSchemes : List Text
                  , localPrefix : Text
                  }
            , when = None { field : Text, hasValue : List Text }
            }
          ]
        , recommended =
            [] : List
                   { allowedValues : List Text
                   , cardinality : < Any | List | Scalar >
                   , description : Optional Text
                   , field : Text
                   , format :
                       Optional
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
                   , path :
                       Optional
                         { allowSelf : Bool, externalUriSchemes : List Text }
                   , reference :
                       Optional
                         { allowLocal : Bool
                         , allowSelf : Bool
                         , externalUriPattern : Optional Text
                         , externalUriSchemes : List Text
                         , localPrefix : Text
                         }
                   , when : Optional { field : Text, hasValue : List Text }
                   }
        , required =
          [ { allowedValues = [] : List Text
            , cardinality = < Any | List | Scalar >.Any
            , description = Some
                "§5.1. What the source is: a followable artifact, or a scope descriptor."
            , field = "resource"
            , format =
                None
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
            , path = None { allowSelf : Bool, externalUriSchemes : List Text }
            , reference =
                None
                  { allowLocal : Bool
                  , allowSelf : Bool
                  , externalUriPattern : Optional Text
                  , externalUriSchemes : List Text
                  , localPrefix : Text
                  }
            , when = None { field : Text, hasValue : List Text }
            }
          ]
        }
      , field = "sources"
      , format =
          None
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
      , objectFields =
          None
            { optional :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , recommended :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , required :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            }
      , path = None { allowSelf : Bool, externalUriSchemes : List Text }
      , reference =
          None
            { allowLocal : Bool
            , allowSelf : Bool
            , externalUriPattern : Optional Text
            , externalUriSchemes : List Text
            , localPrefix : Text
            }
      , uniqueBy = None Text
      , when = None { field : Text, hasValue : List Text }
      }
    , { allowedValues = [] : List Text
      , cardinality = < Any | List | Scalar >.Any
      , description = Some
          "§5.2. Independent confirmations that the content is accurate. A list of mappings, or one bare mapping."
      , elementFields = Some
        { optional =
            [] : List
                   { allowedValues : List Text
                   , cardinality : < Any | List | Scalar >
                   , description : Optional Text
                   , field : Text
                   , format :
                       Optional
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
                   , path :
                       Optional
                         { allowSelf : Bool, externalUriSchemes : List Text }
                   , reference :
                       Optional
                         { allowLocal : Bool
                         , allowSelf : Bool
                         , externalUriPattern : Optional Text
                         , externalUriSchemes : List Text
                         , localPrefix : Text
                         }
                   , when : Optional { field : Text, hasValue : List Text }
                   }
        , recommended =
          [ { allowedValues = [] : List Text
            , cardinality = < Any | List | Scalar >.Any
            , description = Some
                "UTC RFC3339 timestamp, ending in `Z`, for when this happened."
            , field = "at"
            , format = Some
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
                >.Rfc3339Utc
            , path = None { allowSelf : Bool, externalUriSchemes : List Text }
            , reference =
                None
                  { allowLocal : Bool
                  , allowSelf : Bool
                  , externalUriPattern : Optional Text
                  , externalUriSchemes : List Text
                  , localPrefix : Text
                  }
            , when = None { field : Text, hasValue : List Text }
            }
          ]
        , required =
          [ { allowedValues = [] : List Text
            , cardinality = < Any | List | Scalar >.Any
            , description = Some
                "§7. The actor responsible: `<producer>/<version>`, `human:<id>`, or `process:<id>`."
            , field = "by"
            , format = Some
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
                >.Actor
            , path = None { allowSelf : Bool, externalUriSchemes : List Text }
            , reference =
                None
                  { allowLocal : Bool
                  , allowSelf : Bool
                  , externalUriPattern : Optional Text
                  , externalUriSchemes : List Text
                  , localPrefix : Text
                  }
            , when = None { field : Text, hasValue : List Text }
            }
          ]
        }
      , field = "verified"
      , format =
          None
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
      , objectFields = Some
        { optional =
            [] : List
                   { allowedValues : List Text
                   , cardinality : < Any | List | Scalar >
                   , description : Optional Text
                   , field : Text
                   , format :
                       Optional
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
                   , path :
                       Optional
                         { allowSelf : Bool, externalUriSchemes : List Text }
                   , reference :
                       Optional
                         { allowLocal : Bool
                         , allowSelf : Bool
                         , externalUriPattern : Optional Text
                         , externalUriSchemes : List Text
                         , localPrefix : Text
                         }
                   , when : Optional { field : Text, hasValue : List Text }
                   }
        , recommended =
          [ { allowedValues = [] : List Text
            , cardinality = < Any | List | Scalar >.Any
            , description = Some
                "UTC RFC3339 timestamp, ending in `Z`, for when this happened."
            , field = "at"
            , format = Some
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
                >.Rfc3339Utc
            , path = None { allowSelf : Bool, externalUriSchemes : List Text }
            , reference =
                None
                  { allowLocal : Bool
                  , allowSelf : Bool
                  , externalUriPattern : Optional Text
                  , externalUriSchemes : List Text
                  , localPrefix : Text
                  }
            , when = None { field : Text, hasValue : List Text }
            }
          ]
        , required =
          [ { allowedValues = [] : List Text
            , cardinality = < Any | List | Scalar >.Any
            , description = Some
                "§7. The actor responsible: `<producer>/<version>`, `human:<id>`, or `process:<id>`."
            , field = "by"
            , format = Some
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
                >.Actor
            , path = None { allowSelf : Bool, externalUriSchemes : List Text }
            , reference =
                None
                  { allowLocal : Bool
                  , allowSelf : Bool
                  , externalUriPattern : Optional Text
                  , externalUriSchemes : List Text
                  , localPrefix : Text
                  }
            , when = None { field : Text, hasValue : List Text }
            }
          ]
        }
      , path = None { allowSelf : Bool, externalUriSchemes : List Text }
      , reference =
          None
            { allowLocal : Bool
            , allowSelf : Bool
            , externalUriPattern : Optional Text
            , externalUriSchemes : List Text
            , localPrefix : Text
            }
      , uniqueBy = None Text
      , when = None { field : Text, hasValue : List Text }
      }
    , { allowedValues = [] : List Text
      , cardinality = < Any | List | Scalar >.Scalar
      , description = Some
          "§5.5. Calendar date after which the content should be re-confirmed."
      , elementFields =
          None
            { optional :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , recommended :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , required :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            }
      , field = "stale_after"
      , format = Some
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
          >.Date
      , objectFields =
          None
            { optional :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , recommended :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , required :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            }
      , path = None { allowSelf : Bool, externalUriSchemes : List Text }
      , reference =
          None
            { allowLocal : Bool
            , allowSelf : Bool
            , externalUriPattern : Optional Text
            , externalUriSchemes : List Text
            , localPrefix : Text
            }
      , uniqueBy = None Text
      , when = None { field : Text, hasValue : List Text }
      }
    , { allowedValues = [] : List Text
      , cardinality = < Any | List | Scalar >.List
      , description = Some
          "Supporting alerts, dashboards, failure modes or other operational evidence."
      , elementFields =
          None
            { optional :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , recommended :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , required :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            }
      , field = "related"
      , format = Some
          ( < Actor
            | Boolean
            | Date
            | DocumentHandle : Text
            | HumanActor
            | Integer
            | NonNegativeInteger
            | Rfc3339Utc
            | Uri
            | UriWithScheme : Text
            >.UriWithScheme
              "mori"
          )
      , objectFields =
          None
            { optional :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , recommended :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , required :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            }
      , path = None { allowSelf : Bool, externalUriSchemes : List Text }
      , reference =
          None
            { allowLocal : Bool
            , allowSelf : Bool
            , externalUriPattern : Optional Text
            , externalUriSchemes : List Text
            , localPrefix : Text
            }
      , uniqueBy = None Text
      , when = None { field : Text, hasValue : List Text }
      }
    , { allowedValues = [] : List Text
      , cardinality = < Any | List | Scalar >.List
      , description = Some "Earlier runbooks replaced by this procedure."
      , elementFields =
          None
            { optional :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , recommended :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , required :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            }
      , field = "supersedes"
      , format =
          None
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
      , objectFields =
          None
            { optional :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , recommended :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , required :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            }
      , path = None { allowSelf : Bool, externalUriSchemes : List Text }
      , reference = Some
        { allowLocal = True
        , allowSelf = False
        , externalUriPattern = None Text
        , externalUriSchemes = [ "mori" ]
        , localPrefix = "RB"
        }
      , uniqueBy = None Text
      , when = None { field : Text, hasValue : List Text }
      }
    , { allowedValues = [] : List Text
      , cardinality = < Any | List | Scalar >.Scalar
      , description = Some "Later runbook replacing this procedure."
      , elementFields =
          None
            { optional :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , recommended :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , required :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            }
      , field = "supersededBy"
      , format =
          None
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
      , objectFields =
          None
            { optional :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , recommended :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , required :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            }
      , path = None { allowSelf : Bool, externalUriSchemes : List Text }
      , reference = Some
        { allowLocal = True
        , allowSelf = False
        , externalUriPattern = None Text
        , externalUriSchemes = [ "mori" ]
        , localPrefix = "RB"
        }
      , uniqueBy = None Text
      , when = None { field : Text, hasValue : List Text }
      }
    ]
  , recommended =
      [] : List
             { allowedValues : List Text
             , cardinality : < Any | List | Scalar >
             , description : Optional Text
             , elementFields :
                 Optional
                   { optional :
                       List
                         { allowedValues : List Text
                         , cardinality : < Any | List | Scalar >
                         , description : Optional Text
                         , field : Text
                         , format :
                             Optional
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
                         , path :
                             Optional
                               { allowSelf : Bool
                               , externalUriSchemes : List Text
                               }
                         , reference :
                             Optional
                               { allowLocal : Bool
                               , allowSelf : Bool
                               , externalUriPattern : Optional Text
                               , externalUriSchemes : List Text
                               , localPrefix : Text
                               }
                         , when :
                             Optional { field : Text, hasValue : List Text }
                         }
                   , recommended :
                       List
                         { allowedValues : List Text
                         , cardinality : < Any | List | Scalar >
                         , description : Optional Text
                         , field : Text
                         , format :
                             Optional
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
                         , path :
                             Optional
                               { allowSelf : Bool
                               , externalUriSchemes : List Text
                               }
                         , reference :
                             Optional
                               { allowLocal : Bool
                               , allowSelf : Bool
                               , externalUriPattern : Optional Text
                               , externalUriSchemes : List Text
                               , localPrefix : Text
                               }
                         , when :
                             Optional { field : Text, hasValue : List Text }
                         }
                   , required :
                       List
                         { allowedValues : List Text
                         , cardinality : < Any | List | Scalar >
                         , description : Optional Text
                         , field : Text
                         , format :
                             Optional
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
                         , path :
                             Optional
                               { allowSelf : Bool
                               , externalUriSchemes : List Text
                               }
                         , reference :
                             Optional
                               { allowLocal : Bool
                               , allowSelf : Bool
                               , externalUriPattern : Optional Text
                               , externalUriSchemes : List Text
                               , localPrefix : Text
                               }
                         , when :
                             Optional { field : Text, hasValue : List Text }
                         }
                   }
             , field : Text
             , format :
                 Optional
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
             , objectFields :
                 Optional
                   { optional :
                       List
                         { allowedValues : List Text
                         , cardinality : < Any | List | Scalar >
                         , description : Optional Text
                         , field : Text
                         , format :
                             Optional
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
                         , path :
                             Optional
                               { allowSelf : Bool
                               , externalUriSchemes : List Text
                               }
                         , reference :
                             Optional
                               { allowLocal : Bool
                               , allowSelf : Bool
                               , externalUriPattern : Optional Text
                               , externalUriSchemes : List Text
                               , localPrefix : Text
                               }
                         , when :
                             Optional { field : Text, hasValue : List Text }
                         }
                   , recommended :
                       List
                         { allowedValues : List Text
                         , cardinality : < Any | List | Scalar >
                         , description : Optional Text
                         , field : Text
                         , format :
                             Optional
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
                         , path :
                             Optional
                               { allowSelf : Bool
                               , externalUriSchemes : List Text
                               }
                         , reference :
                             Optional
                               { allowLocal : Bool
                               , allowSelf : Bool
                               , externalUriPattern : Optional Text
                               , externalUriSchemes : List Text
                               , localPrefix : Text
                               }
                         , when :
                             Optional { field : Text, hasValue : List Text }
                         }
                   , required :
                       List
                         { allowedValues : List Text
                         , cardinality : < Any | List | Scalar >
                         , description : Optional Text
                         , field : Text
                         , format :
                             Optional
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
                         , path :
                             Optional
                               { allowSelf : Bool
                               , externalUriSchemes : List Text
                               }
                         , reference :
                             Optional
                               { allowLocal : Bool
                               , allowSelf : Bool
                               , externalUriPattern : Optional Text
                               , externalUriSchemes : List Text
                               , localPrefix : Text
                               }
                         , when :
                             Optional { field : Text, hasValue : List Text }
                         }
                   }
             , path :
                 Optional { allowSelf : Bool, externalUriSchemes : List Text }
             , reference :
                 Optional
                   { allowLocal : Bool
                   , allowSelf : Bool
                   , externalUriPattern : Optional Text
                   , externalUriSchemes : List Text
                   , localPrefix : Text
                   }
             , uniqueBy : Optional Text
             , when : Optional { field : Text, hasValue : List Text }
             }
  , required =
    [ { allowedValues = [] : List Text
      , cardinality = < Any | List | Scalar >.Scalar
      , description = Some "The operational document type."
      , elementFields =
          None
            { optional :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , recommended :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , required :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            }
      , field = "type"
      , format =
          None
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
      , objectFields =
          None
            { optional :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , recommended :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , required :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            }
      , path = None { allowSelf : Bool, externalUriSchemes : List Text }
      , reference =
          None
            { allowLocal : Bool
            , allowSelf : Bool
            , externalUriPattern : Optional Text
            , externalUriSchemes : List Text
            , localPrefix : Text
            }
      , uniqueBy = None Text
      , when = None { field : Text, hasValue : List Text }
      }
    , { allowedValues = [] : List Text
      , cardinality = < Any | List | Scalar >.Scalar
      , description = Some "Human-readable procedure title."
      , elementFields =
          None
            { optional :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , recommended :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , required :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            }
      , field = "title"
      , format =
          None
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
      , objectFields =
          None
            { optional :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , recommended :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , required :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            }
      , path = None { allowSelf : Bool, externalUriSchemes : List Text }
      , reference =
          None
            { allowLocal : Bool
            , allowSelf : Bool
            , externalUriPattern : Optional Text
            , externalUriSchemes : List Text
            , localPrefix : Text
            }
      , uniqueBy = None Text
      , when = None { field : Text, hasValue : List Text }
      }
    , { allowedValues = [] : List Text
      , cardinality = < Any | List | Scalar >.Scalar
      , description = Some "Purpose and scope of the procedure."
      , elementFields =
          None
            { optional :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , recommended :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , required :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            }
      , field = "description"
      , format =
          None
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
      , objectFields =
          None
            { optional :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , recommended :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , required :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            }
      , path = None { allowSelf : Bool, externalUriSchemes : List Text }
      , reference =
          None
            { allowLocal : Bool
            , allowSelf : Bool
            , externalUriPattern : Optional Text
            , externalUriSchemes : List Text
            , localPrefix : Text
            }
      , uniqueBy = None Text
      , when = None { field : Text, hasValue : List Text }
      }
    , { allowedValues = [] : List Text
      , cardinality = < Any | List | Scalar >.Scalar
      , description = Some "Bundle-scoped stable RB-N handle."
      , elementFields =
          None
            { optional :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , recommended :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , required :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            }
      , field = "docId"
      , format = Some
          ( < Actor
            | Boolean
            | Date
            | DocumentHandle : Text
            | HumanActor
            | Integer
            | NonNegativeInteger
            | Rfc3339Utc
            | Uri
            | UriWithScheme : Text
            >.DocumentHandle
              "RB"
          )
      , objectFields =
          None
            { optional :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , recommended :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , required :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            }
      , path = None { allowSelf : Bool, externalUriSchemes : List Text }
      , reference =
          None
            { allowLocal : Bool
            , allowSelf : Bool
            , externalUriPattern : Optional Text
            , externalUriSchemes : List Text
            , localPrefix : Text
            }
      , uniqueBy = None Text
      , when = None { field : Text, hasValue : List Text }
      }
    , { allowedValues = [] : List Text
      , cardinality = < Any | List | Scalar >.Scalar
      , description = Some
          "Accountable person, team or role that maintains the procedure and receives escalations."
      , elementFields =
          None
            { optional :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , recommended :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , required :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            }
      , field = "owner"
      , format =
          None
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
      , objectFields =
          None
            { optional :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , recommended :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , required :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            }
      , path = None { allowSelf : Bool, externalUriSchemes : List Text }
      , reference =
          None
            { allowLocal : Bool
            , allowSelf : Bool
            , externalUriPattern : Optional Text
            , externalUriSchemes : List Text
            , localPrefix : Text
            }
      , uniqueBy = None Text
      , when = None { field : Text, hasValue : List Text }
      }
    , { allowedValues = [] : List Text
      , cardinality = < Any | List | Scalar >.List
      , description = Some
          "Canonical Mori URIs for the projects or artifacts affected by this procedure."
      , elementFields =
          None
            { optional :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , recommended :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , required :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            }
      , field = "projects"
      , format = Some
          ( < Actor
            | Boolean
            | Date
            | DocumentHandle : Text
            | HumanActor
            | Integer
            | NonNegativeInteger
            | Rfc3339Utc
            | Uri
            | UriWithScheme : Text
            >.UriWithScheme
              "mori"
          )
      , objectFields =
          None
            { optional :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , recommended :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , required :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            }
      , path = None { allowSelf : Bool, externalUriSchemes : List Text }
      , reference =
          None
            { allowLocal : Bool
            , allowSelf : Bool
            , externalUriPattern : Optional Text
            , externalUriSchemes : List Text
            , localPrefix : Text
            }
      , uniqueBy = None Text
      , when = None { field : Text, hasValue : List Text }
      }
    , { allowedValues = [] : List Text
      , cardinality = < Any | List | Scalar >.List
      , description = Some
          "Explicit applicable environments; vocabulary is owned by the repository."
      , elementFields =
          None
            { optional :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , recommended :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , required :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            }
      , field = "environments"
      , format =
          None
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
      , objectFields =
          None
            { optional :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , recommended :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , required :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            }
      , path = None { allowSelf : Bool, externalUriSchemes : List Text }
      , reference =
          None
            { allowLocal : Bool
            , allowSelf : Bool
            , externalUriPattern : Optional Text
            , externalUriSchemes : List Text
            , localPrefix : Text
            }
      , uniqueBy = None Text
      , when = None { field : Text, hasValue : List Text }
      }
    , { allowedValues = [] : List Text
      , cardinality = < Any | List | Scalar >.Scalar
      , description = Some
          "Event or symptom that makes this procedure applicable."
      , elementFields =
          None
            { optional :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , recommended :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , required :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            }
      , field = "trigger"
      , format =
          None
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
      , objectFields =
          None
            { optional :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , recommended :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , required :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            }
      , path = None { allowSelf : Bool, externalUriSchemes : List Text }
      , reference =
          None
            { allowLocal : Bool
            , allowSelf : Bool
            , externalUriPattern : Optional Text
            , externalUriSchemes : List Text
            , localPrefix : Text
            }
      , uniqueBy = None Text
      , when = None { field : Text, hasValue : List Text }
      }
    , { allowedValues =
        [ "read-only"
        , "repository-change"
        , "registry-change"
        , "service-change"
        , "data-change"
        ]
      , cardinality = < Any | List | Scalar >.List
      , description = Some
          "Possible effects of following the procedure, including conditional branches; this grants no authority."
      , elementFields =
          None
            { optional :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , recommended :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , required :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            }
      , field = "effects"
      , format =
          None
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
      , objectFields =
          None
            { optional :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , recommended :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , required :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            }
      , path = None { allowSelf : Bool, externalUriSchemes : List Text }
      , reference =
          None
            { allowLocal : Bool
            , allowSelf : Bool
            , externalUriPattern : Optional Text
            , externalUriSchemes : List Text
            , localPrefix : Text
            }
      , uniqueBy = None Text
      , when = None { field : Text, hasValue : List Text }
      }
    , { allowedValues = [] : List Text
      , cardinality = < Any | List | Scalar >.List
      , description = Some "Search and discovery terms."
      , elementFields =
          None
            { optional :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , recommended :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , required :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            }
      , field = "tags"
      , format =
          None
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
      , objectFields =
          None
            { optional :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , recommended :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , required :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            }
      , path = None { allowSelf : Bool, externalUriSchemes : List Text }
      , reference =
          None
            { allowLocal : Bool
            , allowSelf : Bool
            , externalUriPattern : Optional Text
            , externalUriSchemes : List Text
            , localPrefix : Text
            }
      , uniqueBy = None Text
      , when = None { field : Text, hasValue : List Text }
      }
    , { allowedValues = [ "draft", "stable", "deprecated" ]
      , cardinality = < Any | List | Scalar >.Scalar
      , description = Some
          "Documentation lifecycle: draft, stable or deprecated; this does not certify an operational exercise."
      , elementFields =
          None
            { optional :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , recommended :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , required :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            }
      , field = "status"
      , format =
          None
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
      , objectFields =
          None
            { optional :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , recommended :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , required :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            }
      , path = None { allowSelf : Bool, externalUriSchemes : List Text }
      , reference =
          None
            { allowLocal : Bool
            , allowSelf : Bool
            , externalUriPattern : Optional Text
            , externalUriSchemes : List Text
            , localPrefix : Text
            }
      , uniqueBy = None Text
      , when = None { field : Text, hasValue : List Text }
      }
    , { allowedValues = [] : List Text
      , cardinality = < Any | List | Scalar >.Any
      , description = Some
          "§5.2. How this content was produced. Supersedes the v0.1 `timestamp` key."
      , elementFields =
          None
            { optional :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , recommended :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            , required :
                List
                  { allowedValues : List Text
                  , cardinality : < Any | List | Scalar >
                  , description : Optional Text
                  , field : Text
                  , format :
                      Optional
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
                  , path :
                      Optional
                        { allowSelf : Bool, externalUriSchemes : List Text }
                  , reference :
                      Optional
                        { allowLocal : Bool
                        , allowSelf : Bool
                        , externalUriPattern : Optional Text
                        , externalUriSchemes : List Text
                        , localPrefix : Text
                        }
                  , when : Optional { field : Text, hasValue : List Text }
                  }
            }
      , field = "generated"
      , format =
          None
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
      , objectFields = Some
        { optional =
            [] : List
                   { allowedValues : List Text
                   , cardinality : < Any | List | Scalar >
                   , description : Optional Text
                   , field : Text
                   , format :
                       Optional
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
                   , path :
                       Optional
                         { allowSelf : Bool, externalUriSchemes : List Text }
                   , reference :
                       Optional
                         { allowLocal : Bool
                         , allowSelf : Bool
                         , externalUriPattern : Optional Text
                         , externalUriSchemes : List Text
                         , localPrefix : Text
                         }
                   , when : Optional { field : Text, hasValue : List Text }
                   }
        , recommended =
          [ { allowedValues = [] : List Text
            , cardinality = < Any | List | Scalar >.Any
            , description = Some
                "UTC RFC3339 timestamp, ending in `Z`, for when this happened."
            , field = "at"
            , format = Some
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
                >.Rfc3339Utc
            , path = None { allowSelf : Bool, externalUriSchemes : List Text }
            , reference =
                None
                  { allowLocal : Bool
                  , allowSelf : Bool
                  , externalUriPattern : Optional Text
                  , externalUriSchemes : List Text
                  , localPrefix : Text
                  }
            , when = None { field : Text, hasValue : List Text }
            }
          ]
        , required =
          [ { allowedValues = [] : List Text
            , cardinality = < Any | List | Scalar >.Any
            , description = Some
                "§7. The actor responsible: `<producer>/<version>`, `human:<id>`, or `process:<id>`."
            , field = "by"
            , format = Some
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
                >.Actor
            , path = None { allowSelf : Bool, externalUriSchemes : List Text }
            , reference =
                None
                  { allowLocal : Bool
                  , allowSelf : Bool
                  , externalUriPattern : Optional Text
                  , externalUriSchemes : List Text
                  , localPrefix : Text
                  }
            , when = None { field : Text, hasValue : List Text }
            }
          ]
        }
      , path = None { allowSelf : Bool, externalUriSchemes : List Text }
      , reference =
          None
            { allowLocal : Bool
            , allowSelf : Bool
            , externalUriPattern : Optional Text
            , externalUriSchemes : List Text
            , localPrefix : Text
            }
      , uniqueBy = None Text
      , when = None { field : Text, hasValue : List Text }
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
                 , cardinality : < Any | List | Scalar >
                 , description : Optional Text
                 , elementFields :
                     Optional
                       { optional :
                           List
                             { allowedValues : List Text
                             , cardinality : < Any | List | Scalar >
                             , description : Optional Text
                             , field : Text
                             , format :
                                 Optional
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
                             , path :
                                 Optional
                                   { allowSelf : Bool
                                   , externalUriSchemes : List Text
                                   }
                             , reference :
                                 Optional
                                   { allowLocal : Bool
                                   , allowSelf : Bool
                                   , externalUriPattern : Optional Text
                                   , externalUriSchemes : List Text
                                   , localPrefix : Text
                                   }
                             , when :
                                 Optional { field : Text, hasValue : List Text }
                             }
                       , recommended :
                           List
                             { allowedValues : List Text
                             , cardinality : < Any | List | Scalar >
                             , description : Optional Text
                             , field : Text
                             , format :
                                 Optional
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
                             , path :
                                 Optional
                                   { allowSelf : Bool
                                   , externalUriSchemes : List Text
                                   }
                             , reference :
                                 Optional
                                   { allowLocal : Bool
                                   , allowSelf : Bool
                                   , externalUriPattern : Optional Text
                                   , externalUriSchemes : List Text
                                   , localPrefix : Text
                                   }
                             , when :
                                 Optional { field : Text, hasValue : List Text }
                             }
                       , required :
                           List
                             { allowedValues : List Text
                             , cardinality : < Any | List | Scalar >
                             , description : Optional Text
                             , field : Text
                             , format :
                                 Optional
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
                             , path :
                                 Optional
                                   { allowSelf : Bool
                                   , externalUriSchemes : List Text
                                   }
                             , reference :
                                 Optional
                                   { allowLocal : Bool
                                   , allowSelf : Bool
                                   , externalUriPattern : Optional Text
                                   , externalUriSchemes : List Text
                                   , localPrefix : Text
                                   }
                             , when :
                                 Optional { field : Text, hasValue : List Text }
                             }
                       }
                 , field : Text
                 , format :
                     Optional
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
                 , objectFields :
                     Optional
                       { optional :
                           List
                             { allowedValues : List Text
                             , cardinality : < Any | List | Scalar >
                             , description : Optional Text
                             , field : Text
                             , format :
                                 Optional
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
                             , path :
                                 Optional
                                   { allowSelf : Bool
                                   , externalUriSchemes : List Text
                                   }
                             , reference :
                                 Optional
                                   { allowLocal : Bool
                                   , allowSelf : Bool
                                   , externalUriPattern : Optional Text
                                   , externalUriSchemes : List Text
                                   , localPrefix : Text
                                   }
                             , when :
                                 Optional { field : Text, hasValue : List Text }
                             }
                       , recommended :
                           List
                             { allowedValues : List Text
                             , cardinality : < Any | List | Scalar >
                             , description : Optional Text
                             , field : Text
                             , format :
                                 Optional
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
                             , path :
                                 Optional
                                   { allowSelf : Bool
                                   , externalUriSchemes : List Text
                                   }
                             , reference :
                                 Optional
                                   { allowLocal : Bool
                                   , allowSelf : Bool
                                   , externalUriPattern : Optional Text
                                   , externalUriSchemes : List Text
                                   , localPrefix : Text
                                   }
                             , when :
                                 Optional { field : Text, hasValue : List Text }
                             }
                       , required :
                           List
                             { allowedValues : List Text
                             , cardinality : < Any | List | Scalar >
                             , description : Optional Text
                             , field : Text
                             , format :
                                 Optional
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
                             , path :
                                 Optional
                                   { allowSelf : Bool
                                   , externalUriSchemes : List Text
                                   }
                             , reference :
                                 Optional
                                   { allowLocal : Bool
                                   , allowSelf : Bool
                                   , externalUriPattern : Optional Text
                                   , externalUriSchemes : List Text
                                   , localPrefix : Text
                                   }
                             , when :
                                 Optional { field : Text, hasValue : List Text }
                             }
                       }
                 , path :
                     Optional
                       { allowSelf : Bool, externalUriSchemes : List Text }
                 , reference :
                     Optional
                       { allowLocal : Bool
                       , allowSelf : Bool
                       , externalUriPattern : Optional Text
                       , externalUriSchemes : List Text
                       , localPrefix : Text
                       }
                 , uniqueBy : Optional Text
                 , when : Optional { field : Text, hasValue : List Text }
                 }
      , recommended =
          [] : List
                 { allowedValues : List Text
                 , cardinality : < Any | List | Scalar >
                 , description : Optional Text
                 , elementFields :
                     Optional
                       { optional :
                           List
                             { allowedValues : List Text
                             , cardinality : < Any | List | Scalar >
                             , description : Optional Text
                             , field : Text
                             , format :
                                 Optional
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
                             , path :
                                 Optional
                                   { allowSelf : Bool
                                   , externalUriSchemes : List Text
                                   }
                             , reference :
                                 Optional
                                   { allowLocal : Bool
                                   , allowSelf : Bool
                                   , externalUriPattern : Optional Text
                                   , externalUriSchemes : List Text
                                   , localPrefix : Text
                                   }
                             , when :
                                 Optional { field : Text, hasValue : List Text }
                             }
                       , recommended :
                           List
                             { allowedValues : List Text
                             , cardinality : < Any | List | Scalar >
                             , description : Optional Text
                             , field : Text
                             , format :
                                 Optional
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
                             , path :
                                 Optional
                                   { allowSelf : Bool
                                   , externalUriSchemes : List Text
                                   }
                             , reference :
                                 Optional
                                   { allowLocal : Bool
                                   , allowSelf : Bool
                                   , externalUriPattern : Optional Text
                                   , externalUriSchemes : List Text
                                   , localPrefix : Text
                                   }
                             , when :
                                 Optional { field : Text, hasValue : List Text }
                             }
                       , required :
                           List
                             { allowedValues : List Text
                             , cardinality : < Any | List | Scalar >
                             , description : Optional Text
                             , field : Text
                             , format :
                                 Optional
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
                             , path :
                                 Optional
                                   { allowSelf : Bool
                                   , externalUriSchemes : List Text
                                   }
                             , reference :
                                 Optional
                                   { allowLocal : Bool
                                   , allowSelf : Bool
                                   , externalUriPattern : Optional Text
                                   , externalUriSchemes : List Text
                                   , localPrefix : Text
                                   }
                             , when :
                                 Optional { field : Text, hasValue : List Text }
                             }
                       }
                 , field : Text
                 , format :
                     Optional
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
                 , objectFields :
                     Optional
                       { optional :
                           List
                             { allowedValues : List Text
                             , cardinality : < Any | List | Scalar >
                             , description : Optional Text
                             , field : Text
                             , format :
                                 Optional
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
                             , path :
                                 Optional
                                   { allowSelf : Bool
                                   , externalUriSchemes : List Text
                                   }
                             , reference :
                                 Optional
                                   { allowLocal : Bool
                                   , allowSelf : Bool
                                   , externalUriPattern : Optional Text
                                   , externalUriSchemes : List Text
                                   , localPrefix : Text
                                   }
                             , when :
                                 Optional { field : Text, hasValue : List Text }
                             }
                       , recommended :
                           List
                             { allowedValues : List Text
                             , cardinality : < Any | List | Scalar >
                             , description : Optional Text
                             , field : Text
                             , format :
                                 Optional
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
                             , path :
                                 Optional
                                   { allowSelf : Bool
                                   , externalUriSchemes : List Text
                                   }
                             , reference :
                                 Optional
                                   { allowLocal : Bool
                                   , allowSelf : Bool
                                   , externalUriPattern : Optional Text
                                   , externalUriSchemes : List Text
                                   , localPrefix : Text
                                   }
                             , when :
                                 Optional { field : Text, hasValue : List Text }
                             }
                       , required :
                           List
                             { allowedValues : List Text
                             , cardinality : < Any | List | Scalar >
                             , description : Optional Text
                             , field : Text
                             , format :
                                 Optional
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
                             , path :
                                 Optional
                                   { allowSelf : Bool
                                   , externalUriSchemes : List Text
                                   }
                             , reference :
                                 Optional
                                   { allowLocal : Bool
                                   , allowSelf : Bool
                                   , externalUriPattern : Optional Text
                                   , externalUriSchemes : List Text
                                   , localPrefix : Text
                                   }
                             , when :
                                 Optional { field : Text, hasValue : List Text }
                             }
                       }
                 , path :
                     Optional
                       { allowSelf : Bool, externalUriSchemes : List Text }
                 , reference :
                     Optional
                       { allowLocal : Bool
                       , allowSelf : Bool
                       , externalUriPattern : Optional Text
                       , externalUriSchemes : List Text
                       , localPrefix : Text
                       }
                 , uniqueBy : Optional Text
                 , when : Optional { field : Text, hasValue : List Text }
                 }
      , required =
          [] : List
                 { allowedValues : List Text
                 , cardinality : < Any | List | Scalar >
                 , description : Optional Text
                 , elementFields :
                     Optional
                       { optional :
                           List
                             { allowedValues : List Text
                             , cardinality : < Any | List | Scalar >
                             , description : Optional Text
                             , field : Text
                             , format :
                                 Optional
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
                             , path :
                                 Optional
                                   { allowSelf : Bool
                                   , externalUriSchemes : List Text
                                   }
                             , reference :
                                 Optional
                                   { allowLocal : Bool
                                   , allowSelf : Bool
                                   , externalUriPattern : Optional Text
                                   , externalUriSchemes : List Text
                                   , localPrefix : Text
                                   }
                             , when :
                                 Optional { field : Text, hasValue : List Text }
                             }
                       , recommended :
                           List
                             { allowedValues : List Text
                             , cardinality : < Any | List | Scalar >
                             , description : Optional Text
                             , field : Text
                             , format :
                                 Optional
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
                             , path :
                                 Optional
                                   { allowSelf : Bool
                                   , externalUriSchemes : List Text
                                   }
                             , reference :
                                 Optional
                                   { allowLocal : Bool
                                   , allowSelf : Bool
                                   , externalUriPattern : Optional Text
                                   , externalUriSchemes : List Text
                                   , localPrefix : Text
                                   }
                             , when :
                                 Optional { field : Text, hasValue : List Text }
                             }
                       , required :
                           List
                             { allowedValues : List Text
                             , cardinality : < Any | List | Scalar >
                             , description : Optional Text
                             , field : Text
                             , format :
                                 Optional
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
                             , path :
                                 Optional
                                   { allowSelf : Bool
                                   , externalUriSchemes : List Text
                                   }
                             , reference :
                                 Optional
                                   { allowLocal : Bool
                                   , allowSelf : Bool
                                   , externalUriPattern : Optional Text
                                   , externalUriSchemes : List Text
                                   , localPrefix : Text
                                   }
                             , when :
                                 Optional { field : Text, hasValue : List Text }
                             }
                       }
                 , field : Text
                 , format :
                     Optional
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
                 , objectFields :
                     Optional
                       { optional :
                           List
                             { allowedValues : List Text
                             , cardinality : < Any | List | Scalar >
                             , description : Optional Text
                             , field : Text
                             , format :
                                 Optional
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
                             , path :
                                 Optional
                                   { allowSelf : Bool
                                   , externalUriSchemes : List Text
                                   }
                             , reference :
                                 Optional
                                   { allowLocal : Bool
                                   , allowSelf : Bool
                                   , externalUriPattern : Optional Text
                                   , externalUriSchemes : List Text
                                   , localPrefix : Text
                                   }
                             , when :
                                 Optional { field : Text, hasValue : List Text }
                             }
                       , recommended :
                           List
                             { allowedValues : List Text
                             , cardinality : < Any | List | Scalar >
                             , description : Optional Text
                             , field : Text
                             , format :
                                 Optional
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
                             , path :
                                 Optional
                                   { allowSelf : Bool
                                   , externalUriSchemes : List Text
                                   }
                             , reference :
                                 Optional
                                   { allowLocal : Bool
                                   , allowSelf : Bool
                                   , externalUriPattern : Optional Text
                                   , externalUriSchemes : List Text
                                   , localPrefix : Text
                                   }
                             , when :
                                 Optional { field : Text, hasValue : List Text }
                             }
                       , required :
                           List
                             { allowedValues : List Text
                             , cardinality : < Any | List | Scalar >
                             , description : Optional Text
                             , field : Text
                             , format :
                                 Optional
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
                             , path :
                                 Optional
                                   { allowSelf : Bool
                                   , externalUriSchemes : List Text
                                   }
                             , reference :
                                 Optional
                                   { allowLocal : Bool
                                   , allowSelf : Bool
                                   , externalUriPattern : Optional Text
                                   , externalUriSchemes : List Text
                                   , localPrefix : Text
                                   }
                             , when :
                                 Optional { field : Text, hasValue : List Text }
                             }
                       }
                 , path :
                     Optional
                       { allowSelf : Bool, externalUriSchemes : List Text }
                 , reference :
                     Optional
                       { allowLocal : Bool
                       , allowSelf : Bool
                       , externalUriPattern : Optional Text
                       , externalUriSchemes : List Text
                       , localPrefix : Text
                       }
                 , uniqueBy : Optional Text
                 , when : Optional { field : Text, hasValue : List Text }
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
