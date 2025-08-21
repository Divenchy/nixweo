{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ".."="cd ../";
      "..."="cd ../; cd ../;";
      "...."="cd ../; cd ../; cd ../;";
      ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user";
      q="exit";
      rf="ranger";
      mixer="alsamixer";
      lg="lazygit";
      md="mkdir";
      ff="fastfetch";
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
      eval "fastfetch"
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi

      ### SHELL INTEGRATIONS ###
      eval "$(fzf --zsh)"
      eval "$(zoxide init --cmd cd zsh)"

      # Defaults
      export TERMINAL="wezterm"
      export WLR_NO_HARDWARE_CURSORS=1

      # Setup previews with fzf
      export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
      export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

      ### ------------- PLUG-INS --------------- ###
      source ~/nixweo/resources/zsh-plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
      source ~/nixweo/resources/zsh-plugins/powerlevel10k/powerlevel10k.zsh-theme
      source ~/nixweo/resources/zsh-plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
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
    
      # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

      export NVM_DIR="$HOME/.nvm"
      [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
      [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
'';
  };
}

