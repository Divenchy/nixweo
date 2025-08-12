{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    home-manager = {
      url = "github:nix-community/home-manager/";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    weomacs-flake.url = "path:/home/weo/nixos/modules/weomacs"; # local path to flake
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let inherit(self) outputs;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations = {
      nixweo = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs outputs; };
	modules = [
	  ./hosts/nixweo/configuration.nix
	];
        };
      nixWEOWSL = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs outputs; };
	modules = [
	  ./hosts/nixWEOWSL/configuration.nix
	];
        };
      };
    };

}
