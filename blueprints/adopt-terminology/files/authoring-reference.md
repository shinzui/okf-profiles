# Terminology authoring reference

The governing profile is `mori://shinzui/okf-profiles/profiles/terminology`, exported as
`documentation.terminology`. The shipped selector pins v0.17.0 and requires `okf` 0.9.0.0 or later.
Keep the profile intact: it describes a controlled vocabulary, not an ontology, API inventory,
capability catalog, or tutorial collection.

## Term shape

Required fields are `type: Term`, canonical `title`, one-sentence `description`, `generated`,
`termId: TERM-N`, and `status: current` or `deprecated`. A deprecated term additionally requires
scalar `replacedBy`, identifying the preferred term. One concept occupies one Markdown file at the
bundle root; `index.md` and `log.md` are reserved, not terms. Do not put concepts in topic folders:
the profile's `pathPattern` is `*`.

This fictional example illustrates the shape only. Its vocabulary, IDs, actor, date, and anchors
must not be copied into a real project without evidence:

```yaml
---
type: Term
title: delivery receipt
description: A durable record that a particular message has already been processed.
generated:
  by: process:example-author
  at: 2026-09-19T00:00:00Z
termId: TERM-8
status: current
tags: [delivery]
scope: message processing
related:
  - TERM-3
anchors:
  - kind: doc
    resource: docs/guides/message-delivery.md
---

# delivery receipt

A receipt lets a consumer recognize a redelivered message. For example, it can prevent a
repeated payment notification from crediting an account twice.

In this fictional service, the receipt and the database update commit together. An attempt
that rolls back can run again. See [Message delivery](../guides/message-delivery.md).
```

The main definition should answer what the concept means without requiring knowledge of a type
parameter, database table, filename convention, or historical ADR. A short example is often more
useful than implementation details. Explain unfamiliar words or link their terms. Put detailed
setup, performance policies, APIs, and migration instructions in the linked authoritative guide.
Retain a technical detail when omitting it would change the meaning or hide a consequential limit.

## Classification and relations

| Field | Supported meaning | Authoring rule |
|---|---|---|
| `tags` | Optional list of free classification tags | Derive consistent topic labels from this project; no fixed taxonomy is imposed by the profile. |
| `scope` | Optional scalar subsystem or bounded context | Qualifies where this meaning holds; it is not a second required category. |
| `aliases` | Optional list of synonyms with identical meaning | Keep one concept for equivalent local names. |
| `abbreviation` | Optional accepted short form | Include only observed usage. |
| `discouraged` | Optional list of wording not to use for this concept | Require evidence and explain the reason in prose; not a ban on that word in all contexts. |
| `broader` | Optional list of more general terms | Use specialization, not containment, ownership, or topic membership. Never author `narrower`; derive it inversely. |
| `related` | Optional list of associated terms | Use for concepts neither equivalent nor broader. |
| `replaces` | Optional list of terms this term succeeds | Keep the old term deprecated and its `replacedBy` consistent. |
| `sameAs` | Optional list of equivalent external term URIs | External only; a local equivalent is an alias. |
| `anchors` | Optional list of artifacts embodying the meaning | Prefer useful evidence; do not invent a code anchor to fill metadata. |

`broader`, `related`, `replaces`, and `replacedBy` use local `TERM-N` handles or canonical external
`mori://` concept URIs. `sameAs` requires the external term shape
`mori://<namespace>/<project>/okf/<bundle>/concepts/TERM-N`. A generic project or package URI is
not an equivalence relation. When the upstream term is not published, cite its canonical project
or most specific supported artifact URI in prose; if artifact-level addressing is pending, pair
the project URI with the project-relative path and state that limitation.

Each anchor has `kind` and `resource`, with optional `note`. Kinds are `module`, `type`, `function`,
`file`, `doc`, or `uri`. File/doc anchors are relative to the repository, whereas Markdown links
are relative to their containing page. Check both. Avoid relations to plans or capabilities merely
because their IDs look like term handles: those artifacts belong in prose or document anchors.

