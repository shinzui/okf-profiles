# Adopt a comprehensive project terminology catalog

Audit this project's vocabulary, then create or improve a controlled vocabulary governed by
`documentation.terminology`. The output should help developers who know the project's problem
domain but are new to its particular concepts, conventions, and guarantees. Comprehensive means
covering the concepts a reader needs across the project's supported surfaces, not cataloging every
symbol or reaching a target number of terms.

Use any additional operator instruction as audience, scope, naming, or categorization guidance.
Read repository instructions and the three shipped references before editing:

- `terminology-profile.dhall`: the exact released v0.17.0 selector;
- `authoring-reference.md`: the metadata and authoring contract;
- `coverage-review.md`: the audit rubric and acceptance scenarios.

If a reference is missing, report the missing artifact rather than guessing its contract. Confirm
`okf` 0.9.0.0 or later and the required local tools. Preserve unrelated edits, use the current
branch, and follow the project's existing formatter and verification conventions. Do not commit,
push, run another agent, or mutate a shared registry unless the operator authorizes that action.
Local manifest edits and validation are part of adoption.

## 1. Establish the baseline and audience

Inspect Git status, the README and getting-started route, public package/module/CLI inventories,
existing documentation navigation, existing terminology and DDD glossaries, and local check and
Mori declarations. Run existing relevant checks and distinguish inherited failures from new ones.
Do not absorb all of `docs/` into a new bundle or overwrite a different governing profile.

Use Mori to locate dependencies before guessing their APIs or meanings: `mori registry list`,
`mori registry search <name>`, `mori registry show <project> --full`, and
`mori registry docs <project>`. Read relevant sources at the returned paths. Scope filesystem
searches to known project roots; never traverse `/` or `/nix/store`. Use canonical `mori://` URIs
for all durable cross-repository references. Local terminology is authoritative for this project's
usage, not for the whole dependency ecosystem.

State the intended reader and assumed background. Use domain-experienced newcomers unless the
operator or repository establishes a different audience. Do not require the user to supply a term
list. An absent glossary is a reason to inspect source and guides, not a reason to stop.

## 2. Audit coverage before writing definitions

Build the evidence matrix described in `coverage-review.md`. Cover each applicable subsystem and
reader journey using public docs, runnable examples, exported interfaces, tests, and accepted
decisions. Follow evidence for confusing or consequential claims into implementation; exported
names alone do not establish semantics. Mark unimplemented plans and superseded decisions as such.

For every candidate record its preferred name, observed use, owning project, topic, existing
handle if any, likely reader confusion, and disposition: new term, improve existing, alias,
upstream reference, explained under another term, unresolved, or omit with reason. Seek omissions
independently of the existing catalog, including whole features missing from its index. Separate
familiar words with a project-specific meaning from genuinely new concepts.

Resolve synonyms by meaning, not similar spelling. Do not invent a distinction, deprecation,
discouraged name, abbreviation, or guarantee. If sources conflict, use current implementation and
supported documentation to investigate; report ambiguity when it remains. Continue with independent
well-supported terms. If no settled project vocabulary exists anywhere in the inspected evidence,
finish as a successful no-op: create no empty bundle, profile, manifest entry, or task. Report the
sources inspected and why none justified a term. Missing docs alone do not meet that condition.

## 3. Reconcile identities and install the profile

Use the established terminology bundle if compatible; otherwise prefer `docs/terminology/`.
Inventory its frontmatter, links, handles, aliases, and provenance before changing it. Preserve
valid handles and existing filenames; never renumber by alphabetical order, reuse a retired ID,
or merge distinct identities silently. Duplicate existing handles require resolution before editing
the affected records. A missing or broken local profile is not permission to erase its contract.

Install the shipped selector at the project's shared-selector location, defaulting to
`mori/terminology-profile.dhall`. Reuse an equivalent existing selector. Do not downgrade a newer
adoption or overwrite deliberate local extensions; inspect and validate its applicable contract.
The shipped version and semantic hash must agree. Type-check the installed selector.

List existing IDs with `okf id list <bundle> --profile <descriptor>` and allocate with
`okf id next <bundle> TERM --profile <descriptor>`. On first adoption use a deterministic filename
order; on later runs allocate above existing and known retired handles. Persist each allocation
before asking for the next, so repeated calls cannot issue the same unused ID.

