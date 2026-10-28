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
  reviews:
    - model: "claude-fable-5-1"
      harness: "claude-code"
      at: 2026-10-28T14:37:57Z
      verdict: "changes-requested"
      note: "Measured the speedup claim (36 ms/relaxation in process vs ~70 s legacy full pass); spike instructions, okf toolchain, objectFields scanner gap and streaming/classification grouping needed fixes, applied in the same session"
    - model: "claude-fable-5-1"
      harness: "claude-code"
      at: 2026-10-28T14:50:13Z
      verdict: "approved"
      note: "Re-read end to end after applying the requested changes; counts, commands and section cross-references are consistent and the plan is implementable from Milestone 1"
  revisions:
    - model: "claude-fable-5-1"
      harness: "claude-code"
      at: 2026-10-28T14:37:57Z
      mode: "update"
      note: "Recorded planning measurements, corrected the Milestone 2 spike and okf toolchain commands, added the legacy objectFields scanner fix, and grouped evaluation per rule location"
---

# Make profile policy sweeps observable and run them natively in okf

This ExecPlan is a living document. The sections Progress, Surprises & Discoveries,
Decision Log, and Outcomes & Retrospective must be kept up to date as work proceeds.
If durable project context changes, update or create ADRs in docs/adr/ in the same change.

This plan implements the improvement request
`mori://shinzui/okf-profiles/okf/improvement-requests/concepts/IR-11` (file
[docs/improvement-requests/make-profile-policy-sweeps-observable-and-reduce-redundant-fixture-scans.md](../improvement-requests/make-profile-policy-sweeps-observable-and-reduce-redundant-fixture-scans.md))
and widens it. The request asks for progress output and fewer repeated fixture scans. This plan
also fixes why the scans are expensive and why some sweep results mislead, and for that okf
gains a native sweep command. That okf work, the engine and the `okf profile sweep` command, is
planned and tracked in okf's own ExecPlan `mori://shinzui/okf/plans/71-add-okf-profile-sweep-for-load-bearing-rule-checks`
(plan 71 below), extracted from this plan on 2026-10-28. This plan keeps the catalog side: the
improved legacy sweep and its recorded baselines, the comparison script that proves parity, and
adoption of the command once okf ships it. The two plans share one intention and reference each
other; the measurements and design decisions made while this plan was written stay recorded
here as history, and plan 71 carries the ones it owns.


## Purpose / Big Picture

Every profile in this catalog must pass a *load-bearing sweep* before release. The sweep checks
that each rule the profile declares is actually tested by some fixture. It does this by weakening
the rule one way at a time and confirming that some rejection fixture notices the change. ADR-9
makes this sweep mandatory whenever a profile gains, loses or changes a rule. Today it is
`scripts/sweep-profile-rules.py`. On the strategy profile it starts one `okf` process per fixture
per relaxation, and each process spends about 0.37 seconds decoding the profile. A full sweep of a
large profile takes tens of minutes to hours. While it runs and output is redirected, nothing
appears until it finishes. Some results it prints as `OK` do not show that any fixture tests the
rule (see Context and Orientation). The same work done once in process costs about 36 ms per
relaxation, measured during planning (see Surprises & Discoveries), which is where the speedup
in this plan comes from.

After this plan:

- **The command** (built in okf under plan 71). A maintainer runs
  `okf profile sweep profiles/coordination/strategy.dhall --accept fixtures/strategy --cases fixtures/strategy-invalid`.
  It finishes in seconds rather than tens of minutes: the planning measurement forecasts about
  six seconds for the strategy profile's default relaxations.
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
      acceptance and descriptor failures from protection, enumerates rules nested under
      `objectFields`, and writes a JSON summary.
- [ ] Milestone 1: legacy baseline summaries recorded for the six families under
      `docs/plans/evidence/13/`.
- [x] Timing spike run on 2026-10-28 during plan validation: compile plus one full pass over
      the 182 strategy cases costs about 36 ms in process, so the in-process approach is
      promoted. The numbers are in Surprises & Discoveries; the spike is now Milestone 0 of
      plan 71.
- [ ] Milestone 2: `scripts/compare-sweep-results.py` written and, with plan 71's Milestone 1
      build on `OKF_BIN`, parity proven for the six families with the okf NDJSON evidence
      committed under `docs/plans/evidence/13/`.
- [ ] Milestone 3: `scripts/sweep-profile-rules.py` delegates to `okf profile sweep`; exception
      manifests written for the six families; `scripts/sweep-all-profiles.sh` added; full
      catalog swept and triaged, including one `--kinds all` run.
- [ ] Milestone 3: README, ADR-9 amendment, IR-11 completion and the logs; the `just check`
      gating decision recorded.

The okf engine, command, classification, optional parallelism, release, okf ADR and okf request
are plan 71's milestones; their state is tracked there.


## Surprises & Discoveries

