{ config, pkgs, lib, ... }:

{
  programs.nvf.settings.vim = {
    viAlias = true;
    
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
      enableTreesitter = true;

      nix.enable = true;
      rust.enable = true;
      zig.enable = true;
      clang.enable = true;
      python.enable = true;
      csharp.enable = true;
    };
  };
}
