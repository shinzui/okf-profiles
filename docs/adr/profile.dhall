--| Descriptor for this repository's own architecture-decision bundle.
--
-- Note the RELATIVE import. Every other repository installs this descriptor as
-- a version-pinned remote import of the published package:
--
--     let Profiles =
--           https://raw.githubusercontent.com/shinzui/okf-profiles/v0.8.0/package.dhall
--             sha256:…
--
-- This repository *is* that package, so a remote pin here would be circular and
-- would govern our decisions with the *previous* release rather than the profile
-- we are shipping. Importing the working tree by relative path is correct here
-- and only here. Do not "fix" this into a remote pin.
--
-- The consequence is deliberate: this bundle validates against the profile under
-- development, so `scripts/test-adr-bundle.sh` is a regression test on
-- `profiles/documentation/architecture-decisions.dhall` and not merely
-- documentation. A change that breaks a real ADR corpus fails the build here
-- before it reaches a consumer.
let Profiles = ../../package.dhall

in  Profiles.documentation.architectureDecisions
