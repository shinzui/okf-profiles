---
id: 1
slug: move-the-profile-schema-pin-to-okf-0-5-0-0-and-widen-the-exported-descriptor-surface
title: "Move the profile schema pin to okf 0.5.0.0 and widen the exported descriptor surface"
kind: exec-plan
created_at: 2026-08-01T23:39:57Z
master_plan: "docs/masterplans/1-bring-okf-profiles-to-okf-v0-2-and-ship-bundle-migrations.md"
---

# Move the profile schema pin to okf 0.5.0.0 and widen the exported descriptor surface

This ExecPlan is a living document. The sections Progress, Surprises & Discoveries,
Decision Log, and Outcomes & Retrospective must be kept up to date as work proceeds.
If durable project context changes, update or create ADRs in docs/adr/ in the same change.


## Purpose / Big Picture

This repository publishes reusable **profiles**. A profile is a small Dhall file that
declares how a team uses the Open Knowledge Format (OKF): which `type:` values are allowed
in a documentation bundle, which frontmatter keys every document must carry, what shape each
key's value must have, and where each kind of document lives on disk. Another repository
imports one of these profiles by pinned URL and checks its own documentation with
`okf validate --profile`.

The *shape* of a profile — the Dhall record type it must match — is owned by the upstream
`okf` tool, not by this repository. This repository pins that shape at one exact upstream
commit, in a single file: `Profile/okf.dhall`. Today that pin points at okf **0.4.0.0**.
Upstream has since released **0.5.0.0**, which implements OKF v0.2 and adds five new pieces
of descriptor vocabulary that this repository literally cannot express while the pin stays
where it is.

After this plan, an author writing a profile in this repository (or importing this package
from another repository) can write a rule that says "this key's value must be a *mapping*
with these members", or "this key's value must name a real file in the bundle", or "this
key's value must be an OKF actor such as `human:nadeem`" — none of which is expressible
today. Nothing else changes: the same seven profiles exist, they behave identically, and
every existing check still passes. That "nothing else changes" is the point. This plan is the
gate that later plans build on, and its whole value lies in landing the pin move with a
provably empty behavioural diff.

You can see it working two ways. First, every one of the six scripts under `scripts/`
still prints its `OK:` line, exactly as before. Second, a small throwaway profile that uses
a v0.5.0.0-only feature — which fails to type-check before this change — loads and runs
after it.


## Progress

- [x] Confirm the environment: `okf v0.5.0.0` on `PATH`, `dhall` ≥ 1.42, and a clean git tree (2026-08-01)
- [x] Record the baseline: run all six `scripts/test-*.sh` and save their output (2026-08-01)
- [x] Update the commit reference in `Profile/okf.dhall` to okf `v0.5.0.0` (2026-08-01)
- [x] Re-freeze the integrity hash with `dhall freeze` (2026-08-01)
- [x] Type-check every Dhall file in the repository (2026-08-01)
- [x] Re-run all six `scripts/test-*.sh` and diff against the baseline — empty (2026-08-01)
- [x] Add `PathReferenceRule` and `FieldCondition` to the root `package.dhall` exports (2026-08-01)
- [x] Type-check `package.dhall` and confirm the new exports resolve (2026-08-01)
- [x] Prove the new vocabulary is reachable with the throwaway probe profile (2026-08-01)
- [x] Update the `Profile/okf.dhall` doc comment to name okf 0.5.0.0 (2026-08-01)
- [x] Update the `README.md` compatibility paragraph that names okf 0.4.0.0 (2026-08-01)
- [x] Commit with the required git trailers (2026-08-01)


## Surprises & Discoveries

- **The `Profile/okf.dhall` doc comment named no version number at all.** The plan's Progress
  item said to "update the two doc-comment references to the new version", but the comment only
  ever said "pinned to a specific okf commit" — the version lived solely in the URL's commit SHA,
  where no reader would recognise it. Rather than skip the item, the comment now names okf 0.5.0.0
  explicitly alongside the commit and lists the five descriptor features that release adds. Future
  pin bumps should keep that paragraph in step with the URL. Date: 2026-08-01

