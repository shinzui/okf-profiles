# seihou-managed. Put project customizations in ../flake.module.nix.
{ ... }:
{
  perSystem = { config, pkgs, lib, ... }:
    let
      tooling = pkgs.callPackage ./tooling.nix { };
    in {
      options.bunProject.extraDevPackages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [ ];
        description = "Additional packages for the Bun development shell";
      };
      config.devShells.default = pkgs.mkShell {
        packages = [ pkgs.bun pkgs.just tooling.typescript tooling.oxlint tooling.oxfmt ]
          ++ config.bunProject.extraDevPackages;
        shellHook = ''
          export LANG=en_US.UTF-8
          if [ ! -d node_modules ]; then
            echo "Run 'just install' (bun install) to fetch dependencies."
          fi
        '';
      };
    };
}