- **2026-10-28 (plan validation): where a legacy okf call spends its time.** Measured with
  `hyperfine -N -w 1 -r 5` on the planning machine (Apple Silicon, okf 0.10.0.0 from the Nix
  profile, another cabal build running concurrently in a different session, so these are
  conservative). The fixture is `fixtures/strategy-invalid/strategic-theme-missing-type`, the
  first entry of `expected.json`. "normalized" means the output of
  `dhall --file profiles/coordination/strategy.dhall` written to a file, which is what the legacy
  script validates against.

  ```text
  okf --version                                                        25.9 ms ±  1.2 ms
  okf validate <fixture>                                               25.7 ms ±  1.2 ms
  okf validate <fixture> --profile profiles/coordination/strategy.dhall  163.8 ms ±  4.9 ms
  okf validate <fixture> --profile <normalized>                         379.7 ms ±  7.8 ms
  okf validate fixtures/strategy --strict --profile <normalized> \
      --profile-enforce --log-enforce                                   392.9 ms ± 11.0 ms
  okf validate fixtures/strategy                                        37.1 ms ±  5.5 ms
  dhall type --file <normalized>                                       309.6 ms ±  4.2 ms
  ```

  Process start-up is 26 ms and validating a two-concept fixture without a profile adds nothing
  measurable. Decoding the source descriptor costs about 138 ms; decoding the 442,085-byte
  normalized descriptor costs about 354 ms, 2.6× more, because normalization inlines every
  shared import. The legacy script pays the slower path on every call because it mutates the
  normalized text. Profile validation of the fixture itself is below the measurement noise.
  Each legacy relaxation therefore costs `0.31 s (dhall type) + 0.39 s (acceptance) +
  0.38 s × fixtures tried`; a relaxation that no fixture notices tries all 182 and costs about
  70 s.

- **2026-10-28 (plan validation): in-process cost, from the Milestone 2 spike.** Run twice from
  the okf checkout inside `nix develop` with GHC 9.12.4 and `-O1`, loading the strategy profile
  and all 182 rejection cases (see Concrete Steps for the exact code and commands):

  ```text
  profile decode: 0.105 s – 0.136 s (once)
  load: 0.150 s – 0.188 s for 182 cases (once)
  violations per pass: 197
  compile only (WHNF):                             200 iterations,  4.0 ms each
  compile + count violations over 182 cases:       200 iterations, 35.6 ms each
  full pass, rendered with show, shared compile:   200 iterations, 30.1 ms each
  compile + full pass rendered with show:          200 iterations, 36.2 ms each
  ```

  One relaxation costs at most 36 ms in process even when every one of the 182 cases is
  evaluated and rendered, against 70 s for the same full pass through the legacy script: a
  factor of about 1,900 on the pass that dominates legacy sweeps. `compileProfile` is cheap
  (about 6 ms once its lazy fields are forced by validation; the 4 ms "WHNF" line forces only
  the outer constructor). Rendering with `show` costs about a sixth of the pass. For the
  strategy profile's 119 legacy relaxations (after the scanner fix), the forecast is 0.3 s of
  fixed loading plus at most 119 × 36 ms, about 4.5 s; the default kinds add one presence
  demotion for each of the strategy profile's 47 required rules, about 166 relaxations and
  about 6 s.

- **2026-10-28 (plan validation): the first spike measured the wrong thing.** The spike as
  originally written looped 200 times over an expression that did not mention the loop index.
  GHC's full-laziness pass floated the expression out of the loop and evaluated it once, so the
  spike printed `200 compiles: 0.164 s` and `200 full suite passes: 0.043 s`, which are the cost
  of one compile and one pass, not of 200. The corrected spike in Concrete Steps passes the loop
  index into `NOINLINE` workers and compiles with `-fno-full-laziness -fno-cse`. Any later
  micro-benchmark of okf-core must do the same.

- **2026-10-28 (plan validation): okf builds only inside its Nix shell.** The okf checkout's
  `cabal.project` says GHC comes from the flake's devShell, pinned to GHC 9.12.4, and
  `dist-newstyle` holds only 9.12.x builds. The `ghc` on the planning machine's `PATH` is 9.10.3;
  a `cabal build` with it fails on the test suite's `zlib` dependency. Also,
  `cabal exec -- runghc spike/SweepSpike.hs` cannot see okf-core: the in-place package is exposed
  to a standalone `ghc` only through a GHC environment file, which
  `cabal build okf-core --write-ghc-environment-files=always` writes to the checkout root. The
  plan's commands now say so, and the environment file must be deleted afterwards because it is
  not ignored by git.

- **2026-10-28 (plan validation): legacy relaxation counts for all six families.** Running the
  legacy script's enumeration (its `rules` and `relaxations` functions) without validating:
  campaigns 62 rules / 90 relaxations, claim-checks 38 / 48, audiences 48 / 65, strategy 68 /
  105, launches 59 / 97, messaging 52 / 79. The strategy profile's 105 break down as 65 `delete`,
  16 `format`, 12 `allowSelf`, 6 `allowLocal`, 5 `allowedValues` and 1 `uniqueBy`. Six of the
  12 `allowSelf` relaxations sit on references with `allowLocal = False`, where okf never
  consults `allowSelf`, so they are provably inert; the 6 `allowLocal` relaxations are masked by
  the composite reference policy. The legacy sweep scans all 182 fixtures for each of these 12,
  about 14 minutes in total, and reports each as `UNPROTECTED`.

- **2026-10-28 (plan validation): a measured legacy run on the smallest family.** The unmodified
  legacy script on `profiles/assurance/claim-checks.dhall` (48 relaxations, 39 cases) took 205 s
  of wall time and printed `20 unprotected of 48 relaxations`. All 20 are members of spliced
  families (`reviews`, the list spelling of `generated` and `verified`, and `sources`). Three
  more results were `acceptance-fails` and were printed as `OK`, which is the honesty defect
  Milestone 1 fixes. Dividing 205 s by the roughly 930 okf and dhall calls the run made gives
  about 0.22 s per call: the claim-checks descriptor is smaller than strategy's, and the per-call
  cost scales with descriptor size. In process, the same sweep is forecast at about one second
  (48 relaxations × 39 cases × 0.17 ms, plus compiles and loading).

