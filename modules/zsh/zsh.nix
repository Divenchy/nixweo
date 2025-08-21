{ config, pkgs, ... }:

{
  programs.nvm.enable = true;
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enablep = true;

    history = {
      size = 5000;
    };

    shellAliases = {
      ..="cd ../"
      ...="cd ../; cd ../;"
      ....="cd ../; cd ../; cd ../;"
      ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user"
      q="exit"
      rf="ranger"
      mixer="alsamixer"
      lg="lazygit"
      md="mkdir"
      ff="fastfetch"
    };

    sessionVariables = {
      TERMINAL="wezterm";
    };

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "zsh-autosuggestions";
        src = pkgs.zsh-autosuggestions;
        file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.zsh-syntax-highlighting;
        file = "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
      }
      {
        name = "zsh-history-substring-search";
        src = pkgs.zsh-history-substring-search;
        file = "share/zsh-history-substring-search/zsh-history-substring-search.zsh";
      }
      {
        name = "zsh-you-should-use";
        src = pkgs.zsh-you-should-use;
        file = "share/zsh/plugins/you-should-use/you-should-use.plugin.zsh";
      }
      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
        file = "fzf-tab.plugin.zsh";
      }
    ];

    shellInit = ''
    eval "fastfetch"
    ### SHELL INTEGRATIONS ###
    eval "$(fzf --zsh)"
    eval "$(zoxide init --cmd cd zsh)"

    ### COMPLETION STYLES ###
    zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
    zstyle ':completion:*' list-colors '${(s.:.)EZA_COLORS}'
    zstyle ':completion:*' menu no
    zstyle ':fzf-tab:complete:*' fzf-preview 'ls $realpath'  

    ### FUNCTIONS ###
    vi() {
      if [[ -z "$argv" ]]; then
        nvim
        echo "!Closed WEOVIM!"
      elif [[ "$argv[1]" = "." ]]; then
        nvim .
        echo "!Closed WEOVIM!"
      else 
        nvim $argv[1]
        echo "!Closed WEOVIM!"
      fi
    }
    ### KEYBINDINGS & HISTORY ###
    bindkey -e
    bindkey '^p' history-search-backward
    bindkey '^n' history-search-forward
    setopt auto_cd

    HISTSIZE=5000
    HISTFILE=$HOME/.config/.zsh_hist
    SAVEHIST=$HISTSIZE
    HISTDUP=erase
    setopt appendhistory sharehistory hist_ignore_space hist_ignore_all_dups \
           hist_save_no_dups hist_ignore_dups hist_find_no_dups
    '';
  };
}
