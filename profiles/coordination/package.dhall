--| Reusable coordination profiles.
--
-- Three of them form one triangle: a use case states what a consumer needs, a
-- capability states what a producer provides, and an improvement request states
-- the gap between them. A bug report is the fourth corner: a capability that is
-- claimed but does not hold. Behavior that was never provided is an improvement
-- request rather than a bug, which is the line that keeps the two apart.
--
-- Jobs and features give the consumer corner canonical identities. A job
-- states the progress a customer seeks, independent of any solution; a feature
-- is one product behavior with its own delivery lifecycle, reusable across use
-- cases, and linked to the jobs it serves, the capabilities contributing to it,
-- the specifications governing it, and the requests delivering it. A use case
-- remains the scenario that ties them together. The research behind a job's
-- support lives in `documentation.productResearch`.
--
-- Designs carry a surface from why to how before it is built: a Design Brief
-- names the jobs it serves and the scenarios it must work in, a Breadboard
-- names the features its affordances rely on, and a Detailed Design presents
-- it. Implementation stays on those features. `designsFor` builds the profile
-- with a house's closed list of viewer axes; it is a function, not a profile.
--
-- A pattern application sits beside them: a service's decision about whether
-- an assessable catalog pattern governs it and which of its own checks prove it.
{ bugReports = ./bug-reports.dhall
, capabilities = ./capabilities.dhall
, designs = ./designs.dhall
, designsFor = ./designs-for.dhall
, features = ./features.dhall
, improvementRequests = ./improvement-requests.dhall
, jobs = ./jobs.dhall
, patternApplications = ./pattern-applications.dhall
, transitions = ./transitions.dhall
, useCases = ./use-cases.dhall
}
