# OKF v0.2 migration reference — okf-profiles v0.8.0

The authoritative contract for migrating a bundle governed by any okf-profiles profile from Open
Knowledge Format v0.1 to v0.2. Every diagnostic quoted here was produced by running the v0.8.0
profiles against a real unmigrated corpus; the wording is exact.

Requires `okf` 0.5.0.0 or later.

## The actor convention (OKF v0.2 §7)

`generated.by`, each `verified[].by`, and each `sources[].author` must match one of exactly three
shapes, case-sensitively:

| Shape | Example | Means |
|-------|---------|-------|
| `human:<id>` | `human:nadeem` | a person |
| `process:<id>` | `process:schema-sync` | an automated process |
| `<producer>/<version>` | `claude-code/2.1.0` | a named tool at a version |

Anything else is rejected:

```text
profile: <concept>: frontmatter value at generated.by must match format actor, found: "nadeem"
```

The `human:` prefix is not cosmetic. OKF §5.3 makes it the sole discriminator between the
machine-confirmed and human-reviewed trust tiers, so using it for a model's output overstates the
tier `okf trust` derives.

## What every profile now demands

### 1. `generated` — provenance (§5.2)

```yaml
generated:
  by: human:nadeem      # required, actor format
  at: "2026-07-26T00:00:00Z"   # recommended, RFC3339 UTC ending in Z
```

Required on five profiles, recommended on the two PostgreSQL profiles. The diagnostic when it is
absent from a profile that requires it:

```text
profile: 0001-use-stable-identifiers: missing profile-required field: generated (§5.2. Who produced this decision record's current content, and when.)
```

**`at` is not a new fact.** It is what the v0.1 `timestamp` key becomes. Reuse the document's
existing `timestamp` value verbatim. For a document with no `timestamp`, take
`git log -1 --format=%cI -- <path>` and convert to the `Z` form. Never use the current time for a
document you did not just write: `okf log` coverage now reads `generated.at` in preference to
`timestamp`, so restamping both destroys history and can break the log gate.

### 2. `timestamp` — demoted, not removed

Moved to every profile's `optional` presence class. Never reported when absent, in any mode, while
its RFC3339-UTC format is still checked whenever it is present:

```text
profile: <concept>: frontmatter value at timestamp must match format rfc3339-utc, found: "2026-07-26"
```

okf reads `timestamp` whenever `generated` is absent, silently and with no removal horizon, so an
unmigrated corpus keeps validating. **Keep the key.** Deleting it across a large corpus is churn
that loses information wherever the two values genuinely differ.

### 3. The bundle dialect declaration

All seven profiles set `requireBundleVersion = Some "0.2"`. A bundle whose root `index.md` does not
declare `okf_version: "0.2"` produces a deviation that names no concept:

```text
profile: bundle does not declare okf_version; this profile requires 0.2 or later
```

One command per bundle:

```bash
okf index <bundle> --write --okf-version 0.2
```

Generates an `index.md` per directory, writes the declaration into the **root one only**,
overwrites exactly what it generates, never deletes, and preserves an existing declaration on a
re-run. It does not notice that a previously indexed file has moved — delete a stale index and
regenerate if you relocate anything.

### 4. `verified` — trust (§5.2), optional everywhere

A list of mappings, or one bare mapping; both spellings are accepted and both are checked:

```yaml
verified:
  by: human:nadeem
  at: "2026-07-27T00:00:00Z"
```

Demanded by no profile. Never fails when absent. `by` is under the same actor rule:

```text
profile: <concept>: frontmatter value at verified[0].by must match format actor, found: "example-agent"
```

Do not add a `trust` key. A document's trust tier is computed from `verified` on every read and is
never written into a bundle.

## Per-profile change table

| Profile | `generated` | `sources` reshape | `status` / `stale_after` | Presence moves to `optional` |
|---------|-------------|-------------------|--------------------------|------------------------------|
| `documentation.architectureDecisions` | **required** | — | house `status` kept, no OKF `status` | `supersedes`, `supersededBy`, `originatingPlan` |
| `documentation.patternCatalog` | **required** | **yes** | house `status` kept, no OKF `status` | `sources`, `supersedes` |
| `documentation.researchDocuments` | **required** | **yes** | house `status` kept, no OKF `status` | `sources`, `supersedes`, `relatedPlans`, `relatedDecisions` |
| `coordination.improvementRequests` | **required** | — | house `status` kept, no OKF `status` | `targetPlan` |
| `coordination.useCases` | **required** | — | house `status` kept, no OKF `status` | none |
| `postgresql` | recommended | — | **OKF `status` and `stale_after` adopted** | `timestamp` (was recommended) |
| `tanPostgresql` | recommended | — | **OKF `status` and `stale_after` adopted** | `timestamp` (was recommended) |

