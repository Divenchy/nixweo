{ inputs, lib, config, pkgs, ... }:

{
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule
    inputs.weomacs-flake.homeManagerModules.default
    inputs.hyprland-flake.homeManagerModules.default
  ];

  home.username = "weo";
  home.homeDirectory = "/home/weo";
  home.stateVersion = "25.05"; # Read docs before changing.
  programs.git.enable = true;
  
  # Install pkgs into env
  home.packages = with pkgs ; [
    steam discord spotify xfce.thunar firefox
    rofi-wayland rofi-bluetooth rofi-power-menu
    rofi-file-browser rofi-calc
    wezterm waybar grimblast grim xclip
    wl-clipboard xdg-desktop-portal xdg-desktop-portal-wlr
    git btop bison flex gcc vim zig
    iosevka-comfy.comfy
    nerd-fonts.iosevka
    nerd-fonts.jetbrains-mono
  ];

  home.sessionVariables = {
    EDITOR = "emacs";
  };
}
