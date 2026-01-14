{ inputs, ...}:

{
  imports = [
    inputs.nvf.homeManagerModules.default
    ./configuration.nix
  ];

  programs.nvf.enable = true;
}
