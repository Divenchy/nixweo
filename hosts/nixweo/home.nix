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
    steam discord spotify wofi wezterm waybar
    git btop bison flex gcc vim
    iosevka-comfy.comfy
    nerd-fonts.iosevka
    nerd-fonts.jetbrains-mono
  ];

  home.sessionVariables = {
    EDITOR = "emacs";
  };

  # Hyprland
  programs.kitty.enable = true;
  wayland.windowManager.hyprland.enable = true;
  # For electron apps
  home.sessionVariables.NIXOS_OZONE_WL = "1";
}
