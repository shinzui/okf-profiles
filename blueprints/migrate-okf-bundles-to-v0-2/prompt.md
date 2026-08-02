# Migrate this repository's OKF bundles to Open Knowledge Format v0.2

Find every profile-governed Open Knowledge Format bundle in the current repository, work out which
`okf-profiles` profile governs each one, and migrate each to OKF v0.2. Preserve every document's
historical meaning; this is a frontmatter and bundle-metadata migration, not a rewrite.

okf-profiles v0.8.0 moves all seven published profiles from OKF v0.1 to v0.2. v0.2 assumes a corpus
written and maintained by agents and adds the frontmatter a reader needs to judge machine-written
knowledge: provenance (`generated`), trust (`verified`), and an explicit bundle dialect
declaration. A repository that pins any of these profiles starts reporting deviations it never
reported before, and under `--profile-enforce` its checks go red.

This run requires a tool-capable local CLI provider such as `claude-cli` or `codex-cli`.

Treat any additional prompt supplied to `seihou agent run` as repository-specific guidance — for
example, a bundle to skip, a preferred check target, or a house actor identifier to use. Apply it
together with repository evidence, but do not let it weaken a profile or skip validation.

## Reference handling

Two references ship with this blueprint. If Seihou reports a readable reference directory, read
both before editing:

- `v0-2-migration-reference.md` is the authoritative per-profile change contract: what each profile
  now demands, the actor convention, the `sources` reshape, and the exact wording of every new
  diagnostic.
- `profile-pins.md` gives the v0.8.0 pinned-import line for each of the seven profile exports, to
  copy rather than compose when installing or repinning a local descriptor.

If the references are unavailable, stop before editing and report that the blueprint cannot safely
determine the profile contract. Do not reconstruct it from memory — the difference between the
profiles is exactly where a mistake silently damages a corpus.

## Working rules

Read every repository-local instruction file before editing. Preserve unrelated changes and work on
the current branch. Follow the repository's commit conventions, but do not commit or push unless the
operator explicitly asks.

If `mori.dhall` exists, run `mori show --full` before planning changes. Use Mori before guessing any
dependency or tool API. Never search `/nix/store` or traverse `/`; scope searches to the current
repository and exact paths Mori returns.

Do not invent provenance. Every `generated.by` and `generated.at` value must come from evidence in
the repository — the document's own frontmatter, or its Git history. Ask one focused question only
when the repository does not contain enough evidence to make a safe choice.

## Phase 1: Inventory the bundles and identify each one's profile

**If this repository has no profile-governed OKF bundle at all, report that the migration is not
applicable and finish successfully without creating anything.** Do not scaffold a bundle, do not
install a descriptor, do not write an index. This no-op behaviour is required because this
blueprint is invoked across repositories whether or not they use OKF.

Start with:

```bash
git status --short --branch
find . -name index.md -not -path './.git/*' | head -50
rg -l 'okf validate' --glob '!.git'
```

Determine which profile governs each bundle, using three sources of evidence in this order of
reliability:

1. **`mori.dhall`'s bundle declarations.** Run `mori show --full` and read the declared OKF
   bundles. This is the most reliable source because it is the repository's own statement of what
   it has.
2. **A local descriptor beside the bundle** — typically `<bundle>/profile.dhall`. Read its import
   and note which export it names:

   ```bash
   rg -n 'okf-profiles' --glob '*.dhall'
   ```

   An import ending `.documentation.architectureDecisions` governs an ADR bundle,
   `.coordination.useCases` a use-case bundle, and so on.
3. **A check script or CI target invoking `okf validate --profile`.** The `--profile` argument
   names the descriptor or the profile path:

   ```bash
   rg -n 'okf validate' --glob '!.git'
   ```

Record, for each bundle you find: its path, the profile export that governs it, the descriptor file
if there is one, and the command the repository already uses to check it.

**Separate inherited failures from the ones this migration creates.** Run each bundle's existing
check *before* editing anything and keep the output. Some advisories — most often
`missing profile-recommended field: reviews` — were failing under `--strict` before v0.8.0 and are
nothing to do with OKF v0.2. Do not manufacture content to silence them: inventing a review entry
for a document nobody reviewed is worse than the advisory. Report them separately at the end as
pre-existing deficiencies the operator may want to address, and treat the migration as complete
when the only remaining advisories are ones that were already there.

**If a bundle's governing profile cannot be determined, report it and leave it alone.** Migrating a
bundle against a guessed profile is worse than not migrating it: the five house-`status` profiles
and the two PostgreSQL profiles want opposite things from the `status` key, and applying the wrong
one silently destroys lifecycle information.

Run each bundle's existing check now and keep the output. You need to know which failures you
inherited before you change anything.

## Phase 2: Migrate each bundle

Work bundles in a fixed order — alphabetical by path — so the run is reproducible. For each, apply
the section below that matches its governing profile. `v0-2-migration-reference.md` carries the
same contract in table form; consult it whenever this prompt is less specific than you need.

### Every profile: the four shared changes

**1. Add `generated` to every concept.** A mapping with a required `by` and a recommended `at`:

