---
type: Bug Report
title: Whole-file export rejects a destination path containing a space
description: A space in the destination path is read as an argument separator, so the export fails before it starts.
generated:
  by: human:nadeem
  at: "2026-08-11T00:01:00Z"
bugId: BUG-2
status: fixed
severity: degraded
origin: mori://example/warehouse
affects: mori://example/platform
affectedVersion: "1.2.0"
fixedVersion: "1.3.1"
workaround: Export to a path with no space and move the file afterwards.
resolution: The destination is quoted before it reaches the shell; a regression test covers a path containing a space.
environment: Reproduces on every platform; unrelated to the filesystem.
observed: The export exits with `unknown argument` naming the text after the first space in the destination path.
expected: The destination path is passed through intact. The user guide's export walkthrough uses a path containing a space.
reproduction:
  - Request a whole-file export with a destination of `/tmp/my exports/data.csv`.
  - Observe the export exit before writing anything, naming `exports/data.csv` as an unknown argument.
reviews:
  - kind: model
    reviewer: example-agent
    reviewed_at: "2026-08-11T00:02:00Z"
    document_timestamp: "2026-08-11T00:01:00Z"
    scope: technical-accuracy
    outcome: approved
    provider: example-provider
    model: example-model
    effort: high
    context: >-
      In-repository review against the fix commit and its regression test.
verified:
  by: process:example-agent
  at: "2026-08-11T00:02:00Z"
---

# Whole-file export rejects a destination path containing a space

This conforming fixture proves a closed report. `status: fixed` demands
`fixedVersion`, and every terminal status demands `resolution` under `--strict`,
so a consumer reading the corpus can tell both why the report closed and which
release to move to — without either answer living in a chat log.

It is `degraded` rather than `unusable` because the export can still be had: the
workaround is a different path. `workaround` is demanded under `--strict`
precisely because `degraded` is defined as the grade where one exists, so a
degraded report that names none is either incomplete or mis-graded.

Its approving model `reviews` entry is mirrored into the bare-mapping spelling of
OKF `verified`, so the derived trust tier reflects the machine confirmation
rather than reporting the concept as unverified.