- **`dhall freeze --inplace` is deprecated in dhall 1.42.3.** The flag still works but prints
  `Warning: the flag "--inplace" is deprecated`; freezing is now in-place by default. The
  instruction inside `Profile/okf.dhall`'s doc comment told the next maintainer to use the
  deprecated form, so it was corrected to `dhall freeze Profile/okf.dhall`. Date: 2026-08-01

- **The stash-based comparison in Step 8 would not have proven what it claimed.** The plan
  suggested stashing the change and re-running the probe against the old schema. That does not
  work cleanly here: by that point `package.dhall` also references `okf.defaults.PathReferenceRule`,
  so stashing only `Profile/okf.dhall` fails on the *export* rather than on the probe's use of
  `objectFields`, and stashing both discards the work under test. Instead the old schema was
  imported directly by its original frozen URL and hash in three standalone one-line probes, each
  naming exactly one feature. All three failed with `Missing record field`, on
  `okf.mk.NestedFieldRule.actor`, `okf.mk.FieldRule.record`, and `okf.PathReferenceRule`
  respectively, while all three resolve under the new pin. This is a stronger proof than the
  stash approach and leaves the working tree untouched. Date: 2026-08-01

- **The pin move was behaviour-preserving exactly as predicted**, confirming the record-completion
  reasoning in Context and Orientation. The before/after diff across all six scripts was empty on
  the first attempt, with no field losing its default upstream and no workaround needed. This is
  the signal later plans depend on: they start from a verified-green baseline. Date: 2026-08-01


## Decision Log

- Decision: Pin by the commit that the `v0.5.0.0` tag points at
  (`2e34d3042f0a919ed4f2c9d2db5fb89a139e25ee`) rather than by the tag name.
  Rationale: The existing pin uses a raw commit SHA in the URL, and a commit SHA cannot be
  moved after the fact whereas a tag can. Keeping the established form also means the
  integrity hash and the URL move together as one reviewable unit.
  Date: 2026-08-01

- Decision: Prove the old schema lacks the v0.2 vocabulary by importing okf 0.4.0.0 directly in
  standalone probes, rather than by stashing the change as Step 8 suggested.
  Rationale: See Surprises & Discoveries. Stashing cannot isolate the schema from the export
  addition once both have landed, so it would have produced a misleading error. Importing the old
  frozen URL and hash directly tests one feature per probe and never disturbs the working tree.
  Date: 2026-08-01

- Decision: Leave the README's *Minimum `okf`* catalog column and the per-profile "0.4.0.0 binary"
  sentence at 0.4.0.0.
  Rationale: The plan directs this explicitly and it is the truthful reading — no profile under
  `profiles/` changed in this plan, so each still decodes with okf-core 0.4.0.0. Only the exported
  descriptor *vocabulary* moved to 0.5.0.0, which the rewritten Compatibility paragraph now states
  as a separate requirement. The migration plans raise the per-profile minimums when the profiles
  actually adopt v0.2 rules.
  Date: 2026-08-01


## Outcomes & Retrospective

Complete on 2026-08-01. All four acceptance criteria in Validation and Acceptance hold.

**What exists now that did not before.** `Profile/okf.dhall` pins okf 0.5.0.0 at commit
`2e34d3042f0a919ed4f2c9d2db5fb89a139e25ee` with the machine-computed hash
`sha256:02a821061043976b0ec0d60745a792f5f536e5f5d0db43bc990890ab0f5af0e3`. Running
`dhall freeze Profile/okf.dhall` a second time produces no diff, which is the proof the hash was
computed rather than typed. The root `package.dhall` exports `PathReferenceRule`
(as `okf.defaults.PathReferenceRule`) and `FieldCondition` (as the bare `okf.FieldCondition`),
matching the record laid out in Interfaces and Dependencies. A downstream author importing only
this package can now write `objectFields`, `path`, and `actor` rules.

