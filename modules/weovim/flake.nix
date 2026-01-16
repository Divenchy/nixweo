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
      programs.nvf.settings.vim = lib.mkMerge [
        (import ./nvim.nix { inherit pkgs; })
        (import ./plugins.nix { inherit pkgs; })
      ];
    };
  };
}
