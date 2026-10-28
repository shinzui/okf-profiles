---
id: 13
slug: make-profile-policy-sweeps-observable-and-run-them-natively-in-okf
title: "Make profile policy sweeps observable and run them natively in okf"
kind: exec-plan
created_at: 2026-10-28T13:49:40Z
intention: "intention_01m61cc0jhee7trcx2kvb6x77y"
provenance:
  created_by:
    model: "claude-opus-5-5"
    harness: "claude-code"
    at: 2026-10-28T13:49:40Z
---

# Make profile policy sweeps observable and run them natively in okf

This ExecPlan is a living document. The sections Progress, Surprises & Discoveries,
Decision Log, and Outcomes & Retrospective must be kept up to date as work proceeds.
If durable project context changes, update or create ADRs in docs/adr/ in the same change.

This plan implements the improvement request
`mori://shinzui/okf-profiles/okf/improvement-requests/concepts/IR-11` (file
[docs/improvement-requests/make-profile-policy-sweeps-observable-and-reduce-redundant-fixture-scans.md](../improvement-requests/make-profile-policy-sweeps-observable-and-reduce-redundant-fixture-scans.md))
and widens it. The request asks for progress output and fewer repeated fixture scans. This plan
also fixes why the scans are expensive and why some sweep results mislead, and for that it adds a
native sweep command to okf (`mori://shinzui/okf`).


## Purpose / Big Picture

Every profile in this catalog must pass a *load-bearing sweep* before release. The sweep checks
that each rule the profile declares is actually tested by some fixture. It does this by weakening
the rule one way at a time and confirming that some rejection fixture notices the change. ADR-9
makes this sweep mandatory whenever a profile gains, loses or changes a rule. Today it is
`scripts/sweep-profile-rules.py`. On the strategy profile it starts one `okf` process per fixture
per relaxation, and each process spends about 0.37 seconds decoding the profile. A full sweep of a
large profile takes tens of minutes to hours. While it runs and output is redirected, nothing
appears until it finishes. Some results it prints as `OK` do not show that any fixture tests the
rule (see Context and Orientation).

After this plan:

- **The command.** A maintainer runs
  `okf profile sweep profiles/coordination/strategy.dhall --accept fixtures/strategy --cases fixtures/strategy-invalid`.
  It finishes in seconds rather than tens of minutes.
- **Streaming output.** It prints one line per relaxation as soon as that relaxation is decided,
  even when output goes to a file or pipe. It ends with a summary that includes elapsed time.
- **Machine-readable output.** With `--json`, it emits one JSON object per line: start, baseline,
  one per relaxation, and a final summary.
- **Every relaxation is classified.** Each relaxation is either protected (with the fixture that
  noticed it), proven unobservable (with the reason), covered by a stronger relaxation of the same
  policy, a documented exception (with its class), or a gap.
- **The exit code is the gate.** The command exits non-zero exactly when a gap exists, so the
  sweep can become a check that fails on its own instead of a report a human has to read.
- **Same answers as today.** On the six released families (campaigns, claim checks, audiences,
  strategy, launches, messaging), the new engine reports the same witnesses as the existing serial
  script for every relaxation the old script tried. A comparison script proves this.


## Progress

- [ ] Milestone 1: the legacy sweep streams progress, resolves `OKF_BIN`, separates
      acceptance and descriptor failures from protection, and writes a JSON summary.
- [ ] Milestone 1: legacy baseline summaries recorded for the six families under
      `docs/plans/evidence/13/`.
- [ ] Milestone 2 (prototype): in-process timing spike in the okf checkout, with numbers
      recorded in Surprises & Discoveries and a promote/discard decision in the Decision Log.
- [ ] Milestone 3: okf improvement request filed in `mori://shinzui/okf` with an allocated handle.
- [ ] Milestone 3: `Okf.Profile.Sweep` in okf-core: typed relaxation enumeration, suite
      loading, in-process evaluation with the legacy predicate.
- [ ] Milestone 3: `okf profile sweep` command with streaming text and `--json` output.
- [ ] Milestone 3: `scripts/compare-sweep-results.py` proves parity with the six legacy baselines.
- [ ] Milestone 4: provable inertness, composite policy units, presence demotion, value-admitting
      vocabulary relaxation, exception manifests, and exit codes in okf.
- [ ] Milestone 5 (conditional): bounded deterministic parallel evaluation, or a recorded
      decision that serial evaluation already meets the time budget.
- [ ] Milestone 6: okf release prepared (owner approves the tag and push).
- [ ] Milestone 6: `scripts/sweep-profile-rules.py` delegates to `okf profile sweep`; exception
      manifests written for the six families; full catalog swept and triaged.
- [ ] Milestone 6: README, ADR-9 amendment, okf ADR, IR-11 completion, and the logs.


## Surprises & Discoveries

(None yet.)


## Decision Log

- Decision: Put the sweep engine in okf as a typed, in-process command (`okf profile sweep`)
  rather than only tuning the Python script.
  Rationale: Measurement during planning showed that about 0.37 s of each `okf validate` call is
  spent decoding the 442,085-byte normalized strategy descriptor. Validating the fixture itself
  takes negligible time. A full scan of the 182 strategy rejection fixtures takes 70.5 s however
  the fixtures are ordered, so a field-indexed ordering alone cannot remove the dominant cost.
  Inside okf, profile validation is the pure function
  `validateProfileWith :: BundleInventory -> ValidationProfile -> CompiledProfile -> [Concept] -> [ProfileViolation]`
  (`okf-core/src/Okf/Profile.hs`). Core OKF validation and log staleness do not depend on the
  profile at all. So a sweep can decode the profile once, load every bundle once, and re-run only
  the pure profile check for each relaxation. Relaxing the decoded `ProfileSpec` value also
  replaces the Python script's hand-written Dhall text surgery, which breaks easily.
  Date: 2026-10-28

- Decision: Keep the existing Python script as a working, improved *legacy engine* (Milestone 1)
  and use it as the reference against which the okf engine must agree.
  Rationale: IR-11's first acceptance criterion is agreement with "the serial baseline". The only
  credible way to show that is to record that baseline with the current algorithm before replacing
  it, and to keep that algorithm runnable until parity is proven.
  Date: 2026-10-28

- Decision: Do all the okf code work under this one ExecPlan. Commits in the okf checkout carry
  `ExecPlan: mori://shinzui/okf-profiles/plans/13-make-profile-policy-sweeps-observable-and-run-them-natively-in-okf`
  and the intention trailer. Milestone 3 begins by filing an okf improvement request so that okf's
  own corpus records the feature.
  Rationale: The user asked for one plan with a principled solution, even if okf needs new support.
  The okf work has no meaning without the catalog's fixtures to verify it against, and both
  repositories have the same owner.
  Date: 2026-10-28

- Decision: Classify results by evidence and by proof, not by a fixed list of "expected
  unprotected" cases. Provable inertness and composite coverage are computed by okf. Only results
  that okf cannot decide (shared-family members tested in their home profile, overlapping rules,
  deliberately deferred gaps) go in a per-suite exception manifest. Exceptions must each name a
  class and a rationale and must not go stale.
  Rationale: ADR-9's three "expected unprotected classes" are currently applied by reading the
  output. IR-11 requires each relaxation to be reported "with its witness, failure, or explicitly
  classified documented exception". A machine-checked classification is the only way to make the
  sweep a gate rather than a report.
  Date: 2026-10-28

- Decision: An acceptance failure or a descriptor that no longer compiles is never counted as
  protection.
  Rationale: ADR-9's 2026-09-27 amendment says a deleted field rule can leave a fixture red only
  because the field became unknown. The tan-product-management EP-4 record says descriptor-load
  failures "were not treated as proof of a domain constraint". The current script nevertheless
  prints both cases as `OK` (see Context and Orientation).
  Date: 2026-10-28

- Decision: The default relaxation kinds are the seven legacy kinds plus presence demotion. The
  other new kinds (cardinality, condition, path policy, whole reference policy, nested container,
  type-level attributes) are available with `--kinds all` and are evaluated automatically only
  when needed to classify a composite unit.
  Rationale: The ADR-9 amendment already requires presence demotion, and today it is done by hand
  as "supplemental controls". Making every new kind a release gate at once could add new required
  fixtures across the whole catalog. Their results are triaged in Milestone 6 and recorded. Making
  them gating is a separate decision.
  Date: 2026-10-28


## Outcomes & Retrospective

(To be filled during and after implementation.)


