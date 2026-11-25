# weo: the full desktop user on nixweo.
{config, ...}: let
  inherit (config.flake.modules) homeManager;
in {
  flake.modules.nixos.weo = {pkgs, ...}: {
    users.users.weo = {
      isNormalUser = true;
      description = "weo";
      extraGroups = [
        "docker"
        "sudo"
        "networkmanager"
        "wheel"
        "audio"
        "libvirtd"
        "kvm"
        "input"
      ];
      shell = pkgs.zsh;
    };

    home-manager = {
      backupFileExtension = "backup";
      users.weo = homeManager.weo;
    };
  };

  flake.modules.homeManager.weo = {pkgs, ...}: {
    imports = with homeManager; [
      packages
      claude-code
      emacs
      starship
      git
      direnv
      fonts
      desktop
    ];

    home = {
      username = "weo";
      homeDirectory = "/home/weo";
      stateVersion = "26.05";

      packages = with pkgs; [
        # Host-specific CLI / hardware tools
        xclip
        brightnessctl
        asusctl
        zenmonitor
        nvtopPackages.full
        dualsensectl
        networkmanager-openconnect

        #IDEs
        jetbrains.rider
        jetbrains.datagrip
      ];

      sessionVariables = {
        EDITOR = "emacs";
      };
    };
  };
}
