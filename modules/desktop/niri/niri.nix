# niri scrollable-tiling compositor; config.kdl is niri's default config adapted for Noctalia.
{
  flake.modules.nixos.niri = {
    programs.niri.enable = true;
  };

  flake.modules.homeManager.niri = {
    xdg.configFile."niri/config.kdl".source = ./config.kdl;
  };
}
