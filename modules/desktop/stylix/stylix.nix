# System-wide theming; wallpapers live in ./wallpapers.
{inputs, ...}: {
  flake.modules.nixos.stylix = {
    lib,
    pkgs,
    ...
  }: {
    imports = [inputs.stylix.nixosModules.stylix];

    stylix = {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
      image = ./wallpapers/chinese_jade_mountains.jpg;
      polarity = "dark";
      targets.qt.platform = lib.mkForce "qtct";

      fonts = {
        sizes = {
          desktop = 24;
          terminal = 30;
        };

        serif = {
          package = pkgs.nerd-fonts.iosevka;
          name = "Iosevka Nerd Font";
        };

        sansSerif = {
          package = pkgs.nerd-fonts.iosevka;
          name = "Iosevka Nerd Font";
        };

        monospace = {
          package = pkgs.nerd-fonts.iosevka;
          name = "Iosevka Nerd Font";
        };
      };
    };
  };

  flake.modules.homeManager.stylix = {
    stylix.targets.emacs.enable = false;
    # Noctalia draws the wallpaper; stop Stylix from starting hyprpaper.
    stylix.targets.hyprland.hyprpaper.enable = false;
  };
}