Tags, scopes, relations, aliases, and anchors are optional in the shared profile. This blueprint
chooses useful tags and evidence links as an editorial practice; it must not describe them as
required profile fields or introduce a local profile override to enforce that preference.

## Identity and provenance

Preserve existing valid IDs, including deprecated entries. Allocate `TERM-N` with positive,
unpadded numbers above all known allocations. Do not recycle a deleted handle or identify a new
concept with an old term's ID. A renamed word retains its ID only if the concept is the same;
succession between separate terms uses `replaces` and `replacedBy`.

`generated.by` identifies the producer of the current content: `human:<id>`, `process:<id>`, or
`<producer>/<version>`. Newly drafted definitions legitimately identify the current authoring
agent using a known actor and the actual UTC revision time. For untouched existing prose, preserve
valid provenance; for missing metadata, inspect Git and repository actor conventions. Do not
attribute an agent rewrite to a prior human author or restamp unchanged pages on every run. Ask
only when material provenance cannot be established. `verified` means an independent confirmation;
do not manufacture it from the author's own review.

## Installing and discovering the bundle

Install the shipped frozen selector at `mori/terminology-profile.dhall` unless the project has an
established equivalent location. Never replace its remote hash with a guess. The descriptor pins
the package hash:

```text
sha256:a947f6c753b6a41f33a5898de8dd25124037eb8420dcf4baf5822fbd43207bd1
```

When the project's pinned schema supports this shape, reconcile one entry in `mori.dhall`:

```dhall
Schema.OkfBundle::{
, name = "terminology"
, path = "docs/terminology"
, profile = Some "mori/terminology-profile.dhall"
, profileBinding = Some
    ( Schema.ProfileBinding.Published
        Schema.PinnedImport::{
        , publisher = "shinzui/okf-profiles"
        , publisherRef = Some
            Schema.MoriRef::{ namespace = "shinzui", name = "okf-profiles" }
        , export = Some "documentation.terminology"
        , version = Some "v0.17.0"
        , pin = Some
            "sha256:a947f6c753b6a41f33a5898de8dd25124037eb8420dcf4baf5822fbd43207bd1"
        }
    )
, okfVersion = "0.2"
, description = Some "Controlled project vocabulary"
}
```

Use Mori to find the schema and inspect its actual source before adopting the optional binding.
If unsupported, retain the `profile` path and report the missing publisher metadata; do not guess
fields or upgrade the schema incidentally. If the project has no manifest, adopt the OKF bundle
without inventing a namespace or adding a whole Mori setup. A discovered registered identity may
supply canonical term URIs; otherwise report that discovery integration is absent.

## Validation layers

Run these commands with the actual bundle and selector paths:

```bash
dhall type --file mori/terminology-profile.dhall
okf validate docs/terminology --strict \
  --profile mori/terminology-profile.dhall --profile-enforce --log-enforce
```

Type-check `mori.dhall` when present. Check `mori --help` for `terms` before wiring or running
`mori terms validate --path .`. An installed CLI can predate terminology support even when OKF
accepts the profile. Do not silently skip an already-required failing gate or claim all checks
passed; name the missing capability and what was verified independently.

Check the whole corpus for unique identities and preferred names, valid local references, broader
cycles, succession mirrors, false local equivalence, and contradictory discouraged wording. Resolve
external references with `mori path` when possible; distinguish unavailable registry data from an
invalid URI. Verify that referenced artifacts exist and that index entries exactly match all term
titles/descriptions. The profile validates metadata shape; it does not prove every repository-level
property or the factual correctness of definitions.

Preserve `okf_version: "0.2"` in the index. For a grouped index, regenerate/reconcile using the
same project-owned grouping policy and verify a second pass is unchanged. Do not run a stock
type-grouped index writer over curated topic groups. Record actual additions or edits in `log.md`
on a date covering their content revisions. A repeat run with unchanged evidence writes no log.
