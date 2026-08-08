--| Reusable coordination profiles.
--
-- The three form one triangle: a use case states what a consumer needs, a
-- capability states what a producer provides, and an improvement request states
-- the gap between them.
{ capabilities = ./capabilities.dhall
, improvementRequests = ./improvement-requests.dhall
, useCases = ./use-cases.dhall
}
