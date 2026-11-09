# Bundle Update Log

## 2026-11-09
* **Update**: FRIC-4 accepted: Keep a tested native patch helper and record the successful image export workaround.
* **Update**: FRIC-3 accepted: Accept command-scoped operator configuration, which passed the project and platform guards.
* **Update**: FRIC-2 accepted: Document the Rosetta-specific build setting after successful AMD64 qualification.
* **Addition**: FRIC-4 records detour tooling friction with https://github.com/nlewo/nix2container: Rosetta patch normalization blocks the pinned image exporter
* **Addition**: FRIC-3 records detour environment friction with mori://shinzui/nagare: Labs deployment needs context-scoped Google credentials and operator tools
* **Addition**: FRIC-2 records detour environment friction with https://github.com/NixOS/nix: Apple Container AMD64 builds cannot load Nix seccomp filters
* **Update**: FRIC-1 accepted: Accept the local policy interaction and document the qualified install command.
* **Addition**: FRIC-1 records detour environment friction with mori://shinzui/seihou-modules/templates/docs-microapp: Pinned reader releases hit the local Bun release-age policy
* **Adoption**: Adopt the `friction-log` profile (`coordination.frictionLog`) from https://raw.githubusercontent.com/shinzui/okf-profiles/v0.23.0/package.dhall.
