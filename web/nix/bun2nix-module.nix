# seihou-managed. Application recipes belong in ../flake.module.nix.
{ inputs, ... }:
{
  perSystem = { config, system, ... }:
    let
      bun2nix = import ./bun2nix-package.nix {
        bun2nix = inputs.bun2nix.packages.${system}.default;
      };
    in {
      packages.bun2nix = bun2nix;
      bunProject.extraDevPackages = [ config.packages.bun2nix ];
    };
}