**The empty behavioural diff held.** All six `scripts/test-*.sh` produce byte-identical output
before and after, and the type-check sweep is clean across `Profile/`, `profiles/`, and both
family packages. No file under `profiles/` or `fixtures/` was touched. The record-completion
argument in Context and Orientation was correct: every field okf 0.5.0.0 added carries an upstream
default, so no existing value broke.

**Verification worth reusing.** The three standalone probes described in Surprises & Discoveries
are the cheapest way to demonstrate that a pin bump actually delivers new vocabulary: import the
old frozen URL and hash directly and name one new field per probe. That pattern is reusable for
the next schema bump and does not require touching the working tree.

**What this unblocks.** EP-2
(`docs/plans/2-ship-the-shared-okf-v0-2-field-family-module-and-the-okfv02-reference-profile.md`)
can now build `Profile/V02.dhall` on `mk.FieldRule.record`, `mk.NestedFieldRule.actor`, and
`PathReferenceRule`, and add the `v02` and `okfV02` exports to the record this plan finalised.

**No ADR written.** This plan makes no durable architectural decision — it consumes a newer
version of a schema this repository already consumed, one-way, with no change to any boundary or
interface this repository owns. The durable constraints of this initiative (the
`okfVersion`/`timestamp`/`actor` triangle, the house-`status` divergence, and `reviews` versus
`verified`) belong to EP-2 through EP-5 and are collected by EP-7, which creates `docs/adr/`.


## Context and Orientation

### Where you are

The repository root is `/Users/shinzui/Keikaku/bokuno/okf-profiles`. Run every command from
there unless told otherwise. It is a git repository on branch `master`; commit directly to
it, do not create a feature branch.

There is no build system. The repository is Dhall source plus Markdown fixtures plus bash
test scripts. "Building" means type-checking Dhall; "testing" means running the scripts under
`scripts/`, each of which shells out to the `okf` binary.

### ADRs

`docs/adr/` does not exist in this repository and there is no ADR corpus of any kind. **No
local ADR applies to this work.** Creating that corpus is the job of
`docs/plans/7-release-okf-profiles-v0-8-0-and-dogfood-the-migrated-adr-profile.md`; do not
create it here.

One cross-repository decision is worth knowing, from the project that owns the schema you are
about to re-pin. `mori://shinzui/okf` records at `docs/adr/7-okf-v0-1-legacy-fallback-policy.md`
(artifact-level URI pending) that okf reads the older `timestamp` frontmatter key whenever
the newer `generated` key is absent, silently and with no removal horizon. That is why moving
the pin cannot break an existing corpus, and it is why this plan expects a zero-behaviour
diff. You do not need to read it to do this work.

### The file you are changing

`Profile/okf.dhall` is the **only** file in this repository containing a remote URL and a
`sha256:` integrity hash. Its entire contents today are a doc comment followed by one import:

```dhall
https://raw.githubusercontent.com/shinzui/okf/774379a09ba13d23a6b0747ae2078fd3b6d78c4d/okf-core/dhall/package.dhall
  sha256:4221ba7fc778aea894c8ef43e7309625a0bf565f59b14163bd16360d88e2bc0a
```

The commit `774379a09ba13d23a6b0747ae2078fd3b6d78c4d` is what okf's `v0.4.0.0` tag points at.
The target commit — what `v0.5.0.0` points at — is
`2e34d3042f0a919ed4f2c9d2db5fb89a139e25ee`. Both are confirmed present on the GitHub remote,
so the raw URL will resolve.

Four sibling files re-export pieces of that import and must **not** change:

