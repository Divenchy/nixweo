# Flake-pinned registry/NIX_PATH, store GC and optimisation.
{
  flake.modules.nixos.nix = {
    inputs,
    lib,
    ...
  }: {
    nix = let
      # flake-parts and import-tree only build this flake; keep them out of the registry.
      flakeInputs = lib.filterAttrs (n: v: lib.isType "flake" v && !lib.elem n ["flake-parts" "import-tree"]) inputs;
    in {
      settings = {
        # Opinionated: disable global registry
        flake-registry = "";
        # Workaround for https://github.com/NixOS/nix/issues/9574
        nix-path = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
        min-free = 20 * 1024 * 1024 * 1024; # start GC when under 20 GB free
        max-free = 50 * 1024 * 1024 * 1024;
        auto-optimise-store = true;
        # Binary cache for wimpysworld flakes (sidra).
        extra-substituters = ["https://nix.wimpys.world"];
        extra-trusted-public-keys = ["nix.wimpys.world-1:fphFHD2f+iEG5G81lFRgU84MB6N9ScHGFvB6D64tLmo="];
      };
      # Opinionated: disable channels
      channel.enable = false;

      # Opinionated: make flake registry and nix path match flake inputs
      registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 8d";
      };
    };
  };
}