## Context and Orientation

### The catalog and its tests

This repository, `okf-profiles` (`mori://shinzui/okf-profiles`), publishes *profiles*. A profile
is a Dhall descriptor that tells the `okf` tool which document types, frontmatter fields and value
rules a team's OKF knowledge bundle must follow. An *OKF bundle* is a directory of Markdown files
with YAML frontmatter, each of which is called a *concept*. Profiles live under
`profiles/<family>/<name>.dhall`; the families are `coordination`, `documentation` and
`assurance`.

Each profile has an *acceptance bundle*, `fixtures/<name>/`, which must validate cleanly:

```bash
okf validate fixtures/<name> --strict --profile <descriptor> --profile-enforce --log-enforce
```

Each profile also has a directory of *rejection fixtures*, `fixtures/<name>-invalid/`. Every
subdirectory there is a tiny bundle that breaks exactly one rule. `fixtures/<name>-invalid/expected.json`
maps each fixture's directory name either to the field name its diagnostic must mention, or to
`{"field": ..., "diagnostics": N}` when okf reports one fault as N overlapping diagnostics.

A *deviation* is one profile diagnostic line. `okf validate` prints these to stderr prefixed
`profile: `, followed by a summary line containing `advisory deviation(s)`. The shared harness
`scripts/profile_fixture_cases.py` runs each fixture *without* `--profile-enforce`. It requires
exactly the expected number of deviation lines, and at least one of them must contain the expected
field name. Per-profile tests such as `scripts/test-strategy-profile.py` call its `run` function.
That harness honours `OKF_BIN`, which selects the okf executable, and `PROFILE`, which overrides
the descriptor.

### ADR-9 and the load-bearing sweep

The decision record is
[docs/adr/0009-a-rejection-fixture-must-fail-for-exactly-one-reason.md](../adr/0009-a-rejection-fixture-must-fail-for-exactly-one-reason.md)
(ADR-9). It requires two checks whenever a profile's rules change. The first is that every
rejection fixture reports exactly one advisory, which `profile_fixture_cases.py` already enforces.
The second is a *load-bearing sweep*: weaken each rule in turn and confirm that some fixture
notices. These terms are used throughout this plan:

- **Relaxation:** one weakening of one rule, for example deleting it or clearing its allowed
  values.
- **Witness:** a rejection fixture that "notices" a relaxation. Under the relaxed profile it no
  longer reports exactly its expected deviation.
- **Load-bearing:** a rule is load-bearing when its relaxations have witnesses.

The ADR adds several constraints that the implementation must preserve:

- **One governing rule.** A sweep is conclusive only when exactly one rule governs the value
  under test. Two rules expressing the same constraint mask each other.
- **Composite policy units.** A composite policy is swept as the authored unit. A reference
  policy short-circuits through local-handle permission, prefix, scheme and pattern, so relaxing
  only an early member can expose the next member and leave the fixture rejected. The same applies
  to handle prefix plus handle format, and to list cardinality plus nested element rules.
- **Closed profiles (2026-09-27 amendment).** When `allowUnknownFields = False`, deleting a field
  rule makes the field unknown, so the fixture stays red for the wrong reason. In that case, relax
  the specific policy instead: move a required rule to optional, clear the vocabulary, or remove
  the format, reference or uniqueness rule.
- **Expected unprotected classes (2026-10-16 amendment).** Three kinds of unprotected result are
  expected:
  - an unconstrained optional field, when unknown fields are allowed;
  - a member of a spliced shared family whose home profile tests it member by member;
  - `allowSelf` or `allowLocal` on an external-only reference.

Two other ADRs set the boundaries of this work.
[docs/adr/0020-a-friction-entry-records-cost-before-it-is-a-defect-or-a-request.md](../adr/0020-a-friction-entry-records-cost-before-it-is-a-defect-or-a-request.md)
explains why IR-11 records a cost rather than a defect. IR-11 was promoted from a friction entry.
[docs/adr/0008-recommended-means-a-well-run-corpus-carries-it.md](../adr/0008-recommended-means-a-well-run-corpus-carries-it.md)
says a `recommended` field's absence is reported only under `--strict`. Rejection fixtures run
without `--strict`, so demoting a `recommended` rule to `optional` is invisible to them by design.
This plan therefore applies presence demotion to `required` rules only.

### The current script, `scripts/sweep-profile-rules.py`

The usage is:

```bash
python3 scripts/sweep-profile-rules.py <profile.dhall> <accept-bundle> <invalid-dir> [extra-accept-bundle ...]
```

It normalizes the descriptor with `dhall --file`, which inlines every import into one large
expression. It then finds every record containing `field = "` in the normalized text. Records
that are conditions (`hasValue` without `allowedValues`) are skipped. It builds textual mutations
of seven kinds:

- `delete`: remove the record from its list.
- `allowedValues`: replace a non-empty list with `[] : List Text`.
- `format`: replace `Some …` with `None <FieldFormat>`.
- `uniqueBy`: replace with `None Text`.
- `allowSelf`, `allowLocal`: change `= False` to `= True` inside `reference`.
- `externalUriPattern`: replace with `None Text`.

For each mutation it writes a temporary file, type-checks it with `dhall type`, and calls
`noticed`. That function runs `okf validate` on the acceptance bundle and on every extra
acceptance bundle (strict, enforced). If any of those fails, it returns `acceptance-fails`.
Otherwise it runs `okf validate` on rejection fixtures until one stops matching its expectation.
Fixtures whose expected field equals the rule's field name are tried first, and the rest follow
in `expected.json` order. Results print only after all relaxations finish:

```text
OK  <field>                  <kind>               fixture <name>
!!  <field>                  <kind>               UNPROTECTED
```

The last line is `N unprotected of M relaxations`.

Planning found four facts about this script that shape the work:

1. **Acceptance and descriptor failures print as protection.** The print at the end of the file
   marks anything not starting with `UNPROTECTED` or `MUTATION` as `OK`. That includes
   `acceptance-fails`, which arises in two situations: when a deletion in a closed profile makes a
   field unknown, and when the relaxed descriptor no longer loads in okf. An example of the second
   is clearing a vocabulary that a `when` condition depends on. okf requires a condition's source
   field to have a closed scalar vocabulary, and `dhall type` does not catch this.
2. **Decoding dominates the cost.** On the strategy profile, `okf validate` of a two-concept
   rejection fixture takes 0.37 s against the normalized descriptor. One pass over all 182
   strategy fixtures took 70.5 s. Every unprotected relaxation costs a full pass.
3. **Output is buffered.** Results print only at the end, through Python's default block
   buffering, so redirected output shows nothing for hours.
4. **The okf binary is hard-coded.** The script calls `okf` from `PATH` and ignores `OKF_BIN`, so
   it cannot be pointed at an unreleased okf build.

The six release-relevant families are listed below.

| Profile | Accept | Cases | Legacy relaxations |
|---|---|---|---|
| `profiles/coordination/campaigns.dhall` | `fixtures/campaigns` | 161 | measure |
| `profiles/assurance/claim-checks.dhall` | `fixtures/claim-checks` | 39 | measure |
| `profiles/coordination/audiences.dhall` | `fixtures/audiences` | 96 | measure |
| `profiles/coordination/strategy.dhall` | `fixtures/strategy` | 182 | 105 |
| `profiles/coordination/launches.dhall` | `fixtures/launches` | 122 | 97 |
| `profiles/documentation/messaging.dhall` | `fixtures/messaging` | 105 | 79 |

Each profile's rejection fixtures are in `fixtures/<name>-invalid` (the strategy row, for example,
uses `fixtures/strategy-invalid`). None of the six per-profile tests passes extra acceptance
bundles. The relaxation counts come from
`mori://tan/tan-product-management/plans/4-add-strategy-messaging-and-launch-profiles-to-okf-profiles`
(and `mori://tan/tan-product-management/plans/3-add-campaign-and-audience-profiles-to-okf-profiles`
for the campaign family).

### okf, the producer (`mori://shinzui/okf`)

okf is a Haskell project: the `okf-core` library and the `okf-cli` executable `okf`, currently
version 0.10.0.0. Find the checkout with `mori registry show shinzui/okf --full` (field `Path`).
Build and test it from the checkout root with `cabal build all` and `cabal test all`. The
executable already links with `-threaded -rtsopts -with-rtsopts=-N`. Use
`OKF_BIN="$(cd <okf checkout> && cabal list-bin okf)"` to run an unreleased build from okf-profiles.

