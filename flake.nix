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
        cmdline-tools-latest
        emulator
        platform-tools
        platforms-android-34
        platforms-android-33
        ndk-26-1-10909125
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

      # React Native + Expo development shell
      expo = pkgs.mkShell {
        buildInputs = with pkgs; [
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

          # Firebase CLI
          firebase-tools

          # SQLite
          sqlite

          # Java for Android builds
          jdk21

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
          xorg.libX11
          xorg.libXext
          xorg.libXrender

          self.nixosConfigurations.nixweo.config.programs.nvf.finalPackage
        ];

        JAVA_HOME = "${pkgs.jdk21}";
        ANDROID_HOME = "${androidSdk}/share/android-sdk";
        ANDROID_SDK_ROOT = "${androidSdk}/share/android-sdk";
        ANDROID_NDK_ROOT = "${androidSdk}/share/android-sdk/ndk/26.1.10909125";

        # Gradle settings
        GRADLE_OPTS = "-Dorg.gradle.daemon=false -Dorg.gradle.parallel=true";

        shellHook = ''
          # Add Android tools to PATH
          export PATH="$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$PATH"

          # Node.js memory optimization for large projects
          export NODE_OPTIONS="--max-old-space-size=4096"

          # Fix for some native modules
          export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath [
            pkgs.libGL
            pkgs.libpulseaudio
            pkgs.xorg.libX11
            pkgs.xorg.libXext
            pkgs.xorg.libXrender
          ]}:$LD_LIBRARY_PATH"

          # Create local.properties for Android if in a project
          if [ -d "android" ] && [ ! -f "android/local.properties" ]; then
            echo "sdk.dir=$ANDROID_HOME" > android/local.properties
            echo "ndk.dir=$ANDROID_NDK_ROOT" >> android/local.properties
            echo "Created android/local.properties"
          fi

          echo ""
          echo "📱 React Native + Expo Development Environment"
          echo "==============================================="
          echo "Node.js:      $(node --version)"
          echo "npm:          $(npm --version)"
          echo "TypeScript:   $(tsc --version 2>/dev/null || echo 'install with: npm i -g typescript')"
          echo "Java:         $(java --version 2>&1 | head -n 1)"
          echo "Android SDK:  $ANDROID_HOME"
          echo ""
          echo "Quick start:"
            echo "  npx create-expo-app@latest my-app"
          echo "  cd my-app"
          echo "  npx expo start"
          echo ""
          echo "Run on Android:"
          echo "  npx expo run:android    # Build and run on device/emulator"
          echo "  npx expo start --android # Use Expo Go"
          echo ""
          echo "Create Android emulator:"
          echo "  avdmanager create avd -n pixel6 -k 'system-images;android-34;google_apis;x86_64'"
          echo "  emulator -avd pixel6"
          echo ""
          echo "Note: iOS builds require macOS or EAS Build (cloud)"
          echo "  npx eas build -p ios    # Cloud build for iOS"
          echo ""
        '';
      };
    };
  };
}
