--| Profile for a Mori-addressable catalog of implementation patterns and standards.
let Profile = ../../Profile/Type.dhall

let TypeRule = ../../Profile/TypeRule.dhall

let rule =
      \(conceptType : Text) ->
      \(path : Text) ->
        TypeRule::{
        , type = conceptType
        , pathPattern = Some path
        , resourceScheme = Some "mori"
        }

in  Profile::{
    , name = "mori-documentation-pattern-catalog"
    , frontmatter =
      { required =
        [ "type"
        , "title"
        , "description"
        , "timestamp"
        , "resource"
        , "tags"
        , "status"
        ]
      , recommended = [ "sources", "supersedes" ]
      }
    , types =
      [ rule "Navigation" "getting-started"
      , rule "Overview" "*/overview"
      , rule "Standard" "*/**"
      , rule "Guide" "*/**"
      , rule "Pattern" "*/**"
      , rule "Runbook" "*/**"
      , rule "Reference" "*/**"
      , rule "Gotcha" "*/**"
      ]
    }
