# niri scrollable-tiling compositor; config.kdl mirrors the Hyprland config and binds in ../hyprland.
{
  flake.modules.nixos.niri = {pkgs, ...}: {
    programs.niri.enable = true;
    # niri auto-spawns this for X11 clients (wezterm enable_wayland=false, Lucid emacs).
    environment.systemPackages = [pkgs.xwayland-satellite];
  };

  flake.modules.homeManager.niri = {pkgs, ...}: {
    xdg.configFile."niri/config.kdl".source = ./config.kdl;
    # Used by the kill / magic-workspace binds in config.kdl.
    home.packages = [pkgs.jq];
  };
}
