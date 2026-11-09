# Exact fixed-output patch from mori://nlewo/nix2container at revision
# e503eb81630a0c5d7ec244e08e0733650235d8f1, default.nix (artifact URI pending).
# Build natively when Rosetta's fetchpatch2 normalization returns an empty patch.
let
  flake = builtins.getFlake ("path:" + toString ../../../../web);
  pkgs = import flake.inputs.nixpkgs { system = builtins.currentSystem; };
in pkgs.fetchpatch2 {
  url = "https://github.com/nlewo/container-libs/commit/21b053ac62f3137de42585611953e923577d0e10.patch";
  sha256 = "sha256-pfwQh7FKWHY/xVAGMSvnjMOmkpMo9NG2HFZqhqZ1VN0=";
  postFetch = ''
    sed -i \
      -e '/^index /d' \
      -e '/^similarity index /d' \
      -e '/^dissimilarity index /d' \
      $out
  '';
}
