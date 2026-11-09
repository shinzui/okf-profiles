---
type: Architecture Decision Record
title: Generated reference crosses an explicit publication boundary
description: The web reader consumes selected generated Markdown through a committed manifest and ships immutable content snapshots independently of its application.
docId: ADR-23
status: Accepted
date: 2026-11-09
generated:
  by: codex-cli/gpt-6.1-sol
  at: "2026-11-09T16:10:32Z"
---

# Generated reference crosses an explicit publication boundary

## Context

Dhall profiles are the catalog's authority. OKF produces their reference bundles;
profile pages contain shared rules and each type page contains the effective merged
rules. A web reader must preserve this meaning, including guidance, required versus
recommended versus optional presence, and conditional rule text. Generated pages
lack stable concept handles, and their leading-slash Markdown links refer to their
own bundle root.

The reader is bootstrapped through
`mori://shinzui/seihou-modules/templates/docs-microapp-labs`. It lives in `web/` to
retain the root repository's existing toolchain and Seihou ownership. The app needs
selected content from its parent repository without publishing unrelated documents.

## Decision

Keep a single inventory at `scripts/profile-docs-catalog.json`. Compare its exports
with the installed OKF CLI, generate all bundles into staging, validate them, and
produce the explicit root `publication.json` before replacing owned output. Preserve
a recoverable prior directory through replacement. A successful generation removes
obsolete profile and type pages. Drift checks cover both Markdown and selection.
Python and OKF remain sufficient for regeneration; Bun is required only by the reader.

Consume generated Markdown without rewriting its bytes. Use source paths as identities.
Resolve leading-slash links within the source's declared bundle and then consult the
explicit selected-target map. Preserve fragments and ordinary relative links, and
reject unpublished targets, unsupported schemes, protocol-relative URLs and bundle-root
traversal. A missing bundle never permits a site-wide filename match.

Use one heading-text and duplicate-ID policy for all six Markdown heading levels,
rendered IDs, section links and field search. Send bounded catalog/search metadata;
keep the full collection's document bodies out of the navigation payload.

Development reloads its corpus after the atomically replaced manifest changes.
Production delivery uses a fixed, checksummed content snapshot, separate from the app
package and registry cache. The installed reader invokes no OKF, Dhall, Mori or Git
subprocess and needs no source checkout. Publish content changes by regenerating,
rebuilding, and restarting with a new immutable image. Image tags require a clean
Git revision. Keep image-publication and deployment reviews separate in the seeded
Nagare runbook, retaining login protection.

Project-owned UI/content/config seeds may be customized; recipe updates preserve edits
and deletions. Keep Nix helper updates managed and place project overrides in
`web/flake.module.nix`.

## Consequences

A profile change has one auditable source-to-site path: edit Dhall, run `just docs`,
review Markdown and selection, run checks, and rebuild. Removed URLs disappear from
navigation/search and return 404 after the next selection load or release. Content
edits can reuse the compiled application. Rollback chooses an accepted prior image
and its original configuration/source revision.

A selected bundle declaration supplies link context without implicitly publishing its
directory or inventing `docId` values. The generated bundles remain outside Mori's
authored-concept registrations. Selection is intentionally limited to generated
reference pages; publishing unrelated documentation requires a deliberate boundary
change. The maintainer workflow is in
[the web guide](../guides/profile-docs-web.md).
