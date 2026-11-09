# Compatibility for bun2nix 2.1.2 (0f2a1f0b6f42cebe3b149bf62d38754c5e0e9729).
# Source: mori://nix-community/bun2nix, programs/bun2nix/src/lib.rs
# (source-file artifact URI pending).
# Bun v2 retains the supported package tuples and strengthens validation.
# Qualify any replacement release against the generator/frozen-install fixtures.
{ bun2nix }:
bun2nix.overrideAttrs (old: {
  postPatch = (old.postPatch or "") + ''
    substituteInPlace src/lib.rs --replace-fail \
      'if lockfile.lockfile_version != 1 {' \
      'if !matches!(lockfile.lockfile_version, 1 | 2) {'
  '';
})