```yaml
generated:
  by: human:nadeem
  at: "2026-07-26T00:00:00Z"
```

`by` must match OKF v0.2 §7's actor convention, case-sensitively — `human:<id>`, `process:<id>`, or
`<producer>/<version>`. A bare `nadeem` is rejected.

Derive both members from evidence, never from the current clock:

- **`at` comes from the document's existing `timestamp`.** That is precisely what `generated.at`
  supersedes, so reuse the value verbatim. Restamping to the current time destroys history and can
  break the `okf log` coverage gate, which now reads `generated.at` in preference to `timestamp`.
- **If a document has no `timestamp`**, use the last commit that meaningfully changed it:

  ```bash
  git log -1 --format=%cI -- <path>
  ```

  Convert to the `Z` form, preserving the instant.
- **`by` comes from authorship.** The Git author of the commit that created the file becomes
  `human:<id>`, using the identifier the repository already uses for that person elsewhere. A
  document that names the tool that generated it becomes `<producer>/<version>`. A description
  maintained by an automated process the repository runs becomes `process:<name>`. When the
  evidence is genuinely ambiguous, prefer the Git author over inventing a producer.

**Edit frontmatter key by key, not with a bulk textual substitution.** `timestamp:` is a substring
of `document_timestamp:`, which appears inside every entry of the house `reviews` family. A
search-and-replace that rewrites `timestamp:` into a `generated:` block will corrupt those entries
and produce a YAML parse error rather than a profile advisory:

```text
runtime-survey.md: invalid YAML frontmatter: YAML parse exception at line 17, column 2,
while parsing a block collection:
did not find expected '-' indicator
```

If you see that message, you damaged the file's structure — re-read it and repair it before
continuing. `last_modified` inside a `sources` entry and `reviewed_at` inside a `reviews` entry are
adjacent hazards.

**2. Keep `timestamp`.** It is demoted to each profile's `optional` list, not removed. A document
may keep it; its RFC3339-UTC format is still checked whenever it is present; its absence is never
reported, in any mode. **Do not delete `timestamp` from the corpus.** Stripping the key is
unnecessary churn on a large corpus and loses information wherever `generated.at` and `timestamp`
genuinely differ.

**3. Declare the bundle dialect.** Every migrated profile requires the bundle root to declare
`okf_version: "0.2"`. Without it you get a deviation that names no concept at all, which is easy to
misread as unrelated noise:

```text
profile: bundle does not declare okf_version; this profile requires 0.2 or later
```

The fix is one command per bundle:

```bash
okf index <bundle> --write --okf-version 0.2
```

It generates an `index.md` per directory and writes the declaration into the root one only. It
overwrites exactly what it generates, never deletes, and preserves an existing declaration on a
re-run, so it is safe to run repeatedly. It does **not** notice that a previously indexed file has
moved — if you relocate anything, delete the stale index and regenerate.

**4. `verified` is newly available and demanded nowhere.** It records independent confirmation that
the content is accurate — a list of `{by, at}` mappings, or one bare mapping, with `by` under the
same actor rule. Nothing fails if it is absent. This is an opportunity, not a task: add it only
where the repository has real evidence someone confirmed a document.

Where a corpus records approvals in a house `reviews` family — improvement requests, use cases, and
research documents all do — mirroring an approving entry into `verified` makes `okf trust` derive an
accurate tier instead of reporting the concept as unverified. Mirror faithfully: a **human** review
becomes `by: human:<id>`, a **model** review becomes `by: process:<agent>`. The `human:` prefix is
what distinguishes the human-reviewed trust tier from the machine-confirmed one, so mirroring a
model review under a human actor overstates the tier.

### `documentation.architectureDecisions`, `coordination.improvementRequests`, `coordination.useCases`

The four shared changes, and nothing else.

`generated` is **required** on these profiles, so a concept without it is a hard failure:

```text
profile: 0001-use-stable-identifiers: missing profile-required field: generated (§5.2. Who produced this decision record's current content, and when.)
```

For `coordination.useCases`, note that the requirement is declared at profile scope, so it applies
to `Use Case Theme` concepts under `themes/` exactly as it does to use cases. A theme carrying only
`type`, `title`, `description`, and `timestamp` fails.

One presence-class relaxation you may be able to take advantage of: `supersedes`, `supersededBy`,
and `originatingPlan` moved from `recommended` to `optional` on the ADR profile, and `targetPlan`
did on the improvement-request profile. If a local descriptor overrides those classifications, the
override is now redundant and can be deleted. Verify before deleting.

### `documentation.patternCatalog` and `documentation.researchDocuments`

The four shared changes, **plus a breaking change to `sources`.**

`sources` was a bare list of strings. It is now the OKF v0.2 list-of-records shape whose `resource`
member is required:

```yaml
# before
sources:
  - mori://example/runtime

# after
sources:
  - resource: mori://example/runtime
```

The existing string becomes the entry's `resource`. Optional members are `id`, `title`, `author`
(an actor), `usage_count` (an unquoted YAML integer, never a quoted string), and `last_modified` (a
calendar date). **Do not invent any of them.** If an entry carries an `id`, a body footnote with
that label must cite it under `--strict`.

