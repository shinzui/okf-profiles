# migrate-okf-bundles-to-v0-2

Agent-driven migration of every profile-governed Open Knowledge Format bundle in a repository from
OKF v0.1 to **OKF v0.2**, for okf-profiles **v0.8.0**.

okf-profiles v0.8.0 moves all seven published profiles to OKF v0.2. v0.2 assumes a corpus written
and maintained by agents and adds the frontmatter a reader needs to judge machine-written
knowledge: provenance (`generated`), trust (`verified`), and an explicit bundle dialect
declaration. Any repository pinning one of these profiles starts reporting deviations it never
reported before, and under `--profile-enforce` its checks go red.

| Command | What it does |
|---------|--------------|
| `seihou agent run migrate-okf-bundles-to-v0-2` | Detect whichever profiled OKF bundles the repository has and migrate each one according to its governing profile |

There is no `seihou agent migrate` entry point. `migrate` selects declared edges by a version
window read from the consumer's own pinned tag, and six of the seven profiles have never been
distributed through a blueprint — a consuming repository has no `.seihou` receipt for them and
often no local descriptor at all. `run` is the correct verb for "inspect this repository and bring
it to a known state", which is exactly this job.

## Usage

```bash
seihou agent run migrate-okf-bundles-to-v0-2
```

For non-interactive automation, use Seihou's batch launcher:

```bash
seihou agent run migrate-okf-bundles-to-v0-2 --batch
```

Pass a repository-specific prompt when local conventions need extra guidance:

```bash
seihou agent run migrate-okf-bundles-to-v0-2 \
  "Use human:ops for anything under docs/runbooks and skip the vendored bundle."
```

Preview the complete rendered prompt without contacting a provider. Seihou may still record
applied-blueprint provenance in `.seihou/manifest.json`, so use a clean or disposable checkout
when the manifest must remain untouched:

```bash
seihou agent --debug run migrate-okf-bundles-to-v0-2
```

## What it detects, and how

The run begins by working out which profile governs each bundle, from three sources of evidence in
descending order of reliability:

1. **`mori.dhall`'s bundle declarations**, read with `mori show --full` — the repository's own
   statement of what it has.
2. **A local descriptor beside the bundle**, typically `<bundle>/profile.dhall`, whose import names
   the profile export.
3. **A check script or CI target** invoking `okf validate --profile`.

If a bundle's governing profile cannot be determined, the run reports it and leaves it alone.
Migrating a bundle against a guessed profile is worse than not migrating it — the five
house-`status` profiles and the two PostgreSQL profiles want opposite things from the `status` key.

**If the repository has no profiled OKF bundle at all, the run reports that the migration is not
applicable and finishes successfully without creating anything.** This no-op behaviour is required
because the blueprint is invoked across repositories whether or not they use OKF.

## What it changes

Four changes apply to every bundle:

- **`generated` is added to every concept** — a mapping with a required `by` (an OKF v0.2 §7 actor:
  `human:<id>`, `process:<id>`, or `<producer>/<version>`) and a recommended `at`. Both members are
  derived from evidence: `at` reuses the document's existing `timestamp`, and where there is none,
  the last commit that meaningfully changed the file. Nothing is restamped to the current time,
  because `okf log` coverage now reads `generated.at` in preference to `timestamp`.
- **`timestamp` is kept.** It is demoted to `optional`, not removed. Its format is still checked;
  its absence is never reported.
- **The bundle root declares `okf_version: "0.2"`**, written with
  `okf index <bundle> --write --okf-version 0.2`.
- **`verified` becomes available** as an optional family. Where a corpus records approvals in a
  house `reviews` family, an approving entry may be mirrored into `verified` so `okf trust` derives
  an accurate tier — a human review as `human:<id>`, a model review as `process:<agent>`.

Two profiles change further. `documentation.patternCatalog` and `documentation.researchDocuments`
reshape `sources` from a bare list of strings into the OKF v0.2 list of records whose `resource`
member is required — the existing string becomes the entry's `resource`. And `postgresql` and
`tanPostgresql` gain OKF's `status` and `stale_after` as newly available optional keys.

Several previously-`recommended` fields moved to `optional` across the catalog, which is a pure
relaxation: a corpus that omits them stops failing `--strict`, and a local descriptor overriding
those classifications may now be able to drop the override.

## What it deliberately does not change

