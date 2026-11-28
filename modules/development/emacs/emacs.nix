# Emacs: weomacs config (home-manager). Everything Emacs lives in the weomacs flake.
{inputs, ...}: {
  flake.modules.homeManager.emacs = {
    imports = [inputs.weomacs-flake.homeManagerModules.default];
  };
}
