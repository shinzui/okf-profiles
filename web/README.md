# docs-microapp

Version 0.1.0. Requires Seihou 0.15.0.0 or newer, Nix with flakes and Bun.
Generates a private Bun workspace with a TanStack Start documentation reader,
React Aria primitives configured for shadcn/ui `aria-nova`, Tailwind, and Pierre
Highlights. It renders Markdown on the server, supports navigation/search,
light/dark themes and exact fenced-source copying. Text uses Geist Serif;
code uses Paper Mono. Fonts are self-hosted and work offline.

```bash
seihou install https://github.com/shinzui/seihou-modules.git --module docs-microapp
seihou run docs-microapp --no-save-prompted --no-commands \
  --var project.name=handbook-web \
  --var project.description='Team documentation' \
  --var docs.site-name='Team Handbook'
nix develop -c bun install
nix develop -c bun2nix -o bun-deps.nix
nix develop -c bun run build
nix develop -c bun run check
nix develop -c bun run test
nix develop -c bun run start
```

Build once before checking types: Vite generates `apps/docs/src/routeTree.gen.ts`.
The production server listens on port 8080 by default. Visit `/`, or
`/docs/content/docs/index`. `/healthz` reports status and the snapshot's full
release commit; local unsnapshotted content reports `unknown`. `PORT` overrides
the listener. `bun run dev` starts Vite with the same reader. `bun run test:e2e`
builds/starts production and runs Chromium; install its browser explicitly with
`bun x playwright install chromium`. In a Bun environment with a release-age
policy, qualify the selected releases before overriding it; repository fixtures
use `bun install --minimum-release-age 0` with their fixed lock.

`apps/docs`, `packages/ui`, `packages/corpus`, root manifests/tasks, publication
configuration, starter content and font sources are project-owned seeds. Rerun,
update and removal preserve edits and intentional deletion. Nix helpers are managed;
put overrides in your own `flake.module.nix`. This scaffold disables the base's
starter outputs and pre-commit hooks and enables its pinned bun2nix helper.
It does not generate Nagare configuration; use the `docs-microapp-labs` recipe
for that composition.

## Publish selected documents

Edit the seeded `content.config.json`. Its versioned schema lists every approved
Markdown file and asset relative to one content root; bundle declarations never
implicitly publish a directory:

```json
{
  "schemaVersion": 1,
  "projectUri": "mori://example/handbook",
  "documents": ["docs/guide.md", "docs/decisions/one.md"],
  "bundles": [{"name": "decisions", "directory": "docs/decisions"}],
  "assets": ["docs/diagram.svg"]
}
```

Ordinary Markdown works without frontmatter. YAML `title`, `description` and
other scalar details appear in the reader. A bundle document with `docId: ADR-1`
has identity `mori://example/handbook/okf/decisions/concepts/ADR-1`. Handles in
separate bundles stay distinct. Without an explicit canonical project, identities
use source paths. `index.md` and `log.md` remain ordinary selected documents.
Only YAML frontmatter is supported. Raw HTML is disabled; source tokens render
as React text. Source-relative links (including Markdown reference links) retain
anchors and resolve only to approved documents/assets. Missing documents return
404. Traversal, duplicate identities and symlinks outside the root fail validation.
Snapshots require regular selected files; use real files instead of symlinks.

Run `bun run validate-content` after editing selection. The reader invokes no
Mori, OKF, Dhall or Git subprocess at request time. Assets are served only under
`/published/<selected-path>`. Treat selected assets as public site content.

For a nested `web/` workspace in a Git repository, keep a publication manifest
at the repository root (for example `publication.json`) and use this unmanaged
`web/flake.module.nix`:

```nix
{ ... }: {
  docsMicroapp.contentSource = ../.;
  docsMicroapp.contentConfig = "publication.json";
}
```

Its document paths are relative to that parent repository. This override is tested
with a real subdirectory Git flake and sandbox snapshot/server checks. For local
commands from `web/`, use the same root and manifest:

```bash
DOCS_CONTENT_ROOT=.. DOCS_CONTENT_CONFIG=publication.json bun run dev
DOCS_CONTENT_ROOT=.. DOCS_CONTENT_CONFIG=publication.json bun run start
```

Nix normalizes the snapshot manifest to `content.config.json`; an installed
server uses `DOCS_CONTENT_ROOT` to select that snapshot. `bun run snapshot` also
copies the explicit selection and emits a checksummed inventory, useful for local
verification. Pick a fresh output directory when regenerating local snapshots.

## Fonts and release provenance

