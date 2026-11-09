---
id: 14
slug: serve-generated-profile-documentation-with-the-seihou-labs-microapp
title: "Serve generated profile documentation with the Seihou Labs microapp"
kind: exec-plan
created_at: 2026-11-09T15:44:48Z
intention: "intention_01m70fs7znecdttjkh08q0pqs6"
provenance:
  created_by:
    model: "gpt-6.1-sol"
    harness: "codex-cli"
    at: 2026-11-09T15:44:48Z
  revisions:
    - model: "gpt-6.1-sol"
      harness: "codex-cli"
      at: 2026-11-09T15:49:20Z
      mode: "update"
      note: "Link the newly created personal Rei intention and finalize the reader, regeneration, and Labs configuration plan."
    - model: "gpt-6.1-sol"
      harness: "codex-cli"
      at: 2026-11-09T15:55:26Z
      mode: "implement"
      note: "Implement the generated profile reader, deterministic publication workflow, and packaged Labs delivery."
---

# Serve generated profile documentation with the Seihou Labs microapp

This ExecPlan is a living document. The sections Progress, Surprises & Discoveries,
Decision Log, and Outcomes & Retrospective must be kept up to date as work proceeds.
If durable project context changes, update or create ADRs in docs/adr/ in the same change.
Record friction met while implementing in the friction-log bundle as it occurs (see FRICTION.md).


## Purpose / Big Picture

Developers will browse every published OKF profile in a polished web reader: choose a
profile, understand its purpose, open a concept type, and find the fields and conditions
that apply to it. Search, profile-aware navigation, section links, readable typography,
and light/dark themes will make the long generated reference pages practical to use.

Bootstrap the app with Seihou's `docs-microapp-labs` recipe in `web/`. Keep Dhall profiles
as the authority and render the Markdown produced by `okf profile document`. A maintainer
will edit a profile, run `just docs`, preview the result, and rebuild a reproducible
content snapshot. The user explicitly chose regeneration and rebuilds as the update
workflow. Prepare protected Labs configuration for `okf-profiles.labs.topagentnetwork.net`
in namespace `personal`; this plan delivers the reader and deployable configuration,
while applying a live publication or deployment is a subsequent operator action.


## Progress

- [x] M1 (2026-11-09): Recipe 0.1.0 at upstream `d7688ba1f42448520d5fc9d28996fcff4f181508` reads the parent manifest. Production Chromium followed profile/type/back links in Features and Pattern Catalog; build, type/lint/format/content checks and 3 corpus tests (31 assertions) passed. Exact npm releases are recorded in `evidence/14/dependency-releases.json`.
- [x] M2 (2026-11-09): All 30 profiles / 61 concept types / 150 documents are reachable. Six production browser journeys passed catalog/404 coverage, keyboard field search, shared heading IDs, copied deep links/history, guidance, local fonts, mobile navigation, themes and focus. An isolated renderer journey also passed tables, nested lists, reference-style links and exact fenced-code copying. Screenshots in `evidence/14/` show 390px/1440px light/dark layouts; hierarchy, wrapping, contrast and focus are legible with no page-wide overflow.
- [ ] M3: One documented regeneration workflow updates Markdown and publication selection, detects drift, and removes stale profile/type pages from navigation, search, and routes.
- [ ] M4: The production build and content snapshot pass repository, browser, and Nix checks; protected Labs configuration and the maintainer update/runbook are verified.


## Surprises & Discoveries

2026-11-09: Regenerating with the installed OKF 0.12.0.0 adds explicit presence/timestamp/membership/unique-value summaries and object/element field-name policies to 91 existing pages. These are current producer bytes; they are retained without reader postprocessing. No source profile or generator version changed.

2026-11-09: Port 8080 is already occupied on this host. Browser acceptance uses an isolated port 18714; the delivered server and Labs configuration retain port 8080.


## Decision Log

2026-11-09: Bundle declarations carry each inventory export as optional `export` metadata so snapshots retain catalog family and export labels without needing the source inventory at runtime. The explicit selected document list remains authoritative. Development invalidates its parsed-corpus cache using the atomically replaced manifest; installed snapshots retain normalized `content.config.json`.