- **2026-10-28 (plan validation): the legacy script never relaxes rules nested under
  `objectFields`.** Its `rules` function scans the normalized text for `field = "`, takes the
  enclosing record, and then continues scanning *after* that record. Dhall normalization sorts
  record fields alphabetically, so inside a container rule the `elementFields` member comes
  before `field` and its nested rules are visited first, but `objectFields` comes after `field`,
  so the scanner reaches the container's own `field = "…"` first and jumps over everything
  inside its `objectFields`. In the strategy profile, 11 nested rules are therefore never swept:
  `generated.at`, `generated.by`, `verified.at`, `verified.by` (the object spellings from
  `Profile/V02.dhall`), `assessment.rationale`, `assessment.assessedAt`, `assessment.evidenceRefs`
  and `hypothesis.problem`, `hypothesis.belief`, `hypothesis.prediction`, `hypothesis.falsifiedIf`.
  Claim-checks has 4 (`generated` and `verified` members). The `at`/`by` relaxations that the
  legacy claim-checks run did print come from the list spelling, through `elementFields`.
  Milestone 1 fixes the scanner (see Decision Log) before the six baselines are recorded, so
  the baselines cover these rules and Milestone 3's comparison needs no special case for them.
  The fix was tried on a copy during validation: it keeps every relaxation the old scanner
  produced (zero lost in all six families) and adds campaigns 90 → 121, claim-checks 48 → 52,
  audiences 65 → 79, strategy 105 → 119, launches 97 → 101 and messaging 79 → 83. The additions
  are `delete`, `format`, `allowedValues`, `allowSelf` and `allowLocal` relaxations on the
  object-nested rules; a sole-element `delete` is still not produced, as before.


## Decision Log

- Decision: Put the sweep engine in okf as a typed, in-process command (`okf profile sweep`)
  rather than only tuning the Python script.
  Rationale: Measurement during planning showed that about 0.35 s of each `okf validate` call is
  spent decoding the 442,085-byte normalized strategy descriptor (process start-up is 26 ms, and
  validating the fixture itself is below measurement noise). A full scan of the 182 strategy
  rejection fixtures takes about 70 s however the fixtures are ordered, so a field-indexed
  ordering alone cannot remove the dominant cost. Inside okf, profile validation is the pure
  function
  `validateProfileWith :: BundleInventory -> ValidationProfile -> CompiledProfile -> [Concept] -> [ProfileViolation]`
  (`okf-core/src/Okf/Profile.hs`). Core OKF validation and log staleness do not depend on the
  profile at all. So a sweep can decode the profile once, load every bundle once, and re-run only
  the pure profile check for each relaxation. The Milestone 2 spike confirmed the arithmetic: a
  compile plus a full rendered pass over all 182 cases costs 36 ms in process, so the whole
  strategy sweep is forecast at about 6 s against tens of minutes. The speedup comes entirely
  from paying the decode once; the typed engine, classification and exit codes exist for
  correctness, not speed. Relaxing the decoded `ProfileSpec` value also replaces the Python
  script's hand-written Dhall text surgery, which breaks easily and, as validation found, skips
  every rule nested under `objectFields`.
  Date: 2026-10-28

- Decision: Keep the existing Python script as a working, improved *legacy engine* (Milestone 1)
  and use it as the reference against which the okf engine must agree.
  Rationale: IR-11's first acceptance criterion is agreement with "the serial baseline". The only
  credible way to show that is to record that baseline with the current algorithm (plus the
  scanner fix below, which only adds relaxations) before replacing it, and to keep that
  algorithm runnable until parity is proven.
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

- Decision: Promote the in-process approach (Milestone 2's promote/discard decision), and expect
  Milestone 5 (parallel evaluation) to be skipped.
  Rationale: The spike measured 36 ms for one compile plus one full rendered pass over all 182
  strategy cases, under the 50 ms promotion threshold. Loading costs about 0.3 s once. The
  forecast for the strategy profile is about 4.5 s with the legacy kinds and about 6 s with the
  default kinds, far under Milestone 5's 30 s trigger. Milestone 4 still measures the real
  command before the skip is recorded.
  Date: 2026-10-28

- Decision: Evaluate relaxations in groups, one group per rule location, and emit a group's
  lines only when every relaxation in the group is classified.
  Rationale: Two classification rules in Milestone 4 look sideways. `subsumed` asks whether
  *every other* relaxation of the same rule location is non-failing, and `covered` asks whether
  a derived `admitValue` relaxation or a composite unit relaxation of the same rule is
  protected. A line-per-relaxation stream in strict enumeration order would have to print a
  `delete` line before its siblings were evaluated. Grouping by rule location keeps the output
  order equal to the enumeration order, keeps `sweepProfile`'s result a lazy list (lazy per
  group), and gives Milestone 5 a natural unit of parallel work. A group costs at most a few
  hundred milliseconds, so streaming stays prompt.
  Date: 2026-10-28

- Decision: Every okf build, test and spike command runs inside the okf checkout's Nix
  development shell: `nix develop --command <command>`.
  Rationale: okf's `cabal.project` states that GHC comes from the flake's devShell (GHC 9.12.4),
  and `dist-newstyle` holds only 9.12.x builds. The planning machine's `PATH` carries GHC 9.10.3,
  which fails to build the test suite's `zlib` dependency outside the shell. A build with the
  wrong compiler would also produce an `okf` binary whose behaviour the release does not
  share.
  Date: 2026-10-28

