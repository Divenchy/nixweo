{
  description = "Basic Neovim Configuration For A Weo";
  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nvf.url = "github:NotAShelf/nvf";
  };
  
  outputs = { self, nixpkgs, nvf }: {
    nixosModules.default = { config, pkgs, lib, ... }: {
      imports = [ nvf.nixosModules.default ];
      programs.nvf.enable = true;
      programs.nvf.settings.vim = import ./nvim.nix;
      programs.nvf.config.vim = import ./lazy.nix;
    };
  };
}