2026-11-09: Generate a nested `web/` workspace using
`mori://shinzui/seihou-modules/templates/docs-microapp-labs`. The root already owns
`README.md`, `justfile`, and Seihou state; nesting isolates the reader's toolchain and
recipe ownership while retaining one Git repository and one documentation source.

2026-11-09: Implement updates as profile edits followed by deterministic regeneration,
publication selection, and rebuild, as confirmed by the user. Generated Markdown remains
unaltered by the reader. Resolve OKF bundle-root links at render time using the source
document's declared bundle, and retain the reader's explicit publication boundaries.

2026-11-09: Use service `okf-profiles`, image repository `okf-profiles-web`, hostname
`okf-profiles.labs.topagentnetwork.net`, and namespace `personal`. The user requested
`okf-profiles` as the hostname and Product Management's namespace; the deployment
configuration in `mori://tan/tan-product-management`, project-relative
`web/apps/hub/nagare/Config.hs` (artifact-level URI pending), establishes `personal`
and the Labs hostname suffix. Keep the recipe's login protection.


## Outcomes & Retrospective

The reader and deterministic publication workflow are implemented. Host app/content Nix packages, host smoke and the offline Nagare Application check have passed. The full repository suite, real source-regeneration browser check, clean-checkout reproduction, and clean-commit Linux image acceptance are in progress. Durable publication/update context is recorded in [ADR-23](../adr/0023-generated-reference-crosses-an-explicit-publication-boundary.md).


## Context and Orientation

This repository publishes Dhall records that describe conventions for Markdown knowledge
documents. `package.dhall` exports those profiles; source definitions live in `profiles/`
and shared record types in `Profile/`. A bundle is a directory of knowledge documents
with an `index.md`. `okf profile document` generates a bundle describing a profile,
including its settings, field rules, and one page per concept type. Type pages already
merge profile-wide and type-specific rules; the reader must preserve their meaning.

`scripts/test-profile-docs.sh` currently contains 30 export/directory pairs. Its default
mode regenerates into a temporary directory, compares with `docs/profiles/`, and validates
the committed bundles. Its `--regenerate` mode rewrites those directories; root
`justfile` exposes that as `just docs`. At planning time there are 150 generated Markdown
files, including 61 type pages. Treat these counts as baseline evidence, not fixed limits.
`README.md`, under “Generated profile documentation,” explains the edit-source-and-regenerate
contract. Root `just check` runs Dhall type checks and all `scripts/test-*.sh` checks.
There is currently no web workspace or root Nix flake.

Representative inputs are `docs/profiles/features/profile.md`,
`docs/profiles/features/types/feature.md`, and `docs/profiles/pattern-catalog/types/pattern.md`.
Their frontmatter supplies `title`, `description`, `type`, and `generated.by`; they have
no `docId`. Use source paths as reader identities rather than inventing canonical concept
handles. Generated links such as `/types/feature.md` and `/profile.md` are relative to
the containing OKF bundle's root. Generated indexes also use ordinary relative links.

The recipe composes the reader, its shared Bun/Nix environment, and Nagare configuration.
Its canonical artifacts are
`mori://shinzui/seihou-modules/templates/docs-microapp-labs`,
`mori://shinzui/seihou-modules/templates/docs-microapp`, and
`mori://shinzui/seihou-modules/templates/nagare-docs-config`. Consult their READMEs after
locating the owning project with Mori. At planning time the registry is stale and cannot
resolve the new recipe URI, but the owning repository and upstream HEAD both contain
recipe version 0.1.0 at commit `d7688ba1f42448520d5fc9d28996fcff4f181508`. The URI is
still the intended canonical reference. `mori registry docs` currently lists no curated
docs for that project or `mori://shinzui/okf`; read their source directly.

The reader seeds `apps/docs/`, `packages/corpus/`, and `packages/ui/` within its workspace.
It uses Bun, TanStack Start, React Aria, Tailwind, and Pierre Highlights, renders Markdown
on the server, and supplies local fonts, themes, navigation, and code copying. Its
`content.config.json` explicitly selects documents and assets. “Snapshot” means an
immutable copy of that selection with a checksummed inventory and Git revision.
The request-time server invokes no OKF, Dhall, Mori, or Git subprocess.

