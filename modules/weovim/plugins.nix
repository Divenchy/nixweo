{pkgs, ...}:

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
    harpoon = {
      package = pkgs.vimPlugins.harpoon;
      setup = "require('harpoon').setup {}";
    };
    
    nvim-web-devicons = {
      package = pkgs.vimPlugins.nvim-web-devicons;
      setup = "require('nvim-web-devicons').setup {}";
    };
  };
}
