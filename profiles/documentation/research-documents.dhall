--| Profile for repository-owned research documents with stable RES-N handles.
let Profile = ../../Profile/Type.dhall

let FrontmatterRules = ../../Profile/FrontmatterRules.dhall

let TypeRule = ../../Profile/TypeRule.dhall

in  Profile::{
    , name = "research-documents"
    , frontmatter = FrontmatterRules::{
      , required =
        [ "type"
        , "title"
        , "description"
        , "timestamp"
        , "researchId"
        , "status"
        , "scope"
        ]
      , recommended =
        [ "reviews"
        , "sources"
        , "relatedPlans"
        , "relatedDecisions"
        , "supersedes"
        , "supersededBy"
        ]
      }
    , allowUnknownTypes = False
    , idField = Some "researchId"
    , types =
      [ TypeRule::{
        , type = "Research Document"
        , pathPattern = Some "**"
        , idPrefix = Some "RES"
        }
      ]
    }
