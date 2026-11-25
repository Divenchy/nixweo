{inputs, ...}: let
  overlays = [
    inputs.zig-overlay.overlays.default
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
