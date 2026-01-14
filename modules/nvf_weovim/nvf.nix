{ inputs, lib,  ...}:

{
  imports = [
    inputs.nvf.nixosModules.default
    ./configuration.nix
    ./plugins.nix
    ./remaps.nix
  ];

  programs.nvf.enable = true;
}
