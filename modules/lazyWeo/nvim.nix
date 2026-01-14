{ configs, pkgs, inputs, lib,  ...}:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
  };
}