The seeded `packages/corpus/src/links.ts` rejects every leading-slash link. This conflicts
with generated OKF links and must be exercised before polishing the full catalog.
The seeded heading renderer also gives IDs only to headings through level three;
type rule headings use level four, so field navigation needs a shared, complete heading
ID policy. Seeded search matches titles, descriptions, and identities; finding field
names in document bodies requires extending its search data.

Relevant local decisions are
[ADR-8](../adr/0008-recommended-means-a-well-run-corpus-carries-it.md), which distinguishes
required, recommended, and optional rules (recommended absence fails strict validation),
and [ADR-18](../adr/0018-guidance-carries-what-rules-and-descriptions-cannot.md), which keeps
guidance separate from enforceable rules and allows it to be absent. Preserve both
distinctions in the presentation. No existing local ADR selects a web reader or update
architecture. `docs/adr/profile.dhall` governs the local ADR bundle registered as `adrs`
in `mori.dhall`; follow the skill's ADR workflow when recording the implemented design.


## Plan of Work

### M1: Bootstrap and prove the generated-document path


Run the recipe in `web/` with the values below. Keep its own `.seihou/` state there and
retain the root manifest. Customize project-owned seeds; leave generated Nix helpers
managed. In `web/flake.module.nix`, set `docsMicroapp.contentSource = ../.;` and
`docsMicroapp.contentConfig = "publication.json";`. The manifest therefore lives at the
repository root and selects repository-relative paths. Retain the seeded local
`web/content.config.json` as a format-valid scaffold file, but make every app command,
test server, content tool, and Nix build use the root manifest.

Initially select the profile/index/type pages from `features` and `pattern-catalog` in
root `publication.json`, declaring one bundle for each directory. Set
`projectUri` to `mori://shinzui/okf-profiles` and `assets` to an empty list. Extend
`web/packages/corpus/src/links.ts` with a browser-safe link context carrying the source
bundle directory. In `web/packages/corpus/src/index.ts` and
`web/packages/corpus/src/types.ts`, pass that context to each document and its renderer
in `web/apps/docs/src/components/markdown.tsx`.

Resolve a single-leading-slash Markdown path inside the source's bundle, normalize it,
and look it up in the explicit document/asset map before returning its web URL. Preserve
fragments and the existing ordinary-relative-link behavior. Reject protocol-relative
URLs, traversal beyond the bundle, unsupported schemes, backslashes, and unpublished
targets. A missing bundle must not turn `/profile.md` into a site-wide match. Use one
resolver for rendered inline and reference-style links. Preserve the generated bytes.

Acceptance is a production browser journey: open Features, follow Feature, return via
the profile link, then repeat with Pattern Catalog and Pattern. Each link stays inside
the correct bundle. Add focused resolver tests for same-named files in different
bundles, relative/index links, fragments, and rejected paths. Run the reader's build,
checks, unit tests, and a browser smoke test against those real pages before M2.

### M2: Make the full reference catalog pleasant to read


Expand publication to the complete generated catalog, using the deterministic selection
generator described in M3. Replace the generic landing page in
`web/apps/docs/src/routes/index.tsx` with a catalog grouped by assurance, coordination,
documentation, format, and PostgreSQL. Show profile names, export paths, and source
descriptions with direct entry to their type pages. Derive the groups from export paths;
handle the three flat exports (`okfV02`, `postgresql`, `tanPostgresql`) explicitly.

In `web/apps/docs/src/components/shell.tsx`, provide a profile/type navigation tree,
active location, and breadcrumbs. Give repeated index titles profile context. Add
keyboard-operable search over profile names, type names, descriptions, and field names
extracted from headings. Return a profile-qualified result with its destination section;
keep full page bodies on the server. Search should find `acceptanceCriteria` in Feature
and distinguish common fields such as `generated` across profiles. Provide a clear
empty state and retain navigation when a query is cleared.

