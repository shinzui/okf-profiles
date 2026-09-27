---
type: OKF Profile Type
title: Verification Run
description: 'One recorded run, or one recorded comparison of runs: what ran, against
  what, where, with which outcome, and where the data is.'
generated:
  by: process:okf-profile-document
---

# Verification Run

One recorded run, or one recorded comparison of runs: what ran, against what, where, with which outcome, and where the data is.

Declared by the [verification-evidence](/profile.md) profile.

## Type settings

- Path pattern: `runs/*/*/*/*`
- Resource URI scheme: none
- Requires a `# Schema` section: no
- Schema columns: none
- Document ID prefix: none

## Frontmatter rules

Every rule below is the effective rule for a concept of type `Verification Run`:
the profile-wide rule and this type's own rule, already merged.

### Required

#### `cohort` — required when `recordKind` is `run`

Name of the cohort the build linked.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: applies only when `recordKind` is `run`
- Object fields: none
- Element fields: none

#### `comparison` — required when `recordKind` is `comparison`

The arms and the verdict.

- Allowed values: any
- Cardinality: object
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: applies only when `recordKind` is `comparison`
- Object fields:
    - `baselineRuns` — required; allowed values: any; cardinality: list; format: none; path: bundle paths resolved to concepts; external URLs not allowed; self-reference not allowed — Recorded runs of the baseline arm.
    - `baselineValue` — required; allowed values: any; cardinality: scalar; format: none — The factor's value on the baseline arm.
    - `candidateRuns` — required; allowed values: any; cardinality: list; format: none; path: bundle paths resolved to concepts; external URLs not allowed; self-reference not allowed — Recorded runs of the candidate arm.
    - `candidateValue` — required; allowed values: any; cardinality: scalar; format: none — The factor's value on the candidate arm.
    - `design` — required; allowed values: `abba`, `baab`, `sequential`; cardinality: scalar; format: none — How the arms were interleaved.
    - `factor` — required; allowed values: `cohort`, `harness`, `dimension`, `knob`; cardinality: scalar; format: none — What differs between the arms.
    - `factorName` — optional; allowed values: any; cardinality: scalar; format: none — Which dimension, knob or package differs.
    - `verdict` — required; allowed values: `pass`, `regression`, `inconclusive`, `infrastructure-failure`; cardinality: scalar; format: none — What the comparison concluded.
- Element fields: none

#### `compatibilityKey` — required when `recordKind` is `run`

64-hex digest of what must match for two runs to be comparable.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: applies only when `recordKind` is `run`
- Object fields: none
- Element fields: none

#### `component` — required

Component inside the layer.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `components` — required when `recordKind` is `run`

Every runtime package the build linked.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: `package`
- Condition: applies only when `recordKind` is `run`
- Object fields: none
- Element fields:
    - `package` — required; allowed values: any; cardinality: scalar; format: none — Cabal package name.
    - `project` — required; allowed values: any; cardinality: scalar; format: uri-with-scheme(mori) — Mori URI of the owning project.
    - `revision` — required when `source` is `git`; allowed values: any; cardinality: scalar; format: none — Full 40-character commit.
    - `source` — required; allowed values: `hackage`, `git`; cardinality: scalar; format: none — Where the solver took it from.
    - `version` — required; allowed values: any; cardinality: scalar; format: none — Exact resolved version.

#### `computations` — required

Definitions that produced the outcome.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: local handles with prefix `VC`; external URIs not allowed; local handles allowed; self-reference not allowed
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `data` — required

Digest-pinned links to the data.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: `uri`
- Condition: none
- Object fields: none
- Element fields:
    - `bytes` — required; allowed values: any; cardinality: scalar; format: non-negative-integer — Object size.
    - `digest` — required; allowed values: any; cardinality: scalar; format: none — Lowercase 64-hex SHA-256 of the object.
    - `kind` — required; allowed values: `run-spec`, `run-result`, `manifest`, `cell-manifest`, `samples`, `series`, `verdicts`, `diagnosis`, `logs`, `comparison`; cardinality: scalar; format: none — What the object is.
    - `mediaType` — required; allowed values: any; cardinality: scalar; format: none — IANA media type.
    - `uri` — required; allowed values: any; cardinality: scalar; format: uri — Where the object lives in durable storage.

#### `description` — required

One sentence a reader can evaluate alone.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `environment` — required when `recordKind` is `run`

Flat excerpt of the environment fingerprint.

- Allowed values: any
- Cardinality: object
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: applies only when `recordKind` is `run`
- Object fields:
    - `arch` — required; allowed values: any; cardinality: scalar; format: none — CPU architecture.
    - `cell` — optional; allowed values: any; cardinality: scalar; format: none — Name of the leased cell.
    - `cellRun` — optional; allowed values: any; cardinality: scalar; format: none — The cell's own identifier for the leased run.
    - `cores` — required; allowed values: any; cardinality: scalar; format: non-negative-integer — Logical cores.
    - `cpuModel` — required; allowed values: any; cardinality: scalar; format: none — CPU model string.
    - `ghc` — required; allowed values: any; cardinality: scalar; format: none — Compiler that built the harness.
    - `kafka` — optional; allowed values: any; cardinality: scalar; format: none — Broker version, when a broker took part.
    - `kernel` — optional; allowed values: any; cardinality: scalar; format: none — Kernel release.
    - `machineType` — optional; allowed values: any; cardinality: scalar; format: none — Cloud machine type of the driver.
    - `memoryBytes` — required; allowed values: any; cardinality: scalar; format: non-negative-integer — Physical memory.
    - `os` — required; allowed values: any; cardinality: scalar; format: none — Operating system.
    - `postgres` — required; allowed values: any; cardinality: scalar; format: none — PostgreSQL server version.
    - `zone` — optional; allowed values: any; cardinality: scalar; format: none — Cloud zone.
