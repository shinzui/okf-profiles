# Deployment review

This project seeds a single service named `okf-profiles` at the full hostname `okf-profiles.labs.topagentnetwork.net` in namespace `personal`. Its image repository is `okf-profiles-web`. It uses port 8080, `/healthz`, scale 0..2 and Nagare login protection.

Use Nagare v0.16.2 from `mori://shinzui/nagare`. Check the target platform compatibility and existing authorized hostname grant before preparing a live review. `requireLogin` creates no grant. Generation and offline checks do not contact a cluster.

`Config.hs` and this runbook are seeds: edit them directly after generation. Reruns with different inputs preserve them, including intentional deletion. DNS labels are validated by Seihou; Nagare smart constructors also check the full hostname's 253-character limit. No service name is appended to the supplied hostname.

All Nix and Nagare commands below run from `web/`, unless a step explicitly starts at the repository root. From a clean committed checkout, build and export on a native Linux host:

```bash
nix build .#docs-app .#docs-content
export DOCS_IMAGE_TAG="$(nix eval --raw .#lib.docsImageTag)"
nix run github:shinzui/nagare/v0.16.2#nagarectl -- app check --file nagare/Config.hs
nix build .#docs-image --out-link result-docs-image
export REGISTRY='registry.example/namespace'
export IMAGE_REF="$REGISTRY/okf-profiles-web:$DOCS_IMAGE_TAG"
export DOCS_IMAGE_ARCHIVE="$PWD/okf-profiles-web-$DOCS_IMAGE_TAG.tar"
nix run .#docs-image.copyTo -- "docker-archive:$DOCS_IMAGE_ARCHIVE:$IMAGE_REF" --tmpdir "${TMPDIR:-/tmp}"
```

## Build and test locally with Apple Container

The deployed `intranet` context uses **linux/amd64**. Build for that target; the
ARM64 image used for local implementation acceptance cannot be deployed there.
On Apple Silicon, use an AMD64 Apple Container with Rosetta. From the repository
root, start a dedicated builder and clone the clean committed repository inside it:

```bash
container run --detach --name okf-profiles-docs-builder --arch amd64 --rosetta --cpus 8 --memory 12G \
  --volume "$PWD:/source:ro" ghcr.io/nixos/nix:2.35.2 sleep infinity && \
container exec okf-profiles-docs-builder sh -c '
  git config --global --add safe.directory /source &&
  git clone --no-hardlinks /source /build/okf-profiles &&
  cd /build/okf-profiles/web &&
  nix --extra-experimental-features "nix-command flakes" build .#docs-image .#checks.x86_64-linux.docs-smoke --no-link --option sandbox false --option filter-syscalls false --option max-jobs 4 --option cores 4 &&
  DOCS_IMAGE_TAG=$(nix --extra-experimental-features "nix-command flakes" eval --raw .#lib.docsImageTag) &&
  nix --extra-experimental-features "nix-command flakes" run .#docs-image.copyTo --option sandbox false --option filter-syscalls false -- "docker-archive:/tmp/okf-profiles-web.tar:okf-profiles-web:$DOCS_IMAGE_TAG" --tmpdir /tmp'
```

The builder uses its own Linux Nix store; the source mount is only a clone input.
Sandboxing and the Nix build syscall filter are disabled only in this dedicated
Rosetta builder. The filter otherwise fails to load an AMD64 seccomp program on
the ARM64 kernel (FRIC-2). For a native ARM64 local runtime check, omit the AMD64/
Rosetta options and use `checks.aarch64-linux.docs-smoke`.

**Rosetta export workaround (FRIC-4):** if the pinned exporter reports an empty
normalized patch, build the unchanged fixed-output patch on the native Mac and
transfer it to the builder before retrying export. From the repository root:

```bash
export DOCS_PATCH_CACHE="$(mktemp -d)" && \
  nix build --impure --file docs/plans/evidence/14/skopeo-patch.nix --no-link && \
  nix copy --impure --file docs/plans/evidence/14/skopeo-patch.nix \
    --to "file://$DOCS_PATCH_CACHE" && \
  container copy "$DOCS_PATCH_CACHE" okf-profiles-docs-builder:/tmp/docs-patch-cache && \
  container exec okf-profiles-docs-builder \
    nix --extra-experimental-features "nix-command flakes" copy --all \
      --from file:///tmp/docs-patch-cache
```