- Decision: Milestone 1 fixes the legacy scanner so that it also enumerates rules nested under
  `objectFields`, and the six baselines are recorded after that fix.
  Rationale: Validation found that the scanner jumps past a container's `objectFields` because
  normalized Dhall sorts `field` before `objectFields` (see Surprises & Discoveries). Eleven
  strategy rules and four claim-checks rules have never been swept. Recording baselines without
  the fix would make the reference incomplete, and the okf engine, which enumerates the typed
  spec, would then disagree with it for reasons that have nothing to do with the engine. The fix
  is one line (continue scanning inside the record instead of after it) and changes no
  relaxation that the old scanner produced. The pre-fix and post-fix relaxation counts are
  recorded in Surprises & Discoveries so the two can be told apart.
  Date: 2026-10-28

- Decision: Relocate the okf work into okf's own ExecPlan, `mori://shinzui/okf/plans/71-add-okf-profile-sweep-for-load-bearing-rule-checks`,
  and keep this plan for the catalog side. This supersedes the earlier decision to do all the
  okf code work under this one plan.
  Rationale: Each repository's plan should be implementable from that checkout alone, and each
  commit should point at a plan in the same repository. Plan 71 now owns the engine design: the
  in-process typed engine, the promote decision, grouping per rule location, the Nix toolchain,
  classification by evidence, "acceptance failure is never protection" as an engine rule, the
  default and `all` kind sets, and the `Okf.Profile.Sweep` and `okf profile sweep` interfaces.
  The entries above that record those decisions stay as the history of how they were reached;
  where they say Milestone 2 (the spike), 3, 4, 5 or 6, read plan 71's Milestones 0, 1, 2, 3
  and 4, and the same mapping applies to the dated revision note below and to the Surprises &
  Discoveries entries written before the relocation. This plan keeps the legacy engine, the baselines, the comparison script, the exception
  manifests, the wrapper, the catalog gate and the ADR-9 amendment, and restates only the parts
  of okf's contract it consumes. Commits in the okf checkout carry plan 71's trailer; commits
  here carry this plan's. Both carry the shared intention.
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
expression. It then scans the normalized text for records containing `field = "` (missing those
nested under `objectFields`; see fact 5 below). Records that are conditions (`hasValue` without
`allowedValues`) are skipped. It builds textual mutations of seven kinds:

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

Planning found five facts about this script that shape the work:

1. **Acceptance and descriptor failures print as protection.** The print at the end of the file
   marks anything not starting with `UNPROTECTED` or `MUTATION` as `OK`. That includes
   `acceptance-fails`, which arises in two situations: when a deletion in a closed profile makes a
   field unknown, and when the relaxed descriptor no longer loads in okf. An example of the second
   is clearing a vocabulary that a `when` condition depends on. okf requires a condition's source
   field to have a closed scalar vocabulary, and `dhall type` does not catch this.
2. **Decoding dominates the cost.** On the strategy profile, `okf validate` of a two-concept
   rejection fixture takes 0.38 s against the normalized descriptor: 26 ms of process start-up,
   about 0.35 s decoding the descriptor, and no measurable time validating the fixture. The
   source descriptor decodes in 0.14 s, but the script cannot use it because it mutates the
   normalized text. One pass over all 182 strategy fixtures takes about 70 s. Every unprotected
   relaxation costs a full pass, and every `dhall type` check costs another 0.31 s. The measured
   numbers are in Surprises & Discoveries.
3. **Output is buffered.** Results print only at the end, through Python's default block
   buffering, so redirected output shows nothing for hours.
4. **The okf binary is hard-coded.** The script calls `okf` from `PATH` and ignores `OKF_BIN`, so
   it cannot be pointed at an unreleased okf build.
5. **Rules nested under `objectFields` are never swept.** `rules()` continues scanning after the
   end of each record it finds. Normalized Dhall sorts record members alphabetically, so a
   container's `elementFields` precede its `field = "…"` and are scanned first, while its
   `objectFields` follow it and are jumped over. Milestone 1 changes the scanner to continue
   scanning inside the record. See Surprises & Discoveries for the affected rules and counts.

The six release-relevant families are listed below. The last column gives the relaxation
count from the current scanner and, after the arrow, the count after Milestone 1's scanner fix.

| Profile | Accept | Cases | Legacy relaxations |
|---|---|---|---|
| `profiles/coordination/campaigns.dhall` | `fixtures/campaigns` | 161 | 90 → 121 |
| `profiles/assurance/claim-checks.dhall` | `fixtures/claim-checks` | 39 | 48 → 52 |
| `profiles/coordination/audiences.dhall` | `fixtures/audiences` | 96 | 65 → 79 |
| `profiles/coordination/strategy.dhall` | `fixtures/strategy` | 182 | 105 → 119 |
| `profiles/coordination/launches.dhall` | `fixtures/launches` | 122 | 97 → 101 |
| `profiles/documentation/messaging.dhall` | `fixtures/messaging` | 105 | 79 → 83 |

Each profile's rejection fixtures are in `fixtures/<name>-invalid` (the strategy row, for example,
uses `fixtures/strategy-invalid`). None of the six per-profile tests passes extra acceptance
bundles. The counts were produced during planning by running the script's own `rules` and
`relaxations` functions without validating; the strategy, launches and messaging counts agree
with the sweeps recorded in
`mori://tan/tan-product-management/plans/4-add-strategy-messaging-and-launch-profiles-to-okf-profiles`.

### okf and the `okf profile sweep` contract (`mori://shinzui/okf`)