- Element fields: none

#### `finishedAt` — required

UTC finish.

- Allowed values: any
- Cardinality: scalar
- Format: rfc3339-utc
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `generated` — required

§5.2. How this content was produced. Supersedes the v0.1 `timestamp` key.

- Allowed values: any
- Cardinality: object
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields:
    - `at` — recommended; allowed values: any; cardinality: any; format: rfc3339-utc — UTC RFC3339 timestamp, ending in `Z`, for when this happened.
    - `by` — required; allowed values: any; cardinality: any; format: actor — §7. The actor responsible: `<producer>/<version>`, `human:<id>`, or `process:<id>`.
- Element fields: none

#### `harnessDirty` — required

Whether the harness was built from a modified tree.

- Allowed values: any
- Cardinality: scalar
- Format: boolean
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `harnessRevision` — required

Full 40-character commit of the harness.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `kind` — required

Kind of evidence.

- Allowed values: `correctness`, `concurrency`, `soak`, `benchmark`
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `layer` — required

Runtime layer the scenario isolates.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `outcome` — required

What came of it.

- Allowed values: `passed`, `failed`, `errored`, `inconclusive`, `infrastructure-failure`
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `placement` — required

Where it ran.

- Allowed values: `local`, `cell`
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `purpose` — required

Why this was recorded.

- Allowed values: `nightly`, `release`, `baseline`, `investigation`
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `recordKind` — required

One run, or a comparison of runs.

- Allowed values: `run`, `comparison`
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `runId` — required

UUIDv7 of the record. Equals the file name.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `scenario` — required

Scenario identifier: layer/component/kind/name.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `seed` — required when `recordKind` is `run`

Seed of every random choice.

- Allowed values: any
- Cardinality: scalar
- Format: non-negative-integer
- Reference: none
- Path: none
- Unique by: none
- Condition: applies only when `recordKind` is `run`
- Object fields: none
- Element fields: none

#### `solverPlanHash` — required when `recordKind` is `run`

Hash of the resolved solver plan.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: applies only when `recordKind` is `run`
- Object fields: none
- Element fields: none

#### `startedAt` — required

UTC start.

- Allowed values: any
- Cardinality: scalar
- Format: rfc3339-utc
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `subject` — required

Mori URI of the most specific runtime artifact under test.

- Allowed values: any
- Cardinality: scalar
- Format: uri-with-scheme(mori)
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `subjectKind` — required

What `subject` names.

- Allowed values: `project`, `package`
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `tier` — required

Cost tier.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `title` — required

What this record is, in one line.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `type` — required

One of the three concept types.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

### Recommended

(none)

### Optional

#### `dimensions` — optional

Dimension values the run used.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: `name`
- Condition: none
- Object fields: none
- Element fields:
    - `name` — required; allowed values: any; cardinality: scalar; format: none — Name, as the harness spells it.
    - `value` — required; allowed values: any; cardinality: scalar; format: none — Value the run used.

#### `knobs` — optional

Knob values the run used.

- Allowed values: any
- Cardinality: list
- Format: none
- Reference: none
- Path: none
- Unique by: `name`
- Condition: none
- Object fields: none
- Element fields:
    - `name` — required; allowed values: any; cardinality: scalar; format: none — Name, as the harness spells it.
    - `value` — required; allowed values: any; cardinality: scalar; format: none — Value the run used.

#### `knownDefects` — optional

Known-defect references of the scenario.

- Allowed values: any
- Cardinality: list
- Format: uri
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `previousRun` — optional

Latest earlier record of the same scenario and compatibility key.

- Allowed values: any
- Cardinality: scalar
- Format: none
- Reference: none
- Path: bundle paths resolved to concepts; external URLs not allowed; self-reference not allowed
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `produced` — optional

Mori URIs of reports this run caused.

- Allowed values: any
- Cardinality: list
- Format: uri-with-scheme(mori)
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields: none
- Element fields: none

#### `verified` — optional

§5.2. Independent confirmations that the content is accurate. A list of mappings, or one bare mapping.

- Allowed values: any
- Cardinality: any
- Format: none
- Reference: none
- Path: none
- Unique by: none
- Condition: none
- Object fields:
    - `at` — recommended; allowed values: any; cardinality: any; format: rfc3339-utc — UTC RFC3339 timestamp, ending in `Z`, for when this happened.
    - `by` — required; allowed values: any; cardinality: any; format: actor — §7. The actor responsible: `<producer>/<version>`, `human:<id>`, or `process:<id>`.
- Element fields:
    - `at` — recommended; allowed values: any; cardinality: any; format: rfc3339-utc — UTC RFC3339 timestamp, ending in `Z`, for when this happened.
    - `by` — required; allowed values: any; cardinality: any; format: actor — §7. The actor responsible: `<producer>/<version>`, `human:<id>`, or `process:<id>`.