These modules matter:

- **`okf-core/src/Okf/Profile.hs`** contains:
  - the authored descriptor types: `ProfileSpec`, `FrontmatterRules` (lists `required`,
    `recommended`, `optional`), `FieldRule`, `NestedRules`, `NestedFieldRule`,
    `HandleReferenceRule`, `PathReferenceRule`, `FieldFormat`, `Cardinality` and `TypeRule`;
  - `loadProfileFile`, which decodes a descriptor from a Dhall file;
  - `compileProfile :: ProfileSpec -> Either (NonEmpty ProfileDefinitionError) CompiledProfile`,
    which checks definitions and merges each type's rules with the profile-wide rules into
    `EffectiveFieldRule`s;
  - `validateProfileWith` and `validateProfileVersion`;
  - the structured `ProfileViolation` type, whose constructors carry the concept ID and the
    `FieldPath`, for example `ValueNotInVocabulary`, `LocalDocumentReferenceNotAllowed` and
    `SelfDocumentReference`.

  `NestedRules` cannot contain further nesting, so a rule's location has at most two levels.
  `compileProfile` rejects duplicate field names within one list at one scope, so
  scope + list + field identifies an authored rule uniquely.
- **`validateReferenceText`** in the same file checks `allowLocal` *before* the prefix,
  dangling-owner and `allowSelf` checks. Two consequences follow:
  - When `allowLocal = False`, the `allowSelf` flag is never consulted, so relaxing it is provably
    unobservable.
  - Relaxing `allowLocal` on an external-only reference turns a `LocalDocumentReferenceNotAllowed`
    deviation into `ReferenceHandlePrefixMismatch` or `DanglingHandleReference` on the same field.
    The fixture stays rejected and still names the field, so the legacy predicate reports no
    witness. That is the composite masking ADR-9 describes.
- **`okf-core/src/Okf/Validation.hs`** contains `validateBundle` (core structural checks under
  `PermissiveConformance` or `StrictAuthoring`), `validateBundleLogs` and `logStaleness`. None of
  them takes a profile.
- **`okf-core/src/Okf/Bundle.hs`** contains `walkBundle`, `walkBundleInventory` and `walkLogs`.
  `okf-core/src/Okf/Index.hs` contains `readBundleVersion`.
- **`okf-cli/src/Okf/Cli.hs`** contains:
  - `runValidate`, which is the composition the sweep must reproduce: core errors and log
    staleness, then `validateProfileVersion <> validateProfileWith`, each printed as
    `"profile: " <> renderProfileViolation compiled concepts v`;
  - the `ProfileCommand` sum (`ProfileList`, `ProfileShow`, `ProfileInit`) and
    `profileCommandParser`, which the new `sweep` subcommand joins;
  - `renderProfileViolation`, which exists only in the CLI.

  Help text lives in `okf-cli/help/*.md`, and `okf-cli/help/profiles.md` documents profile
  commands. The changelog is `okf-cli/CHANGELOG.md` (Keep a Changelog format).

Two okf ADRs constrain the design:

- **`mori://shinzui/okf/okf/adrs/concepts/ADR-5` ("Compile profile rules before validation").**
  Bundle validation accepts only a `CompiledProfile`. Profile-scope and type-scope rules merge by
  field name, vocabularies intersect, and an empty vocabulary means unconstrained. So a relaxation
  must be applied to the authored `ProfileSpec` and recompiled. A relaxation at type scope can be
  partly masked by a profile-scope rule for the same field.
- **`mori://shinzui/okf/okf/adrs/concepts/ADR-11` ("Growing the profile descriptor language").**
  Every additive descriptor-schema change needs a frozen decoder generation. This plan adds *no*
  descriptor schema members, so no new generation is required. Keep it that way. The sweep reads
  descriptors and never changes their published shape.

A naming hazard: okf's own improvement-request corpus also contains an "IR-11" (closing nested
vocabularies), which is unrelated to this request. Always refer to requests by their full `mori://`
URI.

### Shared families

Several profiles *splice* shared field families: the same rule records are inserted into many
types from `Profile/V02.dhall` (OKF v0.2 fields such as `generated`, `verified` and `sources`),
`Profile/Hypothesis.dhall`, `Profile/ReviewRule.dhall` and `Profile/ModelReview.dhall`. The home
profile for the v0.2 family is `profiles/okf-v0-2.dhall`, with `fixtures/okf-v0-2` and
`fixtures/okf-v0-2-invalid`. For the other blocks, the home is the profile whose header comment
says it introduced the block; record it when writing exceptions. After normalization, nothing in a
descriptor says which rules came from a family, so okf cannot detect family membership. That is
why shared-family results go in an exception manifest.


## Plan of Work

The work runs in two repositories. Milestones 1 and 6 change okf-profiles, and Milestones 2–5
change okf. Every commit in either repository uses Conventional Commits and ends with these
trailers:

```text
ExecPlan: mori://shinzui/okf-profiles/plans/13-make-profile-policy-sweeps-observable-and-run-them-natively-in-okf
Intention: intention_01m61cc0jhee7trcx2kvb6x77y
```

In okf-profiles itself, the `ExecPlan:` trailer may instead use the repository-relative form
`docs/plans/13-make-profile-policy-sweeps-observable-and-run-them-natively-in-okf.md`.

Do not create branches; commit on the current branch of each checkout. Before you start, run
`git status` in okf-profiles. If unrelated uncommitted work exists, for example under
`fixtures/designs-invalid/`, leave it alone and stage only your own paths.

### Milestone 1 — An observable, honest legacy sweep (okf-profiles)

This milestone delivers IR-11's observability criterion immediately, with today's released okf.
It also produces the reference results that later milestones must agree with. Every change is in
`scripts/sweep-profile-rules.py`, and the positional usage stays exactly as it is.

**Arguments.** Replace the bare `sys.argv` unpacking with `argparse`. Keep the positionals
`profile accept invalid extra*`. Add three options:

- `--json PATH` writes the summary described below;
- `--quiet` suppresses per-relaxation lines but keeps the summary;
- `--only FIELD` restricts the sweep to rules with that field name, for quick checks.

**Executable resolution.** Read `OKF_BIN` the same way `scripts/profile_fixture_cases.py` does,
defaulting to `okf`. Resolve it with `shutil.which`. At start-up, run `<okf> --version` and print
the first line of its output. If the binary cannot be found or exits non-zero, exit with status 2
and say which binary was tried and how to set `OKF_BIN`. Do the same for `dhall`.

**Baseline.** Replace the `assert noticed(...) is None` baseline with an explicit check. It
validates every acceptance bundle strictly and every rejection fixture against its expectation.
On the first failure it prints which bundle or fixture failed, its okf output, and
`baseline fault: fix the fixtures before sweeping`, then exits with status 2. Python's `-O` flag
removes `assert`, so the current check can silently disappear.

**Outcome classes.** Change `noticed` so it returns a structured result instead of a string.
Distinguish these outcomes:

- `witness` (a fixture name).
- `acceptance-fails`: an acceptance bundle reports a profile deviation under the relaxed
  descriptor.
- `descriptor-invalid`: okf's output for the acceptance run contains `Failed to load profile`.
  Check this before treating the run as `acceptance-fails`.
- `mutation-ill-typed`: `dhall type` rejects the mutated text.
- `unprotected`.

Print `OK ` only for `witness`. Print `!! ` for every other class, with the class name in upper
case in the last column. Keep the legacy column layout, so a reader of old logs recognizes the
lines.

**Streaming.** Print each relaxation's line as soon as it is decided, with `flush=True`, prefixed
by its position, for example `[ 12/105]`. Add the elapsed time for that relaxation and the number
of okf invocations it used, for example `(4 okf runs, 1.6 s)`. Print the total relaxation count
before the first relaxation: compute the full list of `(name, kind, text)` first, which costs
nothing compared with validation. End with:

```text
sweep: 105 relaxations: 80 witnessed, 3 acceptance-fails, 2 descriptor-invalid, 20 unprotected; 2714 okf runs in 1h 05m 12s
```

**JSON summary.** With `--json PATH`, write one JSON object at the end:

```json
{
  "engine": "legacy",
  "okf": "okf v0.10.0.0 (feacb5e)",
  "profile": "...",
  "accept": ["..."],
  "cases": "...",
  "gitCommit": "...",
  "elapsedMs": 0,
  "okfRuns": 0,
  "results": [
    {
      "index": 1,
      "field": "status",
      "kind": "allowedValues",
      "legacyOutcome": "fixture objective-bad-status",
      "class": "witness",
      "witness": "objective-bad-status",
      "okfRuns": 3,
      "elapsedMs": 1100
    }
  ]
}
```

