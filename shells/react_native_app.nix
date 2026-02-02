{
  description = "React Native development environment with Firebase";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    android-nixpkgs = {
      url = "github:tadfisher/android-nixpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    android-nixpkgs,
  }:
    flake-utils.lib.eachSystem ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"] (system: let
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          android_sdk.accept_license = true;
        };
      };

      # Android SDK configuration
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
        ]);

      # Common packages for all systems
      commonPackages = with pkgs; [
        # Node.js ecosystem
        nodejs_20
        yarn
        nodePackages.npm

        # React Native tools
        watchman

        # Firebase
        firebase-tools

        # Java for Android
        jdk17

        # Build tools
        git
        curl
        unzip
        which

        # Ruby for CocoaPods (iOS)
        ruby_3_2
        bundler
      ];

      # Darwin (macOS) specific packages
      darwinPackages = with pkgs;
        [
          cocoapods
          xcodes # Xcode version manager (optional)
        ]
        ++ (with pkgs.darwin.apple_sdk.frameworks; [
          CoreServices
          Foundation
        ]);

      # Linux specific packages
      linuxPackages = with pkgs; [
        # For running Android emulator
        libGL
        libpulseaudio
      ];

      # Build package list based on system
      packages =
        commonPackages
        ++ pkgs.lib.optionals pkgs.stdenv.isDarwin darwinPackages
        ++ pkgs.lib.optionals pkgs.stdenv.isLinux linuxPackages;
    in {
      devShells.default = pkgs.mkShell {
        buildInputs = packages ++ [androidSdk];

        shellHook = ''
          alias vi=nvim
          alias q=exit
          # Android SDK setup
          export ANDROID_HOME="${androidSdk}/share/android-sdk"
          export ANDROID_SDK_ROOT="$ANDROID_HOME"
          export ANDROID_NDK_ROOT="$ANDROID_HOME/ndk/26.1.10909125"
          export PATH="$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$PATH"

          # Java setup
          export JAVA_HOME="${pkgs.jdk17}"

          # Fix for React Native builds
          export GRADLE_OPTS="-Dorg.gradle.daemon=false"

          # iOS setup (macOS only)
          ${
            if pkgs.stdenv.isDarwin
            then ''
              # Ensure Xcode command line tools are accessible
              export DEVELOPER_DIR="/Applications/Xcode.app/Contents/Developer"

              # CocoaPods setup
              export GEM_HOME="$HOME/.gem"
              export PATH="$GEM_HOME/bin:$PATH"
            ''
            else ""
          }

          # Node.js memory optimization
          export NODE_OPTIONS="--max-old-space-size=4096"

          # Create local Android config if not exists
          if [ ! -f "android/local.properties" ] && [ -d "android" ]; then
            echo "sdk.dir=$ANDROID_HOME" > android/local.properties
            echo "ndk.dir=$ANDROID_NDK_ROOT" >> android/local.properties
          fi

          echo ""
          echo "🚀 React Native Development Environment"
          echo "========================================"
          echo "Node.js:     $(node --version)"
          echo "npm:         $(npm --version)"
          echo "Yarn:        $(yarn --version)"
          echo "Java:        $(java --version 2>&1 | head -n 1)"
          echo "Ruby:        $(ruby --version)"
          echo "Firebase:    $(firebase --version)"
          echo ""
          echo "Android SDK: $ANDROID_HOME"
          ${
            if pkgs.stdenv.isDarwin
            then ''
              echo ""
              echo "📱 iOS Development:"
              echo "   Xcode must be installed from the App Store"
              echo "   Run 'sudo xcode-select -s /Applications/Xcode.app' if needed"
              echo "   CocoaPods: $(pod --version 2>/dev/null || echo 'Run: gem install cocoapods')"
            ''
            else ""
          }
          echo ""
        '';

        # Environment variables
        LANG = "en_US.UTF-8";
        LC_ALL = "en_US.UTF-8";
      };
    });
}
