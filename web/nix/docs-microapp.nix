# seihou-managed. Customize docsMicroapp in ../flake.module.nix.
{ config, lib, self, inputs, ... }:
let
  cfg = config.docsMicroapp;
  revision = if self ? rev then self.rev else null;
  imageTag = if revision == null then throw "docs-image requires a clean committed Git revision" else "git-${builtins.substring 0 12 revision}";
in {
  options.docsMicroapp = {
    contentSource = lib.mkOption { type = lib.types.path; default = ../.; description = "Publication root containing the manifest and all approved files"; };
    contentConfig = lib.mkOption { type = lib.types.str; default = "content.config.json"; description = "Manifest path relative to contentSource"; };
    imageName = lib.mkOption { type = lib.types.str; default = "okf-profiles-web"; description = "Image repository, independent of Nagare service name"; };
  };
  config = {
    flake.lib.docsImageTag = imageTag;
    perSystem = { config, pkgs, system, ... }:
      let
        app = pkgs.callPackage ./docs-microapp-app.nix { bun2nix = config.packages.bun2nix; } { sourceRoot = ../.; };
        content = pkgs.callPackage ./docs-microapp-content.nix { } { sourceRoot = cfg.contentSource; configPath = cfg.contentConfig; commit = if revision == null then "unknown" else revision; date = self.lastModifiedDate or "unknown"; };
        ready = builtins.pathExists ../bun.lock && builtins.pathExists ../bun-deps.nix;
        requireLocks = value: if ready then value else throw "Run bun install and bun2nix -o bun-deps.nix; commit both lock files before building docs packages";
      in {
        packages = {
          docs-app = requireLocks app;
          docs-content = content;
        } // lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
          docs-image = requireLocks (pkgs.callPackage ./docs-microapp-image.nix { nix2container = inputs.nix2container.packages.${system}.nix2container; } { inherit app content; name = cfg.imageName; tag = imageTag; });
        };
        checks.docs-smoke = requireLocks (pkgs.runCommand "docs-smoke" { nativeBuildInputs = [ pkgs.bun pkgs.curl ]; __darwinAllowLocalNetworking = true; } ''
          export DOCS_CONTENT_ROOT=${content}
          export PORT=18080
          ${app}/bin/docs-server >server.log 2>&1 &
          server=$!
          trap 'kill "$server" 2>/dev/null || true' EXIT
          for attempt in $(seq 1 100); do
            if curl -fsS http://127.0.0.1:$PORT/healthz > health.json; then break; fi
            sleep .1
          done
          curl -fsS http://127.0.0.1:$PORT/ | grep -q '<html'
          curl -fsS http://127.0.0.1:$PORT/fonts/geist-serif.woff2 > geist.woff2
          curl -fsS http://127.0.0.1:$PORT/fonts/paper-mono.woff2 > paper.woff2
          test -s geist.woff2 && test -s paper.woff2
          mkdir "$out"
          cp health.json "$out/health.json"
        '');
      };
  };
}