`legacyOutcome` is the exact string the old `noticed` returned: `fixture <name>`,
`acceptance-fails`, `MUTATION-ILL-TYPED` or `UNPROTECTED`. `descriptor-invalid` results carry
`legacyOutcome: "acceptance-fails"`, because that is what the old script would have reported.
This field is the comparison key used in Milestone 3. `gitCommit` is `git rev-parse HEAD` of
okf-profiles.

**Recorded baselines.** After the script works, record the six legacy baselines. They take a long
time, so run them in the background, one profile at a time, to keep the machine responsive. Write
each to `docs/plans/evidence/13/<name>.legacy.json` and commit them. They are the evidence for
IR-11's first acceptance criterion. Each records the commit it was produced at.

Acceptance:

- Redirect `python3 scripts/sweep-profile-rules.py profiles/assurance/claim-checks.dhall fixtures/claim-checks fixtures/claim-checks-invalid > out.txt`
  and watch it with `tail -f out.txt`: lines appear one at a time.
- The final line carries elapsed time.
- `--json` writes a document that `python3 -m json.tool` accepts.
- Point `OKF_BIN` at a non-existent path: the script exits 2 with a clear message.
- Temporarily break one rejection fixture's `expected.json` entry: the script exits 2 with a
  baseline fault. Restore the entry afterwards.

### Milestone 2 — Prototype: measure in-process evaluation (okf checkout)

This is a prototyping milestone. It is not committed except as numbers in this plan. It confirms
that decoding the profile once and evaluating every relaxation in memory is as cheap as the
Decision Log assumes. It also finds anything unexpectedly expensive in `compileProfile`, such as
compiling `externalUriPattern` regexes on every compile.

In the okf checkout, write an uncommitted file `spike/SweepSpike.hs` (code under Concrete Steps).
It loads `profiles/coordination/strategy.dhall` from the okf-profiles checkout with
`loadProfileFile`, and loads all 182 rejection fixtures and the acceptance bundle with
`walkBundle`, `walkBundleInventory` and `readBundleVersion`. Then it times three things:

- the load;
- 200 calls of `compileProfile` on the decoded spec;
- 200 full passes over every fixture with
  `validateProfileVersion declaration compiled <> validateProfileWith inventory PermissiveConformance compiled concepts`,
  forcing the results with `length` and `show`.

Run it with `cabal build okf-core && cabal exec -- runghc spike/SweepSpike.hs <okf-profiles checkout>`.

Promote the approach if one compile plus one full suite pass costs under 50 ms. That gives under
10 s serial for 200 relaxations, against tens of minutes today. Otherwise, record the dominant
cost in Surprises & Discoveries and treat Milestone 5 (parallel evaluation) as required.
Record the measured numbers in Surprises & Discoveries either way, and delete `spike/` afterwards.

### Milestone 3 — Native `okf profile sweep` with legacy parity (okf, then okf-profiles)

This milestone builds the engine and the command, and proves that they reproduce the legacy
results.

**Request.** First, file the request in okf's corpus. Copy the frontmatter shape of
`docs/improvement-requests/fail-profile-enforce-when-no-profile-is-applied.md` in the okf checkout:

- `type: Improvement Request`, `title`, `description`, `generated`;
- `requestId` from `okf id next docs/improvement-requests IR` (run in the okf checkout, and add
  `--profile` if that bundle declares one; at planning time it did not);
- `status: proposed`;
- `origin: mori://shinzui/okf-profiles/plans/13-make-profile-policy-sweeps-observable-and-run-them-natively-in-okf`;
- `acceptanceCriteria` restating this plan's Validation and Acceptance for okf.

Title it "Sweep profile rules for load-bearingness natively". Add an entry to okf's
`docs/improvement-requests/log.md` in the existing style. Record the allocated handle and its
`mori://shinzui/okf/okf/improvement-requests/concepts/IR-N` URI in the Decision Log. Verify it
with `mori registry concepts --id IR-N --json` after `mori register --local` in the okf checkout;
if the registry lags, record the intended URI anyway.

**Engine module.** Create `okf-core/src/Okf/Profile/Sweep.hs` and list it in
`okf-core/okf-core.cabal` under `exposed-modules`. It is pure except for one loading function.
Its interfaces are specified in Interfaces and Dependencies. It has five parts:

1. **Rule locations.** A `RuleLocation` names an authored rule by scope (profile-wide, or
   `type:<Type Name>`), presence list (`required`, `recommended`, `optional`), field, and
   optionally a nested container (`elementFields` or `objectFields`) with its own list and member
   field. `renderRuleLocation` prints it as a stable text identifier:

   ```text
   profile/required/status
   type:Objective/required/keyResults/elementFields/required/id
   ```

   A *relaxation ID* is the location plus `#<kind>`, for example
   `type:Launch/required/launchRef#allowLocal`. IDs are the keys used by exception manifests and
   by the comparison script.
2. **Enumeration and application.** `enumerateRelaxations :: KindSet -> ProfileSpec -> [Relaxation]`
   walks the authored spec in declaration order: the profile-wide frontmatter lists first, then
   each type in declaration order, and within each rule its nested members. It yields every
   applicable relaxation. `applyRelaxation :: Relaxation -> ProfileSpec -> ProfileSpec` performs
   it on the typed value. In this milestone, implement only the seven legacy kinds, with the same
   applicability conditions as the Python script:
   - `allowedValues` only when the list is non-empty;
   - `format` and `uniqueBy` only when they are `Just`;
   - `allowSelf` and `allowLocal` only when `False`, inside `reference` (not inside `path`);
   - `externalUriPattern` only when it is `Just`;
   - `delete` for every rule.
3. **Suites.** A `Suite` holds the acceptance bundles and the rejection cases, each loaded once.
   Every bundle keeps its concepts, inventory, version declaration and logs. Each rejection case
   keeps its name and expectation (field, count) parsed from `expected.json`, in file order.
   `loadSuite :: [FilePath] -> FilePath -> IO (Either SuiteError Suite)` does this loading. Use
   aeson's ordered parsing of the top-level object. Aeson's `KeyMap` is not ordered, so parse the
   object's key order from the raw bytes, or decode into `[(Text, Value)]` with
   `Data.Aeson.Decoding`'s token stream. Choose one, record the choice in the Decision Log, and
   test that order survives. Order matters because the legacy witness is the *first* noticing
   fixture.
4. **Baseline.** `checkBaseline` computes each acceptance bundle's core errors and log staleness
   once. These do not depend on the profile. The acceptance bundles must pass
   (`StrictAuthoring`, enforced, log-enforced, exactly as `runValidate` decides), and every
   rejection case must meet its expectation under the unrelaxed profile. Any failure is a
   `BaselineFault`, which stops the sweep before any relaxation runs.
5. **Evaluation.** `evaluateRelaxation` recompiles the relaxed spec. A `Left` is
   `DescriptorInvalid`. Otherwise it computes, for each acceptance bundle, the profile violations
   under `StrictAuthoring`. Any violation means `AcceptanceObservable`, with the rendered lines.
   For each rejection case, it computes the violations under `PermissiveConformance`, renders
   them, and applies the legacy predicate: exactly `count` lines, at least one containing the
   field. A case that fails the predicate is a witness.

   Collect *all* witnesses, not just the first. The *primary* witness is the first in the legacy
   order: cases whose expected field equals the rule's innermost field name first (stable), then
   the rest in file order. Because rendering lives in okf-cli, the engine takes the renderer as a
   parameter:
   `type Render = CompiledProfile -> [Concept] -> ProfileViolation -> Text`.

**Command.** Add `ProfileSweep ProfileSweepOptions` to `ProfileCommand` in `okf-cli/src/Okf/Cli.hs`
and a `sweep` subcommand to `profileCommandParser`:

```text
okf profile sweep PROFILE --accept BUNDLE [--accept BUNDLE ...] --cases DIR
                  [--kinds legacy|default|all] [--json] [--only FIELD]
```

In this milestone, `default` equals `legacy`. `runProfileSweep` follows these steps:

1. Set `hSetBuffering stdout LineBuffering` and the same for stderr.
2. Load the profile with the existing `loadProfileOrExit` and `compileProfileOrExit`, then call
   `loadSuite`.
3. Print a start line naming the okf version, the profile, the number of relaxations and the
   number of cases.
