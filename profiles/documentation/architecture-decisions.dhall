--| Profile for repository-owned Architecture Decision Records with stable ADR-N handles.
let Profile = ../../Profile/Type.dhall

let FrontmatterRules = ../../Profile/FrontmatterRules.dhall

let TypeRule = ../../Profile/TypeRule.dhall

in  Profile::{
    , name = "architecture-decision-records"
    , frontmatter = FrontmatterRules::{
      , required = [ "type", "title", "docId", "status", "date" ]
      , recommended =
        [ "description"
        , "timestamp"
        , "supersedes"
        , "supersededBy"
        , "originatingPlan"
        ]
      }
    , allowUnknownTypes = False
    , idField = Some "docId"
    , types =
      [ TypeRule::{
        , type = "Architecture Decision Record"
        , pathPattern = Some "*"
        , idPrefix = Some "ADR"
        }
      ]
    }