- `Profile/Type.dhall` is `let okf = ./okf.dhall in okf.defaults.Profile`
- `Profile/TypeRule.dhall` is `let okf = ./okf.dhall in okf.defaults.TypeRule`
- `Profile/FrontmatterRules.dhall` is `let okf = ./okf.dhall in okf.defaults.FrontmatterRules`
- `Profile/ReviewRule.dhall` is a shared field rule value, not a schema re-export

Because they name only `defaults.*`, and because okf's 0.5.0.0 additions are all defaulted
fields, they keep working untouched.

### What "record completion" means and why this is safe

Dhall record fields are always required: adding even an optional field to a record *type*
breaks every existing *value* that omitted it. Dhall's answer is the completion operator
`::`. A schema is published as a record `{ Type, default }`, and `Profile::{ name = "x" }`
desugars to `(Profile.default // { name = "x" }) : Profile.Type`. A value therefore only ever
names the fields it cares about, and a new field added upstream **with a default** is absorbed
silently.

Every profile in `profiles/` is written with `Profile::{…}` and `TypeRule::{…}`. Every field
okf 0.5.0.0 added carries a default upstream. That is why this pin move is expected to be
behaviour-preserving — and why you must *verify* it rather than assume it.

### What okf 0.5.0.0 adds to the schema

Read `Profile/okf.dhall`'s resolved contents if you want the ground truth; a local checkout
of okf lives at `/Users/shinzui/Keikaku/bokuno/okf` and its schema source is under
`okf-core/dhall/`. The five additions that matter:

1. **`Profile.requireBundleVersion : Optional Text`**, defaulting to `None Text`. Setting it
   to `Some "0.2"` makes a bundle whose root `index.md` does not declare `okf_version: "0.2"`
   or later a profile deviation. Later plans use this; you only need it to exist.

2. **`FieldRule.objectFields : Optional NestedRules`**, defaulting to `None`. `elementFields`
   (which already existed) describes the record inside *each element of a list*.
   `objectFields` describes the record that *is* the value. OKF v0.2's `generated`,
   `usage_window`, `executor`, and `attester` keys are mappings, not lists, and were
   previously inexpressible. Declaring both accepts either spelling.

3. **`FieldRule.path : Optional PathReferenceRule`** and the new record type
   `PathReferenceRule = { externalUriSchemes : List Text, allowSelf : Bool }`. It declares
   that a key's value names a path or URI: an absolute URL with an allowed scheme, a
   bundle-relative path beginning with `/`, or a relative path resolved against the
   document's own directory. `NestedFieldRule` gained the same member.

4. **Five new `FieldFormat` alternatives**: `Actor`, `HumanActor`, `Integer`,
   `NonNegativeInteger`, and `Boolean`. `Actor` checks OKF v0.2 §7's convention — a value
   must be `<producer>/<version>`, `human:<id>`, or `process:<id>`. `HumanActor` accepts only
   the second. Adding an alternative to a Dhall union is *not* a breaking change for values
   that never mention it.

5. **A `mk/` constructor module**, already re-exported by this repository's root
   `package.dhall` as `mk`, which gained constructors including `field.record`,
   `field.recordOrList`, `field.bundlePath`, `field.actor`, `field.humanActor`,
   `field.integer`, `field.nonNegativeInteger`, and `field.boolean`.

### The export gap you are closing

The root `package.dhall` re-exports a hand-written list of schema names. Compare what it
exports against what okf's `package.dhall` publishes and two are missing:

- **`PathReferenceRule`** — needed by anyone writing a `path` rule, because the rule's value
  is `Some PathReferenceRule::{ externalUriSchemes = [ "https" ] }` and a downstream author
  importing only this package has no way to name that type.
- **`FieldCondition`** — the `{ field : Text, hasValue : List Text }` record used by `when`.
  Three profiles in this repository work around its absence by hand-writing a local
  `condition` helper or an inline record literal. It was missing before 0.5.0.0 too; closing
  the gap here is cheap and belongs with the pin move.

