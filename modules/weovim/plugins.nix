{pkgs, ...}:
{
  lazy.plugins = {
    oil-nvim = {
      package = pkgs.vimPlugins.oil-nvim;

      setupModule = "oil";
      setupOpts = {
        # Oil.nvim options here
        default_file_explorer = true;
        columns = ["icon"];
        view_options = {
          show_hidden = true;
        };
      };

      after = "print('Oil loaded')";
    };
  };
  
  extraPlugins = {
    harpoon = {
      package = pkgs.vimPlugins.harpoon;
      setup = "require('harpoon').setup {}";
    };
  };
}