Everything in the "presence moves" column is a pure relaxation: a corpus that omits those fields
stops failing `--strict`. If a local descriptor overrides one of those classifications, the
override is now redundant and can be deleted.

`reviews` remains `recommended` on `documentation.researchDocuments`,
`coordination.improvementRequests`, and `coordination.useCases`. A concept with no `reviews` block
still fails `--strict` on those three — deliberately, because a corpus that records no review
provenance at all is deficient.

## The `sources` reshape — `patternCatalog` and `researchDocuments` only

`sources` was a bare list of strings. OKF v0.2 §5.1 defines it as a list of records whose
`resource` member is required.

```yaml
# before — v0.1
sources:
  - mori://example/runtime

# after — v0.2
sources:
  - resource: mori://example/runtime
```

The existing string becomes the entry's `resource`. Optional members, none of which should be
invented:

| Member | Shape | Note |
|--------|-------|------|
| `id` | text | short label; if present, a body footnote with that label must cite it under `--strict` |
| `title` | text | human-readable name |
| `author` | actor | same three shapes as `generated.by` |
| `usage_count` | integer | an unquoted YAML integer, never `"40"` — okf does not coerce a quoted string |
| `last_modified` | date | `YYYY-MM-DD` |

The diagnostic names the list index and shows the offending value, so one validation run finds
every occurrence in a corpus:

```text
profile: runtime-survey: frontmatter element at sources[0] must be a record, found: "mori://example/runtime"
```

`usage_window` is a sibling of `sources`, not a member of it — it frames every entry's usage count
for the whole concept. No profile in this catalog declares it; do not add it.

## The `status` divergence — read this before touching any `status` key

Five profiles use `status` for a house lifecycle vocabulary that predates OKF v0.2 and collides
with §5.4's:

| Profile | House `status` values |
|---------|----------------------|
| `documentation.architectureDecisions` | repository-native, e.g. `Accepted` |
| `documentation.patternCatalog` | `current`, `deprecated` |
| `documentation.researchDocuments` | `active`, `complete`, `superseded` |
| `coordination.improvementRequests` | `proposed`, `accepted`, `in-progress`, `completed`, `rejected`, `withdrawn`, `superseded` |
| `coordination.useCases` | `draft`, `validated`, `planned`, `in-progress`, `delivered`, `retired` |

**All five keep their vocabulary and none of them declares OKF's `status` or `stale_after`.** This
is sanctioned rather than tolerated: a profile key name does not imply the OKF core key of that
name. The accepted consequence is that `okf trust` prints the house value verbatim as a status it
does not recognise. Renaming would break every consumer corpus, every cross-repository citation,
and every downstream query, for no conformance gain.

Note that `coordination.useCases` already allows `draft`, which overlaps OKF's vocabulary by
coincidence. Do not read that as partial conformance and do not extend the vocabulary toward OKF's.

Only `postgresql` and `tanPostgresql` adopt OKF v0.2's lifecycle family, because neither declares a
house `status` key and so neither has a collision. There the vocabulary is exactly
`draft` / `stable` / `deprecated`:

```text
profile: schemas/public/tables/orders: frontmatter value at status must be one of [draft, stable, deprecated], found: "current"
```

and `stale_after` is a calendar date:

```text
profile: schemas/public/tables/orders: frontmatter value at stale_after must match format date, found: "2027-13-45"
```

## `reviews` and `verified` coexist

`documentation.researchDocuments`, `coordination.improvementRequests`, and
`coordination.useCases` declare a house `reviews` family recording reviewer identity, review scope,
outcome, serving provider, model identifier, reasoning effort, and evidence context. OKF `verified`
records `by` and `at`.

Neither is a superset of the other, so neither replaces the other. Both are declared. A producer
that records an approving `reviews` entry should mirror it into `verified` so the derived trust
tier is accurate — otherwise `okf trust` reports every concept as `unverified` even where a human
approved it.

