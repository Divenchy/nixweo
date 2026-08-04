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

    android-nixpkgs = {
      url = "github:tadfisher/android-nixpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    weovim-flake,
    stylix,
    android-nixpkgs,
    ...
  } @ inputs: let
    inherit (self) outputs;
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        android_sdk.accept_license = true;
      };
    };

    androidSdk = android-nixpkgs.sdk.${system} (sdkPkgs:
      with sdkPkgs; [
        build-tools-36-0-0
        cmdline-tools-latest
        emulator
        platform-tools
        platforms-android-36
        ndk-27-1-12297006
        cmake-3-22-1
        # System images for emulator
        system-images-android-34-google-apis-x86-64
      ]);
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
            libX11
            libXrandr
            libXi
            libXcursor
            libXinerama
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
              pkgs.libX11
              pkgs.libXrandr
              pkgs.libXi
              pkgs.libXcursor
              pkgs.libXinerama
              pkgs.alsa-lib
            ]}:$LD_LIBRARY_PATH"
          '';
        };

      compPhoto = pkgs.mkShell {
        buildInputs = with pkgs; [
          (pkgs.python3.withPackages (
            python-pkgs:
              with python-pkgs; [
                # select Python packages here
                scikit-image
                scipy

                opencv4
                pandas
                numpy
                matplotlib
                timm
                torch
                torchvision
                transformers
              ]
          ))
          # Your custom neovim
          self.nixosConfigurations.nixweo.config.programs.nvf.finalPackage
        ];

        shellHook = ''
          pip install gradio gradio-imageslider --break-system-packages 2>/dev/null || \
          pip install gradio gradio-imageslider --user

          if [ -z "$IN_NIX_SHELL_ZSH" ]; then
            export IN_NIX_SHELL_ZSH=1
            echo ""
            echo "Computational Photography Python Environment"
            echo "====================================================="
            echo "Python version: $(python --version)"
            echo ""

            exec zsh
          fi
        '';
      };
    };
  };
}
