{
  flake.modules.homeManager.starship = {
    home.file.".config/starship.toml".source = builtins.path {
      path = ./configuration.toml;
      name = "starship-config";
    };
  };
}