`NestedRules`, `NestedFieldRule`, `HandleReferenceRule`, `Cardinality`, `FieldFormat`,
`FieldRule`, `TypeRule`, `FrontmatterRules`, `Profile`, and `mk` are already exported and
need no change.

**Do not rename or remove an existing export.** A downstream repository pins this package by
URL; a renamed field fails at Dhall evaluation time in *their* build, not yours.


## Plan of Work

The work is one milestone with a verification step in the middle, because the pin move and
the export addition have different failure modes and you want to know which one broke
something.

### Milestone 1 — Move the pin, prove nothing changed

Scope: `Profile/okf.dhall` only. At the end of this milestone the repository consumes okf
0.5.0.0's schema and every existing check produces byte-identical output to what it produced
before.

Before touching anything, capture a baseline. Run all six scripts under `scripts/` and keep
their combined output in a scratch file. You need this to prove the diff is empty; do not
skip it and do not reconstruct it from memory.

Then edit `Profile/okf.dhall`. Replace the commit SHA in the URL —
`774379a09ba13d23a6b0747ae2078fd3b6d78c4d` becomes
`2e34d3042f0a919ed4f2c9d2db5fb89a139e25ee` — and leave the `sha256:` line in place for the
moment. The hash is now wrong, and that is expected: the next command fixes it.

Re-freeze with `dhall freeze --inplace Profile/okf.dhall`. This fetches the new URL, computes
its semantic hash, and rewrites the `sha256:` line. **Never hand-write a hash and never delete
the hash line to make an import resolve.** If `dhall freeze` cannot reach the network, stop
and report it rather than removing the integrity protection.

Also update the doc comment in that same file. It currently says the schema is "pinned to a
specific okf commit" and explains how to bump it; that prose stays, but any version number in
it must name 0.5.0.0.

Now verify. Type-check every Dhall file, then re-run all six scripts and diff against the
baseline. An empty diff is the acceptance criterion. If a script fails, the most likely cause
is a schema field that lost its default upstream — read the Dhall error, name the field, and
record it under Surprises & Discoveries before working around it.

### Milestone 2 — Widen the export surface

Scope: the root `package.dhall` only. At the end, `PathReferenceRule` and `FieldCondition`
are importable from this package, and a probe profile that uses a v0.5.0.0-only feature loads
and validates a bundle.

Add two fields to the record the root `package.dhall` returns, placing them next to the
existing schema-type exports rather than at the end, so the list reads in the same grouping
as okf's own `package.dhall`:

```dhall
, PathReferenceRule = okf.PathReferenceRule
, FieldCondition = okf.FieldCondition
```

Note that the existing exports come from two different places. `Profile`, `TypeRule`,
`FrontmatterRules`, `FieldRule`, `NestedRules`, `NestedFieldRule`, and `HandleReferenceRule`
are exported as `okf.defaults.X` — the `{ Type, default }` completion modules, which is what
a profile author writes. `Cardinality` and `FieldFormat` are exported as the bare union types
`okf.X`, because a union has no defaults. `PathReferenceRule` has a defaults module upstream
and `FieldCondition` does not, so export `okf.defaults.PathReferenceRule` and the bare
`okf.FieldCondition`. Check the resolved import before writing this — the local okf checkout
at `/Users/shinzui/Keikaku/bokuno/okf/okf-core/dhall/package.dhall` shows exactly which names
live under `defaults`.

Then prove the vocabulary is reachable end-to-end with a throwaway probe. Write a profile
outside the repository (use the scratch directory, not `profiles/`) that imports this
package and uses `objectFields` and the `actor` format, point `okf validate` at a two-file
bundle, and observe okf enforcing the rule. Delete the probe afterwards; it is proof, not a
deliverable.

