{
  description = "Basic Neovim Configuration For A Weo";
  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nvf.url = "github:NotAShelf/nvf";
  };
  
  outputs = { self, nixpkgs, nvf }: {
    nixosModules.default = { config, pkgs, lib, ... }:
      let
        nvfLib = nvf.lib;
      in
      {
      imports = [ nvf.nixosModules.default ];
      programs.nvf.enable = true;
      programs.nvf.settings.vim = lib.mkMerge [
        (import ./nvim.nix { inherit pkgs lib; nvfLib = nvfLib; })
        (import ./plugins.nix { inherit pkgs; })
        (import ./remaps.nix { inherit pkgs; })
      ];
    };
  };
}
