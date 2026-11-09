# Latest released tooling, fixed-output npm archives and native bindings.
# seihou-managed; refresh with scripts/update-nix-bun-flake.py in the module repository.
{ lib, stdenv, fetchurl, nodejs, makeWrapper, autoPatchelfHook }:
let
  sources = builtins.fromJSON (builtins.readFile ./tooling-sources.json);
  mkTool = name: spec:
    let
      keys = spec.common ++ [ spec.bindings.${stdenv.hostPlatform.system} ];
      archives = map (key: sources.archives.${key}) keys;
    in stdenv.mkDerivation {
      pname = name;
      inherit (spec) version;
      dontUnpack = true;
      dontConfigure = true;
      dontBuild = true;
      nativeBuildInputs = [ makeWrapper ] ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];
      buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ stdenv.cc.cc.lib ];
      installPhase = ''
        runHook preInstall
        ${lib.concatMapStringsSep "\n" (archive: let src = fetchurl { inherit (archive) url hash; }; in ''
          mkdir -p "$out/lib/node_modules/${archive.name}"
          tar -xzf ${src} --strip-components=1 -C "$out/lib/node_modules/${archive.name}"
        '') archives}
        mkdir -p "$out/bin"
        makeWrapper ${nodejs}/bin/node "$out/bin/${if name == "typescript" then "tsc" else name}" \
          --add-flags "$out/lib/node_modules/${name}/bin/${if name == "typescript" then "tsc" else name}"
        runHook postInstall
      '';
      meta.platforms = builtins.attrNames spec.bindings;
    };
in lib.mapAttrs mkTool sources.tools
