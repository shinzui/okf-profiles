# How to update and package the profile reference

This guide shows you how to change a profile, preview its generated reference, and
package a fixed release of the reader. Start at the repository root on the existing
branch. You need Git, Just, Python 3.9+, Dhall, OKF 0.12.0.0, Seihou 0.15.0.0+, and
Nix with flakes. Browser acceptance also needs Chromium. The reader's locked Nix
shell supplies Bun and the JavaScript tools. `just docs` needs no Bun installation.

## Set up a checkout

Install the locked workspace dependencies and Chromium:

```bash
cd web && \
  nix develop -c bun install --frozen-lockfile && \
  nix develop -c bun x playwright install chromium
```

Return to the repository root before running the tasks below. If your local Bun
release-age policy rejects the pinned releases, verify those releases first.
**Workaround:** for this recipe's qualified dependency set, use
`nix develop -c bun install --frozen-lockfile --minimum-release-age 0` in `web/`.
The checked release metadata is in
[the implementation evidence](../plans/evidence/14/dependency-releases.json).

## Change a profile and preview the result

Edit the Dhall definition under `profiles/`; for example, edit field descriptions
in `profiles/coordination/features.dhall`. Then, from the repository root:

```bash
just docs && \
  python3 scripts/profile-docs-publication.py --check && \
  just docs-web-dev
```

Open Vite's printed local URL, choose Features, and open Feature. Search accepts
profile names, concept types, descriptions, and heading/field text such as
`acceptanceCriteria`. Section links preserve the rule's condition text.

`just docs` stages every inventory entry, validates each generated bundle, and
then replaces `docs/profiles/` and `publication.json`. It removes obsolete type
pages and whole profiles. Development reads the new selection on the next page
request; reload an already open page to see regenerated content. Stop Vite with
Ctrl-C when finished.

Commit the source, regenerated Markdown, and publication selection together.
Changes made directly to generated pages are overwritten by the next `just docs`.
The reader preserves the generator's Markdown and interprets bundle-root links
such as `/profile.md` within the source profile's declared bundle.

## Add or remove a profile

When changing the exports in `package.dhall`, update
`scripts/profile-docs-catalog.json` in the same change. Each record has the exact
`export` printed by OKF and a unique lowercase `directory` slug. Use the existing
records as examples. This inventory supplies generation, publication, export
labels, and catalog families.

Run `just docs`. The generator compares the inventory with
`okf profile list --no-local --registry ./package.dhall --json` and fails with the
missing/unknown exports if they disagree. Removing an export and its inventory
entry removes its old directory and selected URLs. Adding/removing a concept type
inside an existing profile needs only the source edit and regeneration.

Do not add unrelated documents to `publication.json` by hand. The publication
check accepts `CHANGELOG.md`, the two root pages and the flat `types/` pages in
inventoried bundles; it rejects symlinks and unexpected directories/files. The request-time reader
serves only the committed explicit selection.

## Write release notes the reader can attribute

The reader publishes `CHANGELOG.md` as a release timeline and adds a Changelog section
to a profile's page for each top-level bullet or paragraph that names its exact export
in backticks, such as `` `coordination.features` ``. Name the export when a note
concerns one profile. A note that does not name an export appears only in the full
changelog, and entries under `### Not included` are never attributed to a profile.

## Check the candidate

From the repository root:

```bash
just docs-web-build && \
  just check && \
  just docs-web-e2e && \
  git diff --check
```

`just check` includes Dhall and profile fixtures, Markdown/publication drift,
temporary-tree generation failure tests, and the reader's build, type, lint,
format, content, and corpus checks. Browser tests separately exercise all selected
pages, mobile/desktop navigation, both themes, field anchors, fonts, code copying,
and 404 boundaries. They use port 18714; isolated update fixtures use 18715–18717.
Keep those ports free. The isolated browser tests run real profile regeneration
several times and can take several minutes.

For production preview, from the root:

```bash
just docs-web-build && \
  bash -c 'export DOCS_CONTENT_ROOT="$PWD" DOCS_CONTENT_CONFIG=publication.json; cd web && nix develop -c bun run start'
```

Open `http://localhost:8080/`; `/healthz` returns `status: ok`. A source preview has
commit `unknown`. Set `PORT` when 8080 is occupied. Stop the server before running
another process on that port.

## Recover an interrupted regeneration

An ordinary generation or selection failure leaves the last good tree and manifest
in place. Correct the reported source/inventory problem and rerun `just docs`.

