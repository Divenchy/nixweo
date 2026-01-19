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
        action = "gT";
        desc = "Go to prev tab";
      };

      "L" = {
        action = "gt";
        desc = "Go to next tab";
      };
    };
  };
}
