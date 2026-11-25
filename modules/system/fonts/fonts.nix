{
  flake.modules.homeManager.fonts = {pkgs, ...}: {
    home.packages = with pkgs; [
      # Fonts/Styling
      iosevka-comfy.comfy
      nerd-fonts.iosevka
      nerd-fonts.jetbrains-mono
      bibata-cursors
    ];
  };
}