okf is the Haskell tool (`okf-core` library, `okf-cli` executable) that validates bundles.
Version 0.10.0.0, the one installed on the owner's `PATH`, has no sweep command. Plan 71 adds
`okf profile sweep` and prepares the next release (expected 0.11.0.0). Until that release is
installed, this plan runs the unreleased build through `OKF_BIN`: from the okf checkout (find
it with `mori registry show shinzui/okf --full`, field `Path`), build inside its Nix shell with
`nix develop --command cabal build all`, then export
`OKF_BIN="$(cd <okf checkout> && nix develop --command cabal list-bin okf)"`. Both
`scripts/profile_fixture_cases.py` and, after Milestone 1, `scripts/sweep-profile-rules.py`
honour it.

What this plan relies on, and plan 71 delivers:

- **Usage.** `okf profile sweep PROFILE --accept BUNDLE [--accept BUNDLE ...] --cases DIR
  [--kinds legacy|default|all] [--json] [--only FIELD] [--exceptions FILE]`. `--cases` is a
  directory in the `fixtures/<name>-invalid` shape, with `expected.json` in the same format
  the catalog uses today. The command decodes the profile once, loads every bundle once,
  evaluates each relaxation in process, and prints one line per relaxation as it is decided,
  with line buffering, then a summary line with elapsed time.
- **The same predicate.** A case is a *witness* under a relaxed profile exactly when it stops
  meeting the expectation that `profile_fixture_cases.py` checks: N rendered `profile:` lines,
  one naming the field. The engine applies this predicate to lines rendered by the same
  renderer `okf validate` uses, so its witnesses match the legacy script's.
- **Outcome classes** (plan 71, Milestone 2). Each relaxation ends as one of: `protected`
  (a witness exists); `subsumed` (a `delete` that only made the field unknown, while every other
  relaxation of the rule is accounted for); `covered` (a member of a composite policy whose
  unit relaxation is protected, or a vocabulary clearing that cannot compile but whose
  value-admitting relaxation is protected); `inert` (okf proves the relaxed profile behaves
  identically, for example `allowSelf` on a reference with `allowLocal = False`, which
  `validateReferenceText` never consults); `exception` (listed in the suite's manifest); or
  `unprotected`. Acceptance failures and definition errors are never protection; an
  unexplained one is a failing outcome. The three ADR-9 "expected unprotected" classes map
  onto these as follows: an unconstrained optional field under `allowUnknownFields = True` is
  `inert`; `allowSelf`/`allowLocal` on an external-only reference is `inert` or `covered`; a
  spliced shared-family member is an `exception`, because after decoding nothing in a
  descriptor says which rules came from a family.
- **Exit codes.** 0 when nothing fails; 1 when any relaxation is failing or a manifest entry is
  stale; 2 for a baseline fault (an acceptance bundle or case that does not meet its expectation
  under the unrelaxed profile), an unreadable manifest or bad arguments; 3 for an internal
  contradiction in okf's inertness proof.
- **Machine-readable output.** With `--json`, NDJSON events `start`, `baseline`, one
  `relaxation` per relaxation and `summary`; the fields this plan's comparison script keys on
  are `field`, `kind` and `legacyOutcome` (see Interfaces and Dependencies).
- **The manifest.** okf reads `<cases>/sweep-exceptions.json` when present (shape under
  Interfaces and Dependencies). The manifest is authored here, beside the cases, and okf reports
  an entry that matches no relaxation, or whose relaxation is not otherwise `unprotected`, as a
  failing `stale-exception`.

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

Every milestone in this plan changes okf-profiles. The okf work is plan 71
(`mori://shinzui/okf/plans/71-add-okf-profile-sweep-for-load-bearing-rule-checks`): Milestone 2 here needs
its Milestone 1 build, and Milestone 3 here needs its release (or `OKF_BIN` until the release is
installed). Every commit here uses Conventional Commits and ends with these trailers:

```text
ExecPlan: docs/plans/13-make-profile-policy-sweeps-observable-and-run-them-natively-in-okf.md
Intention: intention_01m61cc0jhee7trcx2kvb6x77y
```

Commits in the okf checkout carry plan 71's own trailer instead.

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

**Scanner fix.** In `rules()`, the last statement of the loop is `i = end`, which resumes the
scan after the record just found and so skips every rule nested under that record's
`objectFields` (fact 5 above). Change it to `i += len('field = "')`, which resumes just after
the match and lets the loop find the nested records on later iterations. Nothing else changes:
nested records are complete rule records with their own `field = "…"`, `enclosing_brace` finds
their own opening brace, and condition records are still skipped by the `hasValue` test. Verify
the change the way validation did: enumerate relaxations with the old and new scanner on a copy
and confirm that every old `(field, kind, text)` triple is still produced and that the added
triples match the counts in Surprises & Discoveries (strategy 105 → 119).

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
  Both a descriptor that does not decode (`loadProfileOrExit`) and one that decodes but has a
  definition error (`compileProfileOrExit`, for example a condition whose source vocabulary was
  cleared) start their message with that text. Check this before treating the run as
  `acceptance-fails`.
- `mutation-ill-typed`: `dhall type` rejects the mutated text.
- `unprotected`.

Print `OK ` only for `witness`. Print `!! ` for every other class, with the class name in upper
case in the last column. Keep the legacy column layout, so a reader of old logs recognizes the
lines.

**Streaming.** Print each relaxation's line as soon as it is decided, with `flush=True`, prefixed
by its position, for example `[ 12/119]`. Add the elapsed time for that relaxation and the number
of okf invocations it used, for example `(4 okf runs, 1.6 s)`. Print the total relaxation count
before the first relaxation: compute the full list of `(name, kind, text)` first, which costs
nothing compared with validation. End with:

```text
sweep: 119 relaxations: 94 witnessed, 3 acceptance-fails, 2 descriptor-invalid, 20 unprotected; 2714 okf runs in 1h 05m 12s
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
This field is the comparison key used in Milestone 2. `gitCommit` is `git rev-parse HEAD` of
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

### Milestone 2 — Parity between the native engine and the legacy baselines

This milestone needs plan 71's Milestone 1: an okf build whose `okf profile sweep --kinds legacy
--json` runs on the catalog. Point `OKF_BIN` at it (see Context and Orientation). It can start
as soon as that build exists; the baselines from Milestone 1 must have been recorded with the
Milestone 1 script (after the scanner fix) at a commit whose `fixtures/` and `profiles/` are
unchanged since.

**Comparison script.** Add `scripts/compare-sweep-results.py LEGACY.json OKF.ndjson`. It reads
the legacy summary written by `--json` in Milestone 1 and the okf NDJSON stream, and compares
the multisets of `(field, kind, legacyOutcome)` tuples. okf derives `legacyOutcome` from its own
observation with the legacy precedence (plan 71 specifies this): an acceptance violation or a
descriptor that does not compile → `acceptance-fails`; otherwise a primary witness `w` →
`fixture w`; otherwise → `UNPROTECTED`. The script prints every unmatched tuple on either side.
An okf-only tuple is acceptable only when it is a `delete` of a rule that is the sole element of
its list, because the legacy textual deletion cannot remove a sole element; label these
`legacy cannot delete a sole list element`. Any other unmatched tuple, including a legacy
`MUTATION-ILL-TYPED`, makes it exit 1. The script also checks that the legacy summary's
`gitCommit` matches `git rev-parse HEAD` and warns when it does not, since the comparison is
only meaningful on the same fixtures. If a mismatch traces to rendering differences between okf
versions, regenerate the legacy baseline with `OKF_BIN` set to the new build.

**Evidence.** For each of the six families, write the okf stream to
`docs/plans/evidence/13/<name>.okf.ndjson` and commit it beside the legacy baseline, with the
wall time of each run recorded in Outcomes & Retrospective next to the legacy wall time from
Milestone 1.

Acceptance:

- For each family, `python3 scripts/compare-sweep-results.py docs/plans/evidence/13/<name>.legacy.json docs/plans/evidence/13/<name>.okf.ndjson`
  prints `parity: N/N legacy results matched` and exits 0, with only sole-element deletions as
  okf-only results.
- The strategy run's wall time is seconds (forecast about 4.5 s); the legacy baseline for the
  same relaxations is the number recorded in Milestone 1. Record both.

### Milestone 3 — Adoption: wrapper, manifests, catalog gate, documentation

This milestone needs plan 71's Milestone 2 (classification and exit codes). Its gating step
needs the okf release installed on the owner's `PATH`; everything else works with `OKF_BIN`.

**Delegating wrapper.** Add `--engine okf|legacy` to `scripts/sweep-profile-rules.py`:

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
   `fixtures/<name>-invalid/sweep-exceptions.json` with the right class (shape under Interfaces
   and Dependencies).
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
- The okf-side ADR and the okf request's completion are plan 71's Milestone 4.

**Close IR-11.** Set `status: completed`, `completedAt`, `targetPlan` (this plan's `mori://`
URI), a `resolution` naming the okf release, plan 71 and the parity evidence, and an `amended`
entry. Append the completion to `docs/improvement-requests/log.md`, then validate that bundle
strictly with its own profile, `docs/improvement-requests/profile.dhall`. When implementation
starts (Milestone 1), first set `status: in-progress` and `targetPlan`, with a log entry.

