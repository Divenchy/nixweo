{
  pkgs,
  self,
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
      self.nixosConfigurations.nixweo.config.programs.nvf.finalPackage
    ];
  runScript = "bash";
}).env
