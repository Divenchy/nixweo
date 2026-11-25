# GTK/Qt toolkits and the Bibata cursor.
{
  flake.modules.nixos.gtk-qt = {
    lib,
    pkgs,
    ...
  }: {
    environment.variables = {
      XCURSOR_THEME = "Bibata-Modern-Ice";
      XCURSOR_SIZE = "24";
      XCURSOR_PATH = lib.mkForce "${pkgs.bibata-cursors}/share/icons";
    };
  };

  flake.modules.homeManager.gtk-qt = {pkgs, ...}: {
    gtk = {
      enable = true;
      cursorTheme = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 24;
      };
    };

    qt = {
      enable = true;
    };

    home.packages = [pkgs.nwg-look];
  };
}
