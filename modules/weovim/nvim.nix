{ config, pkgs, inputs, ... }:

{
  config = {
    # If this is for NixOS:
    programs.neovim = {
      enable = true;
      package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
      viAlias = true;
      defaultEditor = true;
    };
  };
}