Acceptance:

- `just check` passes in okf-profiles.
- `python3 scripts/sweep-profile-rules.py profiles/coordination/strategy.dhall fixtures/strategy fixtures/strategy-invalid`
  streams okf's lines and exits 0.
- `bash scripts/sweep-all-profiles.sh` exits 0 and prints its total time.
- The ADR bundle and the request bundle validate strictly.


## Concrete Steps

All commands run from the okf-profiles checkout root. Building okf is plan 71's business; this
plan only needs `OKF_BIN` exported as described in Context and Orientation. The scratch
directory for long outputs that are not evidence is any directory outside the checkout.

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
baseline: 1 acceptance bundle, 39 rejection cases OK (40 okf runs, 9.1 s)
[  1/52] OK  claimCheckId             delete               fixture missing-claim-check-id  (2 okf runs, 0.6 s)
[  2/52] !!  reviewer                 delete               UNPROTECTED  (40 okf runs, 9.0 s)
...
sweep: 52 relaxations: 29 witnessed, 3 acceptance-fails, 0 descriptor-invalid, 20 unprotected; 1000 okf runs in 3m 50s
```

The unmodified script took 205 s on this family during planning and reported 20 unprotected
results and 3 acceptance failures (printed as `OK`), so the improved script should land near
the numbers above; the four extra relaxations come from the scanner fix.

Record the six baselines (long-running, one at a time, in the background). Budget for them:
each unprotected relaxation costs a full pass of about 0.38 s per case on the strategy profile
(less on smaller descriptors), so expect roughly half an hour each for strategy, launches,
campaigns and messaging, a quarter of an hour for audiences and four minutes for claim-checks,
about two hours in total. Start the loop and carry on with Milestone 2's script while it runs:

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
descriptor failures as their own classes, enumerate rules nested under
objectFields (the scanner skipped them), and write a JSON summary.

ExecPlan: docs/plans/13-make-profile-policy-sweeps-observable-and-run-them-natively-in-okf.md
Intention: intention_01m61cc0jhee7trcx2kvb6x77y
```

Milestone 2 — with `OKF_BIN` pointing at a plan 71 Milestone 1 build, sweep and compare:

