{inputs, ...}: let
  overlays = [
    inputs.zig-overlay.overlays.default

    # TEMP: nixos-unstable (7fd4004) ships a stale pnpmDeps hash for
    # typescript-language-server 6.0.2 (pulled in by weomacs). Fixed on nixpkgs
    # master; remove once `nix flake update nixpkgs` picks up the fix.
    (final: prev: {
      typescript-language-server = prev.typescript-language-server.overrideAttrs (old: {
        pnpmDeps = old.pnpmDeps.overrideAttrs {
          outputHash = "sha256-xR/EF60lVBsITKgH7wCM2wHM46PFQevD51KfCENSUH4=";
        };
      });
    })
  ];
in {
  flake.modules.nixos.overlays = {
    nixpkgs.overlays = overlays;
  };

  perSystem = {system, ...}: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system overlays;
      config = {
        allowUnfree = true;
        android_sdk.accept_license = true;
      };
    };
  };
}
