---
okf_version: "0.2"
---

# Files

- [profile.dhall](profile.dhall)

# Friction Entry

- [Pinned reader releases hit the local Bun release-age policy](1-pinned-reader-releases-hit-the-local-bun-release-age-policy.md) - The recipe dependency installation rejects qualified releases younger than the local seven-day minimum and requires an explicit install override.
- [Apple Container AMD64 builds cannot load Nix seccomp filters](2-apple-container-amd64-builds-cannot-load-nix-seccomp-filters.md) - The deployment requires AMD64 while the local Apple Container kernel is ARM64, and Nix fails when loading its build syscall filter under Rosetta.
- [Labs deployment needs context-scoped Google credentials and operator tools](3-labs-deployment-needs-context-scoped-google-credentials-and-operator-tools.md) - The default Google ADC quota project and bare Nagare CLI environment do not match the Labs deployment guard requirements.
- [Rosetta patch normalization blocks the pinned image exporter](4-rosetta-patch-normalization-blocks-the-pinned-image-exporter.md) - The pinned nix2container exporter fails while normalizing its platform-independent Skopeo patch inside the AMD64 Rosetta builder.

