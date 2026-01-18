{ pkgs, ... }:

let
  oil-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "oil.nvim";
    version = "2.15";
    src = pkgs.fetchFromGitHub {
      owner = "stevearc";
      repo = "oil.nvim";
      rev = "6b59a6cf623fa2245c7454ddb458df5bdb6615d3"; # or specific commit/tag
      sha256 = "sha256-ULtIh+rY2m7OHC2U4bOBN/OcP5Uh0YgGa/Kgnke95Q0="; # Run once to get the hash, then fill it in
    };
  };
  which-key-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "which-key.nvim";
    version = "3.17";
    src = pkgs.fetchFromGitHub {
      owner = "folke";
      repo = "which-key.nvim";
      rev = "fcbf4eea17cb299c02557d576f0d568878e354a4";
      sha256 = "sha256-rKaYnXM4gRkkF/+xIFm2oCZwtAU6CeTdRWU93N+Jmbc=";
    };
  };

  oilLuaConfig = ./lua/oil.lua;
  whichKeyLuaConfig = ./lua/which_key.lua;
in
{
  lazy.plugins = {
    "oil.nvim" = {
      package = oil-nvim;
      lazy = false;
      after = ''dofile("${oilLuaConfig}")'';
    };
  };

  extraPlugins = {
    harpoon = {
      package = pkgs.vimPlugins.harpoon;
      setup = "require('harpoon').setup {}";
    };

    nvim-web-devicons = {
      package = pkgs.vimPlugins.nvim-web-devicons;
      setup = "require('nvim-web-devicons').setup {}";
    };

    "which-key.nvim" = {
      package = which-key-nvim;
      setup = ''dofile("${whichKeyLuaConfig}")'';
    };
  };
}
