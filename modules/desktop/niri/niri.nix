# niri scrollable-tiling compositor; config.kdl mirrors the Hyprland config and binds in ../hyprland.
{
  flake.modules.nixos.niri = {
    programs.niri.enable = true;
  };

  flake.modules.homeManager.niri = {pkgs, ...}: {
    xdg.configFile."niri/config.kdl".source = ./config.kdl;
    # Used by the kill / magic-workspace binds in config.kdl.
    home.packages = [pkgs.jq];
  };
}
