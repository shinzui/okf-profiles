---
type: Architecture Decision Record
title: A rejection fixture must fail for exactly one reason
description: A fixture that fails twice tests nothing, and a passing rejection loop is not evidence that any rule is load-bearing.
docId: ADR-9
status: Accepted
date: 2026-08-02
generated:
  by: openai-codex/gpt-5
  at: "2026-08-23T21:20:05Z"
---

# A rejection fixture must fail for exactly one reason

## Context

Every profile in this catalog is tested by a `scripts/test-*.sh` that validates
one acceptance bundle and then loops over a directory of invalid bundles,
asserting each is rejected under `--profile-enforce`. The loop only checks the
exit status.

Migrating the catalog to OKF v0.2 exposed three ways that design silently stops
testing anything. All three were found by accident, and all three left every
script green.

**A new fixture can trip a rule it was not written for.** The pattern catalog's
`Guide` type carries `pathPattern = "*/**"`. The first drafts of its v0.2
rejection fixtures put the concept at the bundle root, so each produced two
deviations — the intended one plus a path violation. The fixtures would have kept
passing with the v0.2 rule deleted from the profile.

**Adding a required field invalidates every existing rejection fixture at once.**
Making `generated` required meant all nine improvement-request and all five
use-case rejection fixtures — written for v0.1, carrying `timestamp` and no
`generated` — began failing for their own rule *and* for missing provenance.
`missing-jobs` and `missing-completed-at` would each have kept passing with the
rule they exist to test removed. Nobody edited those files; the profile change
did it.

**A rule with no fixture at all is invisible.** Sweeping every spliced v0.2 rule
by deleting it and re-running the script showed that `verified`,
`legacyTimestamp`, and `sources` were each untested in at least one profile. The
plans had budgeted two rejection fixtures per profile; twenty-seven were written.

## Decision

Two checks are mandatory whenever a profile in this catalog gains, loses, or
changes a rule.

**One: every rejection fixture reports exactly one advisory.** Run each one
*without* `--profile-enforce` and read the output. A passing rejection loop is
not evidence.

```bash
for d in fixtures/<profile>-invalid/*/; do
  echo "--- $(basename "$d")"
  okf validate "$d" --profile <profile> 2>&1 | grep '^profile: ' | grep -v 'advisory deviation'
done
```

**Two: sweep every rule for load-bearingness.** Delete each rule from the profile
in turn, confirm the script fails, and restore. The mechanical form is a loop
that restores a backup copy between iterations.

Both checks run over *pre-existing* fixtures, not only new ones.

## Rationale

The exit-status-only loop is the right shape — it is simple and it is what a
consumer's own CI looks like — but it answers "is this bundle rejected?" when the
question is "is this bundle rejected *by the rule it was written for?*". The two
diverge silently and often.

The sweep is the only check that finds a rule with no fixture, because such a
rule produces no failure to inspect.

## Consequences

A change that adds a `required` field to a profile must budget for rewriting
every rejection fixture in that profile's tree. The repair is mechanical —
`timestamp: X` becomes `generated: {by: human:nadeem, at: X}` — but it must be
done deliberately.

**Presence class decides whether this happens.** Making `generated` *required*
disturbed fourteen fixtures; making it *recommended* on the two PostgreSQL
profiles disturbed none, because a recommended field's absence is only reported
under `--strict` and no rejection loop passes it. This is the same trade-off
[ADR-8](0008-recommended-means-a-well-run-corpus-carries-it.md) governs, seen
from the test side.

**A sweep is only conclusive when exactly one rule governs the value under
test.** `resourceScheme` on the `PostgreSQL Table` type rule and the profile-wide
`resource` format rule express the same constraint over the same value, so
deleting either leaves `bad-resource-scheme` still rejected. Neither is
individually load-bearing, and "the script fails when I delete the rule" proves
nothing there. `requireSchemaSection` was swept the same way and is genuinely
load-bearing.

**A composite rule is swept as the authored policy unit.** A reference policy
may short-circuit through local-handle permission, scheme selection, and a
whole-value external pattern. Relaxing only an earlier member can expose the
next member and leave the fixture rejected for the same intended policy. The
negative control therefore removes the complete composite policy, while the
one-advisory inspection still proves which branch rejected each fixture.

A few fixtures deliberately fail for several reasons —
`fixtures/improvement-requests-invalid/invalid-policy` is a kitchen sink with
seven simultaneous violations, and a malformed identifier can trip both a format
rule and an ID rule. Those are fine as long as the multiplicity is intended and
the rules they cover are load-bearing somewhere.
