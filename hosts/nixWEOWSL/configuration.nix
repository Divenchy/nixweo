{ inputs, lib, config, pkgs, ... }:

{
  imports =
    [ ./hardware-configuration.nix
      inputs.home-manager.nixosModules.home-manager
    ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.weo = import ./home.nix { inherit inputs lib config pkgs; };
  };

  # Disable bootloader: WSL boots via Windows boot manager
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = false;

  # No graphical environment in WSL by default
  services.xserver.enable = false;
  services.displayManager.gdm.enable = false;
  services.desktopManager.gnome.enable = false;

  # Kernel: use default WSL kernel provided by Windows
  boot.kernelPackages = pkgs.linuxPackages;

  networking.hostName = "nixweowsl";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Chicago";

  i18n.defaultLocale = "en_US.UTF-8";

  # Minimal locale settings
  i18n.extraLocaleSettings = {
    LC_TIME = "en_US.UTF-8";
  };

  users.users.weo = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };

  # Disable sound, printing, and other services not typically available on WSL
  services.printing.enable = false;
  services.pulseaudio.enable = false;
  services.pipewire.enable = false;

  # Keep nixpkgs unfree allowed and overlays if you want
  nixpkgs.config.allowUnfree = true;

  # Experimental nix features
  nix.settings.experimental-features = "nix-command flakes";

  environment.systemPackages = with pkgs; [
    vim git wget curl
    # Add any CLI tools you want here
  ];

  # Enable home-manager for user 'weo'
  programs.home-manager.enable = true;

  system.stateVersion = "25.05";
}

