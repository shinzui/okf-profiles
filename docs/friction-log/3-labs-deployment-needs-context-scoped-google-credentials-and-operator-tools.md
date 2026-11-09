---
type: Friction Entry
title: "Labs deployment needs context-scoped Google credentials and operator tools"
description: "The default Google ADC quota project and bare Nagare CLI environment do not match the Labs deployment guard requirements."
generated:
  by: "codex-cli/gpt-6.1-sol"
  at: "2026-11-09T17:31:32Z"
frictionId: FRIC-3
status: "accepted"
impact: detour
kind: environment
origin: "mori://shinzui/okf-profiles"
affects: "mori://shinzui/nagare"
plan: "docs/plans/14-serve-generated-profile-documentation-with-the-seihou-labs-microapp.md"
workaround: "Use a private command-scoped gcloud configuration with the Labs quota project, the intranet kubeconfig, and the release-qualified Nagare operator package; the project guard then passes without altering global configuration."
resolution: "Keep global Google credentials unchanged; use command-scoped Labs ADC, the intranet kubeconfig, and the qualified Nagare operator package for live commands."
amended:
  - by: "codex-cli/gpt-6.1-sol"
    at: "2026-11-09T17:49:23Z"
    change: "Accept command-scoped operator configuration, which passed the project and platform guards."
---
# Labs deployment needs context-scoped Google credentials and operator tools

## Attempted

Run the intranet context guard before publishing the reader image.

## Encountered

The default ADC quota project was tan-ng rather than tan-ng-labs, and the bare CLI package omitted Pulumi from PATH.

```text
Application Default Credentials attribute API quota to project tan-ng, not the selected context project tan-ng-labs; pulumi was not found on PATH.
```

## Workaround

Use a private command-scoped gcloud configuration with the Labs quota project, the intranet kubeconfig, and the release-qualified Nagare operator package; the project guard then passes without altering global configuration.
