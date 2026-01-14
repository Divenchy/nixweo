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

    stylix.url = "github:danth/stylix";

    lazyweo-flake.url = "path:./modules/lazyWeo";
    weomacs-flake.url = "path:./modules/weomacs";
    hyprland-flake.url = "path:./modules/hyprland";
    wezterm-flake.url = "path:./modules/wezterm";
  };

  outputs = { self, nixpkgs, home-manager, stylix, nvf, ... }@inputs:
    let inherit(self) outputs;
        system = "x86_64-linux";
        # pkgs = nixpkgs.legacyPackages.${system};
        pkgs = import nixpkgs { inherit system; };
    in
      {
        nixosConfigurations = {
          nixweo = nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs outputs; };
	          modules = [
              stylix.nixosModules.stylix
              inputs.nvf_weovim-flake.nixosModules.default
              ./hosts/nixweo/configuration.nix
	          ];  
          };
          nixweosl = nixpkgs.lib.nixosSystem {
            system = system;
            specialArgs = { inherit inputs outputs; };
	          modules = [
	            ./hosts/nixweosl/configuration.nix
	          ];
          };
        };
      };
}
