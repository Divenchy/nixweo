# nixweosl: the terminal-only dev user on WSL.
{config, ...}: let
  inherit (config.flake.modules) homeManager;
in {
  flake.modules.nixos.nixweosl = {pkgs, ...}: {
    wsl.defaultUser = "nixweosl";

    users.users.nixweosl = {
      isNormalUser = true;
      extraGroups = ["sudo"];
      shell = pkgs.zsh;
    };

    home-manager.users.nixweosl = homeManager.nixweosl;
  };

  flake.modules.homeManager.nixweosl = {
    imports = with homeManager; [
      packages
      claude-code
      emacs
      fonts
    ];

    home.username = "nixweosl";
    home.homeDirectory = "/home/nixweosl";
    home.stateVersion = "26.05";
  };
}
