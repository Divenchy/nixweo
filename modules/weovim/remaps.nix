{pkgs, ...}: {
  maps = {
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
    };
  };
}
