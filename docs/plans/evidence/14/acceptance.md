# Plan 14 acceptance evidence

The runtime release candidate is commit `3e9d1a358db39901bf3ce29de7541952065875f6`.
Later evidence/plan commits do not change the reader or selected content. A later
generator-only guard rejects symlinked `docs/` roots before writing; its six
temporary-tree checks passed, and it is outside runtime app/content inputs. The
recipe is version 0.1.0 at `d7688ba1f42448520d5fc9d28996fcff4f181508`, from
`mori://shinzui/seihou-modules/templates/docs-microapp-labs`.

## Reader and regeneration

The selected catalog contains 30 profiles, 61 concept types, and 150 Markdown
files. Build, TypeScript, lint, formatting, publication validation, and 5 corpus
unit tests passed (39 assertions). Six temporary-tree Python tests passed for
selection determinism, content drift, missing inventory exports, added/removed
profiles and types, symlink boundaries, generation/selection failures, and failed
manifest-write rollback. Empty stale directories are also rejected, and a symlinked `docs/` root fails before generation starts.

Six production browser journeys passed the two-bundle forward/back path, reachability
of every selected document, unpublished-path 404s, keyboard search, repeated-field
qualification, empty/clear states, shared heading anchors, copying section URLs,
reload/back/forward, mobile navigation, guidance, local fonts, light/dark persistence,
and focus visibility. Three isolated browser journeys also passed tables/nested lists,
reference-style links, exact fenced-code clipboard text, removed-page/search/navigation
behavior, and an actual Dhall description edit followed by drift failure, regeneration,
development refresh, restoration and repeated byte-identical generation. A separately
served snapshot retained the edited text after source restoration.

## Visual assessment

`design-brief-1440-light.png`, `design-brief-1440-dark.png`,
`design-brief-390-light.png`, and `design-brief-390-dark.png` show the same long
reference in both themes. `catalog-desktop.png` shows the grouped landing page.
The title/body/code hierarchy is clear; reference prose and condition text wrap
within the reading column, and wide code/tables scroll locally. Desktop navigation
and the section rail have separate scrolling. Mobile uses a navigation dialog and
section disclosure. The light paper/dark neutral palettes preserve text contrast,
and keyboard focus has a visible accent outline. Browser assertions found no
page-wide horizontal overflow at either width. Screenshot review identified a
block-layout breadcrumb defect; the saved images include its inline-layout fix.

## Packaging and clean reproduction

A clean clone at `/tmp/okf-profiles-plan14-clean` installed the frozen Bun lock
with the authorized release-age override, ran `just docs-web-check` and `just docs`,
and finished with no Git changes. The host app/content packages and Darwin smoke
check passed. All six catalog browser journeys also passed against the installed
host server, launched through `nix shell .#docs-app -c docs-server` with a separate
Nix content snapshot.

A dedicated Apple Container built the native ARM64 Linux app, content, image and
Linux smoke check from a clean committed clone. Export used the image's `copyTo`
Docker archive transport; a fresh filename was required when exporting another
revision. Pinned Skopeo converted it to OCI for Apple Container import. The final
image ran as `65532:65532`, with a read-only root, tmpfs `/tmp`, no mounted checkout,
and no OKF/Dhall/Mori/Git request-time dependency. `/healthz` matched the full source
commit. Six catalog browser journeys passed against this image (5.6 seconds), including
all selected pages, section routes, unpublished-path 404s and fonts with external
browser requests blocked. Source-mutation fixture tests are deliberately excluded
when targeting an external immutable runtime; those passed separately above.

`linux-release.json` records the exact tag, health response, architecture and archive
checksum. The retained local archive is outside the checkout at
`/tmp/okf-profiles-plan14-delivery/image-3e9d1a358db3.tar`.

Offline Nagare v0.16.2 reported:

```json
{"brokers":0,"databases":0,"kind":"application","name":"okf-profiles","namespace":"personal","service":true,"tasks":0,"workers":0}
```

The config retains hostname `okf-profiles.labs.topagentnetwork.net`, image repository
`okf-profiles-web`, port 8080, `/healthz` and login protection. No publication or
live deployment was applied. A Seihou recipe dry-run reported `alreadyUpToDate: true`,
15 unchanged managed files and 46 preserved seeds, with no warnings. ADR-23 passed
strict profile/log enforcement. FRIC-1 is accepted; no friction remains logged for
this plan.

## Final gates

`just check` exited successfully after the full Dhall/profile/blueprint/drift and
web build/type/lint/format/content/unit gates. `just docs-web-e2e` passed all nine
combined production/development journeys in 3.9 minutes. The final generator guard
was also checked by the six temporary-tree tests, and strict ADR/friction-log
validation and `git diff --check` passed.
