{ stdenv, gnat, gprbuild, glibc }:

stdenv.mkDerivation {
  pname = "an-ada-program";
  version = "1.2.3";

  src = ...;

  nativeBuildInputs = [
    gprbuild
    gnat
  ];

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild

    gprbuild

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    # Only install what we need to run the binary.
    gprinstall --prefix=$out hello.gpr \
      --no-project \
      --no-manifest \
      --mode=usage

    runHook postInstall
  '';
}