**House `status` values.** Five profiles — architecture decisions, the pattern catalog, research
documents, improvement requests, and use cases — use `status` for their own lifecycle vocabulary
and deliberately do **not** adopt OKF v0.2 §5.4's `draft` / `stable` / `deprecated`. The key name is
shared; the meaning is not. Rewriting an ADR's `status: Accepted` to `status: stable` would destroy
the corpus's lifecycle information and break every downstream query. Only `postgresql` and
`tanPostgresql` take OKF's vocabulary, because neither declares a house `status` key.

This is the item most likely to cause silent damage, so the prompt states it twice — once as a
per-profile instruction and once in the prohibition list — and the shipped
`v0-2-migration-reference.md` tabulates every house vocabulary in the catalog.

The run also does not rewrite prose, renumber documents, change any stable handle (`ADR-N`, `IR-N`,
`UC-N`, `RES-N`), delete `timestamp`, weaken a profile to make a corpus pass, or add a `trust` key —
a document's trust tier is computed from `verified` on every read and is never written into a
bundle.

## Reference files

Two references ship with the blueprint and the prompt stops rather than proceeding if they are
unavailable:

- **`v0-2-migration-reference.md`** — the per-profile change table, the actor convention, the
  `sources` reshape, the house-`status` divergence, the `reviews`/`verified` mirroring rule, and
  full unmigrated-corpus transcripts showing exactly what a consumer sees the first time they pull
  v0.8.0.
- **`profile-pins.md`** — the v0.8.0 pinned-import line for each of the seven profile exports, a
  descriptor template, the repinning diff, and the freezing rules.

## Prerequisites

- **`okf` 0.5.0.0 or later** and **`dhall` 1.42 or later** in the target repository's environment.
- **A tool-capable local CLI provider**, such as `claude-cli` or `codex-cli`. Some providers reject
  an empty instruction, so pass the optional prompt argument if the session fails to start:

  ```bash
  seihou agent run migrate-okf-bundles-to-v0-2 \
    "Follow the blueprint instructions for this repository." --provider claude-cli
  ```

## Relationship to `adopt-architecture-decisions`

A repository whose `docs/adr` bundle was installed by
[`adopt-architecture-decisions`](../adopt-architecture-decisions/) has a dedicated upgrade path for
that one bundle:

```bash
seihou agent migrate adopt-architecture-decisions --from 0.7.0 --to 0.8.0
```

Either route produces the same result for that bundle. Use the dedicated edge when the ADR bundle
is the only one you have — it also moves the descriptor pin and retires the presence override that
blueprint used to install. Use this blueprint when the repository has other bundles too; its report
says which route it took for each so an operator does not run both.

Be aware of one Seihou behaviour if you do run the dedicated edge and it deliberately refuses —
because the repository never adopted the profile. Seihou records a receipt whenever a session
returns, and a deliberate refusal returns normally, so that edge is then marked done and skipped on
the run that should have applied it. Pass `--rerun` to execute it anyway. This is tracked upstream
as `mori://shinzui/seihou`'s IR-1, which asks for a not-applicable outcome distinct from both
success and provider failure.

## For maintainers: adding an edge

This blueprint declares no migration edges, because it is new at 0.8.0 and has no earlier version
of itself to migrate from. When a future `okf-profiles` release changes what any of the seven
profiles demands:

1. Write the edge prompt under `migrations/`, naming the exact constraints that changed and the
   validation that proves the upgrade worked.
2. Declare it in `blueprint.dhall` keyed at the **last release before the change**, not at the
   oldest version still in the wild. An edge is selected only when it falls inside the requested
   window, so keying it too early makes it unreachable from every later `--from`.
3. Update `files/profile-pins.md` and `files/v0-2-migration-reference.md` to the new contract, and
   rename the reference if the format version itself moves.
4. Bump the blueprint `version` in both `blueprint.dhall` and `seihou-registry.dhall` to match the
   `okf-profiles` tag it targets.
5. Verify with `seihou validate-blueprint blueprints/migrate-okf-bundles-to-v0-2 --lint`, then
   dry-run with `seihou agent --debug run` and read the rendered prompt end to end.

Note that `seihou agent --debug` renders the **installed** copy under
`~/.config/seihou/installed/`, not the working tree. Reinstall the blueprint before dry-running a
change, or the preview shows the previous version.
