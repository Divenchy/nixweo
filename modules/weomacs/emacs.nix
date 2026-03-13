{
  config,
  pkgs,
  ...
}: let
  tree-sitter-odin = pkgs.tree-sitter.buildGrammar {
    language = "odin";
    version = "unstable";
    src = pkgs.fetchFromGitHub {
      owner = "amaanq";
      repo = "tree-sitter-odin";
      rev = "master";
      sha256 = "sha256-aPeaGERAP1Fav2QAjZy1zXciCuUTQYrsqXaSQsYG0oU=";
    };
  };
in {
  programs.emacs = {
    enable = true;
    package = pkgs.emacs;

    extraPackages = epkgs:
      (with epkgs; [
        # Langs
        nix-mode
        nim-mode
        rust-mode
        zig-mode
        haskell-mode
        # Dev
        direnv
        magit
        projectile
        counsel-projectile
        treemacs
        dogears
        perspective
        lsp-mode
        lsp-ui
        lsp-treemacs
        lsp-ivy
        dap-mode
        yasnippet
        # Extendability
        ivy
        ivy-rich
        swiper
        counsel
        doom-themes
        doom-modeline
        rainbow-delimiters
        which-key
        helpful
        avy
        company
        company-box
        flycheck
        hydra
        vterm
        # Note Taking
        pdf-tools
        org
        org-bullets
        eshell-git-prompt
        # Presentation
        visual-fill-column
        command-log-mode
        evil-nerd-commenter
        visual-fill-column
      ])
      ++ [
        (epkgs.trivialBuild {
          pname = "odin-ts-mode";
          version = "unstable";
          src = pkgs.fetchFromGitHub {
            owner = "Sampie159";
            repo = "odin-ts-mode";
            rev = "master";
            sha256 = "eKJMp2QB4vz5WOFSu0+OPf+v3bUAM+F1PBIY41t19ZA=";
          };
        })
      ];

    extraConfig = builtins.readFile ./init.el;
  };

  # Symlink weomacs lisp files into ~/.emacs.d
  home.file = {
    ".emacs.d/tree-sitter/libtree-sitter-odin.so".source = "${tree-sitter-odin}/parser";
    ".emacs.d/basic_settings.el".source = ./basic_settings.el;
    ".emacs.d/init.el".source = ./init.el;
    ".emacs.d/eshell.el".source = ./eshell.el;
    ".emacs.d/qol.el".source = ./qol.el;
    ".emacs.d/weofuncs.el".source = ./weofuncs.el;
    ".emacs.d/workflows.el".source = ./workflows.el;
    ".emacs.d/remaps.el".source = ./remaps.el;
    ".emacs.d/themes.el".source = ./themes.el;
    ".emacs.d/lsp.el".source = ./lsp.el;
    ".emacs.d/org.el".source = ./org.el;
  };
}
