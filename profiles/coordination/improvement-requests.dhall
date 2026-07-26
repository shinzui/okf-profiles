--| Profile for cross-repository improvement requests with stable IR-N handles.
let Profile = ../../Profile/Type.dhall

let FrontmatterRules = ../../Profile/FrontmatterRules.dhall

let TypeRule = ../../Profile/TypeRule.dhall

in  Profile::{
    , name = "cross-repository-improvement-requests"
    , frontmatter = FrontmatterRules::{
      , required =
        [ "type"
        , "title"
        , "description"
        , "timestamp"
        , "requestId"
        , "status"
        , "origin"
        ]
      }
    , allowUnknownTypes = False
    , idField = Some "requestId"
    , types =
      [ TypeRule::{
        , type = "Improvement Request"
        , pathPattern = Some "*"
        , idPrefix = Some "IR"
        }
      ]
    }