The diagnostic names the list index and shows the offending value, so one validation run finds
every occurrence:

```text
profile: runtime-survey: frontmatter element at sources[0] must be a record, found: "mori://example/runtime"
```

`sources` and `supersedes` also moved from `recommended` to `optional` on both profiles, so a
corpus that omits them stops failing `--strict`. On `researchDocuments`, `relatedPlans` and
`relatedDecisions` moved too. `reviews` remains `recommended` on `researchDocuments`, so a research
record with no `reviews` block still fails `--strict` — deliberately.

### `postgresql` and `tanPostgresql`

The four shared changes, with two differences.

**`generated` is `recommended` here, not required.** A concept without it validates normally and is
only reported under `--strict`. These are the most permissive profiles in the catalog by design,
because a large database is documented incrementally and a partially-documented bundle is still
useful. For a database description the natural actor is usually `process:<sync-tool>` rather than a
person.

**`status` and `stale_after` are newly available — here and nowhere else.** These are the only two
profiles that adopt OKF v0.2 §5.4 `status` (`draft` / `stable` / `deprecated`) and §5.5
`stale_after` (a calendar date after which the description should be re-confirmed). Both are
optional; adopting them is a judgement call, not a migration requirement. `stale_after` is
genuinely useful on a database description, whose accuracy decays on a schedule whether or not
anyone edits the document.

## Phase 3: Repin descriptors and validate

If a bundle has a local descriptor pinning `okf-profiles`, move the pin to the v0.8.0 tag. Copy the
import line from `profile-pins.md` rather than composing it, then re-freeze the integrity hash:

```bash
dhall freeze <bundle>/profile.dhall
```

Never hand-write a `sha256:` value, and never delete the hash to make an import resolve.
(`--inplace` is deprecated as of dhall 1.42.3; freezing is in-place by default.)

Then run each bundle's own check. Use the repository's existing check target — a `just`, `make`, or
`npm` script wrapping `okf validate` — and fall back to the direct command only if none exists:

```bash
okf validate <bundle> --strict --profile <descriptor-or-profile-path> \
  --profile-enforce --log-enforce
```

A passing run reports the version declaration, which is how you know the bundle index took effect:

```text
OK: 12 concepts (okf_version 0.2)
```

If a bundle has a `log.md` and the check reports stale coverage — `generated date <date> has no
enclosing log.md` — append a dated entry describing this migration:

```bash
okf log add <bundle> --kind Migration -m "Move the bundle to OKF v0.2." --date <date>
```

## Do not

- **Do not rewrite house `status` values.** This is the single most damaging mistake available in
  this migration. `documentation.architectureDecisions`, `documentation.patternCatalog`,
  `documentation.researchDocuments`, `coordination.improvementRequests`, and
  `coordination.useCases` all use `status` for their own lifecycle vocabulary — `Accepted`,
  `current`, `active`, `proposed`, `validated`, and their siblings — and all five deliberately do
  **not** adopt OKF v0.2 §5.4's `draft` / `stable` / `deprecated`. The key name is shared; the
  meaning is not. Rewriting an ADR's `status: Accepted` to `status: stable` destroys the corpus's
  lifecycle information and breaks every downstream query, and nothing in v0.8.0 asks for it. Only
  `postgresql` and `tanPostgresql` take OKF's vocabulary, and only there is `status: stable`
  correct.
- **Do not delete `timestamp`.** It is demoted to `optional`, not removed.
- **Do not restamp `timestamp` or invent a `generated.at`.** Both come from the document's own
  history.
- **Do not touch a bundle whose governing profile you could not determine.** Report it instead.
- Do not weaken a profile to make a corpus pass. Do not move a field out of `required`, do not add
  `allowUnknownTypes = True`, and do not drop `--strict` or `--profile-enforce` from a check that
  already had it.
- Do not rewrite document prose. This migration touches frontmatter, bundle indexes, descriptors,
  and logs.
- Do not renumber documents or change any stable handle — `ADR-N`, `IR-N`, `UC-N`, `RES-N`. Those
  are the rename-stable identities other repositories cite.
- Do not add a `trust` key. A document's trust tier is computed from `verified` on every read and
  is never written into a bundle.
- Do not add `sources`, `usage_window`, `status`, or `stale_after` to a profile that does not
  declare them.

## Before you finish

Confirm every migrated bundle's check passes, and report:

- Every bundle you found, its governing profile, and how you determined it.
- Every bundle you left alone, and why.
- Every advisory that was already failing before you started, listed as pre-existing rather than
  mixed in with the migration's own work.
- How many concepts gained `generated`, and where the `by` and `at` values came from.
- Every `sources` entry you reshaped.
- Every descriptor you repinned and re-froze.
- Anything you could not resolve.

If the repository has an adopted `docs/adr` bundle installed by the
`adopt-architecture-decisions` blueprint, note that it has its own dedicated upgrade path:

```bash
seihou agent migrate adopt-architecture-decisions --from 0.7.0 --to 0.8.0
```

Either route produces the same result for that bundle. Say which one you used so the operator does
not run both.
