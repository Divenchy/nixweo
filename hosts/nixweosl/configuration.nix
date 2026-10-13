{ inputs, lib, pkgs, ... }:

{
  imports =
    [ 
      inputs.nixos-wsl.nixosModules.default
      ../../modules/zsh/zsh.nix      
      inputs.home-manager.nixosModules.home-manager
    ];

  wsl.enable = true;
  wsl.defaultUser = "nixweosl";

  # WSL has no hardware-configuration.nix; NixOS-WSL provides the hardware layer.
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.nixweosl = ./home.nix;
  };

  users.users.nixweosl = {
    isNormalUser = true;
    extraGroups = [ "sudo" ];
    shell = pkgs.zsh;
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = ["nix-command flakes"];

  system.stateVersion = "26.05";
}
