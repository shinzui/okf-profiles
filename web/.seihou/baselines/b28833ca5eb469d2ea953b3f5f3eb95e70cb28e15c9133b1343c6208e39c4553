{
  description = "Developer reference for the OKF profile catalog";

  # Module-owned revisions move with module releases. All inputs stay declared
  # across feature toggles, so every project shares the shipped lock.
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/39ad350a0602fa0a58a544344e3e9187526ea45c";
    flake-parts = {
      url = "github:hercules-ci/flake-parts/024633cd702b10285db5cb19b40ad48d2399ba60";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix/a0e4241b51206fbcbf52fd322eb5f0cd80f153c4";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    bun2nix = {
      url = "github:nix-community/bun2nix/0f2a1f0b6f42cebe3b149bf62d38754c5e0e9729";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
    # nix2container v1.1.0; available to unmanaged image definitions.
    nix2container = {
      url = "github:nlewo/nix2container/e503eb81630a0c5d7ec244e08e0733650235d8f1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ flake-parts, nixpkgs, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "aarch64-darwin" "aarch64-linux" "x86_64-linux" ];
      imports = [
        ./nix/bun.nix
        ./nix/bun2nix-module.nix
      ]
      ++ nixpkgs.lib.optional (builtins.pathExists ./nix/docs-microapp.nix) ./nix/docs-microapp.nix
      ++ nixpkgs.lib.optional (builtins.pathExists ./flake.module.nix) ./flake.module.nix;
    };
}
