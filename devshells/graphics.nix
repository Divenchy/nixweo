{
  pkgs,
  inputs,
  system,
  self,
}: let
  zig = pkgs.zigpkgs.master-2026-05-25;
  zlsPkg = inputs.zls.packages.${system}.default;
in
  pkgs.mkShell {
    name = "graphics-dev";

    buildInputs = with pkgs; [
      # Langs
      zig
      zlsPkg
      rustc
      cargo
      rust-analyzer
      clippy
      rustfmt
      odin

      # Vulkan
      vulkan-headers
      vulkan-loader
      vulkan-tools
      vulkan-validation-layers
      shaderc
      spirv-tools
      glslang

      # OpenGL
      libGL
      libGLU
      mesa
      glew

      # Windowing
      glfw
      SDL2
      SDL2_image
      SDL2_ttf

      # X11
      libX11
      libXrandr
      libXi
      libXcursor
      libXinerama
      libXext
      libXxf86vm

      # Wayland
      wayland
      wayland-protocols
      libxkbcommon

      # Common libs
      pkg-config
      cmake
      ninja
      gnumake
      premake5

      # Audio
      openal
      alsa-lib
      libpulseaudio

      # Image loading
      libpng
      libjpeg
      stb

      # Math
      glm

      # Debugging
      gdb
      renderdoc

      # Editor
      self.nixosConfigurations.nixweo.config.programs.nvf.finalPackage
    ];

    VK_LAYER_PATH = "${pkgs.vulkan-validation-layers}/share/vulkan/explicit_layer.d";

    shellHook = ''
      echo ""
      echo "╔══════════════════════════════════════════════════════════╗"
      echo "║          Graphics Development Environment                ║"
      echo "╠══════════════════════════════════════════════════════════╣"
      echo "║  Languages:                                              ║"
      echo "║    Zig:   $(zig version)                                 ║"
      echo "║    Rust:  $(rustc --version | cut -d' ' -f2)             ║"
      echo "║    Odin:  $(odin version 2>&1 | head -n1 | cut -d' ' -f3)  ║"
      echo "╠══════════════════════════════════════════════════════════╣"
      echo "║  Graphics APIs:                                          ║"
      echo "║    Vulkan: $(vulkaninfo --summary 2>/dev/null | grep 'Vulkan Instance' | cut -d':' -f2 | xargs || echo 'available')         ║"
      echo "║    OpenGL: $(glxinfo 2>/dev/null | grep 'OpenGL version' | cut -d':' -f2 | xargs || echo 'available')               ║"
      echo "╚══════════════════════════════════════════════════════════╝"
      echo ""
      echo "Tools: shaderc (glslc), renderdoc, vulkaninfo, glxinfo"
      echo ""

      unset ZIG_GLOBAL_CACHE_DIR
      export ZIG_GLOBAL_CACHE_DIR="$HOME/.cache/zig"
      mkdir -p "$ZIG_GLOBAL_CACHE_DIR"

      export VK_LAYER_PATH="${pkgs.vulkan-validation-layers}/share/vulkan/explicit_layer.d"
      export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath [
        pkgs.vulkan-loader
        pkgs.libGL
        pkgs.glfw
        pkgs.SDL2
        pkgs.xorg.libX11
        pkgs.xorg.libXrandr
        pkgs.xorg.libXi
        pkgs.xorg.libXcursor
        pkgs.xorg.libXinerama
        pkgs.wayland
        pkgs.libxkbcommon
        pkgs.openal
        pkgs.alsa-lib
      ]}:$LD_LIBRARY_PATH"

      export LIBCLANG_PATH="${pkgs.llvmPackages.libclang.lib}/lib"
    '';
  }
