# Noctalia Greeter on greetd; lists every installed Wayland session (Hyprland, niri).
{
  flake.modules.nixos.noctalia-greeter = {pkgs, ...}: {
    services.displayManager.noctalia-greeter = {
      enable = true;
      cursorTheme = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
      };
      settings.keyboard.layout = "us";
    };
  };
}
