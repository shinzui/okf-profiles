--| Shared reader-facing documentation profile from okf-profiles v0.16.0.
--
-- The profile was introduced in v0.13.0. Loading this v0.16.0 descriptor
-- requires `okf` 0.9.0.0 or later.
let Profiles =
      https://raw.githubusercontent.com/shinzui/okf-profiles/v0.16.0/package.dhall
        sha256:746aecda3c11200e312ee68633e138a8104cbe7f3be8e18db7e2cd236fa10a4c

in  Profiles.documentation.userDocumentation
