{ pkgs, ... }:
let
  optionsLua = ./lua/options.lua;
  remapsLua = ./lua/remaps.lua;
  auAutocmdsLua = ./lua/auAutocmds.lua;
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

  extraConfigLua = ''
  dofile("${optionsLua}")
  dofile("${remapsLua}")
  dofile("${auAutocmdsLua}")
  '';
  

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
