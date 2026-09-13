--| Shared reader-facing documentation profile from okf-profiles v0.15.0.
--
-- The profile was introduced in v0.13.0. Loading this v0.15.0 descriptor
-- requires `okf` 0.9.0.0 or later.
let Profiles =
      https://raw.githubusercontent.com/shinzui/okf-profiles/v0.15.0/package.dhall
        sha256:e1e7eaac9d08fd3409fe0d19057dba5634a4186733ccbf28323e9aa2a2512dc0

in  Profiles.documentation.userDocumentation
