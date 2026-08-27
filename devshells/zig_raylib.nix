{
  pkgs,
  self,
}: let
  zig = pkgs.zigpkgs.master-2026-05-25;
  zls = pkgs.zls;
in
  pkgs.mkShell {
    buildInputs = with pkgs; [
      zig
      zls
      raylib

      # X11/Wayland dependencies
      libX11
      libXrandr
      libXi
      libXcursor
      libXinerama
      libGL
      alsa-lib

      # Development tools
      gdb

      # Custom editor
      self.nixosConfigurations.nixweo.config.programs.nvf.finalPackage
    ];

    shellHook = ''
      echo "Raylib + Zig + Weovim development environment"
      echo "Zig version: $(zig version)"
      unset ZIG_GLOBAL_CACHE_DIR
      export ZIG_GLOBAL_CACHE_DIR="$HOME/.cache/zig"
      mkdir -p "$ZIG_GLOBAL_CACHE_DIR"
      export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath [
        pkgs.raylib
        pkgs.libGL
        pkgs.libX11
        pkgs.libXrandr
        pkgs.libXi
        pkgs.libXcursor
        pkgs.libXinerama
        pkgs.alsa-lib
      ]}:$LD_LIBRARY_PATH"
    '';
  }
