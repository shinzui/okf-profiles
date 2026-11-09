---
type: Friction Entry
title: "Apple Container AMD64 builds cannot load Nix seccomp filters"
description: "The deployment requires AMD64 while the local Apple Container kernel is ARM64, and Nix fails when loading its build syscall filter under Rosetta."
generated:
  by: "codex-cli/gpt-6.1-sol"
  at: "2026-11-09T17:29:35Z"
frictionId: FRIC-2
status: "accepted"
impact: detour
kind: environment
origin: "mori://shinzui/okf-profiles"
affects: "https://github.com/NixOS/nix"
plan: "docs/plans/14-serve-generated-profile-documentation-with-the-seihou-labs-microapp.md"
workaround: "Pass filter-syscalls=false only to Nix builds in the dedicated disposable AMD64 builder; retain the deployed application protection."
resolution: "Use sandbox=false and filter-syscalls=false only in the disposable AMD64 Apple Container builder; the built image and smoke/browser checks passed."
amended:
  - by: "codex-cli/gpt-6.1-sol"
    at: "2026-11-09T17:49:22Z"
    change: "Document the Rosetta-specific build setting after successful AMD64 qualification."
---
# Apple Container AMD64 builds cannot load Nix seccomp filters

## Attempted

Build docs-image and x86_64-linux docs-smoke in an AMD64 Apple Container with sandbox=false.

## Encountered

Nix build setup failed with unable to load seccomp BPF program: Invalid argument.

```text
error: unable to load seccomp BPF program: Invalid argument
```

## Workaround

Pass filter-syscalls=false only to Nix builds in the dedicated disposable AMD64 builder; retain the deployed application protection.
