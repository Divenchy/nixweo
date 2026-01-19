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

  oilLuaConfig = ./lua/oil.lua;
  smearCursorLuaConfig = ./lua/smear.lua;
  telescopeLuaConfig = ./lua/telescope.lua;
in {
  lazy.plugins = {
    "oil.nvim" = {
      package = oil-nvim;
      lazy = false;
      after = ''dofile("${oilLuaConfig}")'';
    };
  };

  extraPlugins = {
    smear-cursor = {
      "smear-cursor.nvim" = {
        package = smear-cursor-nvim;
        setup = ''dofile("${smearCursorLuaConfig}})'';
      };
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