4. Run the baseline. On a fault, print it and exit 2.
5. Print one line per relaxation, in enumeration order, as each is decided. The text layout is:

   ```text
   [  12/105] OK  type:Objective/required/status#allowedValues  witness objective-bad-status (+2 more) 3 ms
   [  13/105] !!  type:Launch/required/launchRef#allowLocal      unprotected 41 ms
   ```

6. Print a summary line with counts per outcome and the total elapsed time.

With `--json`, print one JSON object per line (NDJSON) instead, with the schema under Interfaces
and Dependencies.

For this milestone, exit 0 after a successful run whatever the outcomes, matching the legacy
script. Exit codes become meaningful in Milestone 4. Write `okf-cli/help/profiles.md` text for
the command, along with an `[Unreleased]` changelog entry and tests:

- **okf-core tests** (`okf-core/test/Main.hs`) cover enumeration over a small fixture profile
  under `okf-core/test/fixtures/` (expected IDs), `applyRelaxation` for each kind, preservation of
  `expected.json` order, baseline faults, and a witness and an unprotected result on a two-case
  suite.
- **An okf-cli test** (`okf-cli/test/Main.hs`) runs the command end to end on that fixture suite
  and checks the NDJSON shape.

**Comparison script.** Back in okf-profiles, add `scripts/compare-sweep-results.py LEGACY.json OKF.ndjson`.
It reads the legacy summary from Milestone 1 and the okf NDJSON stream, and compares the
multisets of `(field, kind, legacyOutcome)` tuples. The okf side derives `legacyOutcome` from its
own observation with the legacy precedence:

1. `AcceptanceObservable` or `DescriptorInvalid` → `acceptance-fails`;
2. otherwise a primary witness `w` → `fixture w`;
3. otherwise → `UNPROTECTED`.

It prints every unmatched tuple on either side. An okf-only tuple is acceptable only when it is a
`delete` of a rule that is the sole element of its list, because the legacy textual deletion
cannot remove a sole element. The script labels these `legacy cannot delete a sole list element`.
Any other unmatched tuple, including a legacy `MUTATION-ILL-TYPED`, makes it exit 1.

The comparison is only meaningful when both runs used the same fixtures (same `gitCommit` for the
files under `fixtures/` and `profiles/`) and the same okf renderer. If a mismatch traces to
rendering, regenerate the legacy baseline with `OKF_BIN` set to the new build.

Acceptance:

- For each of the six profiles,
  `"$OKF_BIN" profile sweep <profile> --accept fixtures/<name> --cases fixtures/<name>-invalid --kinds legacy --json > docs/plans/evidence/13/<name>.okf.ndjson`
  completes.
- `python3 scripts/compare-sweep-results.py docs/plans/evidence/13/<name>.legacy.json docs/plans/evidence/13/<name>.okf.ndjson`
  prints `parity: N/N legacy results matched` and exits 0.
- Record each pair of wall times in Outcomes & Retrospective.

### Milestone 4 — Principled classification and a failing exit code (okf)

This milestone turns observations into classifications that can gate a release. It extends
`Okf.Profile.Sweep` and the command. The ordering of classification rules below is normative.

**New relaxation kinds:**

- `presence`: move a `required` rule to the `optional` list at the same scope, keeping every
  constraint. This is in the `default` set. It does not apply to `recommended` rules, whose
  absence is invisible without `--strict`, which rejection fixtures do not use (ADR-8).
- `admitValue:<value>`: append one value to a non-empty `allowedValues`. This is generated only
  for a rule whose `allowedValues` relaxation is `DescriptorInvalid`. There is one candidate for
  each distinct value that some rejection case's baseline `ValueNotInVocabulary` violation
  reports at that rule's field path. It is the general form of the "expand the allowed values"
  controls recorded in the tan-product-management EP-4 record.
- In the `all` set only:
  - `cardinality` (set to `Any`);
  - `condition` (set `when` to `Nothing`);
  - `path` (set `path` to `Nothing`);
  - `reference` (set `reference` to `Nothing`; this is the composite unit);
  - `elementFields` and `objectFields` (set to `Nothing`; composite with list cardinality);
  - at type scope: `pathPattern`, `resourceScheme`, `requireSchemaSection` (to `False`),
    `schemaColumns` (to `[]`), and `idPrefix` (composite with a `DocumentHandle` format).

**Observation.** For each relaxation the engine records the witnesses (outcome level, the legacy
predicate), the acceptance violations, the definition errors, and the *facet witnesses*. A facet
witness is a rejection case in which a baseline violation of the relaxation's own kind (see the
table below) at the rule's path disappears, whether or not the fixture still fails for another
reason. The mapping from relaxation kind to violation constructors is:

- `delete`/`presence` → `MissingProfileField`, `MissingNestedProfileField`;
- `allowedValues`/`admitValue` → `ValueNotInVocabulary`;
- `format` → `ValueFormatMismatch`;
- `uniqueBy` → `DuplicateNestedFieldValue`;
- `allowLocal` → `LocalDocumentReferenceNotAllowed`;
- `allowSelf` → `SelfDocumentReference`;
- `externalUriPattern` → `ExternalReferencePatternMismatch`;
- `cardinality` → `CardinalityMismatch`;
- `reference` → every reference constructor;
- `path` → the path constructors.

**Classification:** apply these rules in order; the first that matches decides the outcome.

1. **`protected`:** at least one witness, and no acceptance violation and no definition error.
2. **`subsumed`** (non-failing): the kind is `delete`, the result is `AcceptanceObservable` or
   `DescriptorInvalid`, and every other relaxation of the same rule location ends `protected`,
   `inert`, `covered` or `exception`. A deletion that only makes the field unknown tests the
   declaration, not a constraint. The constraint-specific relaxations carry the evidence. The
   line names them.
3. **`covered`** (non-failing): the kind is `allowedValues`, the result is `DescriptorInvalid`,
   and some `admitValue` relaxation of the same rule is `protected`. The line names it and its
   witness.
4. **`descriptor-invalid` or `acceptance-observable`** (failing): every other result with
   definition errors or acceptance violations.
5. **`inert`** (non-failing): no witness, and the relaxed compiled profile is *behaviourally
   equal* to the baseline. Define `behaviourKey :: CompiledProfile -> BehaviourKey` as a
   projection of the compiled rules that erases only what the validator provably never consults.
   Each erasure needs a code comment naming the validator function that proves it, and a test.
   There are four erasures:
   - descriptions and guidance;
   - an `EffectiveFieldRule` with no presence clauses, no allowed values, `Any` cardinality and no
     format, nested rules, reference, path or uniqueness, when `allowUnknownFields` is `True`;
   - `allowSelf` inside a handle reference whose effective `allowLocal` is `False`;
   - `externalUriPattern` when `externalUriSchemes` is empty.

   Inert means equal keys. The engine always evaluates the relaxation anyway. If an inert
   relaxation has a witness, that is an okf bug: report it as an internal error and exit 3, so an
   unsound proof can never hide a real result.
6. **`covered`** (non-failing): no witness, and the relaxation is a member of a composite unit
   whose unit relaxation is `protected`. The units are:
   - the members of a handle reference policy (`allowLocal`, `allowSelf`, `externalUriPattern`)
     and the unit `reference`;
   - a type's `idPrefix` and the `DocumentHandle` `format` of its `idField`, each covering the
     other;
   - a `List` cardinality and `elementFields`.

   The engine evaluates the unit relaxation even under the `default` set when a member needs it.
   It reports the unit and its witness, and also the member's facet witnesses, which show that the
   fixture does exercise the member.
7. **`exception`** (non-failing): no witness, and the relaxation ID matches an entry in the
   suite's exception manifest.
8. **`unprotected`** (failing): everything else.

**Exception manifest.** The command reads `--exceptions FILE`, defaulting to
`<cases>/sweep-exceptions.json` when that file exists, with this shape:

```json
{
  "version": 1,
  "exceptions": [
    {
      "relaxation": "type:Objective/optional/verified/objectFields/required/by#delete",
      "class": "shared-family",
      "home": "okfV02",
      "rationale": "Spliced from Profile/V02.dhall; okf-v0-2-invalid tests each member."
    }
  ]
}
```

`class` is a closed vocabulary:

