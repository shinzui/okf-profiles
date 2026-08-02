---
type: Architecture Decision Record
title: The OKF v0.2 field families are defined once in Profile/V02.dhall
description: One shared module owns the six v0.2 families; a consuming profile may reword a rule but never redefine its constraint.
docId: ADR-5
status: Accepted
date: 2026-08-01
generated:
  by: human:nadeem
  at: "2026-08-01T00:00:00Z"
---

# The OKF v0.2 field families are defined once in Profile/V02.dhall

## Context

Seven profiles adopted OKF v0.2 at once. Each needed some subset of the six v0.2
frontmatter families — `generated`, `verified`, `status`, `stale_after`,
`sources`, `usage_window` — plus the demoted `timestamp` rule. Writing them
per-profile would have produced seven independent descriptions of `generated`
that drift the first time one is corrected.

## Decision

**`Profile/V02.dhall` is the single definition of the v0.2 families for this
catalog.** It is exported from the root `package.dhall` as `v02`. A consuming
profile imports it and splices the named values into its own presence lists:

```dhall
let v02 = ../../Profile/V02.dhall

in  Profile::{ okfVersion = "0.2", frontmatter = FrontmatterRules::{
    , required = [ …, v02.generated ]
    , optional = [ v02.verified, v02.legacyTimestamp ]
    } }
```

**A consuming profile may reword a rule's `description` with the `//` operator.
It may not redefine the constraint.** If a shared value is wrong for one profile
it is wrong for all of them: fix it in the module and re-verify every consumer.

Which families a profile splices remains its own choice — that is a house
convention question, not a shared one. In particular the five profiles with a
house `status` key splice neither `status` nor `staleAfter`; see
[ADR-1](0001-house-status-diverges-from-okf-v0-2.md).

## Rationale

The families are format-level definitions with a specification section number
each. There is exactly one correct shape for `generated`, and it is okf's, not
this catalog's. Anything a profile genuinely needs to vary — presence class, and
whether the family is declared at all — is expressed at the splice site rather
than in the rule.

Descriptions are deliberately short in the module, because okf echoes a rule's
description back inside its missing-field diagnostic and a paragraph there
produces an unreadable error line. They are also worded to make sense in *any*
profile in this catalog, since all of them surface the same text.

The module was built and frozen before the three migration plans ran, precisely
so that all three consumed a fixed contract rather than negotiating one.

## Consequences

`Profile/V02.dhall` is a shared-ownership boundary. A change to it affects every
profile in the catalog and must be verified against every one — in practice, by
running all of `scripts/`.

The module also ships assembled as a standalone profile, exported as `okfV02`
(`profiles/okf-v0-2.dhall`), so a team with no house conventions can check that
its v0.2 frontmatter is well formed without adopting any of this catalog's
opinions. That export costs one small file and one fixture, and it means the
shared values are exercised as a profile and not only as fragments.

The module header carries the reasoning for the two catalog-wide policies that a
consuming profile author cannot infer from the code — the `status` collision and
the `reviews`/`verified` relationship. Those are now
[ADR-1](0001-house-status-diverges-from-okf-v0-2.md) and
[ADR-4](0004-reviews-and-verified-coexist.md); the header remains as the
point-of-use pointer.
