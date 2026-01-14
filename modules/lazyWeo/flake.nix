{
  description = "Basic Neovim Configuration For A Weo";

  outputs = { self }: {
    nixosModules.default = import ./nvim.nix;
  };
}
