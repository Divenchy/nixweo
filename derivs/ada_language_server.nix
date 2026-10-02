# ada-language-server.nix
{ pkgs }:

pkgs.stdenv.mkDerivation rec {
  pname = "ada-language-server";
  version = "25.0.0";  # Check latest version

  src = pkgs.fetchurl{
    url =
      "https://github.com/AdaCore/ada_language_server/releases/download/2026.3.202607051/als-2026.3.202607051-linux-x64.tar.gz";
    sha256 = "9dfa29af05418913ff445be0c6875f7a51ebad5fc781f3446d3e2c3903d09787";
  };

  nativeBuildInputs = [ pkgs.autoPatchelfHook ];

  buildInputs = with pkgs; [
    stdenv.cc.cc.lib
    glibc
    zlib
  ];

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/bin
    cp -v ada_language_server $out/bin/
    chmod +x $out/bin/ada_language_server
  '';
}
