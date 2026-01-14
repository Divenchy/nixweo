{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    inputs.nvf.nixosModules.default
    ./configuration.nix
  ];

  programs.nvf.enable = true;
}
