{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.hyprland-flake.homeManagerModules.default
    inputs.wezterm-flake.homeManagerModules.default
    inputs.caelestia-shell.homeManagerModules.default
    inputs.weomacs-flake.homeManagerModules.default
  ];

  home = {
    username = "weo";
    homeDirectory = "/home/weo";
    stateVersion = "26.05";

    packages = with pkgs; [
      # Desktop Applications
      audacity
      kdePackages.okular
      imagemagick
      simulide
      freecad
      discord
      spotify
      kdePackages.dolphin
      firefox
      obs-studio
      inkscape
      gimp3
      brave
      wezterm
      godot
      vlc

      # WM Extensibility
      hyprshot
      grimblast
      grim
      slurp
      kitty
      wl-clipboard
      xdg-desktop-portal
      xdg-desktop-portal-wlr
      foot
      bemenu

      # Fonts/Styling
      iosevka-comfy.comfy
      nerd-fonts.iosevka
      nerd-fonts.jetbrains-mono
      bibata-cursors
      nwg-look

      # CLI Tools
      fossil
      (pkgs.callPackage ../../derivs/ada_language_server.nix {})
      man-pages
      xclip
      wget
      fastfetch
      fzf
      zoxide
      tree
      hugo
      eza
      brightnessctl
      bat
      ranger
      git
      btop
      lazygit
      unzip
      zip
      fd
      ripgrep
      starship
      asusctl
      zenmonitor
      nvtopPackages.full

      # Tooling/Libs/System
      texliveFull
      inetutils
      dualsensectl
      llvm
      gnumake
      freetype
      bison
      flex
      ninja
      tree-sitter
      networkmanager-openconnect
      ffmpeg
      nil
      systemd.dev
      pkg-config
      picotool
      glfw
      vulkan-headers
      libGL
      mesa
      vulkan-tools

      ## Main Langs ##

      # ATS
      gmp
      ats2

      # .NET
      dotnet-sdk_11
      netcoredbg

      # C / ASM
      nasm
      gcc-arm-embedded
      (lib.lowPrio gdb)
      cmake
      valgrind

      # Ada
      gnat # provides gcc
      gprbuild

      # Odin
      odin

      # Zig
      zigpkgs."0.17.0"
      (pkgs.writeShellScriptBin "zigmaster" ''
        exec ${pkgs.zigpkgs.master}/bin/zig "$@"
      '')
      zls

      # Elixir
      beamPackages.erlang
      beamPackages.elixir

      # Other
      cargo
      rustc
      rust-analyzer
      jdk25
      gleam
      (python313.withPackages (ps:
        with ps; [
          tkinter
          matplotlib
          pandas
        ]))
      go

      #IDEs
      jetbrains.rider
      jetbrains.datagrip
    ];

    sessionVariables = {
      EDITOR = "emacs";
    };
  };

  home.file.".config/starship.toml".source = builtins.path {
    path = ../../resources/starship/configuration.toml;
    name = "starship-config";
  };

  home.file = {
    ".config/waybar/config.jsonc".source = ../../resources/waybar/config.jsonc;
    ".config/waybar/style.css".source = ../../resources/waybar/style.css;
  };

  gtk = {
    enable = true;
    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };
  };

  qt = {
    enable = true;
  };

  services = {
    hyprpaper = {
      enable = true;
      settings = {
        preload = ["${config.stylix.image}"];
        wallpaper = [",${config.stylix.image}"]; # , means all monitors
      };
    };
  };

  programs = {
    git.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    caelestia = {
      enable = true;
      systemd = {
        enable = false; # if you prefer starting from your compositor
        target = "graphical-session.target";
        environment = [];
      };
      settings = {
        general = {
          idle = {
            lockBeforeSleep = false;
            inhibitWhenAudio = true;
            timeouts = [
              {
                timeout = 900; # 10 minutes
                idleAction = "dpms off";
                returnAction = "dpms on";
              }
              {
                timeout = 1800; # 15 minutes
                idleAction = ["systemctl" "suspend-then-hibernate"];
              }
            ];
          };
        };
        bar.persistent = false;
        bar.statusIcons = [
          {
            id = "lockStatus";
            enabled = true;
          }
          {
            id = "network";
            enabled = true;
          }
          {
            id = "bluetooth";
            enabled = true;
          }
          {
            id = "battery";
            enabled = false;
          }
        ];
        paths.wallpaperDir = "~/Images";
      };
      cli = {
        enable = true;
        settings = {
          theme.enableGtk = false;
        };
      };
    };
  };
}
