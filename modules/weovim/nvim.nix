{nvfLib, lib, ... }:
let
  inherit (nvfLib.nvim.dag) entryAnywhere entryAfter entryBefore;
in
{
  viAlias = true;
  vimAlias = true;

  # Set leader key
  globals = {
    mapleader = " "; # Space as leader
    maplocalleader = ","; # Comma as local leader (optional)
  };

  ###### OPTIONS  #######
  options = {
    guicursor = "";
    mouse = "a";
    
    number = true;
    relativenumber = true;

    tabstop = 2;
    softtabstop = 2;
    shiftwidth = 2;
    expandtab = true;
    cursorline = true;

    smartindent = true;
    breakindent = true;
    showmode = false;

    ignorecase = true;
    smartcase = true;

    wrap = false;

    swapfile = false;
    backup = false;

    termguicolors = true;

    scrolloff = 20;
    signcpolumn = "yes";
  };

  luaConfigRC = {
    custom-options = entryAnywhere (builtins.readFile ./lua/options.lua);
    custom-remaps = entryAnywhere (builtins.readFile ./lua/remaps.lua);
    custom-autocmds = entryAnywhere (builtins.readFile ./lua/auAutocmds.lua);
  };  

  statusline.lualine.enable = true;
  telescope.enable = true;
  treesitter.enable = true;
  autocomplete.nvim-cmp.enable = true;
  git.enable = true;

  ###### LSP  #######

  lsp = {
    enable = true;
    formatOnSave = true;
  };

  languages = {
    enableTreesitter = true;
    nix.enable = true;
    rust.enable = true;
    zig.enable = true;
    clang.enable = true;
    csharp.enable = true;
  };
}