```bash
"$OKF_BIN" profile sweep --help
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
parity: 119/119 legacy results matched; 2 okf-only results (legacy cannot delete a sole list element)
```

Milestone 3 — the default-kind strategy sweep, before any manifest exists:

```bash
"$OKF_BIN" profile sweep profiles/coordination/strategy.dhall \
  --accept fixtures/strategy --cases fixtures/strategy-invalid; echo "exit=$?"
```

The expected shape is one line per relaxation, then a summary like:

```text
sweep: 166 relaxations: 130 protected, 6 inert, 9 covered, 3 subsumed, 0 exception, 18 unprotected, 0 failing other; 5.9 s
exit=1
```

After a manifest exists, the same command ends with `exit=0`. Then:

```bash
just check
bash scripts/sweep-all-profiles.sh
okf validate docs/adr --strict --profile docs/adr/profile.dhall --profile-enforce --log-enforce
okf validate docs/improvement-requests --strict --profile docs/improvement-requests/profile.dhall --profile-enforce --log-enforce
```


## Validation and Acceptance

The plan is complete when every item below is true. Each corresponds to an IR-11 criterion or to
this plan's widening. Items that test okf's internals (the engine's own tests, the inertness
contradiction, determinism under parallel evaluation) belong to plan 71.

1. **Same answers as the serial baseline (IR-11 criterion 1).** For each of the six families,
   `scripts/compare-sweep-results.py` matches every legacy result recorded in
   `docs/plans/evidence/13/<name>.legacy.json` against `docs/plans/evidence/13/<name>.okf.ndjson`
   and exits 0. The only unmatched okf entries are labelled sole-element deletions.
2. **Baseline faults stop the run, and nothing untested is labelled protected (IR-11
   criterion 2).**
   - Breaking one `expected.json` entry makes both engines exit 2 before any relaxation line.
   - In the legacy engine, `OK` is printed only for a witness; in okf, no relaxation is
     `protected` without a witness, and an acceptance failure or a definition error is
     `subsumed`, `covered` or failing, never `protected`.
3. **Prompt redirected output with elapsed time and a machine-readable summary (IR-11
   criterion 3).** Redirect either engine's output to a file and run `tail -f`: lines arrive as
   relaxations are decided. The summary carries the elapsed time. The legacy `--json` summary
   parses with `python3 -m json.tool`; okf's `--json` ends with a `summary` event that `jq`
   parses.
4. **Lower wall time on a representative large corpus, without weakening ADR-9 (IR-11
   criterion 4).** Outcomes & Retrospective records, for the strategy profile (182 cases), the
   legacy wall time and the okf wall time for the same relaxations. The okf time must be at least
   20× lower, and under 60 s, on the same machine. Those are floors; the planning measurements
   (Surprises & Discoveries) forecast about 4.5 s for okf against tens of minutes for the legacy
   script, a factor in the hundreds, and the measured legacy run on claim-checks took 205 s where
   okf is forecast at about 1 s. The `default` kinds are a superset of the legacy kinds, so
   coverage only grows.
5. **The sweep is a gate.** With the manifests committed, `okf profile sweep` exits 0 for each of
   the six families. Deleting any one rejection fixture that is the only witness of some
   relaxation makes it exit 1 and name that relaxation `unprotected`. Try this on one strategy
   fixture and restore it with `git checkout -- fixtures/strategy-invalid`.
6. **The repository stays green.** `just check` passes in okf-profiles.


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
- **The okf release.** The release belongs to plan 71 and is its one outward-facing step. If it
  slips, Milestone 3's wrapper still works with `OKF_BIN` pointing at a local build. Only the
  `just check` gating waits.
- **Request files.** The okf request and IR-11 edits are additive frontmatter changes. Validate
  their bundles after each edit; if validation fails, fix the frontmatter rather than reverting
  the log entry.


## Interfaces and Dependencies

### The okf command (owned by plan 71)

The engine module `Okf.Profile.Sweep`, the `okf profile sweep` options and the classification
rules are specified in plan 71 (`mori://shinzui/okf/plans/71-add-okf-profile-sweep-for-load-bearing-rule-checks`). This plan consumes the command line
`okf profile sweep PROFILE --accept BUNDLE [--accept BUNDLE ...] --cases DIR [--kinds legacy|default|all] [--json] [--only FIELD] [--exceptions FILE]`,
the exit codes 0/1/2/3 described in Context and Orientation, the NDJSON events below, and the
exception manifest below. If plan 71 changes any of these, update this plan in the same change.

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
fields are what `scripts/compare-sweep-results.py` keys on; plan 71 treats them as a published
contract.

### Exception manifest (`fixtures/<name>-invalid/sweep-exceptions.json`)

Authored in this repository beside the cases, read by okf:

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