A forceful interruption during replacement can leave `docs/.profiles-last-good/`.
The generator refuses another replacement while it exists. Inspect it and the
current `docs/profiles/`, save any output you need outside those directories,
restore the last good directory if necessary, and remove the recovery directory
only after verifying your choice. Run `just docs` and the drift gate again.
Temporary staging directories have names `docs/.profile-docs-*`; they are ignored.

## Build a fixed content snapshot

From `web/`, create a fresh directory outside the checkout:

```bash
export DOCS_SNAPSHOT_PARENT="$(mktemp -d)" && \
  nix develop -c bun run snapshot "$DOCS_SNAPSHOT_PARENT/content"
```

The tool copies only selected documents/assets and writes normalized
`content.config.json` plus `content-inventory.json` with checksums and release
metadata. It refuses an existing output directory so removed pages cannot linger.
To inspect that fixed selection, set `DOCS_CONTENT_ROOT` to the new `content`
directory when starting the production server. Local snapshots report `unknown`
unless `DOCS_COMMIT` and `DOCS_COMMIT_DATE` were supplied. Nix records the committed
revision automatically.

Track all new source files before Nix builds; Git flakes omit untracked files.
From `web/`:

```bash
nix build .#docs-app .#docs-content && \
  nix build .#checks.aarch64-darwin.docs-smoke
```

Use `checks.aarch64-linux.docs-smoke` on an ARM Linux builder. `docs-app` contains
the bundled server and local fonts; `docs-content` contains the approved snapshot.
An installed server requires neither the source checkout, node_modules, OKF,
Dhall, nor Git. Content-only edits preserve the app and registry-cache derivations.
A packaged release changes only when you rebuild its snapshot/image and restart
with the new artifacts.

## Package and test Linux delivery

Commit a candidate before image creation. `web/` is a nested flake; use a clean
committed copy of the **whole repository** when building elsewhere. Dirty source
refuses an immutable image tag.

Prefer a local Apple Container Linux Nix builder on Apple Silicon. Use the
[delivery runbook](../../web/nagare/README.md) for the tested ARM64
build/export/import commands, native Linux alternatives, HTTP/browser acceptance,
and cleanup. Its offline Nagare check qualifies service `okf-profiles`, image
`okf-profiles-web`, namespace `personal`, hostname
`okf-profiles.labs.topagentnetwork.net`, port 8080, `/healthz`, and login protection.

## Update dependencies or the recipe

For a deliberate JavaScript dependency change, discover the dependency through
Mori, check its current registry release and upstream tags, and read its source
before changing APIs. Edit the appropriate `web/**/package.json`, then from `web/`:

```bash
nix develop -c bun install && \
  nix develop -c bun2nix -o bun-deps.nix
```

Commit `web/bun.lock` and `web/bun-deps.nix` together. Run the candidate checks and
Nix packages/smoke check again. Keep `web/flake.lock` on the shared toolchain
baseline unless deliberately updating that toolchain.

For a recipe update, from `web/`:

```bash
seihou update docs-microapp-labs --dry-run --json
```

Inspect the preview before applying the ordinary Seihou update. The recipe is
`mori://shinzui/seihou-modules/templates/docs-microapp-labs`, version 0.1.0 at
implementation. UI/content/config files are project-owned seeds: Seihou preserves
their edits and intentional deletions. Managed Nix helpers follow the recipe update
workflow; keep local overrides in `web/flake.module.nix`. Do not remove either the
root or nested `.seihou/manifest.json` to force initialization.

## Release or roll back an accepted image

The [delivery runbook](../../web/nagare/README.md) keeps image publication and
application deployment as separate operator reviews. Use the actual authorized
registry/context, preserve `git-<12 hex characters>` tags, and retain the accepted
image resource ID and original config/source revision. This repository's build
checks perform no live publication or deployment.

For rollback, select a previously accepted immutable image publication and its
original configuration revision, prepare the deployment review with that image
resource ID and unchanged tag, then apply through the authorized operator workflow.
Verify `/healthz`, an authorized profile read, and anonymous login protection after
the operator action. Git retains the corresponding profile and snapshot history.

The protected Labs deployment records Kansoku page visits under source service
`okf-profiles`, using the signed-in opaque user subject. Search text, query strings,
section fragments, referrer and UTM attribution are removed. Tracking uses memory
storage, respects Do Not Track and Global Privacy Control, and stops when identity
cannot be verified. Sessions, page leaves, Web Vitals and sanitized client errors are
also enabled. See [ADR-24](../adr/0024-reader-analytics-require-a-verified-subject.md)
and the [runtime configuration runbook](../../web/nagare/README.md#kansoku-analytics).
