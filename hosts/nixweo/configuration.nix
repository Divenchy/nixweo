{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
    ../../modules/zsh/zsh.nix
    ./packages/godot_4_6.nix
  ];

  services.acpid.enable = true;

  # Tell logind to ignore lid switches (let acpid handle them)
  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchDocked = "ignore";
    HandleLidSwitchExternalPower = "ignore";
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd start-hyprland";
        user = "greeter";
      };
      initial_session = {
        command = "start-hyprland";
        user = "weo";
      };
    };
  };

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
    image = ../../resources/wallpapers/chinese_jade_mountains.jpg;
    polarity = "dark";
    targets.qt.platform = lib.mkForce "qtct";

    fonts = {
      sizes = {
        desktop = 24;
        terminal = 30;
      };

      serif = {
        package = pkgs.nerd-fonts.iosevka;
        name = "Iosevka Nerd Font";
      };

      sansSerif = {
        package = pkgs.nerd-fonts.iosevka;
        name = "Iosevka Nerd Font";
      };

      monospace = {
        package = pkgs.nerd-fonts.iosevka;
        name = "Iosevka Nerd Font";
      };
    };
  };

  home-manager = {
    backupFileExtension = "backup";
    useGlobalPkgs = true;
    useUserPackages = true;
    users.weo = import ./home.nix {
      inherit
        inputs
        lib
        pkgs
        config
        ;
    };
  };

  services.xserver.videoDrivers = ["nvidia"];

  # Bootloader.
  boot.loader.grub = {
    enable = true;
    fontSize = 40;
    efiSupport = true;
    device = "nodev";
    useOSProber = true;
  };
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [
    "kvm"
    "kvm_amd"
    "acpi"
    "acpi_call"
  ];

  # NVIDIA suspend support
  boot.kernelParams = [
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    "nvidia.NVreg_TemporaryFilePath=/var/tmp"
  ];
  boot.extraModulePackages = with config.boot.kernelPackages; [
    acpi_call
  ];

  networking.hostName = "nixos"; # Define your hostname.
  networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    wireplumber = {
      enable = true;
      configPackages = [
        (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/10-disable-camera.conf" ''
          wireplumber.profiles = {
            main = {
              monitor.libcamera = disabled
            }
          }
        '')
      ];
    };

    extraConfig.pipewire."92-low-latency" = {
      context.properties = {
        default.clock.rate = 48000;
        default.clock.quantum = 1024;
        default.clock.min-quantum = 512;
        default.clock.max-quantum = 2048;
      };
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];
    config = {
      common = {
        default = ["hyprland" "gtk"];
      };
      hyprland = {
        default = ["hyprland" "gtk"];
      };
    };
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.weo = {
    isNormalUser = true;
    description = "weo";
    extraGroups = [
      "sudo"
      "networkmanager"
      "wheel"
      "audio"
      "libvirtd"
      "kvm"
      "input"
    ];
    shell = pkgs.zsh;
  };

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "weo";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  nixpkgs = {
    overlays = [
    ];

    config = {
      allowUnfree = true;
    };
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Opinionated: disable global registry
      flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };
    # Opinionated: disable channels
    channel.enable = false;

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    git-lfs
    cmake
    fastfetch
    wl-clipboard
    xclip
    wireplumber
    pipewire
    wget
    hyprland
    hyprpaper
    kitty
    alsa-utils
    qemu_kvm
    remmina
    virt-manager
    virt-viewer
    spice
    spice-gtk
    spice-protocol
    swtpm
    virtio-win
    win-spice
    adwaita-icon-theme
    networkmanager-openconnect
    openconnect
    unzip
    vimPlugins.nvim-treesitter-textobjects
    vimPlugins.nvim-treesitter
    acpi
    powertop
    upower
    wtype
    direnv
  ];

  environment.variables = {
    XCURSOR_THEME = "Bibata-Modern-Ice";
    XCURSOR_SIZE = "24";
    XCURSOR_PATH = lib.mkForce "${pkgs.bibata-cursors}/share/icons";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {

  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.keyd = {
    enable = true;

    keyboards.default = {
      ids = ["0b05:19b6"]; # Matches all keyboards
      settings = {
        main = {
          capslock = "\\";
          rightalt = "layer(weomods)";
        };

        "weomods:C" = {
          space = "backspace";
          h = "left";
          j = "down";
          k = "up";
          l = "right";

          q = "@";
          w = "=";
          e = "-";
          r = "'";
          a = "(";
          s = ")";
          d = "[";
          f = "]";
          g = "%";

          x = "$";
          c = "^";
          v = "`";
        };

        "weomods+shift" = {
          q = "&";
          a = "!";
          s = "?";
          g = "#";
          c = "*";
        };

        "weomods+alt" = {
          a = "1";
          s = "2";
          d = "3";
          f = "4";
          g = "5";
          h = "6";
          j = "7";
          k = "8";
          l = "9";
          ";" = "0";
        };
      };
    };
  };

  services.emacs = {
    enable = true;
  };

  services.upower.enable = true;

  services.blueman.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  programs.hyprland.enable = true;
  #programs.hyprland.package = inputs.hyprland.packages."${pkgs.system}".hyprland;

  # Zsh setup
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };

  # Virtualization
  programs.dconf.enable = true;

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        swtpm.enable = true;
      };
    };
    spiceUSBRedirection.enable = true;
  };
  services.spice-vdagentd.enable = true;

  systemd.sleep.extraConfig = ''
    AllowSuspend=yes
    AllowHibernation=yes
    AllowSuspendThenHibernate=yes
    AllowHybridSleep=yes
  '';

  # Power management
  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  powerManagement.powerUpCommands = ''
    # Disable USB wake that might prevent suspend
    if [ -e /proc/acpi/wakeup ]; then
      echo XHC0 > /proc/acpi/wakeup 2>/dev/null || true
      echo XHC1 > /proc/acpi/wakeup 2>/dev/null || true
    fi
  '';

  system.stateVersion = "25.05"; # Did you read the comment?
}
