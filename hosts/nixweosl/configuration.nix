{ inputs, lib, config, pkgs, ... }:

{
  imports =
    [ 
      <nixos-wsl/modules>
      inputs.home-manager.nixosModules.home-manager
    ];

  wsl.enable = true;
  wsl.defaultUser = "nixweosl";

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.nixweosl = import ./home.nix { inherit inputs lib config pkgs; };
  };

  users.users.nixweosl = {
    isNormalUser = true;
    extraGroups = [ "sudo" ];
  };

  # Keep nixpkgs unfree allowed and overlays if you want
  nixpkgs.config.allowUnfree = true;

  # Experimental nix features
  nix.settings.experimental-features = "nix-command flakes";

  system.stateVersion = "25.05";
}