The helper reproduces the recipe-pinned patch with its original SHA-256; no
dependency pin or hash is changed. Use a fresh archive filename for a repeated
export; Skopeo refuses to modify an existing Docker archive.

Still at the root, copy the archive out, convert it to OCI using the flake's pinned
Skopeo, and run the image without mounting the source checkout:

```bash
export DOCS_EXPORT_DIR="$(mktemp -d)" && \
export DOCS_IMAGE_TAG="git-$(git rev-parse --short=12 HEAD)" && \
container copy okf-profiles-docs-builder:/tmp/okf-profiles-web.tar "$DOCS_EXPORT_DIR/image.tar" && \
nix shell --inputs-from ./web nixpkgs#skopeo -c skopeo --insecure-policy copy \
  "docker-archive:$DOCS_EXPORT_DIR/image.tar" \
  "oci-archive:$DOCS_EXPORT_DIR/image-oci.tar:okf-profiles-local:$DOCS_IMAGE_TAG" && \
container image load --input "$DOCS_EXPORT_DIR/image-oci.tar" && \
container run --detach --name okf-profiles-docs-acceptance --arch amd64 --rosetta --read-only --tmpfs /tmp \
  --publish 127.0.0.1:18718:8080 "okf-profiles-local:$DOCS_IMAGE_TAG"
```

After startup, verify health and run the catalog browser suite from the root:

```bash
curl --fail --silent http://127.0.0.1:18718/healthz && \
DOCS_TEST_URL=http://127.0.0.1:18718 just docs-web-e2e
```

The health commit must equal `git rev-parse HEAD` of the built clone. Browser checks
exercise every selected page, unpublished-path 404s, section anchors, both themes,
and local fonts while blocking external browser requests. The local source-mutation
fixtures are excluded for an external immutable runtime. Keep the archive and image
reference for review, or stop/delete only these test resources when finished:

```bash
container stop okf-profiles-docs-acceptance okf-profiles-docs-builder && \
container delete okf-profiles-docs-acceptance okf-profiles-docs-builder && \
container image delete "okf-profiles-local:$DOCS_IMAGE_TAG"
```

If local capacity cannot satisfy the build, clone the committed whole repository to
a matching native Linux runner and execute the first build/export block there.
Copy its exported archive back for local runtime acceptance. A remote Linux export
binary cannot run on macOS.

## Prepare publication and deployment reviews

Use the release-qualified operator package (`nix shell github:shinzui/nagare/v0.16.2#nagare -c nagarectl …`) for live commands; the bare CLI package omits Pulumi. Select `--context intranet` and the context-specific kubeconfig. Run the context/project and platform guards first. This deployment used a private command-scoped gcloud configuration with ADC quota project `tan-ng-labs`; the global ADC configuration was preserved (FRIC-3).

Keep the exported archive outside tracked source or ignored; a dirty checkout cannot produce a publication image tag. Choose the actual registry from your authorized context. Config image, destination and accepted publication must agree on repository/tag. If `docsMicroapp.imageName` is overridden, update this seeded config and destination too.

The following operator steps prepare two separate saved reviews; automatic checks do not run them:

```bash
nagarectl app image-plan --archive "$DOCS_IMAGE_ARCHIVE" --destination "$IMAGE_REF" --key "okf-profiles-web-$DOCS_IMAGE_TAG" --save-plan image-review
```

Review and apply the publication through Nagare's inventory workflow. Set `IMAGE_RESOURCE_ID` to the returned accepted resource ID, then prepare the deployment:

```bash
nagarectl app deploy --file nagare/Config.hs --tag "$DOCS_IMAGE_TAG" --image-resource "$IMAGE_RESOURCE_ID" --save-plan app-review
```

Review before applying. Keep review and archive files at stable paths until the inventory transaction completes. For rollback, use a previously accepted publication and its original config/source revision; keep its immutable tag. Verify anonymous protection and an authorized page read after an explicitly authorized deployment.

The initial live deployment is recorded in [the deployment receipt](../../docs/plans/evidence/14/deployment.json). After adding a protected host, prepare/apply `access portal sync --save-plan DIR` so authentication startup settings include it, then review the intended viewer grant.
