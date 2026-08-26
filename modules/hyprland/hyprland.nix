{
  config,
  pkgs,
  lib,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    # extraConfig = builtins.readFile ./hyprland.lua;
    extraConfig = ''
      -- Prepend current configuration directory to package.path
      package.path = "${./.}/?.lua;${./.}/lua/?.lua;" .. package.path
      ${builtins.readFile ./hyprland.lua}
    '';
  };
}