Finally, update the paragraph in `README.md` under "Compatibility" that reads "The schema is
pinned to the `okf` 0.4.0.0 release commit. Every profile in this checkout uses 0.4 rules …
so the catalog must be decoded with okf-core 0.4.0.0 or later." Change the version numbers to
0.5.0.0 and say that the catalog now exports the v0.2 descriptor vocabulary. Do **not** touch
the "Profile catalog" table's *Minimum `okf`* column yet — the profiles themselves have not
moved, so 0.4.0.0 is still the truthful minimum for each of them. That column is updated by
the later migration plans.


## Concrete Steps

All commands run from `/Users/shinzui/Keikaku/bokuno/okf-profiles`.

**Step 1 — check the environment.**

```bash
okf --version
dhall --version
git status --short
```

Expect `okf v0.5.0.0 (2e34d30)` or later, `1.42.3` or later, and no output from `git status`.
If `okf` still reports `v0.4.0.0`, the global install has not finished; wait for it. Every
acceptance check in this plan depends on running the 0.5.0.0 binary.

**Step 2 — capture the baseline.**

```bash
mkdir -p /tmp/ep1 && for s in scripts/*.sh; do echo "--- $s"; bash "$s" 2>&1; done > /tmp/ep1/before.txt; cat /tmp/ep1/before.txt
```

Expected content, in this order:

```text
--- scripts/test-architecture-decisions-profile.sh
OK: 2 concepts
OK: architecture-decision profile acceptance and rejection fixtures
--- scripts/test-improvement-requests-profile.sh
OK: 2 concepts
OK: improvement-request profile acceptance and rejection fixtures
--- scripts/test-pattern-catalog-profile.sh
OK: 3 concepts
OK: pattern-catalog profile acceptance and rejection fixtures
--- scripts/test-research-documents-profile.sh
OK: 2 concepts
OK: research-document profile acceptance and rejection fixtures
--- scripts/test-tan-postgresql-profile.sh
OK: 2 concepts
OK: tan-postgresql profile acceptance and rejection fixtures
--- scripts/test-use-cases-profile.sh
OK: 2 concepts
OK: use-case profile acceptance and rejection fixtures
```

If any script fails *before* your change, stop and report it. You cannot prove an empty diff
against a red baseline.

**Step 3 — edit the pin.** Open `Profile/okf.dhall` and change the commit SHA in the URL, and
the version number in the doc comment. Leave the `sha256:` line alone.

**Step 4 — re-freeze the hash.**

```bash
dhall freeze --inplace Profile/okf.dhall
git diff Profile/okf.dhall
```

The diff must show exactly two changed content lines — the URL and the `sha256:` — plus the
doc-comment edit. If `dhall freeze` reports a hash mismatch or a fetch failure, do not
proceed; the network or the commit reference is wrong.

**Step 5 — type-check everything.**

```bash
dhall type --file package.dhall > /dev/null && echo "package OK"
for f in Profile/*.dhall profiles/*.dhall profiles/*/*.dhall; do
  dhall type --file "$f" > /dev/null || echo "FAILED: $f"
done; echo "type-check sweep done"
```

Every file must succeed. `profiles/coordination/package.dhall` and
`profiles/documentation/package.dhall` are records of profiles and type-check like the rest.

**Step 6 — re-run the scripts and diff.**

```bash
for s in scripts/*.sh; do echo "--- $s"; bash "$s" 2>&1; done > /tmp/ep1/after.txt
diff /tmp/ep1/before.txt /tmp/ep1/after.txt && echo "EMPTY DIFF — pin move is behaviour-preserving"
```

An empty diff is the milestone-1 acceptance criterion.

**Step 7 — add the two exports** to the root `package.dhall`, then re-type-check:

```bash
dhall type --file package.dhall > /dev/null && echo "package OK"
dhall <<< '(./package.dhall).PathReferenceRule.default'
dhall <<< '(./package.dhall).FieldCondition'
```

