let AgentPlans =
      https://raw.githubusercontent.com/shinzui/mori-schema/e4899c15b6a7c36f5d6f2619c8a36ceabe58fc41/extensions/agent-plans/package.dhall
        sha256:0b567808087da1924fb121df044c9432f676bb81305d5373809e3182d054943b

in  AgentPlans.AgentPlansCatalog::{
    , plans =
      [ AgentPlans.ExposedPlan::{
        , kind = AgentPlans.PlanKind.ExecPlan
        , file =
            "docs/plans/11-publish-the-platform-transitions-profile-and-adoption-blueprint.md"
        , status = AgentPlans.PlanStatus.Complete
        , summary = Some
            "Released transition profile and blueprint with verified live adoption rehearsal"
        }
      ]
    }
