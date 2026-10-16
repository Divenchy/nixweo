{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/common/packages.nix
    ../../modules/common/claude-knowledge.nix
    inputs.weomacs-flake.homeManagerModules.default
  ];

  home.username = "nixweosl";
  home.homeDirectory = "/home/nixweosl";
  home.stateVersion = "26.05";

  # Host-specific packages; shared CLI tools, libs and languages come from modules/common/packages.nix
  home.packages = with pkgs; [
    # Fonts/Styling
    iosevka-comfy.comfy
    nerd-fonts.iosevka
    nerd-fonts.jetbrains-mono
    bibata-cursors
  ];
}