Mirror faithfully:

| `reviews` entry | `verified.by` |
|-----------------|---------------|
| `kind: human`, `reviewer: nadeem` | `human:nadeem` |
| `kind: model`, `reviewer: example-agent` | `process:example-agent` |

Do not mirror a model review under a `human:` actor.

## Validation

```bash
okf validate <bundle> --strict --profile <descriptor-or-profile-path> \
  --profile-enforce --log-enforce
```

A passing run reports the version declaration, which is how you know the bundle index took effect:

```text
OK: 12 concepts (okf_version 0.2)
```

If the log gate reports stale coverage — `generated date <date> has no enclosing log.md` — append a
dated entry:

```bash
okf log add <bundle> --kind Migration -m "Move the bundle to OKF v0.2." --date <date>
```

## Full unmigrated-corpus transcripts

What a consumer sees the first time they pull v0.8.0, per profile, before any repair.

`documentation.architectureDecisions`:

```text
profile: bundle does not declare okf_version; this profile requires 0.2 or later
profile: 0001-use-stable-identifiers: missing profile-required field: generated (§5.2. Who produced this decision record's current content, and when.)
profile: 0002-keep-local-links: missing profile-required field: generated (§5.2. Who produced this decision record's current content, and when.)
```

`documentation.patternCatalog`:

```text
profile: bundle does not declare okf_version; this profile requires 0.2 or later
profile: getting-started: missing profile-required field: generated (§5.2. Who produced this document's current content, and when.)
profile: runtime/overview: missing profile-required field: generated (§5.2. Who produced this document's current content, and when.)
profile: runtime/startup: missing profile-required field: generated (§5.2. Who produced this document's current content, and when.)
```

`documentation.researchDocuments`:

```text
profile: bundle does not declare okf_version; this profile requires 0.2 or later
profile: notes/alternative-evaluation: missing profile-required field: generated (§5.2. Who produced this research record's current content, and when.)
profile: notes/alternative-evaluation: missing profile-recommended field: reviews (Chronological human or model review provenance for this document revision.)
profile: runtime-survey: missing profile-required field: generated (§5.2. Who produced this research record's current content, and when.)
profile: runtime-survey: frontmatter element at sources[0] must be a record, found: "mori://example/runtime"
```

`coordination.improvementRequests`:

```text
profile: bundle does not declare okf_version; this profile requires 0.2 or later
profile: first: missing profile-required field: generated (§5.2. Who produced this request's current content, and when.)
profile: first: missing profile-recommended field: reviews (Chronological human or model review provenance for this document revision.)
profile: second: missing profile-required field: generated (§5.2. Who produced this request's current content, and when.)
```

`coordination.useCases`:

```text
profile: bundle does not declare okf_version; this profile requires 0.2 or later
profile: 001-investigate-alert: missing profile-required field: generated (§5.2. Who produced this use case or theme's current content, and when.)
profile: 001-investigate-alert: missing profile-recommended field: reviews (Chronological human or model review provenance for this document revision.)
profile: themes/operations: missing profile-required field: generated (§5.2. Who produced this use case or theme's current content, and when.)
profile: themes/operations: missing profile-recommended field: reviews (Chronological human or model review provenance for this document revision.)
```

`tanPostgresql` — note that `generated` appears as *recommended* here, and that core strict adds
its own `missing generated field (or legacy timestamp)` line above the profile section:

```text
schemas/public/tables/orders: missing recommended field: description
schemas/public/tables/orders: missing generated field (or legacy timestamp)
streams/order: missing recommended field: description
streams/order: missing generated field (or legacy timestamp)
profile: bundle does not declare okf_version; this profile requires 0.2 or later
profile: schemas/public/tables/orders: missing profile-recommended field: description (One or two sentences explaining the object's purpose.)
profile: schemas/public/tables/orders: missing profile-recommended field: generated (§5.2. Who or what produced this description, and when it was last confirmed accurate.)
profile: streams/order: missing profile-recommended field: description (One or two sentences explaining the object's purpose.)
profile: streams/order: missing profile-recommended field: generated (§5.2. Who or what produced this description, and when it was last confirmed accurate.)
profile: streams/order: missing profile-recommended field: resource (postgresql:// URI locating the live object.)
```
