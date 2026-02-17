{
  nvfLib,
  lib,
  ...
}: let
  inherit (nvfLib.nvim.dag) entryAnywhere entryAfter entryBefore;
in {
  viAlias = true;
  vimAlias = true;

  # Set leader key
  globals = {
    mapleader = " "; # Space as leader
    maplocalleader = ","; # Comma as local leader (optional)
  };

  # theme = {
  #   enable = true;
  #   name = lib.mkForce "base16";
  #   style = "everforest";
  #   # name = "base16-ashes";
  #   # name = "base16-tokyo-night-storm";
  #   # name = "base16-gigavolt";
  #   # name = "base16-gruvbox-material-light-soft";
  #   # name = "base16-edge-light";
  #   # name = "base16-rose-pine-dawn";
  # };

  ###### OPTIONS  #######
  options = {
    guicursor = "";
    mouse = "a";

    number = true;
    relativenumber = true;

    tabstop = 2;
    softtabstop = 2;
    shiftwidth = 2;
    expandtab = true;
    cursorline = true;

    smartindent = true;
    breakindent = true;
    showmode = false;

    ignorecase = true;
    smartcase = true;

    wrap = false;

    swapfile = false;
    backup = false;
    undofile = true;

    hlsearch = true;
    incsearch = true;

    termguicolors = true;

    scrolloff = 20;
    signcolumn = "yes";

    updatetime = 50;
    timeoutlen = 300;

    foldcolumn = "1";
    foldlevel = 99;
    foldlevelstart = 99;
    foldenable = true;

    splitright = true;
    splitbelow = true;

    inccommand = "split";
  };

  luaConfigRC = {
    custom-options = entryAnywhere (builtins.readFile ./lua/options.lua);
    custom-remaps = entryAnywhere (builtins.readFile ./lua/remaps.lua);
    custom-autocmds = entryAnywhere (builtins.readFile ./lua/auAutocmds.lua);
  };

  statusline.lualine.enable = true;

  git = {
    enable = true;
    gitsigns.enable = true;
    gitsigns.codeActions.enable = false;
    neogit.enable = true;
  };

  ###### LSP  #######

  lsp = {
    enable = true;

    formatOnSave = true;
    lspkind.enable = false;
    lightbulb.enable = true;
    lspsaga.enable = false;
    trouble.enable = true;
    lspSignature.enable = false;
    otter-nvim.enable = true;
    nvim-docs-view.enable = true;
    harper-ls.enable = true;
  };

  debugger = {
    nvim-dap = {
      enable = true;
      ui.enable = true;
    };
  };

  languages = {
    enableFormat = true;
    enableTreesitter = true;
    enableExtraDiagnostics = true;

    assembly.enable = true;
    python.enable = true;
    lua.enable = true;
    nix.enable = true;
    rust = {
      enable = true;
      extensions.crates-nvim.enable = true;
    };
    zig.enable = false;
    clang.enable = true;
    csharp.enable = true;
    toml.enable = true;
    yaml.enable = true;
    bash.enable = true;
    json.enable = true;
    sql.enable = true;
    ts.enable = true;
  };

  autocomplete = {
    nvim-cmp.enable = false;
    blink-cmp.enable = false;
  };

  visuals = {
    nvim-web-devicons.enable = true;
    nvim-cursorline.enable = true;
    cinnamon-nvim.enable = true;
    fidget-nvim.enable = true;

    highlight-undo.enable = true;
    indent-blankline.enable = true;

    cellular-automaton.enable = true;
  };

  autopairs.nvim-autopairs.enable = true;

  snippets.luasnip.enable = true;

  tabline = {
    nvimBufferline.enable = true;
  };

  treesitter = {
    enable = true;
    context.enable = true;
  };

  telescope.enable = true;

  binds = {
    whichKey.enable = true;
  };

  notify = {
    nvim-notify.enable = true;
  };

  projects = {
    project-nvim.enable = true;
  };

  utility = {
    vim-wakatime.enable = false;
    icon-picker.enable = true;
    surround.enable = true;
    leetcode-nvim.enable = true;
    multicursors.enable = true;
    smart-splits.enable = true;
    undotree.enable = true;
    nvim-biscuits.enable = false;
    motion = {
      hop.enable = false;
      leap.enable = false;
      precognition.enable = true;
    };
    images = {
      image-nvim.enable = false;
      img-clip.enable = true;
    };
  };

  notes = {
    neorg.enable = false;
    orgmode.enable = false;
    mind-nvim.enable = true;
    todo-comments.enable = true;
  };

  terminal = {
    toggleterm = {
      enable = true;
      lazygit.enable = true;
    };
  };

  ui = {
    borders.enable = true;
    noice.enable = true;
    colorizer.enable = true;
    modes-nvim.enable = false;
    illuminate.enable = true;
    breadcrumbs = {
      enable = true;
      navbuddy.enable = true;
    };
    smartcolumn = {
      enable = true;
      setupOpts.custom_colorcolumn = {
        # this is a freeform module, it's `buftype = int;` for configuring column position
        nix = "110";
      };
    };
    fastaction.enable = true;
  };

  comments = {
    comment-nvim.enable = true;
  };
}
