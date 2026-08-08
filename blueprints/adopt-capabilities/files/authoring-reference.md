# Capability catalog authoring reference

The authoritative contract for a bundle governed by `coordination.capabilities`
(okf-profiles v0.9.0). Follow it exactly; do not reconstruct it from memory.

## Bundle layout

```text
docs/capabilities/
  profile.dhall     # the pinned descriptor shipped with this blueprint, verbatim
  index.md          # reserved: okf_version, what the repo provides, the record table
  log.md            # reserved: dated adoption entry
  <slug>.md         # one concept per capability
```

`index.md` and `log.md` are **reserved** OKF files and are not concepts. Concept files sit flat at
the bundle root; the `/concepts/` segment in a `mori://` URI is addressing grammar, not a directory.

## Concept frontmatter

```yaml
---
title: "Human-readable capability name"
type: Capability
description: "One sentence a consumer can evaluate without reading the body."
generated:
  by: <producer>/<version>        # your actor identity; NOT human:<id>
  at: "2026-08-08T00:00:00Z"      # RFC3339 UTC, ending in Z
capabilityId: CAP-1               # bundle-scoped, stable
provider: mori://<namespace>/<project>
status: shipped                   # shipped | deprecated | withdrawn
stability: stable                 # experimental | stable
since: "1.2.0"                    # release it arrived in, or "unreleased"
packages:
  - example-core                  # what a consumer depends on
interface:                        # recommended: entry points actually touched
  - Example.Module
requires:                         # optional: CAP-N handles or mori:// capability URIs
  - CAP-2
evidence:                         # required, at least one entry
  - kind: test                    # test | conformance | example | benchmark | module | guide
    resource: test/ExampleSpec.hs
    proves: What a reader learns by opening it.
---
```

### Field notes

| Field | Rule |
|---|---|
| `capabilityId` | Must match `CAP-<number>`. Unique within the bundle. |
| `provider` | Must be a `mori://` URI. Redundant inside one bundle, load-bearing once capabilities are aggregated across repositories. |
| `status` | Closed vocabulary. **There is no `planned`** — see below. |
| `stability` | Closed vocabulary: `experimental` or `stable`. Orthogonal to `status`. |
| `since` | Free text, but use the fixed vocabulary below — do not invent a spelling. |
| `packages` | List. What a consumer adds to depend on this. |
| `evidence[].kind` | Closed vocabulary: `test`, `conformance`, `example`, `benchmark`, `module`, `guide`. |
| `evidence[].resource` | **Not checked by okf.** A path rule resolves only within the bundle's concept tree, and capability evidence is repository-wide, so verify existence yourself. |
| `replacedBy` | **Required once `status` is `deprecated` or `withdrawn`.** List of `CAP-N` handles or `mori://` capability URIs. |
| `requires` | Optional. **Mirror each entry as a body link** or it produces no graph edge. |
| `reviews` | Profile-recommended. Machine-authored records will not have it; do not fabricate one. |
| `verified` | Optional. Only a human review that actually happened belongs here. |

## Why there is no `planned` status

The three coordination profiles form one triangle:

- a **use case** states what a consumer needs,
- a **capability** states what a producer provides,
- an **improvement request** states the gap between them.

A capability that does not exist yet is an improvement request. Allowing `planned` here would let
the catalog drift into a roadmap, and a roadmap that calls itself a capability catalog is worse than
no catalog — a consumer cannot tell which entries are real. Combined with required `evidence`, the
omission is what keeps every record checkable.

By the same logic, a claim that is only true when several repositories cooperate is not a capability
record. No single repository can assert or prove it. It belongs to the consuming repository as a
use-case feature.

## Granularity

> One capability is one thing a consumer can adopt **and** verify independently. Where two
> candidates always ship together and are proven by the same evidence, they are one capability.

Group by shared *mechanism*, not shared theme. Six catalog extensions that are each a typed loader,
a projection, and a query surface are one capability, because adopting the seventh is the same
decision again. Six subcommands of one feature are one capability, because nobody adopts the
subcommand without the feature.

Split when a consumer genuinely chooses one without the other, when the two arrived in different
releases, or when different evidence proves each.

## `since`

Derive it from release history. The profile cannot constrain the value — it is free text — so use
exactly one of these three spellings and **do not invent a fourth**. Two authors independently
inventing `undetermined` and a prose hedge for the same situation is what this vocabulary prevents:

| Value | Use when |
|---|---|
| `"1.2.0"` | The capability arrived in an identifiable release. Bare version, no commentary. |
| `unreleased` | It exists only on the default branch and is in no release. |
| `unknown` | Release history does not record it. **Explain in the record body why it could not be established** — that sentence is the point of the value. |

Never append commentary to a version (`"0.10.0 (reintroduced…)"`). `since` is the one field a
consumer compares mechanically across capabilities, and free-text decoration destroys that. Put the
history in the body.

## Capabilities that grew

Never move an older record's `since` forward, and never claim an early `since` for behavior that
arrived later. Both misinform a consumer pinning an older version. What remains is deciding whether
growth earns a new record, and there is one test:

> **Could a consumer pinned to the older release still do the thing this record describes?**
>
> - **No — the thing is impossible for them.** Split. The grown form takes its own record with the
>   later release as `since`, and `requires` the older one.
> - **Yes, just less well** — fewer checks, weaker guarantees, more manual work, narrower coverage.
>   Same record. Keep the original `since` and describe the evolution in the body.

Worked examples:

- Concurrent prefetch removed in one release and reintroduced in a later one → **split**. A consumer
  on the intervening release cannot prefetch at all.
- Four extra validation checks added to an existing validator → **same record**. A consumer on the
  earlier release still validates, just less thoroughly. Note it in the body.
- A capability that gains a second backend → **same record**, unless the backend is separately
  adoptable and separately evidenced, in which case it was always its own capability.

When the test is genuinely ambiguous, prefer the same record with a body note. An over-split catalog
reads as a changelog with handles; an under-split one loses information a body paragraph can carry.

## Mori declaration

Add to `mori.dhall`:

```dhall
, okfBundles =
  [ Schema.OkfBundle::{
    , name = "capabilities"
    , path = "docs/capabilities"
    , profile = Some "docs/capabilities/profile.dhall"
    , okfVersion = "0.2"
    , description = Some "What <project> provides today, one concept per capability, with evidence"
    }
  ]
```

`OkfBundle` requires a recent `mori-schema`. If the pinned schema lacks the field, `dhall type` will
report `Missing record field: OkfBundle` — upgrade the pin with `mori schema upgrade` before adding
the entry.

Registration makes the catalog queryable across every registered repository:

```bash
mori registry concepts --search "<term>"
mori path mori://<namespace>/<project>/okf/capabilities/concepts/CAP-1
```

## Validation

```bash
mori validate
okf validate docs/capabilities --profile docs/capabilities/profile.dhall \
  --profile-enforce --log-enforce
okf graph docs/capabilities
```

`okf graph` must show an edge for every `requires` entry. A missing edge means the requirement was
declared in frontmatter but not mirrored as a body link.

`--strict` additionally reports the recommended `reviews` family. For a machine-authored catalog
that is expected output, not a failure.
