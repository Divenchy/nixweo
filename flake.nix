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
    zig-overlay,
    stylix,
    android-nixpkgs,
    ...
  } @ inputs: let
    inherit (self) outputs;
    system = "x86_64-linux";
    # pkgs = nixpkgs.legacyPackages.${system};
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        android_sdk.accept_license = true;
      };
    };

    androidSdk = android-nixpkgs.sdk.${system} (sdkPkgs:
      with sdkPkgs; [
        build-tools-34-0-0
        build-tools-33-0-1
        build-tools-35-0-0
        build-tools-36-0-0
        cmdline-tools-latest
        emulator
        platform-tools
        platforms-android-36
        platforms-android-35
        platforms-android-34
        platforms-android-33
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

      # React Native + Expo development shell
      expo = let
        fhs = pkgs.buildFHSEnv {
          name = "expo-fhs";
          targetPkgs = pkgs:
            with pkgs; [
              # Node.js ecosystem
              nodejs_20
              yarn
              nodePackages.npm
              nodePackages.pnpm
              # TypeScript tooling
              nodePackages.typescript
              nodePackages.typescript-language-server
              # React Native / Expo
              watchman
              # SQLite
              sqlite
              # Java for Android builds
              jdk17
              # Android SDK
              androidSdk
              # Build tools
              git
              curl
              unzip
              which
              # For Android emulator on Linux
              libGL
              libpulseaudio
              libX11
              libXext
              libXrender
              # Additional libs needed by aapt2 and other Android tools
              zlib
              stdenv.cc.cc.lib
              # Your custom neovim
              self.nixosConfigurations.nixweo.config.programs.nvf.finalPackage
            ];

          multiPkgs = pkgs:
            with pkgs; [
              zlib
            ];

          profile = ''
            export JAVA_HOME="${pkgs.jdk17}"
            export ANDROID_HOME="${androidSdk}/share/android-sdk"
            export ANDROID_SDK_ROOT="${androidSdk}/share/android-sdk"
            export ANDROID_NDK_ROOT="${androidSdk}/share/android-sdk/ndk/27.1.12297006"
            export GRADLE_OPTS="-Dorg.gradle.daemon=false -Dorg.gradle.parallel=true"
            export PATH="$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$PATH"
            export NODE_OPTIONS="--max-old-space-size=4096"
            export ANDROID_AVD_HOME="$HOME/.android/avd"
            mkdir -p "$ANDROID_AVD_HOME"

            # Create local.properties for Android if in a project
            if [ -d "android" ] && [ ! -f "android/local.properties" ]; then
              echo "sdk.dir=$ANDROID_HOME" > android/local.properties
              echo "ndk.dir=$ANDROID_NDK_ROOT" >> android/local.properties
              echo "Created android/local.properties"
            fi

            if [ -z "$IN_NIX_SHELL_ZSH" ]; then
              export IN_NIX_SHELL_ZSH=1

              echo ""
              echo "📱 React Native + Expo Development Environment (FHS)"
              echo "====================================================="
              echo "Node.js:      $(node --version)"
              echo "npm:          $(npm --version)"
              echo "Java:         $(java --version 2>&1 | head -n 1)"
              echo "Android SDK:  $ANDROID_HOME"
              echo ""
              echo "Emulator:     emulator -avd pixel6"
              echo "Start:        npx expo start"
              echo "Build:        npx expo run:android"
              echo ""

              exec zsh
            fi
          '';

          runScript = "bash";
        };
      in
        pkgs.mkShell {
          shellHook = ''
            exec ${fhs}/bin/expo-fhs
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
              ]
          ))
          # Your custom neovim
          self.nixosConfigurations.nixweo.config.programs.nvf.finalPackage
        ];

        shellHook = ''
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
