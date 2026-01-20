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

    weovim-flake.url = "path:./modules/weovim";
    wezterm-flake.url = "path:./modules/wezterm";

    weomacs-flake.url = "path:./modules/weomacs";

    hyprland-flake.url = "path:./modules/hyprland";

    zig-overlay.url = "github:mitchellh/zig-overlay";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    weovim-flake,
    zig-overlay,
    stylix,
    ...
  } @ inputs: let
    inherit (self) outputs;
    system = "x86_64-linux";
    # pkgs = nixpkgs.legacyPackages.${system};
    pkgs = import nixpkgs {inherit system;};
  in {
    nixosConfigurations = {
      nixweo = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          stylix.nixosModules.stylix
          weovim-flake.nixosModules.default
          ./hosts/nixweo/configuration.nix
        ];
      };
      nixweosl = nixpkgs.lib.nixosSystem {
        system = system;
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./hosts/nixweosl/configuration.nix
        ];
      };
    };

    devShells.${system} = {
      # Raylib + Zig with weovim
      zigRaylib = let
        zigWrapper = pkgs.writeShellScriptBin "zig" ''
          unset ZIG_GLOBAL_CACHE_DIR  # Clear any existing value
          export ZIG_GLOBAL_CACHE_DIR="$HOME/.cache/zig"
          mkdir -p "$ZIG_GLOBAL_CACHE_DIR"
          exec ${pkgs.zig}/bin/zig "$@"
        '';
      in
        pkgs.mkShell {
          buildInputs = with pkgs; [
            zig
            zls
            raylib

            # X11/Wayland dependencies
            xorg.libX11
            xorg.libXrandr
            xorg.libXi
            xorg.libXcursor
            xorg.libXinerama
            libGL
            alsa-lib

            # Development tools
            gdb

            # Your custom neovim
            self.nixosConfigurations.nixweo.config.programs.nvf.finalPackage
          ];

          shellHook = ''
            echo "Raylib + Zig + Weovim development environment"
            echo "Zig version: $(zig version)"

            # Override the Nix-set ZIG_GLOBAL_CACHE_DIR
            unset ZIG_GLOBAL_CACHE_DIR
            export ZIG_GLOBAL_CACHE_DIR="$HOME/.cache/zig"
            mkdir -p "$ZIG_GLOBAL_CACHE_DIR"

            export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath [
              pkgs.raylib
              pkgs.libGL
              pkgs.xorg.libX11
              pkgs.xorg.libXrandr
              pkgs.xorg.libXi
              pkgs.xorg.libXcursor
              pkgs.xorg.libXinerama
              pkgs.alsa-lib
            ]}:$LD_LIBRARY_PATH"
          '';
        };
    };
  };
}
