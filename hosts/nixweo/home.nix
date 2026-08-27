{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule
    inputs.weomacs-flake.homeManagerModules.default
    inputs.hyprland-flake.homeManagerModules.default
    inputs.wezterm-flake.homeManagerModules.default
    inputs.caelestia-shell.homeManagerModules.default
  ];

  home = {
    username = "weo";
    homeDirectory = "/home/weo";
    stateVersion = "26.05"; # Read docs before changing.

    packages = with pkgs; [
      # Desktop Applications
      audacity
      lyx
      kdePackages.okular
      imagemagick
      simulide
      freecad
      discord
      spotify
      kdePackages.dolphin
      firefox
      obs-studio
      davinci-resolve
      inkscape
      gimp3
      brave
      xournalpp
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

      # Tooling/Libs/System
      texliveFull
      inetutils
      dualsensectl
      llvm
      gcc-arm-embedded
      gnumake
      freetype
      bison
      flex
      valgrind
      gcc
      (lib.lowPrio gdb)
      cmake
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

      # Langs
      odin
      zigpkgs.master
      zls
      nim
      cargo
      rustc
      rust-analyzer
      sbcl
      beamPackages.erlang
      beamPackages.elixir
      gleam
      (python313.withPackages (ps:
        with ps; [
          tkinter
          matplotlib
          pandas
        ]))
      go
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