`class` is a closed vocabulary: `shared-family` requires `home`, naming the home profile's
export; `overlapping-rule` requires `overlapsWith`, the relaxation ID or type attribute that
governs the same value (ADR-9's one-governing-rule caveat); `deferred` requires `request`, a
`mori://` URI of the request that will add the fixture. Every entry needs a non-empty
`rationale`. A relaxation ID is a rule location (`profile/required/status`,
`type:Objective/required/keyResults/elementFields/required/id`) plus `#<kind>`.

### okf-profiles

- **`scripts/sweep-profile-rules.py`:**
  - positional interface unchanged;
  - options `--json PATH`, `--quiet` and `--only FIELD` from Milestone 1;
  - from Milestone 3, `--engine okf|legacy` and `--kinds`.
  - Python standard library only: argparse, json, shutil, subprocess, tempfile, time.
- **`scripts/compare-sweep-results.py LEGACY.json OKF.ndjson`:**
  - exit 0 on parity, 1 otherwise;
  - standard library only.
- **`scripts/sweep-all-profiles.sh`:** a bash loop, `set -euo pipefail` semantics, except that it
  continues past one profile's failure so it can report every profile, then exits non-zero if any
  failed.
- **`fixtures/<name>-invalid/sweep-exceptions.json`:** the manifest shape above, one per suite
  that needs exceptions (Milestone 3).
- **`docs/plans/evidence/13/`:** the legacy JSON and okf NDJSON evidence files.

External tools are `dhall` (≥ 1.42, legacy engine only), `okf` (≥ 0.11.0.0 for the native
engine, or an unreleased build through `OKF_BIN`), `python3`, `jq` (to inspect NDJSON) and
`hyperfine` (optional, for repeating the timing measurements). Building okf needs `nix`; see
plan 71.


## Revision Notes

### 2026-10-28 — validation of the speedup claim and corrections found while validating

Validated by measuring rather than by reading. Changes and why:

- **Evidence for the speedup.** Surprises & Discoveries now holds the `hyperfine` split of a
  legacy `okf validate` call (26 ms process, about 0.35 s decoding the normalized descriptor,
  nothing measurable for the fixture), the Milestone 2 spike results (36 ms per compile plus full
  rendered pass over 182 cases), a measured 205 s legacy run on claim-checks, and the legacy
  relaxation counts for all six families. The Decision Log's first entry and Validation item 4
  cite these numbers. Milestone 2's Progress item is checked, because the spike was run during
  validation, and its promote decision is recorded.
- **The spike as written would have misled.** `cabal exec -- runghc` cannot see the in-place
  okf-core library, and GHC's full-laziness pass hoisted the original loop bodies so that 200
  iterations cost one. The spike code, build commands and guidance were replaced with the
  version that ran (NOINLINE workers taking the loop index, `-fno-full-laziness -fno-cse`, a GHC
  environment file). Milestone 2 and Concrete Steps carry the fix.
- **Toolchain.** okf builds only inside `nix develop` (GHC 9.12.4). Every okf command in Context
  and Orientation, Milestones 2, 3 and 6, Concrete Steps and Interfaces and Dependencies now says
  so, and the Decision Log records why.
- **Legacy scanner gap.** The legacy script never relaxes rules nested under `objectFields`
  (fact 5 in Context and Orientation, with the affected rules and before/after counts in
  Surprises & Discoveries). Milestone 1 gains a one-line scanner fix, verified on a copy to lose
  no existing relaxation, and the baselines are recorded after it. The family table shows both
  counts, and the Milestone 1 transcript example uses claim-checks' real numbers.
- **Streaming versus classification.** `subsumed` and `covered` depend on sibling relaxations,
  which a strict one-line-per-relaxation stream in enumeration order cannot honour. Milestone 3
  now evaluates and emits one rule location's relaxations as a group, Milestone 4 says which
  rules need it, Milestone 5 parallelizes over groups, and Interfaces and Dependencies defines
  the per-group laziness. `admitValue` candidates are derived during enumeration so the start
  event's count is exact.
- **Milestone 5.** `parBufferChunks` does not exist in the `parallel` package; the plan names
  `parBuffer` with its type. The milestone is expected to be skipped on the measured forecast
  (about 6 s against a 30 s trigger) and says so.
- **Consistency pass (same day).** After the edits above, the plan was re-read end to end and
  the counts that the scanner fix changed were aligned everywhere: 119 legacy relaxations for
  strategy (the parity example, the stream examples and the Milestone 3 forecast) and about 166
  default-kind relaxations (119 plus one presence demotion for each of the 47 required rules),
  with the strategy forecast at about 6 s. The Milestone 3 engine description now says six
  parts, the command prints as each rule location's group is decided, the remaining
  `cabal test all` commands carry the `nix develop` prefix, the Milestone 1 commit example and
  Progress item mention the scanner fix, and the `descriptor-invalid` detection string was
  verified against okf's `loadProfileOrExit` and `compileProfileOrExit`, which both start their
  message with `Failed to load profile`.
- **Milestone 3 acceptance** gains a wall-time expectation (about 4 s; over 15 s is a defect to
  investigate), so a lost sharing of the loaded suite cannot pass unnoticed.

### 2026-10-28 — okf work relocated to plan 71

The okf half of this plan (the prototype, the `Okf.Profile.Sweep` engine, the `okf profile sweep`
command, classification and exit codes, optional parallel evaluation, the okf release, okf ADR
and okf request) now lives in okf's own ExecPlan,
`mori://shinzui/okf/plans/71-add-okf-profile-sweep-for-load-bearing-rule-checks`, created from this plan's text with the
measurements and decisions it owns. This plan keeps the catalog side and restates only the
contract it consumes. Changes: the intro, Purpose and Progress say where each half lives; the
Decision Log records the relocation and which earlier entries are now history; the okf section
of Context and Orientation became a description of the command's contract (usage, predicate,
outcome classes, exit codes, NDJSON, manifest) with `OKF_BIN` instructions; Milestones 2–6
became Milestone 2 (comparison script and parity, needing plan 71's Milestone 1) and Milestone 3
(wrapper, manifests, catalog script, gating, documentation, IR-11 completion, needing plan 71's
Milestone 2 and release); Concrete Steps, Validation and Interfaces dropped the okf build, spike,
engine exports and okf-internal checks, and the exception manifest moved to Interfaces because it
is authored here. Milestone 1 is unchanged except that its comparison-key reference now points
at Milestone 2.
