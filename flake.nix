{
  description = "Nixos config flake for a weo.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    home-manager = {
      url = "github:nix-community/home-manager/";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix";

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    hyprland-flake.url = "path:./modules/hyprland";

    quickshell = {
      url = "github:quickshell-mirror/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    weomacs-flake = {
      url = "github:Divenchy/weomacs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    weovim-flake.url = "path:./modules/weovim";
    wezterm-flake.url = "path:./modules/wezterm";

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
    overlays = [
      zig-overlay.overlays.default

      # TEMP: nixos-unstable (7fd4004) ships a stale pnpmDeps hash for
      # typescript-language-server 6.0.2 (pulled in by weomacs). Fixed on nixpkgs
      # master; remove once `nix flake update nixpkgs` picks up the fix.
      (final: prev: {
        typescript-language-server = prev.typescript-language-server.overrideAttrs (old: {
          pnpmDeps = old.pnpmDeps.overrideAttrs {
            outputHash = "sha256-xR/EF60lVBsITKgH7wCM2wHM46PFQevD51KfCENSUH4=";
          };
        });
      })
    ];
    # Systems the flake's per-system outputs (devShells) are generated for.
    # NixOS hosts take their platform from hardware-configuration.nix instead.
    systems = ["x86_64-linux" "aarch64-linux"];
    forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system (pkgsFor system));
    pkgsFor = system:
      import nixpkgs {
        inherit system overlays;
        config = {
          allowUnfree = true;
          android_sdk.accept_license = true;
        };
      };

    androidSdkFor = system:
      android-nixpkgs.sdk.${system} (sdkPkgs:
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
      nixweo = import ./hosts/nixweo {
        inherit nixpkgs stylix weovim-flake overlays inputs outputs;
      };

      nixweosl = import ./hosts/nixweosl {
        inherit nixpkgs weovim-flake overlays inputs outputs;
      };
    };

    devShells = forAllSystems (system: pkgs: {
      zig-ray-lib = import ./devshells/zig_raylib.nix {inherit pkgs;};
      graphics = import ./devshells/graphics.nix {inherit pkgs inputs system;};
      elixir-phoenix = import ./devshells/elixir-phoenix.nix {inherit pkgs;};
    });
  };
}
