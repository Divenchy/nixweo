{ pkgs, ... }:

{
  programs.nvf.settings.vim.extraPlugins = with pkgs.vimPlugins; [
    aerial-nvim
    harpoon
  ];
  
}
