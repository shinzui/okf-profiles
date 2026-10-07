---
id: 11
slug: publish-the-platform-transitions-profile-and-adoption-blueprint
title: "Publish the platform transitions profile and adoption blueprint"
kind: exec-plan
created_at: 2026-10-07T05:09:59Z
intention: "intention_01m49takqfe6stqd5b14j7dqxb"
provenance:
  created_by:
    model: "gpt-6.1-sol"
    harness: "codex-cli"
    at: 2026-10-07T05:09:59Z
---

# Publish the platform transitions profile and adoption blueprint

This ExecPlan is a living document. Progress, Surprises & Discoveries, Decision Log,
and Outcomes & Retrospective are maintained while work proceeds.

## Purpose / Big Picture

Fulfil [IR-8](../improvement-requests/add-a-platform-transitions-profile.md) so an owner
can publish declared platform transition intent with stable TR-N handles and validate its
shape independently of runtime observations. This closes the external profile gate in
`mori://shinzui/mori/plans/294-decode-validate-and-query-declared-platform-transitions`
under `mori://shinzui/mori/masterplans/40-track-platform-transitions-and-explain-predecessor-retirement`.
The user explicitly authorized upstream work and pushes during that initiative.

## Progress

- [x] Descriptor and export encode all profile-expressible declaration rules; the shared
  four-transition consumer corpus is accepted and focused profile-level defects are rejected.
- [x] Documentation and adopt-transitions blueprint explain defaults, reference grammars,
  engine limits, safe no-op adoption and stable handle preservation.
- [x] Live prompt-guided TAN adoption, stable-handle rerun and no-intent no-op are retained.
- [x] The catalog passes its release checks and the profile is available at a tagged,
  hash-pinnable version; remote strict validation reproduces local results.

## Surprises & Discoveries

The profile engine is depth bounded. It can inspect list elements but cannot recursively
validate requirements[].owner.role/party or nested object lists. Mori's semantic gate owns
those checks. Regex slugs, reference ownership, list joins and exactly-one identity rules
also require Mori. OKF 0.2 rejects required timestamp rules, so generated is required
and timestamp is optional compatibility metadata. Existing unreleased runbooks work is already committed and must not
be reverted or silently treated as this feature.

## Decision Log

- Keep absent or empty requirements valid: no declared requirements means unknown readiness.
  Presence/cardinality checks are advisory unless --profile-enforce is selected.
- A release must obey ADR-7's blueprint version policy and pass the complete catalog checks.
  Publishing the descriptor alone does not prove that an adoption has runtime evidence.

## Outcomes & Retrospective

The profile and blueprint are implemented. `just check` passes for the complete catalog,
including all existing profiles, blueprint lint and registry version agreement, generated docs,
the standalone snapshot, four accepted transitions and 31 field-specific rejection cases.
The profile ships at v0.20.0 (commit 47e75a6). Strict remote validation accepts the four
concepts and its semantic hash equals the local source. The live adopter rehearsal passes in
`mori://tan/tan-platform/plans/19-adopt-platform-transitions-and-immutable-retirement-evidence`: the known
register publishes four strict-valid concepts, repetition preserves all handles and declaration
bytes, and a no-intent scratch project creates no transition. Its retained evidence is at
`mori://tan/tan-platform/docs/transition-evidence`. IR-8 is completed; all five criteria are established. The native agent-plans catalog
publishes this completed plan so its canonical targetPlan link resolves in Mori.

## Context and Orientation

Profiles live under profiles/coordination and the family package exports camelCase members.
The root package re-exports the family. Canonical schema types come from Profile/okf.dhall.
Read profiles/coordination/capabilities.dhall and pattern-applications.dhall for nested rules,
shared generated/review fields, conditional presence and stable handles. Source code for the
engine is located through Mori at `mori://shinzui/okf`, project-relative
okf-core/src/Okf/Profile.hs (source artifact URI pending). IR-8 contains the complete contract.

## Plan of Work

Add transitions.dhall with a Transition type at the bundle root, TR handles and exact
vocabularies. Required metadata uses the shared OKF 0.2 rules. Declare nested fields and
uniqueness where supported and document every delegated check in guidance. Add acceptance
and focused rejection fixtures, including optional omission and pending identities. Author
an adopt-transitions blueprint preserving existing handles and refusing to invent evidence.
Register discovery metadata, generate docs, run just check, and publish a tag only after
all release checks pass. Verify the remote descriptor over the consumer fixtures and record
its semantic hash in the owning Mori child plan.

## Concrete Steps

From this repository: dhall type --file package.dhall; bash scripts/test-transitions-profile.sh;
bash scripts/test-profile-docs.sh --regenerate; just check. Before commits, format Dhall with
dhall format and use Conventional Commits. Commit trailers use this plan's local path,
Intention intention_01m49takqfe6stqd5b14j7dqxb, and the canonical Mori MasterPlan URI.

## Validation and Acceptance

All IR-8 acceptance criteria are checked explicitly. Shared consumer fixtures must remain
byte identical: the profile consumes intent and never edits capability catalogs or DDD state.
Strict remote validation and a real hash establish the release gate; a local descriptor cannot.
AC-4 uses the released prompt in a guided live adopter rehearsal; no Seihou provider run is claimed.

## Idempotence and Recovery

Regeneration is deterministic. Adoption is a no-op without owner-backed transition intent
and preserves handles on repeated runs. Avoid force pushes and do not move existing tags.

## Artifacts

Local profile semantic hash: `sha256:7c5e94174d546260f9c583dbf168510773678665ab31aa73a8b7bdd3f61e03b9`.
The v0.20.0 candidate passed `just check` on 2026-10-07. IR-8 is completed after prompt-guided live adoption/no-intent/repeat rehearsal.
Blueprint lint alone was not treated as adoption proof. TAN retains the rehearsal artifact
and separate scratch comparison; real runtime readiness remains outside this release.

## Interfaces and Dependencies

New export coordination.transitions; new stable handle field transitionId with TR prefix;
new blueprint adopt-transitions. Uses the currently pinned OKF schema and requires no engine
or Mori schema change. Evidence envelopes and verdicts remain entirely Mori-owned.

Release evidence (2026-10-07): catalog package hash
`sha256:079a5b3679dccafd2070535b3d59a0ffdf28e20bf9cacfe095dca96c8012879a`;
selected transition profile hash
`sha256:7c5e94174d546260f9c583dbf168510773678665ab31aa73a8b7bdd3f61e03b9`.
Both were verified from the tagged remote import; no existing tag was moved.
