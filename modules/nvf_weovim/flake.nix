{
  description = "Basic Neovim Configuration For A Weo";

  outputs = { self, nixpkgs, home-manager }: {
    homeManagerModules.default = import ./nvf.nix;
  };
}
