# Desktop applications with no configuration of their own.
{
  flake.modules.homeManager.apps = {pkgs, ...}: {
    home.packages = with pkgs; [
      # Desktop Applications
      audacity
      kdePackages.okular
      imagemagick
      simulide
      freecad
      discord
      spotify
      firefox
      obs-studio
      inkscape
      gimp3
      brave
      vlc
    ];
  };
}
