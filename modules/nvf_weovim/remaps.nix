{
  programs.nvf.settings.vim.leader = " ";

  programs.nvf.settings.vim.keymaps = [
    {
      mode = [ "n" "v" ];
      key = "<leader>y";
      action = "\"+y";
    }
    {
      mode = "n";
      key = "<leader>w";
      action = ":w<CR>";
      options = {
        noremap = true;
        silent = true;
      };
    }

    {
      mode = "n";
      key = "<leader>q";
      action = ":q<CR>";
    }

    {
      mode = "n";
      key = "<C-h>";
      action = "<C-w>h";
    }
  ];
}