- `shared-family` requires `home`, naming the home profile's export;
- `overlapping-rule` requires `overlapsWith`, the relaxation ID or type attribute that governs
  the same value (ADR-9's one-governing-rule caveat);
- `deferred` requires `request`, a `mori://` URI of the request that will add the fixture.

These rules apply to the manifest:

- Every entry needs a non-empty `rationale`.
- An entry whose ID matches no relaxation, or whose relaxation is not otherwise `unprotected`, is
  *stale*. It is reported as `stale-exception` and is failing, so manifests cannot rot.
- Malformed manifests are a baseline fault.

**Exit codes:**

- 0 when no failing outcome or stale exception exists;
- 1 when any does;
- 2 for a baseline fault, an unreadable manifest or bad arguments;
- 3 for an internal inertness contradiction.

**Output.** The summary line lists counts for every outcome. The NDJSON relaxation events gain
`outcome`, `coveredBy`, `facetWitnesses`, `reason` and `exception` (see Interfaces and
Dependencies).

**Tests.** Write okf-core tests, each on a small purpose-built profile and suite under
`okf-core/test/fixtures/sweep/`, for:

- each classification rule, including a contradiction test that feeds a deliberately wrong
  `behaviourKey` through an internal test hook and expects the internal error;
- each erasure in `behaviourKey`: the same bundles yield identical violations with and without
  the erased member;
- `admitValue` generation from a conditional status vocabulary, where emptying the vocabulary
  must make `compileProfile` fail;
- the `allowLocal` masking case, which must end `covered` by `reference`;
- stale and malformed manifests.

Acceptance:

- `cabal test all` passes in the okf checkout.
- On the six families,
  `"$OKF_BIN" profile sweep … --kinds legacy --json` still passes the comparison script.
  `legacyOutcome` is unchanged by classification.
- `"$OKF_BIN" profile sweep profiles/coordination/strategy.dhall --accept fixtures/strategy --cases fixtures/strategy-invalid`
  (with the default kinds and no manifest yet) exits 1. Its unprotected lines are exactly the
  shared-family members and any genuine gaps. No `allowSelf`/`allowLocal` line is unprotected:
  each is `inert` or `covered`.

### Milestone 5 — Conditional: bounded, deterministic parallel evaluation (okf)

Do this milestone only if Milestone 4's default-kind sweep of the strategy profile takes more
than 30 s of wall time on the reference machine, or if Milestone 2 recorded that it would.
Otherwise, record the measured time and the decision to skip it in the Decision Log, check the
Progress item, and move on.

Evaluation is pure, so parallelism needs no threads in the engine. In `runProfileSweep`:

1. Build the lazy list of `(Relaxation, Outcome)` pairs.
2. Apply `withStrategy (parBufferChunks jobs rdeepseq)`. If the `parallel` package lacks a
   chunked buffer in the version the build resolves, use `parBuffer jobs rdeepseq`.
3. Consume the list sequentially for printing.

Output order stays the enumeration order whatever the scheduling, so results are deterministic.
At most `jobs` evaluations run ahead of printing, which bounds both work and memory.

To support this:

- Add `--jobs N`, defaulting to the RTS capability count, with `--jobs 1` meaning serial.
- Add `NFData` instances through `deriving anyclass (NFData)` for the engine's result types and
  for any okf-core types they contain (`ProfileViolation`, `FieldPath` and their components).
- Add `parallel` and `deepseq` with bounds to `okf-cli/okf-cli.cabal`, and `deepseq` to
  `okf-core/okf-core.cabal` if the instances live there.

Acceptance: running the same sweep with `--jobs 1` and `--jobs 8` gives byte-identical `--json`
output once `elapsedMs` is removed (`jq -c 'del(.elapsedMs)'`), and the `--jobs 8` wall time is
lower.

### Milestone 6 — Release and adoption (okf, then okf-profiles)

**okf release.** Prepare the release by following okf's established process: version bump in
both `.cabal` files, the changelog section, and generated help if any. Look at the most recent
`chore(release)` commit in the okf checkout with `git log --grep 'chore(release)' -1 --stat` and
mirror it. The expected version is 0.11.0.0; record the actual one. **Ask the owner before
tagging or pushing.** Installing the release on the owner's `PATH` (through their Nix
home-manager configuration) is the owner's action. Until it happens, keep using `OKF_BIN`.

**Delegating wrapper.** In okf-profiles, add `--engine okf|legacy` to
`scripts/sweep-profile-rules.py`:

- `okf`, the default, first checks that `"$OKF_BIN" profile sweep --help` succeeds. It then
  replaces itself with
  `okf profile sweep <profile> --accept <accept> [--accept <extra> ...] --cases <invalid>`
  through `os.execvp`, passing `--json` and `--kinds` through. Output streams with no Python
  buffering, and the exit code is okf's.
- If okf lacks the command, the wrapper prints
  `okf <version> has no 'profile sweep'; install okf >= <release> or pass --engine legacy` and
  exits 2. It does *not* silently fall back.
- `legacy` keeps the Milestone 1 behaviour.

**Exception manifests.** For each of the six families:

1. Run the default-kind sweep.
2. For every `unprotected` result, either add the missing rejection fixture, following ADR-9
   (one fault per fixture, with an entry in `expected.json`), or add an exception entry to
   `fixtures/<name>-invalid/sweep-exceptions.json` with the right class.
3. Verify each `shared-family` exception: run the home profile's sweep and confirm that the same
   innermost field and kind are `protected` there. Note any that are not as findings.
4. Re-run until the sweep exits 0.

**New script.** Add `scripts/sweep-all-profiles.sh`. It loops over every profile whose test uses
`profile_fixture_cases.run` (the pairs can be read from `scripts/test-*-profile.py`). For each,
it runs the sweep with default kinds, prints a one-line result per profile and a total time, and
exits non-zero if any sweep does. Run it once over the whole catalog with `--kinds all` as well,
and record the counts of new findings per profile in Surprises & Discoveries. Do not make
`--kinds all` gating in this plan.

**Gating.** If the default-kind catalog sweep takes under 120 s in total, add a `sweep` recipe to
`justfile` and call it from `check` (`check: types test sweep`), so that ADR-9's second check runs
automatically before every release. Otherwise, add only the `sweep` recipe and record the time.
Either way, record the decision. Gate `check` on the sweep only after the release is installed.
Until then, a contributor with okf 0.10 would see `just check` fail for a missing command.

**Documentation:**

- Update `README.md` near line 445, replacing "slow, and not part of `just test`" with the new
  command, the outcome classes, the exception manifest and the minimum okf version.
- Add a dated amendment to ADR-9 that records:
  - the sweep is native and typed;
  - acceptance failures and descriptor failures are never protection;
  - inertness and composite coverage are decided by okf;
  - only shared-family, overlapping-rule and deferred results may be documented exceptions, and
    stale exceptions fail.

  Advance ADR-9's `timestamp` (or its equivalent last-revision field, per the local profile) and
  add a log entry with `okf log add docs/adr --kind Update -m "ADR-9 …"` in the established style. Then run
  `okf validate docs/adr --strict --profile docs/adr/profile.dhall --profile-enforce --log-enforce`.
- In okf, add an ADR recording why the sweep relaxes the typed descriptor in process and what
  `behaviourKey` may erase, following okf's ADR workflow (`okf id next docs/adr ADR --profile docs/adr/profile.dhall`).
- Mark the okf request completed in the same way.

**Close IR-11.** Set `status: completed`, `completedAt`, `targetPlan` (this plan's `mori://`
URI), a `resolution` naming the okf release and the parity evidence, and an `amended` entry.
Append the completion to `docs/improvement-requests/log.md`, then validate that bundle strictly
with its own profile, `docs/improvement-requests/profile.dhall`. When implementation starts
(Milestone 1), first set `status: in-progress` and `targetPlan`, with a log entry.

Acceptance:

- `just check` passes in okf-profiles.
- `python3 scripts/sweep-profile-rules.py profiles/coordination/strategy.dhall fixtures/strategy fixtures/strategy-invalid`
  streams okf's lines and exits 0.
- `bash scripts/sweep-all-profiles.sh` exits 0 and prints its total time.
- Both ADR bundles and both request bundles validate strictly.


## Concrete Steps

All okf-profiles commands run from the okf-profiles checkout root. All okf commands run from the
okf checkout root (find it with `mori registry show shinzui/okf --full`). The scratch directory
for long outputs that are not evidence is any directory outside both checkouts.

Milestone 1 — try the improved legacy script on the smallest family and watch it stream:

