# Architecture-decision migration reference

The authoritative profile is `documentation.architectureDecisions` from `okf-profiles`. It permits
one flat concept type, `Architecture Decision Record`, under a bundle rooted at `docs/adr/`.

Every concept requires non-empty `type`, `title`, `docId`, `status`, and `date` frontmatter. The
strict repository check also requires OKF's `description` and `timestamp` authoring fields;
`timestamp` records the last meaningful revision while `date` preserves the original decision
date. Its
`docId` must have the strict form `ADR-N`: `N` is positive and has no leading zero. IDs are unique
within one bundle. Mori scopes the handle by project and bundle, producing a rename-stable reference
such as `mori://shinzui/mina/okf/adrs/concepts/ADR-4`.

Common legacy forms include `# ADR 0001: Title` or `# ADR 1 — Title`; bullet metadata such as
`- Status: Accepted`; plain `Status: Accepted`; and a `## Status` section whose first paragraph is
`Accepted — YYYY-MM-DD`. Treat these as evidence, not as a grammar that justifies global replacement.

OKF skips `index.md` and `log.md`. It does not reserve `README.md`, so a legacy index named README
must be renamed to `index.md` or it will be treated as a concept and fail the profile. The profile's
`*` path pattern requires ADR concepts at the bundle root.

When legacy ADR numbers collide, document IDs—not zero-padded filenames—are the enforced identity.
Preserve established human citations where possible, allocate a fresh handle when necessary, and
update ambiguous headings and incoming links together. Exact-ID lookup intentionally reports every
cross-project match; always store the full project-and-bundle-scoped Mori URI in another repository.

Registration-time Mori profile checks are advisory. Repository checks must therefore run:

```bash
okf validate docs/adr \
  --profile docs/adr/profile.dhall \
  --profile-enforce \
  --log-enforce
```

Preserve `log.md` when present and append a dated migration entry with `okf log add`. When no log
exists, that command creates the reserved file; its date must cover the concepts' last meaningful
revision timestamps.

Local plans and ADRs should keep repository-relative Markdown links. Cross-repository references
should use the handle-form URI returned by `mori registry concepts`, never a guessed URI or another
checkout's absolute filesystem path.
