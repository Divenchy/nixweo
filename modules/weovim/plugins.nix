{pkgs, ...}: let
  oil-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "oil.nvim";
    version = "2.15";
    src = pkgs.fetchFromGitHub {
      owner = "stevearc";
      repo = "oil.nvim";
      rev = "6b59a6cf623fa2245c7454ddb458df5bdb6615d3";
      sha256 = "sha256-ULtIh+rY2m7OHC2U4bOBN/OcP5Uh0YgGa/Kgnke95Q0=";
    };
  };

  smear-cursor-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "smear-cursor.nvim";
    version = "0.6";
    src = pkgs.fetchFromGitHub {
      owner = "sphamba";
      repo = "smear-cursor.nvim";
      rev = "c85bdbb25db096fbcf616bc4e1357bd61fe2c199";
      sha256 = "sha256-Uz79FiDF1EF/IPj35PImkRuudZBARWDUEEbTdT4/Tbs=";
    };
  };

  modes-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "modes.nvim";
    version = "0.3";
    src = pkgs.fetchFromGitHub {
      owner = "mvllow";
      repo = "modes.nvim";
      rev = "0932ba4e0bdc3457ac89a8aeed4d56ca0b36977a";
      sha256 = "sha256-SXx1S/yBDTddb/oncHmfvpdO2oUNbgUjBItnudDAIE8=";
    };
  };

  oilLuaConfig = ./lua/oil.lua;
  modesLuaConfig = ./lua/modes.lua;
  smearCursorLuaConfig = ./lua/smear.lua;
  telescopeLuaConfig = ./lua/telescope.lua;
  leapLuaConfig = ./lua/leap.lua;
in {
  lazy.plugins = {
    "oil.nvim" = {
      package = oil-nvim;
      lazy = false;
      after = ''dofile("${oilLuaConfig}")'';
    };
    "modes.nvim" = {
      package = modes-nvim;
      lazy = false;
      after = ''dofile("${modesLuaConfig}")'';
    };
  };

  extraPlugins = {
    smear-cursor = {
      package = smear-cursor-nvim;
      setup = ''dofile("${smearCursorLuaConfig}")'';
    };

    leap = {
      package = pkgs.vimPlugins.leap-nvim;
      setup = ''dofile("${leapLuaConfig}")'';
    };

    plenary = {
      package = pkgs.vimPlugins.plenary-nvim;
    };

    harpoon = {
      package = pkgs.vimPlugins.harpoon2;
      setup = ''
        local harpoon = require('harpoon')
        harpoon:setup({
            settings = {
                save_on_toggle = true
            }
        })
      '';
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
