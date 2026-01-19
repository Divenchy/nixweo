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

  oilLuaConfig = ./lua/oil.lua;
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
    which-key-nvim = {
      package = pkgs.vimPlugins.which-key-nvim;
      setup = ''dofile("${whichKeyLuaConfig}")'';
    };

    plenary = {
      package = pkgs.vimPlugins.plenary-nvim;
    };

    telescope = {
      package = pkgs.vimPlugins.telescope-nvim;
      setup = ''dofile("${telescopeLuaConfig}")'';
    };

    telescope-fzf-native = {
      package = pkgs.vimPlugins.telescope-fzf-native-nvim;
    };

    telescope-ui-select = {
      package = pkgs.vimPlugins.telescope-ui-select-nvim;
    };
  };
}
