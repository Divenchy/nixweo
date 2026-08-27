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
      nixweo = import ./hosts/nixweo {
        inherit nixpkgs stylix weovim-flake overlays inputs outputs;
      };

      nixweosl = import ./hosts/nixweosl {
        inherit nixpkgs weovim-flake overlays system inputs outputs;
      };
    };

    devShells.${system} = {
      zig-ray-lib = import ./devshells/zig_raylib.nix {inherit pkgs self;};
      graphics = import ./devshells/graphics.nix {inherit pkgs inputs system self;};
      elixir-phoenix = import ./devshells/elixir-phoenix.nix {inherit pkgs self;};
    };
  };
}
