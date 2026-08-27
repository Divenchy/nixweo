{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
    ./packages/godot_4_6.nix
    ../../modules/zsh/zsh.nix
  ];

  system.stateVersion = "26.05";

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
    kernelModules = ["kvm" "kvm_amd" "acpi" "acpi_call"];
    kernelParams = [
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
      "nvidia.NVreg_TemporaryFilePath=/var/tmp"
    ];
    extraModulePackages = with config.boot.kernelPackages; [acpi_call];
  };

  networking = {
    hostName = "nixos";
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
    xserver = {
      videoDrivers = ["nvidia"];
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
    };

    upower.enable = true;
    udisks2.enable = true;
    acpid.enable = true;
    ntp.enable = true;
    tailscale.enable = true;
    greetd = {
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

    # Enable CUPS to print documents.
    printing.enable = true;

    # Audio
    pulseaudio.enable = false;
    pipewire = {
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
          default.clock = {
            rate = 48000;
            quantum = 1024;
            min-quantum = 512;
            max-quantum = 2048;
          };
        };
      };
    };
    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;
    displayManager.autoLogin.enable = true;
    displayManager.autoLogin.user = "weo";
    openssh.enable = true;

    keyd = {
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
    emacs = {
      enable = true;
    };
    blueman.enable = true;

    postgresql = {
      enable = true;
      package = pkgs.postgresql_18;
      ensureDatabases = ["report_web_test_db"];
      ensureUsers = [
        {
          name = "report_web_test_db";
          ensureDBOwnership = true;
        }
      ];
      authentication = pkgs.lib.mkOverride 10 ''
        # TYPE DATABASE      USER        ADDRESS       METHOD
        local  all           all                       trust
        host   all           all         127.0.0.1/32  trust
        host   all           all         ::1/128       trust
      '';
    };
    # Virtualization
    spice-vdagentd.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Virtualization
  programs.dconf.enable = true;
  virtualisation = {
    docker = {
      enable = true;
    };

    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        swtpm.enable = true;
      };
    };
    spiceUSBRedirection.enable = true;
  };

  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  # Audio
  security.rtkit.enable = true;

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.weo = {
    isNormalUser = true;
    description = "weo";
    extraGroups = [
      "docker"
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

  home-manager = {
    backupFileExtension = "backup";
    useGlobalPkgs = true;
    useUserPackages = true;
    users.weo = import ./home.nix {inherit inputs lib pkgs config;};
  };

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
    man-pages
    xclip
    alsa-utils

    # VM
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

    # CLI Tools
    vim
    unzip
    openconnect
    networkmanager-openconnect
    git-lfs

    # Tooling/Libs/System
    acpi
    powertop
    upower
    wtype
  ];

  environment.variables = {
    XCURSOR_THEME = "Bibata-Modern-Ice";
    XCURSOR_SIZE = "24";
    XCURSOR_PATH = lib.mkForce "${pkgs.bibata-cursors}/share/icons";
  };
}
