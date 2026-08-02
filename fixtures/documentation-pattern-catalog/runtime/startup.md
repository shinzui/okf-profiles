---
type: Guide
title: Runtime startup
description: Assemble and start the example runtime in dependency order
generated:
  by: okf-authoring-agent/1.4
  at: 2026-07-22T00:00:00Z
sources:
  - id: runtime-source
    resource: mori://example/runtime
    title: The example runtime project
resource: mori://example/patterns/docs/runtime-startup
tags: [runtime, startup]
status: current
---

# Runtime startup

Acquire resources, assemble handlers, start background workers, and only then
accept traffic[^runtime-source]. Return to the [runtime overview](overview.md)
for related guidance.

[^runtime-source]: The example runtime's startup sequence.
