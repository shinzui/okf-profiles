--| Reusable coordination profiles.
--
-- Three of them form one triangle: a use case states what a consumer needs, a
-- capability states what a producer provides, and an improvement request states
-- the gap between them. A bug report is the fourth corner: a capability that is
-- claimed but does not hold. Behavior that was never provided is an improvement
-- request rather than a bug, which is the line that keeps the two apart.
--
-- A pattern application sits beside them: a service's decision about whether
-- an assessable catalog pattern governs it and which of its own checks prove it.
{ bugReports = ./bug-reports.dhall
, capabilities = ./capabilities.dhall
, improvementRequests = ./improvement-requests.dhall
, patternApplications = ./pattern-applications.dhall
, useCases = ./use-cases.dhall
}
