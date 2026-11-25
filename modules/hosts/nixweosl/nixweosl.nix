# nixweosl: NixOS-WSL, terminal-only dev environment (no window managers or GUI desktop).
{
  inputs,
  config,
  ...
}: let
  inherit (config.flake.modules) nixos;
in {
  flake.nixosConfigurations.nixweosl = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {inherit inputs;};
    modules = [nixos.nixweosl-host];
  };

  flake.modules.nixos.nixweosl-host = {
    imports = [
      nixos.overlays
      nixos.base
      nixos.wsl
      nixos.home-manager
      nixos.weovim
      nixos.zsh
      nixos.nixweosl
    ];
  };
}