```bash
python3 scripts/sweep-profile-rules.py profiles/assurance/claim-checks.dhall \
  fixtures/claim-checks fixtures/claim-checks-invalid --json /tmp/claim-checks.legacy.json \
  > /tmp/claim-checks.out 2>&1 &
tail -f /tmp/claim-checks.out
```

The expected shape (numbers are illustrative):

```text
okf: okf v0.10.0.0 (feacb5e)
baseline: 1 acceptance bundle, 39 rejection cases OK (40 okf runs, 15.2 s)
[  1/58] OK  claimCheckId             delete               fixture missing-claim-check-id  (2 okf runs, 0.8 s)
[  2/58] !!  verified                 delete               UNPROTECTED  (40 okf runs, 15.0 s)
...
sweep: 58 relaxations: 49 witnessed, 1 acceptance-fails, 0 descriptor-invalid, 8 unprotected; 640 okf runs in 4m 06s
```

Record the six baselines (long-running, one at a time, in the background):

```bash
mkdir -p docs/plans/evidence/13
for p in claim-checks:assurance audiences:coordination campaigns:coordination \
         strategy:coordination launches:coordination messaging:documentation; do
  name=${p%%:*}; family=${p##*:}
  python3 scripts/sweep-profile-rules.py "profiles/$family/$name.dhall" \
    "fixtures/$name" "fixtures/$name-invalid" \
    --json "docs/plans/evidence/13/$name.legacy.json" > "/tmp/$name.legacy.out" 2>&1
done
```

Commit Milestone 1. For example:

```text
feat(sweep): stream legacy sweep results and separate acceptance failures

Print each relaxation as it is decided with elapsed time and okf run counts,
resolve OKF_BIN, fail clearly on baseline faults, report acceptance and
descriptor failures as their own classes, and write a JSON summary.

ExecPlan: docs/plans/13-make-profile-policy-sweeps-observable-and-run-them-natively-in-okf.md
Intention: intention_01m61cc0jhee7trcx2kvb6x77y
```

Milestone 2 — the spike file in the okf checkout, `spike/SweepSpike.hs`. Adjust imports if the
compiler reports a name in a different module. Each name below was verified to exist at planning
time in the module shown.

```haskell
{-# LANGUAGE OverloadedStrings #-}
module Main (main) where

import Control.Monad (forM, forM_, replicateM_)
import Data.Time.Clock (diffUTCTime, getCurrentTime)
import Okf.Bundle (walkBundle, walkBundleInventory)
import Okf.Index (readBundleVersion)
import Okf.Profile (compileProfile, loadProfileFile, validateProfileVersion, validateProfileWith)
import Okf.Validation (ValidationProfile (..))
import System.Directory (doesDirectoryExist, listDirectory)
import System.Environment (getArgs)
import System.FilePath ((</>))

main :: IO ()
main = do
  [root] <- getArgs
  t0 <- getCurrentTime
  Right spec <- loadProfileFile (root </> "profiles/coordination/strategy.dhall")
  let casesDir = root </> "fixtures/strategy-invalid"
  names <- listDirectory casesDir
  dirs <- filter snd <$> forM names (\n -> (,) (casesDir </> n) <$> doesDirectoryExist (casesDir </> n))
  suite <- forM (map fst dirs) $ \d -> do
    Right concepts <- walkBundle d
    Right inventory <- walkBundleInventory d
    Right declaration <- readBundleVersion d
    pure (concepts, inventory, declaration)
  t1 <- getCurrentTime
  putStrLn ("load: " <> show (diffUTCTime t1 t0) <> " for " <> show (length suite) <> " cases")
  replicateM_ 200 (either (error . show) (const (pure ())) (compileProfile spec))
  t2 <- getCurrentTime
  putStrLn ("200 compiles: " <> show (diffUTCTime t2 t1))
  let Right compiled = compileProfile spec
  forM_ [1 :: Int .. 200] $ \i -> do
    let total = sum [ length (show vs)
                    | (concepts, inventory, declaration) <- suite
                    , let vs = validateProfileVersion declaration compiled
                                 <> validateProfileWith inventory PermissiveConformance compiled concepts ]
    total `seq` pure i
  t3 <- getCurrentTime
  putStrLn ("200 full suite passes: " <> show (diffUTCTime t3 t2))
```

```bash
cabal build okf-core
cabal exec -- runghc spike/SweepSpike.hs <okf-profiles checkout>
rm -r spike
```

Record the three printed durations in Surprises & Discoveries. Divide the second and third by 200
to get the per-relaxation cost.

Milestone 3 — build, test and compare:

```bash
# okf checkout
cabal build all && cabal test all
export OKF_BIN="$(cabal list-bin okf)"
"$OKF_BIN" profile sweep --help
```

```bash
# okf-profiles checkout, with OKF_BIN exported as above
for p in claim-checks:assurance audiences:coordination campaigns:coordination \
         strategy:coordination launches:coordination messaging:documentation; do
  name=${p%%:*}; family=${p##*:}
  /usr/bin/time -p "$OKF_BIN" profile sweep "profiles/$family/$name.dhall" \
    --accept "fixtures/$name" --cases "fixtures/$name-invalid" --kinds legacy --json \
    > "docs/plans/evidence/13/$name.okf.ndjson"
  python3 scripts/compare-sweep-results.py \
    "docs/plans/evidence/13/$name.legacy.json" "docs/plans/evidence/13/$name.okf.ndjson"
done
```

The expected comparison output for each profile:

```text
parity: 105/105 legacy results matched; 2 okf-only results (legacy cannot delete a sole list element)
```

Milestone 4 — the default-kind strategy sweep, before any manifest exists:

```bash
"$OKF_BIN" profile sweep profiles/coordination/strategy.dhall \
  --accept fixtures/strategy --cases fixtures/strategy-invalid; echo "exit=$?"
```

The expected shape is one line per relaxation, then a summary like:

```text
sweep: 131 relaxations: 101 protected, 6 inert, 9 covered, 3 subsumed, 0 exception, 12 unprotected, 0 failing other; 4.1 s
exit=1
```

Milestone 6 — after a manifest exists, the same command ends with `exit=0`. Then:

```bash
just check
bash scripts/sweep-all-profiles.sh
okf validate docs/adr --strict --profile docs/adr/profile.dhall --profile-enforce --log-enforce
okf validate docs/improvement-requests --strict --profile docs/improvement-requests/profile.dhall --profile-enforce --log-enforce
```


## Validation and Acceptance

The plan is complete when every item below is true. Each corresponds to an IR-11 criterion or to
this plan's widening.

1. **Same answers as the serial baseline (IR-11 criterion 1).** For each of the six families,
   `scripts/compare-sweep-results.py` matches every legacy result recorded in
   `docs/plans/evidence/13/<name>.legacy.json` against `docs/plans/evidence/13/<name>.okf.ndjson`
   and exits 0. The only unmatched okf entries are labelled sole-element deletions.
2. **Baseline faults stop the run, and nothing untested is labelled protected (IR-11
   criterion 2).**
   - Breaking one `expected.json` entry makes `okf profile sweep` exit 2 before any relaxation
     line. The okf-core baseline-fault test covers the same case.
   - No relaxation is `protected` unless it has a witness.
   - An acceptance failure or a definition error is `subsumed`, `covered` or failing, never
     `protected`.
   - The inertness contradiction test exits 3.
3. **Prompt redirected output with elapsed time and a machine-readable summary (IR-11
   criterion 3).** Redirect `okf profile sweep … > out` and run `tail -f out`: lines arrive as
   relaxations are decided. The text summary carries the elapsed time. `--json` ends with a
   `summary` event that `jq` parses. The legacy script does the same since Milestone 1.
4. **Lower wall time on a representative large corpus, without weakening ADR-9 (IR-11
   criterion 4).** Outcomes & Retrospective records, for the strategy profile (182 cases), the
   legacy wall time and the okf wall time for the same relaxations. The okf time must be at least
   20× lower, and under 60 s, on the same machine. The `default` kinds are a superset of the
   legacy kinds, so coverage only grows.
5. **The sweep is a gate.** With the manifests committed, `okf profile sweep` exits 0 for each of
   the six families. Deleting any one rejection fixture that is the only witness of some
   relaxation makes it exit 1 and name that relaxation `unprotected`. Try this on one strategy
   fixture and restore it with `git checkout -- fixtures/strategy-invalid`.
6. **Determinism (only if Milestone 5 ran).** `--jobs 1` and `--jobs 8` produce identical JSON,
   ignoring elapsed times.
7. **The repositories stay green.** `just check` passes in okf-profiles and `cabal test all`
   passes in okf.


