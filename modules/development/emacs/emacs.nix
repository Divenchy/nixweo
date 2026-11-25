# Emacs: weomacs config (home-manager) and the emacs daemon (NixOS).
{inputs, ...}: {
  flake.modules.nixos.emacs = {
    services.emacs = {
      enable = true;
    };
  };

  flake.modules.homeManager.emacs = {
    imports = [inputs.weomacs-flake.homeManagerModules.default];
  };
}
