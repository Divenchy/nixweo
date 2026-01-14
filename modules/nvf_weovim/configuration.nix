{ config, pkgs, lib, ... }:

{
  vim = {
    theme = {
      enable = true;
      name = "gruvbox";
      style = "dark";
    };

    options = {
      number = true;
      relativenumber = true;
      expandtab = true;
      shiftwidth = 4;
      tabstop = 4;
    };

    statusline.lualine.enable = true;
    telescope.enable = true;
    treesitter.enable = true;
    autocomplete.nvim-cmp.enable = true;
    git.enable = true;

    lsp = {
      enable = true;
      formatOnSave = true;
    };
    
    languages = {
      enableLSP = true;
      enableTreesitter = true;

      nix.enable = true;
      rust.enable = true;
      zig.enable = true;
      c.enable = true;
    };
  };
}
