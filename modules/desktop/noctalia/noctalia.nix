# Noctalia desktop shell (bar, launcher, control center, notifications, lock screen).
# Started by each compositor's autostart (Hyprland: config/hyprland.lua, niri: config.kdl).
{
  flake.modules.nixos.noctalia = {
    # recommendedServices stays off: its power-profiles-daemon conflicts with TLP (hardware/asus-laptop).
    programs.noctalia.enable = true;
  };
}