Create `web/apps/docs/src/components/table-of-contents.tsx` and a shared heading helper
under `web/packages/corpus/src/` for stable IDs through level six. Derive heading text
from Markdown structure, including inline code, and suffix repeated headings consistently.
Use exactly the same policy in rendered headings, the section list, and search results.
Provide copyable section links and browser back/forward behavior on deep URLs.

Refine `web/packages/ui/src/styles/globals.css` and the reader components into a calm
reference layout: warm neutral surfaces, one restrained accent, clear title/body/code
hierarchy, bounded reading width, generous paragraph spacing, and visible focus states.
Retain self-hosted Geist Serif and Paper Mono. Present settings, guidance, nested rule
lists, tables, and condition text without dropping information. Use a wide-screen section
rail and a small-screen section disclosure; allow long code/values to scroll locally.
Required/recommended/optional must remain visible in text as well as any styling.

Acceptance covers every catalog entry, a long type page, guidance in Designs, and the
type-free `okfV02` profile. Check 390px and 1440px widths in light and dark themes,
keyboard navigation and search, field anchors, unknown-page 404s, and exact fenced-code
copying. Save representative screenshots under `docs/plans/evidence/14/` and record a
brief human-readable assessment of hierarchy, wrapping, contrast, and focus visibility.

### M3: Make source-to-site updates repeatable


Extract the existing export/directory pairs into `scripts/profile-docs-catalog.json`,
with records containing `export` and `directory`. Refactor `scripts/test-profile-docs.sh`
to consume that inventory, and compare its export set with
`okf profile list --no-local --registry ./package.dhall --json` using that installed CLI's
actual JSON shape. A new package export missing from the inventory must fail with an
actionable message. This single inventory drives generation, profile labels, and selection.

Add `scripts/profile-docs-publication.py` with `--write` and `--check` modes. It produces
sorted root `publication.json` with schema version 1, canonical project URI, explicit
Markdown paths under each inventoried `docs/profiles/<directory>/`, a bundle declaration
per profile, and no assets. Check paths and reject unexpected directories or symlinks.
It may enumerate those approved generated bundle directories while producing the file;
the running reader consumes only that committed explicit selection. Its check mode
compares bytes and reports the regeneration command without writing.

Generate Markdown into staging first and replace the owned generated tree only after all
profile commands succeed. Removing an inventory entry or a type must remove its old
generated output as well as its manifest entry. Restrict replacement to `docs/profiles/`;
stage the publication file and replace it only after selection validates. Failures must
leave a recoverable last-good tree, and subsequent drift checks must fail until outputs
and manifest agree. Do not use filesystem links or copy generated Markdown into `web/`.

Extend root `just docs` to regenerate Markdown and publication selection. Add root
`docs-web-dev`, `docs-web-build`, `docs-web-check`, and `docs-web-e2e` tasks. They execute
within `web/` with an absolute `DOCS_CONTENT_ROOT` pointing to the repository root and
`DOCS_CONTENT_CONFIG=publication.json`. Make build validate selection first. Adjust
`web/package.json`, `web/playwright.config.ts`, and `web/scripts/content.ts` as necessary
so they honor those settings in development, production, validation, and snapshots.
In particular, Playwright's build/start subprocess must inherit the same content root.
Keep `just docs` usable with the existing OKF/Python toolchain without installing Bun.

Keep Markdown drift detection in `scripts/test-profile-docs.sh`; add publication drift
validation to that gate. Wire `docs-web-check` (build, type/lint/format checks, corpus
tests) into root `just check`. Run browser acceptance separately as `just docs-web-e2e`.
Add tests under `web/packages/corpus/tests/` and a temporary-tree Python test exposed by
`scripts/test-docs-publication.sh` for changed content, added/removed types and profiles,
determinism, missing inventory exports, and failed generation/selection. Adapt or replace
the scaffold's starter-content tests so the tests exercise this catalog.

Acceptance includes a temporary valid description change in
`profiles/coordination/features.dhall`: the drift gate fails before regeneration, `just docs`
updates the page, and the next page request in development shows the new text. Restore the
source edit and regenerate. In a temporary fixture, add and remove a type, refresh the
selection, and prove the removed URL becomes a 404 and disappears from navigation/search.
Running regeneration twice without source changes produces identical bytes. Production
uses a fixed snapshot; documenting rebuild/restart for an update is part of acceptance.

