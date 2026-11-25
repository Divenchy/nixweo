{pkgs, ...}: {
  maps = {
    terminal = {
      "<C-a>" = {
        action = "<C-\\><C-n>";
        desc = "Exit terminal insert mode";
      };
    };

    normal = {
      "-" = {
        action = "<CMD>Oil<CR>";
        desc = "Open parent directory";
      };

      "<C-n>" = {
        action = "j";
        desc = "Give emacs movement";
      };

      "<C-p>" = {
        action = "k";
        desc = "Give emacs movement";
      };

      "H" = {
        action = ":bprev<CR>";
        desc = "Go to prev tab";
      };

      "L" = {
        action = ":bnext<CR>";
        desc = "Go to next tab";
      };

      "<leader>ce" = {
        action = ":colorscheme base16-everforest<CR>";
        desc = "Change theme to everforest";
      };

      "<leader>cp" = {
        action = ":colorscheme base16-rose-pine-dawn<CR>";
        desc = "Change theme to rose-pine-light";
      };

      "<leader>cn" = {
        action = "base16-tokyo-night-storm<CR>";
        desc = "Change theme to tokyo night";
      };
    };
  };
}
