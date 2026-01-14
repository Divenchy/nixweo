{
  config.vim.lazy.plugins = {
    aerial.nvim = {
    # ^^^^^^^^^ this name should match the package.pname or package.name
      package = aerial-nvim;

      setupModule = "aerial";
      setupOpts = {option_name = false;};

      after = "print('aerial loaded')";
    };

    harpoon.nvim = {
      package = harpoon-nvim;

      setupModule = "harpoon";

      after = "print('harpoon loaded')";
  };
}
