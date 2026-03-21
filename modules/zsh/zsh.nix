{
  config,
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ".." = "cd ../";
      "..." = "cd ../; cd ../;";
      "...." = "cd ../; cd ../; cd ../;";
      ls = "eza --color=always --long --git --no-filesize --icons=always --no-time --no-user";
      q = "exit";
      rf = "ranger";
      mixer = "alsamixer";
      lg = "lazygit";
      md = "mkdir";
      ff = "fastfetch";
      devExpo = "nix develop ~/nixweo#expo --profile ~/.nix-profiles/expo";
      devZigGame = "nix develop ~/nixweo#zigRaylib --profile ~/.nix-profiles/zigRaylib";
      devCompPhoto = "nix develop ~/nixweo#compPhoto";
    };

    setOptions = [
      "HIST_IGNORE_DUPS"
      "SHARE_HISTORY"
      "HIST_FCNTL_LOCK"
      "AUTO_CD"
      "APPEND_HISTORY"
      "SHARE_HISTORY"
      "HIST_IGNORE_SPACE"
      "HIST_IGNORE_ALL_DUPS"
      "HIST_SAVE_NO_DUPS"
      "HIST_IGNORE_DUPS"
      "HIST_FIND_NO_DUPS"
    ];

    histSize = 5000;

    shellInit = ''
      # Defaults
      export TERMINAL="wezterm"
      export WLR_NO_HARDWARE_CURSORS=1
      # Setup previews with fzf
      export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
      export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

      # Vars
      export PICO_SDK_PATH="~/projects/rp2040_arm_asm/pico-sdk/"
    '';

    promptInit = ''
      eval "$(starship init zsh)"
      eval "fastfetch"

      ### SHELL INTEGRATIONS ###
      eval "$(fzf --zsh)"
      eval "$(zoxide init --cmd cd zsh)"


      ### ------------- PLUG-INS --------------- ###
      source ~/nixweo/resources/zsh-plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
      source ~/nixweo/resources/zsh-plugins/zsh-you-should-use/you-should-use.plugin.zsh
      source ~/nixweo/resources/zsh-plugins/fzf-tab/fzf-tab.plugin.zsh
      #### -------------- END OF PLUG-INS ---------###

      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      zstyle ':completion:*' list-colors "''${(s.:.)EZA_COLORS}"
      zstyle ':completion:*' menu no
      zstyle ':fzf-tab:complete:*' fzf-preview 'ls $realpath'

      #----------------- FUNCTIONS ----------------#

      vi() {
          if [[ -z "$argv" ]]; then
              nvim
              echo "!Closed WEOVIM!"
              return
          elif [[ "$argv[1]" = "." ]]; then
              nvim .
              echo "!Closed WEOVIM!"
              return
          else
              nvim $argv[1]
              echo "!Closed WEOVIM!"
              return
          fi
      }
      ##--------------END OF ALIASES/FUNCTIONS----------------##

      ## KEYBINDINGS
      bindkey -e
      bindkey '^p' history-search-backward
      bindkey '^n' history-search-forward

      eval "$(direnv hook zsh)"
    '';
  };
}