### M4: Verify production delivery and document maintenance


Build `web/`'s app and content packages, run the host's `docs-smoke` check, and exercise
the installed production server through the checks, without inspecting its store path.
From a clean committed revision, build/export the Linux image and run HTTP/browser
acceptance against that image. Prefer a local Apple Container Linux environment with
the required architecture and Nix; use a matching remote builder only if local capacity
is unavailable or unsuitable. An unavailable runtime is unfinished image acceptance.
Verify that selecting a snapshot does not require the source checkout or OKF/Dhall at
runtime, that `/healthz` reports the release commit, and local fonts load offline.

Keep `web/nagare/Config.hs` on the recipe's Application API and check it offline with
the recipe-qualified Nagare version. The hostname, namespace, service, image repository,
port 8080, `/healthz`, and login protection must agree with the recorded choices. Do not
copy Product Management's older Deployment API. Its configuration supplied the namespace
and hostname suffix only. Retain the generated two-stage publication/deployment runbook
and adapt paths to this nested workspace.

Write `docs/guides/profile-docs-web.md`, update the generated-documentation section of
`README.md`, and register the guide in `mori.dhall`. Explain clean setup, source edits,
regeneration, adding/removing profiles, preview, checks, snapshots, immutable image tags,
dependency lock updates, recipe updates, and rollback to an accepted prior release.
Distinguish ordinary content updates from Seihou template updates: UI/content/config
files are project-owned seeds, so `seihou update` preserves their edits and deletions;
managed Nix helpers use the update workflow. No edit to a generated page survives `just docs`.

Acceptance is a clean-checkout reproduction of the documented commands plus the full
repository and browser checks below, with concise evidence in this plan. Record an ADR
for the implemented source-to-reader boundary and update policy through the local ADR
profile, triage implementation friction, and complete the living sections.


## Concrete Steps

Run discovery from the repository root. Never search the filesystem root or Nix store.
Use Mori before consulting dependency APIs and recheck registry/tag releases before
selecting pins or compatibility changes.

```bash
mori registry list
mori registry search seihou
mori registry show shinzui/seihou-modules --full
mori registry docs shinzui/seihou-modules
mori registry search okf
mori registry show shinzui/okf --full
mori registry docs shinzui/okf
seihou --version
okf --version
okf profile list --no-local --registry ./package.dhall --json
```

As verified on 2026-11-09, installed Seihou is 0.15.0.0 and installed OKF is 0.12.0.0.
Hackage lists Seihou CLI 0.15.0.0 and OKF CLI 0.13.0.0 as the latest releases; their
upstream tags exist. The recipe requires Seihou 0.15+. This work does not require an OKF
upgrade: qualify the installed generator with the existing drift gate and avoid widening
the task into catalog/schema migration. Verify recipe source against upstream before
installation; retain the resolved source revision in the implementation evidence.

Bootstrap once from the repository root, then change into `web/`:

```bash
seihou install https://github.com/shinzui/seihou-modules.git --module docs-microapp-labs
mkdir -p web
cd web
seihou run docs-microapp-labs --no-save-prompted --no-commands \
  --var project.name=okf-profiles-web \
  --var project.description='Developer reference for the OKF profile catalog' \
  --var docs.site-name='OKF Profiles' \
  --var nagare.service-name=okf-profiles \
  --var nagare.domain=okf-profiles.labs.topagentnetwork.net \
  --var nagare.namespace=personal
nix develop -c bun install
nix develop -c bun2nix -o bun-deps.nix
```

Expected: `web/apps/docs/`, `web/packages/corpus/`, `web/packages/ui/`, Nix files,
`web/nagare/Config.hs`, and `web/.seihou/manifest.json` exist. Root `README.md`,
`justfile`, and `.seihou/manifest.json` retain their existing contents until deliberately
integrated. Verify the seeded JavaScript releases against npm and upstream tags before
accepting the generated locks; retain qualified recipe versions unless a demonstrated
compatibility issue requires a change. Commit `web/bun.lock` and `web/bun-deps.nix`
together. Build once before type checking because Vite generates the route tree.

