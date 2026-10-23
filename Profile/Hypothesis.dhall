--| A falsifiable hypothesis shared by coordinated campaigns and initiatives.
let okf = ./okf.dhall

let FieldRule = okf.defaults.FieldRule

let NestedRules = okf.defaults.NestedRules

let NestedFieldRule = okf.defaults.NestedFieldRule

let Cardinality = okf.Cardinality

in  FieldRule::{
    , field = "hypothesis"
    , description = Some
        "The problem, belief, prediction, and falsification condition."
    , cardinality = Cardinality.Any
    , objectFields = Some NestedRules::{
      , required =
        [ NestedFieldRule::{
          , field = "problem"
          , description = Some "The observed problem being addressed."
          , cardinality = Cardinality.Scalar
          }
        , NestedFieldRule::{
          , field = "belief"
          , description = Some "The causal belief being tested."
          , cardinality = Cardinality.Scalar
          }
        , NestedFieldRule::{
          , field = "prediction"
          , description = Some
              "The observable result expected if the belief holds."
          , cardinality = Cardinality.Scalar
          }
        , NestedFieldRule::{
          , field = "falsifiedIf"
          , description = Some "The observation that would falsify the belief."
          , cardinality = Cardinality.Scalar
          }
        ]
      , optional = [] : List NestedFieldRule.Type
      }
    }
