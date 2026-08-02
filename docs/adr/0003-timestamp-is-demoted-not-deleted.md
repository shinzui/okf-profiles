---
type: Architecture Decision Record
title: The superseded timestamp key is demoted to optional, not deleted
description: Keeping the rule in the optional list stops reporting its absence without stopping its format from being checked.
docId: ADR-3
status: Accepted
date: 2026-08-01
generated:
  by: human:nadeem
  at: "2026-08-01T00:00:00Z"
---

# The superseded timestamp key is demoted to optional, not deleted

## Context

OKF v0.2 §13.1 supersedes the v0.1 `timestamp` key with `generated.at`. Every
profile in this catalog demanded `timestamp` — five as required, two as
recommended — and
[a profile cannot declare `okfVersion = "0.2"` while it does](0002-a-profile-flips-to-okf-v0-2-atomically.md).
So each migrating profile had to either move the rule to `optional` or delete it.

okf reads `timestamp` whenever `generated` is absent, silently, with no removal
horizon. That is a deliberate upstream commitment, recorded as okf ADR 7
(`mori://shinzui/okf` at `docs/adr/7-okf-v0-1-legacy-fallback-policy.md`;
artifact-level URI pending).

## Decision

**Every migrated profile keeps a `timestamp` rule in its `optional` presence
list.** No profile deletes it. The shared value is `Profile/V02.dhall`'s
`legacyTimestamp`, so the wording and the format constraint are identical
everywhere.

## Rationale

`optional` is precisely the presence class for this case: the key is never
reported when absent, in any mode including `--strict`, while every constraint
the rule declares still applies whenever the key *is* present.

Deleting the rule would look equivalent and is not. It would let a malformed
legacy timestamp through unnoticed during exactly the window when corpora are
half-migrated and okf is still falling back to the key. A corpus in that state
would carry a `timestamp` that okf reads for log coverage and that no profile
checks.

The behaviour is not obvious from reading the profile, so it is tested directly
rather than assumed. Each migrated profile has a `bad-legacy-timestamp` rejection
fixture carrying valid `generated` provenance alongside a malformed `timestamp`:

```text
profile: <concept>: frontmatter value at timestamp must match format rfc3339-utc, found: "2026-07-26"
```

Those fixtures exist because a sweep found the demoted rule was otherwise
untested — the profile could have lost it with every test still green.

## Consequences

A consumer migrating a corpus keeps `timestamp` wherever they have it. Both
Seihou blueprints say so explicitly and list "do not delete `timestamp`" among
their prohibitions, because the instinct on reading "v0.2 retires `timestamp`" is
to strip the key everywhere. That would be unnecessary churn on a large corpus
and would lose information wherever `generated.at` and `timestamp` genuinely
differ.

The natural migration is `timestamp: X` → `generated: {by: <actor>, at: X}`,
reusing the same instant. Restamping to the current time destroys history and can
break the `okf log` coverage gate, which now reads `generated.at` in preference
to `timestamp`.

If okf ever announces a removal horizon for the fallback, this decision should be
revisited; nothing here assumes the rule is permanent.