## Idempotence and Recovery

- **Read-only sweeps.** Every sweep is read-only with respect to the repository. The legacy
  script writes mutated descriptors only inside a `tempfile.TemporaryDirectory`, and the okf
  engine mutates values in memory. Re-running any sweep is safe.
- **Interrupted baselines.** If a legacy baseline run is interrupted, re-run that profile; the
  JSON file is written only at the end, so a partial file is never left behind. If fixtures or
  profiles change after a baseline was recorded, the baseline no longer applies. Regenerate it
  before comparing, which the `gitCommit` field makes detectable.
- **Fixture experiments.** Negative experiments (breaking an `expected.json` entry, deleting a
  fixture) must be undone with `git checkout -- <path>`. Do them on a clean tree so the restore
  cannot discard other work.
- **The okf release.** The release is the one outward-facing step: ask the owner before tagging
  or pushing, and never move a published tag. If the release slips, Milestone 6's wrapper still
  works with `OKF_BIN` pointing at a local build. Only the `just check` gating waits.
- **Request files.** The okf request and IR-11 edits are additive frontmatter changes. Validate
  their bundles after each edit; if validation fails, fix the frontmatter rather than reverting
  the log entry.


## Interfaces and Dependencies

### `okf-core/src/Okf/Profile/Sweep.hs`

This module is new and depends only on okf-core's existing dependencies, plus `deepseq` if
Milestone 5 runs. Its exports at the end of Milestone 4:

```haskell
module Okf.Profile.Sweep
  ( -- * Rule identity
    RuleScope (..),          -- ProfileScope | TypeScope Text
    PresenceList (..),       -- RequiredList | RecommendedList | OptionalList
    NestedContainer (..),    -- ElementFields | ObjectFields
    RuleLocation (..),       -- scope, list, field, Maybe (NestedContainer, PresenceList, Text)
    renderRuleLocation,      -- :: RuleLocation -> Text
    -- * Relaxations
    RelaxationKind (..),     -- Delete | Presence | ClearVocabulary | AdmitValue Text | DropFormat
                             -- | DropUniqueBy | AllowSelf | AllowLocal | DropExternalUriPattern
                             -- | DropCardinality | DropCondition | DropPath | DropReference
                             -- | DropNested NestedContainer | DropTypeAttribute TypeAttribute
    TypeAttribute (..),      -- PathPattern | ResourceScheme | RequireSchemaSection | SchemaColumns | IdPrefix
    KindSet (..),            -- LegacyKinds | DefaultKinds | AllKinds
    Relaxation (..),         -- target (rule location or type name) and kind
    relaxationId,            -- :: Relaxation -> Text, e.g. "type:Launch/required/launchRef#allowLocal"
    legacyKindName,          -- :: RelaxationKind -> Maybe Text, the Python kind string when one exists
    enumerateRelaxations,    -- :: KindSet -> ProfileSpec -> [Relaxation]
    applyRelaxation,         -- :: Relaxation -> ProfileSpec -> ProfileSpec
    -- * Suites
    CaseExpectation (..),    -- field :: Text, count :: Int
    RejectionCase (..),      -- name, expectation, loaded bundle
    SuiteBundle (..),        -- path, concepts, inventory, version declaration, logs
    Suite (..),              -- acceptance :: [SuiteBundle], cases :: [RejectionCase] (expected.json order)
    SuiteError (..),
    loadSuite,               -- :: [FilePath] -> FilePath -> IO (Either SuiteError Suite)
    -- * Evaluation
    Render,                  -- = CompiledProfile -> [Concept] -> ProfileViolation -> Text
    BaselineFault (..),
    checkBaseline,           -- :: Render -> CompiledProfile -> Suite -> Either BaselineFault PreparedSuite
    PreparedSuite,           -- suite with profile-independent core and log results computed once
    Observation (..),        -- witnesses, primaryWitness, facetWitnesses, acceptanceViolations, definitionErrors
    observeRelaxation,       -- :: Render -> PreparedSuite -> ProfileSpec -> Relaxation -> Observation
    legacyOutcome,           -- :: Observation -> Text  ("fixture <n>" | "acceptance-fails" | "UNPROTECTED")
    -- * Classification
    BehaviourKey,
    behaviourKey,            -- :: CompiledProfile -> BehaviourKey
    ExceptionClass (..),     -- SharedFamily Text | OverlappingRule Text | Deferred Text
    SweepException (..),     -- relaxation id, class, rationale
    loadExceptions,          -- :: FilePath -> IO (Either Text [SweepException])
    Outcome (..),            -- Protected | Subsumed [Text] | Covered Text Text | DescriptorInvalidOutcome
                             -- | AcceptanceObservableOutcome | Inert Text | ExceptionOutcome SweepException
                             -- | Unprotected
    outcomeIsFailing,        -- :: Outcome -> Bool
    SweepResult (..),        -- relaxation, observation, outcome
    sweepProfile,            -- :: Render -> KindSet -> [SweepException] -> PreparedSuite -> ProfileSpec
                             --    -> Either InternalError ([SweepResult], [SweepException])  -- results, stale exceptions
  )
```

The names may be adjusted during implementation if the compiler or okf's style requires it.
Record any change in the Decision Log. `sweepProfile` must return a lazy list in enumeration
order. Composite unit relaxations that it evaluates for classification and that the chosen
`KindSet` does not request are reported only through `Covered`, never as their own results.

### okf-cli

- **`Okf.Cli`** gains `ProfileSweep ProfileSweepOptions` with the fields `profilePath`, `accept`
  (non-empty list), `casesDir`, `kinds`, `json`, `only`, `exceptionsPath` and `jobs` (Milestone 5).
- **`runProfileSweep`** sets line buffering on stdout and stderr, uses `loadProfileOrExit`,
  `compileProfileOrExit`, `loadSuite`, `checkBaseline` and `sweepProfile`, and renders with the
  existing `renderProfileViolation`.

### NDJSON events (`--json`)

`okf profile sweep --json` writes exactly one object per line, in this order:

```json
{"event":"start","okf":"0.11.0.0","profile":"profiles/coordination/strategy.dhall","accept":["fixtures/strategy"],"cases":"fixtures/strategy-invalid","caseCount":182,"kinds":"default","relaxationCount":131}
{"event":"baseline","ok":true,"elapsedMs":412}
{"event":"relaxation","index":12,"total":131,"id":"type:Objective/required/status#allowedValues","field":"status","kind":"allowedValues","outcome":"protected","legacyOutcome":"fixture objective-bad-status","witness":"objective-bad-status","witnesses":["objective-bad-status","objective-bad-status-achieved"],"facetWitnesses":["objective-bad-status"],"coveredBy":null,"reason":null,"exception":null,"elapsedMs":3}
{"event":"summary","relaxations":131,"counts":{"protected":101,"inert":6,"covered":9,"subsumed":3,"exception":0,"unprotected":12,"descriptor-invalid":0,"acceptance-observable":0},"staleExceptions":[],"failing":["..."],"elapsedMs":4100,"exit":1}
```

A baseline fault writes `{"event":"baseline","ok":false,"fault":"...","detail":"..."}` and then
the summary with `"exit":2`. `field` is the innermost field name, and `kind` is the legacy kind
string when one exists, otherwise the new kind's name. Together with `legacyOutcome`, these two
fields are what `scripts/compare-sweep-results.py` keys on.

### okf-profiles

- **`scripts/sweep-profile-rules.py`:**
  - positional interface unchanged;
  - options `--json PATH`, `--quiet` and `--only FIELD` from Milestone 1;
  - from Milestone 6, `--engine okf|legacy` and `--kinds`.
  - Python standard library only: argparse, json, shutil, subprocess, tempfile, time.
- **`scripts/compare-sweep-results.py LEGACY.json OKF.ndjson`:**
  - exit 0 on parity, 1 otherwise;
  - standard library only.
- **`scripts/sweep-all-profiles.sh`:** a bash loop, `set -euo pipefail` semantics, except that it
  continues past one profile's failure so it can report every profile, then exits non-zero if any
  failed.
- **`fixtures/<name>-invalid/sweep-exceptions.json`:** the manifest shape above, one per suite
  that needs exceptions.
- **`docs/plans/evidence/13/`:** the legacy JSON and okf NDJSON evidence files.

External tools are `dhall` (≥ 1.42, legacy engine only), `okf` (≥ 0.11.0.0 for the native engine),
`python3` and `jq` (for the determinism check).
