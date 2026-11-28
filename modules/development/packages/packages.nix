# Packages shared by every host (home-manager module).
{inputs, ...}: {
  flake.modules.homeManager.packages = {
    lib,
    pkgs,
    config,
    ...
  }: let
    cfg = config.weo.packages;
  in {
    options.weo.packages = {
      cli.enable = lib.mkEnableOption "common CLI tools" // {default = true;};
      devLibs.enable = lib.mkEnableOption "dev libs / tooling / language backends" // {default = true;};
      langs.enable = lib.mkEnableOption "programming languages" // {default = true;};
    };

    # tack: authenticate GitHub API calls with the access-tokens from ~/.config/nix/nix.conf (avoids the 60 req/h limit).
    config.home.sessionVariables.TACK_NIX_CONF_TOKENS = lib.mkIf cfg.cli.enable "1";

    config.home.packages = with pkgs;
      lib.optionals cfg.cli.enable [
        claude-code
        inputs.tack.packages.${pkgs.stdenv.hostPlatform.system}.tack
        fossil
        man-pages
        direnv
        devenv
        vim
        wget
        fastfetch
        fzf
        zoxide
        tree
        hugo
        eza
        bat
        ranger
        git
        git-lfs
        btop
        lazygit
        unzip
        zip
        fd
        ripgrep
        starship
      ]
      ++ lib.optionals cfg.devLibs.enable [
        texliveFull
        inetutils
        llvm
        gnumake
        freetype
        bison
        flex
        ninja
        tree-sitter
        ffmpeg
        nil
        systemd.dev
        pkg-config
        picotool
        glfw
        vulkan-headers
        libGL
        mesa
        vulkan-tools
      ]
      ++ lib.optionals cfg.langs.enable [
        # ATS
        gmp
        ats2

        # Java
        jdk25

        # .NET
        (with dotnetCorePackages; combinePackages [
          sdk_11_0
          sdk_10_0
        ])
        netcoredbg

        # C / ASM
        nasm
        gcc-arm-embedded
        (lib.lowPrio gdb)
        cmake
        valgrind

        # Ada
        gnat # provides gcc
        gprbuild

        # Odin
        odin

        # Zig
        zigpkgs."0.17.0"
        (pkgs.writeShellScriptBin "zigmaster" ''
          exec ${pkgs.zigpkgs.master}/bin/zig "$@"
        '')
        zls

        # Elixir
        beamPackages.erlang
        beamPackages.elixir

        # Other
        go      
        cargo
        rustc
        rust-analyzer      
        nodejs_26
        uv
        sbcl
        gleam
        (python313.withPackages (ps:
          with ps; [
            tkinter
            matplotlib
            pandas
          ]))
      ]
      # Upstream only ships an x86_64-linux binary
      ++ lib.optional (cfg.langs.enable && pkgs.stdenv.hostPlatform.isx86_64)
      (pkgs.callPackage ./_ada_language_server.nix {});
  };
}
