{pkgs, ...}:
{
  lazy.plugins = {
    oil.nvim = {
      package = oil-nvim;

      setupModule = "oil";
      setupOps = {option_name = false;};

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
