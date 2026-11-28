# The full graphical desktop: every app in modules/desktop/.
{config, ...}: let
  inherit (config.flake.modules) nixos homeManager;
in {
  flake.modules.nixos.desktop = {
    imports = with nixos; [
      xserver
      noctalia-greeter
      noctalia
      hyprland
      niri
      audio
      bluetooth
      printing
      stylix
      gtk-qt
      godot
    ];

    # programs.niri defaults to niri; keep Hyprland preselected in the greeter.
    services.displayManager.defaultSession = "hyprland";
  };

  flake.modules.homeManager.desktop = {
    imports = with homeManager; [
      hyprland
      niri
      luciole
      zen-browser
      wezterm
      stylix
      gtk-qt
      godot
      apps
    ];
  };
}
