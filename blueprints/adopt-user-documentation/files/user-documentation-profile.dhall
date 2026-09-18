--| Shared reader-facing documentation profile from okf-profiles v0.17.0.
--
-- The profile was introduced in v0.13.0. Loading this v0.17.0 descriptor
-- requires `okf` 0.9.0.0 or later.
let Profiles =
      https://raw.githubusercontent.com/shinzui/okf-profiles/v0.17.0/package.dhall
        sha256:a947f6c753b6a41f33a5898de8dd25124037eb8420dcf4baf5822fbd43207bd1

in  Profiles.documentation.userDocumentation
