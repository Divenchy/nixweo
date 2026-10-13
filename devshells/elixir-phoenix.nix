{
  pkgs,
}:
(pkgs.buildFHSEnv {
  name = "elixir-phoenix-fhs";
  targetPkgs = pkgs:
    with pkgs; [
      beamPackages.elixir
      beamPackages.erlang
      inotify-tools
      nodejs
      stdenv.cc.cc
      postgresql_18
      zlib
    ];
  runScript = "bash";
}).env