The first prints `{ allowSelf = False, externalUriSchemes = [] : List Text }` (field order may
vary). The second prints the record type `{ field : Text, hasValue : List Text }`.

**Step 8 — prove the new vocabulary works end-to-end.** Write the probe outside the
repository so it cannot be committed by accident. Substitute your scratch directory for
`$SCRATCH`:

```bash
SCRATCH=/tmp/ep1/probe; mkdir -p "$SCRATCH/bundle"
cat > "$SCRATCH/probe.dhall" <<'DHALL'
let P = /Users/shinzui/Keikaku/bokuno/okf-profiles/package.dhall

let field = P.mk.FieldRule

let nested = P.mk.NestedFieldRule

in  P.Profile::{
    , name = "ep1-probe"
    , okfVersion = "0.2"
    , frontmatter = P.FrontmatterRules::{
      , required =
        [ field.plain "type"
        , field.record
            "generated"
            P.NestedRules::{ required = [ nested.actor "by" ] }
        ]
      }
    }
DHALL
printf -- '---\ntype: Thing\ngenerated:\n  by: not-an-actor\n---\n\n# T\n' > "$SCRATCH/bundle/t.md"
okf validate "$SCRATCH/bundle" --profile "$SCRATCH/probe.dhall"
```

Expected — okf is enforcing an `objectFields` rule with the `actor` format, neither of which
exists in the 0.4.0.0 schema:

```text
profile: t: frontmatter value at generated.by must match format actor, found: "not-an-actor"
OK: 1 concepts
profile: 1 advisory deviation(s) (use --profile-enforce to fail)
```

Then confirm the same probe **fails to load** against the old schema, which is what proves
the pin move was necessary. Check out the previous `Profile/okf.dhall` into a temporary
worktree or simply `git stash` your change, re-run the probe, and observe a Dhall type error
naming `objectFields` as a missing field. Restore your change immediately afterwards with
`git stash pop`.

Delete the probe when done:

```bash
rm -rf /tmp/ep1/probe
```

**Step 9 — update the README** compatibility paragraph as described in Milestone 2.

**Step 10 — commit.**

```bash
git add Profile/okf.dhall package.dhall README.md
git commit -F - <<'MSG'
chore(schema): pin okf 0.5.0.0 and export the v0.2 descriptor vocabulary

Move Profile/okf.dhall from okf 0.4.0.0 to 0.5.0.0 and re-freeze the
integrity hash. Export PathReferenceRule and FieldCondition from the root
package, which okf publishes but this catalog did not re-export.

Every existing profile type-checks unchanged and all six profile test
scripts produce byte-identical output, because every field 0.5.0.0 added
is defaulted and every profile here is built with record completion.

MasterPlan: docs/masterplans/1-bring-okf-profiles-to-okf-v0-2-and-ship-bundle-migrations.md
ExecPlan: docs/plans/1-move-the-profile-schema-pin-to-okf-0-5-0-0-and-widen-the-exported-descriptor-surface.md
MSG
```


## Validation and Acceptance

This plan is complete when all four of the following hold.

**The pin is at 0.5.0.0 with a machine-computed hash.** `grep -n 'raw.githubusercontent' Profile/okf.dhall`
shows the URL containing `2e34d3042f0a919ed4f2c9d2db5fb89a139e25ee`, and
`dhall freeze --inplace Profile/okf.dhall` run a second time produces no diff — proving the
recorded hash is the one Dhall computes rather than one you typed.

**Nothing observable changed.** The diff between `/tmp/ep1/before.txt` and
`/tmp/ep1/after.txt` is empty, and the six scripts collectively print six `OK: … fixtures`
lines. This is the load-bearing check: later plans assume they start from a working baseline.

**The new vocabulary is reachable from this package alone.** The probe in Step 8 loads
without a Dhall error and produces the `must match format actor` advisory. A downstream author
can therefore write `objectFields`, `path`, and `actor` rules by importing only
`okf-profiles/package.dhall`.

