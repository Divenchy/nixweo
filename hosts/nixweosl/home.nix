{ inputs, lib, config, pkgs, ... }:

{
  imports = [
    inputs.weomacs-flake.homeManagerModules.default
  ];

  home.username = "nixweosl";
  home.homeDirectory = "/home/nixweosl";
  home.stateVersion = "26.05";
  
  # Install pkgs into env
  home.packages = with pkgs ; [
    steam discord git btop
    iosevka-comfy.comfy
    nerd-fonts.iosevka
    nerd-fonts.jetbrains-mono

    # Fonts/Styling
    iosevka-comfy.comfy
    nerd-fonts.iosevka
    nerd-fonts.jetbrains-mono
    bibata-cursors
    nwg-look

    # CLI Tools
    man-pages
    xclip
    wget
    fastfetch
    fzf
    zoxide
    tree
    hugo
    eza
    brightnessctl
    bat
    ranger
    git
    btop
    lazygit
    unzip
    zip
    fd
    ripgrep
    starship

    # Tooling/Libs/System
    texliveFull
    inetutils
    dualsensectl
    llvm
    gcc-arm-embedded
    gnumake
    freetype
    bison
    flex
    valgrind
    gcc
    (lib.lowPrio gdb)
    cmake
    ninja
    tree-sitter
    networkmanager-openconnect
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

    # Langs
    odin
    zigpkgs.master
    zls
    nim
    cargo
    rustc
    rust-analyzer
    sbcl
    beamPackages.erlang
    beamPackages.elixir
    gleam
    (python313.withPackages (ps:
      with ps; [
        tkinter
        matplotlib
        pandas
      ]))
    go
  ];
}
