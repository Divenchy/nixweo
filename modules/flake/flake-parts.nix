# Every .nix file under modules/ is a flake-parts module (loaded by import-tree).
# Features publish NixOS / home-manager modules under flake.modules.<class>.<name>;
# hosts in modules/hosts compose them.
{inputs, ...}: {
  imports = [inputs.flake-parts.flakeModules.modules];

  # Systems the flake's per-system outputs (devShells) are generated for.
  # NixOS hosts take their platform from hardware-configuration.nix instead.
  systems = ["x86_64-linux" "aarch64-linux"];
}
