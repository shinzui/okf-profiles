# Deployment review

This project seeds a single service named `okf-profiles` at the full hostname `okf-profiles.labs.topagentnetwork.net` in namespace `personal`. Its image repository is `okf-profiles-web`. It uses port 8080, `/healthz`, scale 0..2 and Nagare login protection.

Use Nagare v0.16.2 from `mori://shinzui/nagare`. Check the target platform compatibility and existing authorized hostname grant before preparing a live review. `requireLogin` creates no grant. Generation and offline checks do not contact a cluster.

`Config.hs` and this runbook are seeds: edit them directly after generation. Reruns with different inputs preserve them, including intentional deletion. DNS labels are validated by Seihou; Nagare smart constructors also check the full hostname's 253-character limit. No service name is appended to the supplied hostname.

From a clean committed consumer, build and export on a native Linux host:

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

On macOS a remote builder produces Linux outputs but does not run Linux export binaries. With this committed checkout copied to the configured Linux runner, export there and copy the archive back (replace `linux-runner` and `/work/docs` with that runner and checkout):

```bash
ssh linux-runner 'cd /work/docs && nix run .#packages.x86_64-linux.docs-image.copyTo -- "docker-archive:$PWD/docs-image.tar:registry.example/namespace/okf-profiles-web:git-$(git rev-parse --short=12 HEAD)" --tmpdir /tmp'
scp linux-runner:/work/docs/docs-image.tar ./docs-image.tar
```

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
