{ inputs, lib, config, pkgs, ... }:

{
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
  
  # Install pkgs into env
  home.packages = with pkgs ; [
    steam discord spotify xfce.thunar firefox keyd obs-studio davinci-resolve inkscape gimp3
    slack brave
    fastfetch fzf zoxide tree eza brightnessctl bat freetype ranger ffmpeg
    rofi rofi-bluetooth rofi-power-menu hyprshot
    rofi-file-browser rofi-calc xournalpp nwg-look
    wezterm waybar grimblast grim xclip networkmanager-openconnect
    wl-clipboard xdg-desktop-portal xdg-desktop-portal-wlr
    git btop bison flex gcc gdb vim zig python314 cmake ninja lazygit fd ripgrep sbcl
    iosevka-comfy.comfy nerd-fonts.iosevka nerd-fonts.jetbrains-mono
    bibata-cursors
  ];

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
}
