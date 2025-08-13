{ config, pkgs, ...}:

{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-gtk;

    extraPackages = epkgs: with epkgs; [
      nix-mode magit ivy ivy-rich swiper counsel doom-themes doom-modeline rainbow-delimiters which-key
      helpful projectile counsel-projectile treemacs avy dogears
      lsp-mode lsp-ui lsp-treemacs lsp-ivy dap-mode yasnippet company company-box flycheck
      eshell-git-prompt command-log-mode ada-mode zig-mode evil-nerd-commenter
    ];

    extraConfig = builtins.readFile ./init.el;
  };

  # Symlink weomacs lisp files into ~/.emacs.d
  home.file = {
    ".emacs.d/basic_settings.el".source = ./basic_settings.el;
    ".emacs.d/init.el".source = ./init.el;
    ".emacs.d/eshell.el".source = ./eshell.el;
    ".emacs.d/qol.el".source = ./qol.el;
    ".emacs.d/weofuncs.el".source = ./weofuncs.el;
    ".emacs.d/workflows.el".source = ./workflows.el;
    ".emacs.d/remaps.el".source = ./remaps.el;
    ".emacs.d/themes.el".source = ./themes.el;
  };
}
