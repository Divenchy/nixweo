{pkgs, ...}: let
  godot-4_6 = pkgs.stdenv.mkDerivation rec {
    pname = "godot4_6";
    version = "4.6-stable";

    src = pkgs.fetchzip {
      url = "https://github.com/godotengine/godot/releases/download/4.6-stable/Godot_v4.6-stable_linux.x86_64.zip";
      sha256 = "sha256-/5IqQFzDcw4rUsngBjMSTSIjjN46aS4wZpe7c/pL2Uc=";
    };

    nativeBuildInputs = [
      pkgs.autoPatchelfHook
      pkgs.makeWrapper
    ];

    buildInputs = with pkgs; [
      libX11
      libXcursor
      libXinerama
      libXrandr
      libXrender
      libXi
      libXext
      libXfixes
      libGL
      libxkbcommon
      alsa-lib
      pulseaudio
      dbus
      fontconfig
      udev
      vulkan-loader
      libdecor
      wayland
      speechd
    ];

    runtimeDependencies = with pkgs; [
      libX11
      libXcursor
      libXinerama
      libXrandr
      libXrender
      libXi
      libXext
      libXfixes
      libGL
      libxkbcommon
      alsa-lib
      pulseaudio
      dbus
      fontconfig
      fontconfig.lib
      udev
      vulkan-loader
      libdecor
      wayland
      speechd
    ];

    installPhase = ''
          runHook preInstall

          mkdir -p $out/bin
          cp Godot_v* $out/bin/godot4_6-unwrapped
          chmod +x $out/bin/godot4_6-unwrapped

          makeWrapper $out/bin/godot4_6-unwrapped $out/bin/godot4_6 \
            --prefix LD_LIBRARY_PATH : ${pkgs.lib.makeLibraryPath (with pkgs; [
        libX11
        libXcursor
        libXinerama
        libXrandr
        libXrender
        libXi
        libXext
        libXfixes
        libGL
        libxkbcommon
        alsa-lib
        pulseaudio
        dbus
        fontconfig
        udev
        vulkan-loader
        libdecor
        wayland
        speechd
      ])} \
      --run 'export XDG_CONFIG_HOME="''${XDG_CONFIG_HOME:-$HOME/.config}"' \
      --run 'export XDG_DATA_HOME="''${XDG_DATA_HOME:-$HOME/.local/share}"' \
      --run 'export XDG_CACHE_HOME="''${XDG_CACHE_HOME:-$HOME/.cache}"'
      runHook postInstall
    '';
  };
in {
  environment.systemPackages = [godot-4_6];
}
