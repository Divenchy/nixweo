# Hyprland compositor: Lua config in ./config, helper scripts in ./scripts.
{
  flake.modules.nixos.hyprland = {pkgs, ...}: {
    # Registers the Hyprland session with the greeter.
    programs.hyprland.enable = true;

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
      ];
      config = {
        common = {
          default = ["hyprland" "gtk"];
        };
        hyprland = {
          default = ["hyprland" "gtk"];
        };
      };
    };
  };

  flake.modules.homeManager.hyprland = {pkgs, ...}: {
    wayland.windowManager.hyprland = {
      enable = true;
      configType = "lua";
      # extraConfig = builtins.readFile ./config/hyprland.lua;
      extraConfig = ''
        -- Prepend current configuration directory to package.path
        package.path = "${./config}/?.lua;${./config}/lua/?.lua;" .. package.path
        ${builtins.readFile ./config/hyprland.lua}
      '';
    };

    home.packages = with pkgs; [
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
    ];
  };
}
