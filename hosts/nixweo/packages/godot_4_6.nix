{pkgs, ...}: let
  godot-4_6 = pkgs.stdenv.mkDerivation rec {
    pname = "godot";
    version = "4.6-stable";

    src = pkgs.fetchzip {
      url = "https://downloads.godotengine.org/?version=4.6&flavor=stable&slug=linux.x86_64.zip&platform=linux.64";
      sha256 = ""; # Run once, Nix will tell you the correct hash
    };

    nativeBuildInputs = [pkgs.autoPatchelfHook];

    buildInputs = with pkgs; [
      xorg.libX11
      xorg.libXcursor
      xorg.libXinerama
      xorg.libXrandr
      xorg.libXrender
      xorg.libXi
      xorg.libXext
      xorg.libXfixes
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

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      cp Godot_v* $out/bin/godot
      chmod +x $out/bin/godot
      runHook postInstall
    '';
  };
in {
  environment.systemPackages = [godot-4_6];
}
