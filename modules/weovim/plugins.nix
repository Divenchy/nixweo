{pkgs, ...}:

let
  oil-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "oil.nvim";
    version = "2.15";
    src = pkgs.fetchFromGitHub {
      owner = "stevearc";
      repo = "oil.nvim";
      rev = "6b59a6cf623fa2245c7454ddb458df5bdb6615d3"; # or specific commit/tag
      sha256 = "sha256-ULtIh+rY2m7OHC2U4bOBN/OcP5Uh0YgGa/Kgnke95Q0="; # Run once to get the hash, then fill it in
    };
  };
in
{
  lazy.plugins = {
    "oil.nvim" = {
      package = oil-nvim;

      setupModule = "oil";
      setupOpts = {
        # Oil.nvim options here
        default_file_explorer = true;
        
        columns = [
          "icon"
          "mtime"
        ];
        
        buf_options = {
          buflisted = false;
          bufhidden = "hide";
        };
        
        win_options = {
          wrap = false;
          signcolumn = "no";
          cursorcolumn = false;
          foldcolumn = "0";
          spell = false;
          list = false;
          conceallevel = 3;
          concealcursor = "nvic";
        };
        
        delete_to_trash = false;
        skip_confirm_for_simple_edits = false;
        prompt_save_on_select_new_entry = true;
        cleanup_delay_ms = 2000;
        
        lsp_file_methods = {
          enabled = true;
          timeout_ms = 1000;
          autosave_changes = false;
        };
        constrain_cursor = "name";
        watch_for_changes = true;
        
        keymaps = {
          "g?" = "actions.show_help";
          "<CR>" = "actions.select";
          "<C-s>" = {
            __raw = ''{ "actions.select", opts = { vertical = true }, desc = "Open the entry in a vertical split" }'';
          };
          "<C-h>" = {
            __raw = ''{ "actions.select", opts = { horizontal = true }, desc = "Open the entry in a horizontal split" }'';
          };
          "<C-t>" = {
            __raw = ''{ "actions.select", opts = { tab = true }, desc = "Open the entry in new tab" }'';
          };
          "<C-p>" = "actions.preview";
          "<C-c>" = "actions.close";
          "<C-l>" = "actions.refresh";
          "-" = "actions.parent";
          "_" = "actions.open_cwd";
          "`" = "actions.cd";
          "~" = {
            __raw = ''{ "actions.cd", opts = { scope = "tab" }, desc = ":tcd to the current oil directory" }'';
          };
          "gs" = "actions.change_sort";
          "gx" = "actions.open_external";
          "g." = "actions.toggle_hidden";
          "g\\" = "actions.toggle_trash";
        };
        
        use_default_keymaps = true;

        view_options = {
          show_hidden = true;
          is_hidden_file = {
            __raw = ''
              function(name, bufnr)
                return vim.startswith(name, ".")
              end
            '';
          };
          is_always_hidden = {
            __raw = ''
              function(name, bufnr)
                return false
              end
            '';
          };
          natural_order = false;
          case_insensitive = false;
          sort = [
            { type = "asc"; }
            { name = "asc"; }
          ];
        };
        
        extra_scp_args = [];
        git = {
          add = {
            __raw = ''
              function(path)
                return false
              end
            '';
          };
          mv = {
            __raw = ''
              function(src_path, dest_path)
                return false
              end
            '';
          };
          rm = {
            __raw = ''
              function(path)
                return false
              end
            '';
          };
        };
        float = {
          padding = 2;
          max_width = 0;
          max_height = 0;
          border = "rounded";
          win_options = {
            winblend = 0;
          };
          preview_split = "auto";
          override = {
            __raw = ''
              function(conf)
                return conf
              end
            '';
          };
        };
        
        preview = {
          max_width = 0.9;
          min_width = [ 40 0.4 ];
          width = null;
          max_height = 0.9;
          min_height = [ 5 0.1 ];
          height = null;
          border = "rounded";
          win_options = {
            winblend = 0;
          };
          update_on_cursor_moved = true;
        };

        progress = {
          max_width = 0.9;
          min_width = [ 40 0.4 ];
          width = null;
          max_height = [ 10 0.9 ];
          min_height = [ 5 0.1 ];
          height = null;
          border = "rounded";
          minimized_border = "none";
          win_options = {
            winblend = 0;
          };
        };
        
        ssh = {
          border = "rounded";
        };
        
        keymaps_help = {
          border = "rounded";
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
    
    nvim-web-devicons = {
      package = pkgs.vimPlugins.nvim-web-devicons;
      setup = "require('nvim-web-devicons').setup {}";
    };
  };
}
