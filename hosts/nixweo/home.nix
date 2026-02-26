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
  ];

  home.username = "weo";
  home.homeDirectory = "/home/weo";
  home.stateVersion = "25.05"; # Read docs before changing.
  programs.git.enable = true;

  home.file.".config/starship.toml".source = builtins.path {
    path = "/home/weo/nixweo/resources/starship/configuration.toml";
    name = "starship-config";
  };

  # Install pkgs into env
  home.packages = with pkgs; [
    # Desktop Applications
    discord
    spotify
    thunar
    firefox
    keyd
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
    waybar
    nwg-look
    rofi
    rofi-bluetooth
    rofi-power-menu
    hyprshot
    grimblast
    grim
    iosevka-comfy.comfy
    nerd-fonts.iosevka
    nerd-fonts.jetbrains-mono
    bibata-cursors
    # CLI Tools
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
    zip
    fd
    ripgrep
    starship
    nix-direnv
    # Tooling/Libs/System
    tree-sitter
    freetype
    networkmanager-openconnect
    ffmpeg
    xdg-desktop-portal
    xdg-desktop-portal-wlr
    nil
    bison
    flex
    gcc
    valgrind
    gdb
    cmake
    ninja

    # Langs
    cargo
    rustc
    rust-analyzer
    inputs.zig-overlay.packages.${pkgs.system}.master
    sbcl
    (python313.withPackages (ps:
      with ps; [
        tkinter
        matplotlib
        pandas
      ]))
    go
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.sessionVariables = {
    EDITOR = "emacs";
  };

  # Waybar setup
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

  services.hyprpaper = {
    enable = true;
    settings = {
      preload = ["${config.stylix.image}"];
      wallpaper = [",${config.stylix.image}"]; # , means all monitors
    };
  };
}