`apps/docs/public/fonts/font-sources.json` records the immutable release commits,
original paths, SHA-256 and verified axes. Geist Serif Regular is static, from
`mori://vercel/geist-font` v1.9.2; Paper Mono is variable weight 100..800, from
`mori://paper-design/paper-mono` v1.000. Artifact-level URIs are pending; original
paths in the manifest are relative to those canonical projects. Original copyright
and SIL Open Font License files accompany both families.

Seihou 0.15's copy path decodes text and cannot seed WOFF2 bytes. The consumer
therefore owns base64 representations and their manifest. The Vite plugin verifies
checksums, decodes locally and emits the original `/fonts/*.woff2` bytes. To change
a font, replace the base64 bytes and checksum and adjust CSS/axes deliberately.
No font CDN, private checkout, install hook or first-start download is involved.
The module's source also retains the original WOFF2 release assets for audit.

The qualified direct dependency set includes Start 1.169.5, Router 1.170.46,
React 19.3.1, React Aria Components 1.22.1, Vite 8.3.7 and Highlights 0.5.0.
The test fixture retains the complete Bun lock and generated dependency expression.
Dependency ownership is `mori://TanStack/router`, `mori://adobe/react-spectrum`,
`mori://shadcn-ui/ui` and `mori://pierrecomputer/pierre/packages/@pierre/highlights`.

## Nix packages and images

Commit the generated sources, manifest, fonts, `bun.lock` and `bun-deps.nix` before
publication. Lock generation is explicit; a Seihou rerun never installs or rewrites
locks. Update both lock files together after deliberate dependency changes.
The base's canonical `flake.lock` and toolchain stay shared.

```bash
nix build .#docs-app .#docs-content
nix build .#checks.aarch64-darwin.docs-smoke
nix build .#packages.x86_64-linux.docs-image --out-link result-docs-image
nix eval --raw .#lib.docsImageTag
```

Choose the host system's smoke attribute on Linux. `docs-app` contains the bundled
Bun server, client assets and fonts; `docs-content` contains only selected content,
a normalized manifest and checksummed release inventory. `docs-image` exists only
on Linux and requires a native matching builder. Tags are `git-<12 hex characters>`;
a dirty/uncommitted source refuses a publication tag. App/development builds still
work on dirty source. The installed server needs no `node_modules` or source tree.
Content-only edits preserve the app and registry-cache derivations; app-source
edits preserve the registry cache. Commit metadata belongs to the content snapshot.

The image runs as `65532:65532`, listens on 8080 and uses separate runtime,
application and content layers. nix2container returns an image description.
Export it through `copyTo` with a concrete transport, repository/tag and temporary
directory, on Linux:

```bash
export DOCS_IMAGE_TAG="$(nix eval --raw .#lib.docsImageTag)"
export IMAGE_REF="registry.example/namespace/handbook-web:$DOCS_IMAGE_TAG"
export DOCS_IMAGE_ARCHIVE="$PWD/handbook-web-$DOCS_IMAGE_TAG.tar"
nix run .#docs-image.copyTo -- \
  "docker-archive:$DOCS_IMAGE_ARCHIVE:$IMAGE_REF" --tmpdir "${TMPDIR:-/tmp}"
```

Keep archives and build links ignored or outside the checkout so export does not
dirty the source. A remote builder does not make Linux export binaries executable
on macOS. Copy the committed checkout to the Linux runner, run the command there,
and copy the resulting archive back. The repository's executable acceptance path
is `python3 scripts/test-docs-microapp-container.py --native-linux x86_64-linux`:
it discovers a matching SSH builder or accepts `--linux-runner user@host`, bundles
the committed fixture through Git, exports on that host, checks the archive, and
runs Chromium through an SSH tunnel to the native container. It uses an existing
Docker daemon or an isolated temporary daemon with passwordless sudo, no bridge,
forwarding or iptables changes; cleanup stops that daemon and its container.
A missing Linux runtime is a failure, never a skipped acceptance.

Override `docsMicroapp.imageName` in `flake.module.nix` to change the repository.
Update any seeded Nagare config and archive destination to match. The recipe's
runbook explains separate publication and deployment reviews, hostname grants and
rollback to an existing accepted publication.

For fast local runtime iteration on macOS, prefer Apple Container. After exporting
a Docker archive and installing the generated consumer's browser-test dependencies,
run the repository's local check (it converts to OCI with the pinned Nix Skopeo,
imports the image, runs browser/HTTP checks, and removes its temporary container/image):

```bash
python3 scripts/test-docs-microapp-container.py \
  --apple-archive /path/to/image.tar --apple-project /path/to/generated-consumer
```

Apple Container 1.5.0 was verified with this scaffold; amd64 images use Rosetta
on Apple Silicon. Native x86_64 build/export acceptance remains separately recorded.
New local Linux build work should prefer an Apple Container Nix environment over
a remote builder when its native architecture meets the required check.
