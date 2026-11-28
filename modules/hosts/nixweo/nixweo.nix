# nixweo: desktop/laptop install, full environment + Hyprland desktop.
{
  inputs,
  config,
  ...
}: let
  inherit (config.flake.modules) nixos;
in {
  flake.nixosConfigurations.nixweo = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {inherit inputs;};
    modules = [nixos.nixweo];
  };

  flake.modules.nixos.nixweo = {pkgs, ...}: let
    # Machine-local, gitignored files live in hosts/nixweo/. Generate the hardware config with:
    #   sudo nixos-generate-config --show-hardware-config > hosts/nixweo/hardware-configuration.nix
    # and build with a `path:` flake ref so the untracked file is visible to the flake:
    #   sudo nixos-rebuild switch --flake path:.#nixweo
    hwConfig = ../../../hosts/nixweo/hardware-configuration.nix;
    localConfig = ../../../hosts/nixweo/local.nix;
  in {
    imports =
      [
        (
          if builtins.pathExists hwConfig
          then hwConfig
          else
            throw ''
              Missing hardware-configuration.nix for this host.
              Generate it with `sudo nixos-generate-config --show-hardware-config > hosts/nixweo/hardware-configuration.nix`
              and rebuild with `--flake path:.#nixweo` (git+file refs skip untracked files).
            ''
        )
        nixos.overlays
        nixos.base
        nixos.nix
        nixos.home-manager
        nixos.weovim
        nixos.zsh
        nixos.emacs
        nixos.docker
        nixos.libvirt
        nixos.keyd
        nixos.desktop
        nixos.weo
        # Opt-in hardware profiles, selected per machine in the untracked local.nix
        nixos.cpu-amd
        nixos.nvidia-prime
        nixos.asus-laptop
      ]
      ++ (
        if builtins.pathExists localConfig
        then [localConfig]
        else []
      );

    # Bootloader.
    boot = {
      loader = {
        grub = {
          enable = true;
          fontSize = 40;
          efiSupport = true;
          device = "nodev";
          useOSProber = true;
        };
        systemd-boot.enable = false;
        efi.canTouchEfiVariables = true;
      };
      kernelPackages = pkgs.linuxPackages_latest;
      kernelModules = ["kvm" "acpi"];
      kernelParams = [
        # "processor.max_cstate=5"
      ];
    };

    networking = {
      hostName = "nixweo";
      wireless.enable = true; # wpa_supplicant
      networkmanager.enable = true;
      # Configure network proxy if necessary
      # proxy.default = "http://user:password@proxy:port/";
      # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

      # Open ports in the firewall.
      # firewall.allowedTCPPorts = [ ... ];
      # firewall.allowedUDPPorts = [ ... ];
      # Or disable the firewall altogether.
      # firewall.enable = false;
    };

    # Set time zone.
    time.timeZone = "America/Chicago";

    #i18n. Select internationalisation properties.
    i18n = {
      defaultLocale = "en_US.UTF-8";
      extraLocaleSettings = {
        LC_ADDRESS = "en_US.UTF-8";
        LC_IDENTIFICATION = "en_US.UTF-8";
        LC_MEASUREMENT = "en_US.UTF-8";
        LC_MONETARY = "en_US.UTF-8";
        LC_NAME = "en_US.UTF-8";
        LC_NUMERIC = "en_US.UTF-8";
        LC_PAPER = "en_US.UTF-8";
        LC_TELEPHONE = "en_US.UTF-8";
        LC_TIME = "en_US.UTF-8";
      };
    };

    services = {
      upower.enable = true;
      udisks2.enable = true;
      acpid.enable = true;
      ntp.enable = true;
      tailscale.enable = true;
      openssh.enable = true;
    };

    powerManagement = {
      enable = true;
    };

    environment.systemPackages = with pkgs; [
      man-pages
      xclip
      alsa-utils

      # CLI Tools
      vim
      unzip
      openconnect
      networkmanager-openconnect
      git-lfs
      lm_sensors

      # Tooling/Libs/System
      acpi
      upower
      wtype
    ];
  };
}