**The type-check sweep is clean.** Step 5 prints `type-check sweep done` with no `FAILED:`
lines.

What you should **not** see: any change in the number of concepts a fixture bundle reports,
any new `profile:` advisory line, or any change to a file under `profiles/` or `fixtures/`.
If you do, the pin move was not behaviour-preserving and that is a discovery worth recording
in this plan and in the parent MasterPlan's Surprises & Discoveries section before you
proceed.


## Idempotence and Recovery

Every step here is safe to repeat. `dhall freeze --inplace` is idempotent: run against an
already-frozen import it recomputes the same hash and rewrites the same bytes. Type-checking
and the test scripts are read-only with respect to the repository — the scripts only invoke
`okf validate`, which never writes.

The whole change is two files plus a README paragraph, so recovery is
`git checkout -- Profile/okf.dhall package.dhall README.md` before committing, or
`git revert` after. There is no generated state, no cache to clear, and no database.

The one step that touches the network is `dhall freeze`. If it fails, Dhall leaves the file
as you edited it — URL updated, hash stale — which will not load. Either retry the freeze or
restore the file; do not "fix" it by deleting the hash, which would silently disable integrity
checking for every consumer of this repository.

If Step 8's stash-based comparison leaves you unsure of the working tree state, `git status`
and `git stash list` tell you the truth; the change is small enough to redo from scratch in a
minute.


## Interfaces and Dependencies

**Upstream, `okf` 0.5.0.0.** The binary must be on `PATH` for the test scripts and the probe.
The schema is consumed as a frozen remote import from
`https://raw.githubusercontent.com/shinzui/okf/2e34d3042f0a919ed4f2c9d2db5fb89a139e25ee/okf-core/dhall/package.dhall`.
A local read-only checkout is available at `/Users/shinzui/Keikaku/bokuno/okf` for reading the
schema source under `okf-core/dhall/`; never edit it, and never import from it in committed
code — the committed import must be the frozen URL.

**`dhall` CLI ≥ 1.42**, for `dhall type` and `dhall freeze`.

**No other plan may be in flight against `Profile/okf.dhall` or `package.dhall`.** This plan
owns both files for its duration.

At the end of this plan the following must be true of the root `package.dhall` record, and
later plans depend on it:

```dhall
{ Profile              -- okf.defaults.Profile      (unchanged)
, TypeRule             -- okf.defaults.TypeRule     (unchanged)
, FrontmatterRules     -- okf.defaults.FrontmatterRules (unchanged)
, FieldRule            -- okf.defaults.FieldRule    (unchanged)
, NestedRules          -- okf.defaults.NestedRules  (unchanged)
, NestedFieldRule      -- okf.defaults.NestedFieldRule (unchanged)
, HandleReferenceRule  -- okf.defaults.HandleReferenceRule (unchanged)
, PathReferenceRule    -- okf.defaults.PathReferenceRule  (NEW)
, FieldCondition       -- okf.FieldCondition        (NEW)
, Cardinality          -- okf.Cardinality           (unchanged)
, FieldFormat          -- okf.FieldFormat           (unchanged)
, mk                   -- okf.mk                    (unchanged)
, reviewRule           -- ./Profile/ReviewRule.dhall (unchanged)
, coordination         -- ./profiles/coordination/package.dhall (unchanged)
, documentation        -- ./profiles/documentation/package.dhall (unchanged)
, postgresql           -- ./profiles/postgresql.dhall (unchanged)
, tanPostgresql        -- ./profiles/tan-postgresql.dhall (unchanged)
}
```

The next plan,
`docs/plans/2-ship-the-shared-okf-v0-2-field-family-module-and-the-okfv02-reference-profile.md`,
adds two further exports (`v02` and `okfV02`) to this record and depends on `PathReferenceRule`
and `mk` being present. Do not add those two here.