After creating `publication.json`, the nested-flake override, and the M1 link adapter,
these commands run from `web/`:

```bash
DOCS_CONTENT_ROOT=.. DOCS_CONTENT_CONFIG=publication.json nix develop -c bun run build
DOCS_CONTENT_ROOT=.. DOCS_CONTENT_CONFIG=publication.json nix develop -c bun run check
DOCS_CONTENT_ROOT=.. DOCS_CONTENT_CONFIG=publication.json nix develop -c bun run test
DOCS_CONTENT_ROOT=.. DOCS_CONTENT_CONFIG=publication.json nix develop -c bun run start
```

Normalize the root environment to an absolute path in the app/tool wrappers before they
change working directories. Visit `http://localhost:8080/` and
`http://localhost:8080/docs/docs/profiles/features/profile`. The repeated `docs` is
intentional: `/docs/` is the reader route prefix and `docs/profiles/...` is the source path.

Once the root tasks exist, use these from the repository root:

```bash
just docs
python3 scripts/profile-docs-publication.py --check
bash scripts/test-profile-docs.sh
just docs-web-dev
```

`just docs` must report regeneration of all inventoried bundles and publication selection;
the check prints `OK: profile documentation is current and validates` and an explicit
publication-current result. Development serves the catalog on Vite's printed local URL.
Stop development before starting production/browser tests on the same port.

```bash
cd web
nix develop -c bun x playwright install chromium
cd ..
just docs-web-build
just check
just docs-web-e2e
git diff --check
```

From `web/`, with all generated files tracked, run the Nix acceptance commands. Nix's
Git source includes tracked files only. Image/tag acceptance additionally requires a clean
commit; commit directly to the current branch with this plan and intention trailers.

```bash
nix build .#docs-app .#docs-content
nix build .#checks.aarch64-darwin.docs-smoke
DOCS_IMAGE_TAG=git-000000000000 nix run github:shinzui/nagare/v0.16.2#nagarectl -- \
  app check --file nagare/Config.hs
nix eval --raw .#lib.docsImageTag
```

Use the host's corresponding `docs-smoke` attribute on Linux. The all-zero tag is a
syntax-valid offline-check fixture, never a publication tag. On native matching Linux,
from the clean checkout's `web/`, build and export with the recipe's documented transport:

```bash
nix build .#docs-image --out-link result-docs-image
export DOCS_IMAGE_TAG="$(nix eval --raw .#lib.docsImageTag)"
export DOCS_IMAGE_ARCHIVE="${TMPDIR:-/tmp}/okf-profiles-web-$DOCS_IMAGE_TAG.tar"
nix run .#docs-image.copyTo -- \
  "docker-archive:$DOCS_IMAGE_ARCHIVE:okf-profiles-web:$DOCS_IMAGE_TAG" \
  --tmpdir "${TMPDIR:-/tmp}"
```

An archive export is local packaging, not an image publication. Record the exact local
container import/run/browser commands used in the runbook after choosing the available
runtime. Keep archives, result links, browser reports, and review state ignored or outside
the checkout. No production operation is needed to accept the implementation.


## Validation and Acceptance

M1 must first prove the real OKF producer/reader interaction: root-absolute profile/type
links work within both Features and Pattern Catalog without rewriting Markdown, and
unapproved targets remain unavailable. Compilation alone cannot accept this milestone.

For M2, `just docs-web-e2e` must exercise the complete catalog, keyboard search, a result
for `acceptanceCriteria` landing on the correct Feature rule, an explicit no-results
state, mobile navigation, theme persistence, deep-link reload and browser history,
guidance, tables/nested lists, fenced-code copying, and a missing route returning 404.
Every generated document must be reachable from a profile page or navigation. Desktop
and mobile screenshots must show readable hierarchy with no page-wide horizontal overflow;
code and wide tables may scroll inside their own containers. Test the production server.

