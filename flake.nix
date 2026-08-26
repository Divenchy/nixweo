{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    quickshell = {
      url = "github:quickshell-mirror/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
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

    zig-overlay = {
      url = "github:mitchellh/zig-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zls = {
      url = "github:zigtools/zls";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
    zig-overlay,
    zls,
    android-nixpkgs,
    ...
  } @ inputs: let
    inherit (self) outputs;
    system = "x86_64-linux";
    overlays = [
      zig-overlay.overlays.default
    ];
    pkgs = import nixpkgs {
      inherit system;
      inherit overlays;
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
          ({
            config,
            pkgs,
            ...
          }: {
            nixpkgs.overlays = overlays;
          })

          stylix.nixosModules.stylix
          weovim-flake.nixosModules.default
          ./hosts/nixweo/configuration.nix
        ];
      };
      nixweosl = nixpkgs.lib.nixosSystem {
        system = system;
        specialArgs = {inherit inputs outputs;};
        modules = [
          ({
            config,
            pkgs,
            ...
          }: {
            nixpkgs.overlays = overlays;
          })

          weovim-flake.nixosModules.default
          ./hosts/nixweo/configuration.nix
        ];
      };
    };

    devShells.${system} = {
      # Raylib + Zig with weovim
      zigRaylib = let
        zig = pkgs.zigpkgs.master-2026-05-25;
        zls = pkgs.zls;
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

      graphics = let
        zig = pkgs.zigpkgs.master-2026-05-25;
        zlsPkg = inputs.zls.packages.${system}.default;
      in
        pkgs.mkShell {
          name = "graphics-dev";

          buildInputs = with pkgs; [
            # Langs
            zig
            zlsPkg

            rustc
            cargo
            rust-analyzer
            clippy
            rustfmt

            odin

            # Vulkan
            vulkan-headers
            vulkan-loader
            vulkan-tools
            vulkan-validation-layers
            shaderc
            spirv-tools
            glslang

            # OpenGL
            libGL
            libGLU
            mesa
            glew

            # windowing
            glfw
            SDL2
            SDL2_image
            SDL2_ttf

            # X11
            libX11
            libXrandr
            libXi
            libXcursor
            libXinerama
            libXext
            libXxf86vm

            # === Wayland ===
            wayland
            wayland-protocols
            libxkbcommon

            # === Common libs ===
            pkg-config
            cmake
            ninja
            gnumake

            # === Audio (for games) ===
            openal
            alsa-lib
            libpulseaudio

            # === Image loading ===
            libpng
            libjpeg
            stb # stb_image headers

            # === Math libs ===
            glm # C++ but headers useful for reference

            # === Debugging ===
            gdb
            renderdoc # Graphics debugger

            # === Optional: Your editor ===
            self.nixosConfigurations.nixweo.config.programs.nvf.finalPackage
          ];

          # Vulkan ICD (Installable Client Driver)
          VK_LAYER_PATH = "${pkgs.vulkan-validation-layers}/share/vulkan/explicit_layer.d";

          shellHook = ''
            echo ""
            echo "╔══════════════════════════════════════════════════════════╗"
            echo "║         Graphics Development Environment                 ║"
            echo "╠══════════════════════════════════════════════════════════╣"
            echo "║  Languages:                                              ║"
            echo "║    Zig:   $(zig version)                                 ║"
            echo "║    Rust:  $(rustc --version | cut -d' ' -f2)                                        ║"
            echo "║    Odin:  $(odin version 2>&1 | head -n1 | cut -d' ' -f3)                                    ║"
            echo "╠══════════════════════════════════════════════════════════╣"
            echo "║  Graphics APIs:                                          ║"
            echo "║    Vulkan: $(vulkaninfo --summary 2>/dev/null | grep 'Vulkan Instance' | cut -d':' -f2 | xargs || echo 'available')         ║"
            echo "║    OpenGL: $(glxinfo 2>/dev/null | grep 'OpenGL version' | cut -d':' -f2 | xargs || echo 'available')              ║"
            echo "╚══════════════════════════════════════════════════════════╝"
            echo ""
            echo "Tools: shaderc (glslc), renderdoc, vulkaninfo, glxinfo"
            echo ""

            # Zig cache
            unset ZIG_GLOBAL_CACHE_DIR
            export ZIG_GLOBAL_CACHE_DIR="$HOME/.cache/zig"
            mkdir -p "$ZIG_GLOBAL_CACHE_DIR"

            # Vulkan setup
            export VK_LAYER_PATH="${pkgs.vulkan-validation-layers}/share/vulkan/explicit_layer.d"
                  # Library path for runtime linking
            export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath [
              pkgs.vulkan-loader
              pkgs.libGL
              pkgs.glfw
              pkgs.SDL2
              pkgs.xorg.libX11
              pkgs.xorg.libXrandr
              pkgs.xorg.libXi
              pkgs.xorg.libXcursor
              pkgs.xorg.libXinerama
              pkgs.wayland
              pkgs.libxkbcommon
              pkgs.openal
              pkgs.alsa-lib
            ]}:$LD_LIBRARY_PATH"

            # For Rust GPU crates
            export LIBCLANG_PATH="${pkgs.llvmPackages.libclang.lib}/lib"
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

      elixir-phoenix =
        (pkgs.buildFHSEnv {
          name = "elixir-phoenix-fhs";
          targetPkgs = pkgs:
            with pkgs; [
              beamPackages.elixir
              beamPackages.erlang
              inotify-tools
              nodejs
              stdenv.cc.cc
              postgresql_18
              zlib
              self.nixosConfigurations.nixweo.config.programs.nvf.finalPackage
            ];
          runScript = "bash";
        }).env;
    };
  };
}
