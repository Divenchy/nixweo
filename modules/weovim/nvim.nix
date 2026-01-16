{pkgs, ...}:
{
  viAlias = true;
  vimAlias = true;

  # Set leader key
  globals = {
    mapleader = " ";      # Space as leader
    maplocalleader = ","; # Comma as local leader (optional)
  };

  ###### OPTIONS  #######
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
  };
}
