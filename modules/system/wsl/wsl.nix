{inputs, ...}: {
  flake.modules.nixos.wsl = {lib, ...}: {
    imports = [inputs.nixos-wsl.nixosModules.default];

    wsl.enable = true;

    # WSL has no hardware-configuration.nix; NixOS-WSL provides the hardware layer.
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  };
}
