# seihou-managed. App and registry cache exclude publication content.
{ lib, stdenvNoCC, bun, makeWrapper, bun2nix }:
{ sourceRoot }:
let
  manifests = map (p: sourceRoot + "/${p}/package.json") [ "apps/docs" "packages/ui" "packages/corpus" ];
  workspaceNames = map (p: (builtins.fromJSON (builtins.readFile p)).name) manifests;
  registryOnly = { copyPathToStore, fetchFromGitHub, fetchgit, fetchurl, ... }@args:
    builtins.removeAttrs (import (sourceRoot + "/bun-deps.nix") args) workspaceNames;
  bunDeps = bun2nix.fetchBunDeps { bunNix = registryOnly; };
  excluded = [ "node_modules" "dist" ".tanstack" "routeTree.gen.ts" ];
  src = builtins.path {
    path = sourceRoot;
    name = "docs-app-source";
    filter = path: _:
      let
        relative = lib.removePrefix (toString sourceRoot + "/") (toString path);
        parts = lib.splitString "/" relative;
      in !(lib.any (p: builtins.elem p excluded) parts)
        && (builtins.elem relative [ "package.json" "bun.lock" "tsconfig.json" "apps" "packages" ]
          || lib.any (prefix: relative == prefix || lib.hasPrefix (prefix + "/") relative) [ "apps/docs" "packages/ui" "packages/corpus" ]);
  };
in stdenvNoCC.mkDerivation {
  pname = "docs-app";
  version = "0.1.0";
  inherit src bunDeps;
  strictDeps = true;
  nativeBuildInputs = [ bun bun2nix.hook makeWrapper ];
  bunInstallFlags = [ "--frozen-lockfile" "--linker=isolated" ] ++ lib.optional stdenvNoCC.hostPlatform.isDarwin "--backend=symlink";
  dontRunLifecycleScripts = true;
  dontUseBunPatch = true;
  dontUseBunCheck = true;
  dontFixup = true;
  buildPhase = ''
    runHook preBuild
    bun run build
    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall
    mkdir -p "$out/share/docs" "$out/bin"
    cp -R apps/docs/dist apps/docs/server.ts apps/docs/site-name.txt "$out/share/docs/"
    makeWrapper ${bun}/bin/bun "$out/bin/docs-server" --add-flags "$out/share/docs/server.ts" --set NODE_ENV production
    runHook postInstall
  '';
  passthru.registryCache = bunDeps;
}