For M3, temporary-tree tests must demonstrate stale-output failures, source changes
appearing after regeneration, added/removed profiles and types changing selection, no
publication of unrelated repository documents, and failure without silently serving an
incomplete selection. After reverting the temporary source change, run `just docs` twice
and verify that the second run changes no generated byte. Removing a type must remove its
search/navigation entry and return 404 at its former route. With the dev server running,
a page request after successful regeneration must read the new corpus; production changes
take effect only after a new snapshot/build/restart.

For M4, `just check`, `just docs-web-e2e`, both Nix packages, the host smoke check,
offline Nagare check, and Linux image/browser checks must pass. Confirm the image's
`/healthz` commit matches the source commit, approved document and section routes work,
unpublished paths return 404, and font/code rendering works without external network
access. Keep acceptance evidence concise and mark unavailable required checks unfinished.
Validate any new ADR using `okf validate docs/adr --strict --profile docs/adr/profile.dhall
--profile-enforce --log-enforce`, maintaining its bundle log as required.


## Idempotence and Recovery

Use the existing Git repository and branch. Never rerun initialization by removing the
root or nested Seihou manifests. From `web/`, preview managed-template updates with
`seihou update docs-microapp-labs --dry-run --json`; apply the reviewed ordinary update
without changing project-owned seeds. Repeating `just docs` and publication generation
must be deterministic. Do not hand-fix a generated page or postprocess its links on disk.

Generation failures retain last-good outputs or a documented staging recovery path;
never delete source profiles or unrelated `docs/` content. Regenerate after restoring
source edits used for acceptance, and discard only known temporary fixtures. A deleted
generated type/profile must not survive a successful rebuild in publication selection.
Unknown or unpublished browser paths return 404 rather than falling back to another page.

Keep Bun and Nix dependency locks consistent. A failed build does not justify regenerating
unrelated locks or changing the shared Nix baseline. For delivery rollback, select a prior
accepted immutable image and its corresponding configuration/source revision using the
generated runbook; content history stays in Git. Before marking complete, record the
durable boundary/update decisions in a profile-valid ADR and triage any friction entries.


## Interfaces and Dependencies

This is a standalone ExecPlan with no prerequisite child plans. The generator interface
is `okf profile document --no-local --registry ./package.dhall <export> --out <directory>
--write --okf-version 0.2`, owned by `mori://shinzui/okf`. Its implementation is
project-relative `okf-core/src/Okf/Profile/Documentation.hs` (artifact-level URI pending).
Preserve deterministic output and the current omission of clock-derived timestamps.

`scripts/profile-docs-catalog.json` is the shared export/directory inventory. Root
`publication.json` is the reader's schema-version-1 manifest, with `projectUri`,
`documents`, `bundles`, and `assets`. Each bundle has a unique slug name and the
repository-relative `docs/profiles/<directory>` root. Keep selection explicit at runtime.
Do not add generated reference bundles to Mori's authored-concept bundles merely to
provide reader context, and do not invent `docId` values for generated pages.

In `web/packages/corpus/src/types.ts`, extend `Document` with the context needed for
bundle-root links and shared heading/search data. In
`web/apps/docs/src/server/reader.server.ts`, continue loading content through the
approved manifest and return bounded catalog/search summaries. In
`web/packages/corpus/src/links.ts`, keep resolution browser-safe and publication-scoped.
`web/apps/docs/src/components/markdown.tsx` and the section/search UI share heading IDs.
App wrappers consistently use `DOCS_CONTENT_ROOT` and `DOCS_CONTENT_CONFIG`; Nix uses
`docsMicroapp.contentSource` and `docsMicroapp.contentConfig` to select the same root.

The reader stack comes from the Seihou recipe; preserve its established UI primitives,
Markdown/code rendering, local font assets/licenses, and managed Nix packaging. Before
changing dependency APIs, discover the relevant sources with Mori; before accepting pins,
verify released versions with npm/Hackage and upstream tags. Nagare's recipe-qualified
offline checker is `mori://shinzui/nagare` v0.16.2; recheck that qualification and target
compatibility before any later live operation. The installed reader needs no database.

Every implementation commit must use Conventional Commits and carry:

```text
ExecPlan: docs/plans/14-serve-generated-profile-documentation-with-the-seihou-labs-microapp.md
Intention: intention_01m70fs7znecdttjkh08q0pqs6
```