## 4. Author terms for understanding and lookup

Write one root-level Markdown file per distinct concept, following `authoring-reference.md`.
Start with a one-sentence conceptual definition. Add a brief example or consequence and the
distinction most likely to confuse this audience. Put API types, storage layouts, SQL, and migration
history behind links or after the conceptual explanation when needed for precise usage. Define the
word; do not reproduce a guide or turn the glossary into a specification.

Explain the boundary of guarantees, especially retries, durability, consistency, validation, and
compatibility. Distinguish an operation running from its effects committing, payload decoding from
historical behavior, a versioned contract from physical data, and delivery timing from query waiting
when those distinctions apply. Never borrow these distinctions merely because the reference
adoption had them; confirm them in this project.

Make terms used to explain other terms discoverable. Introduce or link important supporting words;
avoid cycles of definitions that each require the other. Explain inherited vocabulary locally when
the project uses it in a distinctive way, and name the upstream owner. Use `sameAs` only for verified
equivalence to an actual external term URI. An upstream project link belongs in prose or a URI
anchor, not in `sameAs`.

Choose a small set of topic `tags` from the actual subsystem inventory. Apply consistent spelling
to existing and new terms; multiple topics are allowed. Use `scope` only for the context of meaning,
`broader` for genuine specialization, and `related` for association. Categories are not invented
parent terms. Preserve intentional existing classifications and explain any normalization.

Record truthful provenance for newly authored or substantially rewritten content. Preserve existing
provenance on unchanged prose and metadata-only reconciliation. Do not claim independent
verification for the authoring agent's own checks.

## 5. Integrate navigation, discovery, and maintenance

Maintain `index.md` with `okf_version: "0.2"`, a short audience/start-here introduction, and exactly
one entry per term containing its canonical name, link, and description. Prefer topic sections with
alphabetical entries inside each section. Tags remain the machine-readable classification; keep the
chosen primary navigation group deterministic when a term has multiple tags. Preserve useful
existing navigation. Do not overwrite grouped navigation with an unconditional `okf index --write`
task: the ordinary generated index may group every entry under its single `Term` type.

Add a concise dated entry to `log.md` for actual changes, using the repository convention and
covering the new content dates. Connect the catalog from the project's existing documentation
entry point and link explanatory occurrences in relevant existing terms. Do not rewrite unrelated
guides as part of adoption.

When `mori.dhall` exists, add or reconcile the terminology `OkfBundle`, descriptor path, OKF version,
and typed published profile binding as described in the reference. Inspect the project's pinned
schema before using optional fields; do not upgrade its entire schema as a side effect. Preserve
existing names and metadata. No shared registry write is required to edit or type-check the manifest.

Wire strict profile/log validation into the existing verification target. Use `mori terms validate
--path .` as an additional repository gate only after checking that the installed CLI supports it.
Do not add a command known to be unavailable and thereby break the project's aggregate check.
If no task runner exists, document the validation commands in the contributor entry point.

## 6. Validate structure, meaning, coverage, and repeatability

Run strict OKF validation, descriptor/manifest type checks, the available repository terminology
gate, and the native documentation target. Check term identities, local and external relationships,
anchors, Markdown links, and grouped index completeness separately where tooling does not cover
them. Report unresolved upstream term URIs separately from malformed ones; registry freshness can
limit resolution. Do not claim the profile alone validates all repository or registry semantics.

Perform two editorial passes: first accuracy against evidence, then comprehension for the stated
audience. Revisit the evidence matrix after authoring: every applicable subsystem and major journey
must have coverage or an explicit exclusion reason. Account for omitted and unresolved terms in
the report rather than quietly declaring the inventory complete.

Reconcile a second time against unchanged evidence and require no further edits: no IDs, timestamps,
log entries, classifications, index churn, manifest duplicates, or validation tasks. This can be a
local reconciliation pass; do not launch a second agent without authorization. If verification cannot
run, report the exact unavailable layer without overstating completeness or discarding finished work.

Finish with the audience, inspected surfaces, coverage by topic, new and retained ID ranges, notable
distinctions, unresolved candidates, profile/discovery integration, checks and limitations, and
repeatability evidence. Link the catalog and use canonical term URIs where applicable. Do not
claim that an exhaustive symbol list or a passing schema check proves comprehensive terminology.
