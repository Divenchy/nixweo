{
  nixpkgs,
  weovim-flake,
  overlays,
  system,
  inputs,
  outputs,
}:
nixpkgs.lib.nixosSystem {
  system = system;
  specialArgs = {inherit inputs outputs;};
  modules = [
    ({
      config,
      pkgs,
      ...
    }: {
      nixpkgs.overlays = overlays;
    })
    weovim-flake.nixosModules.default
    ./configuration.nix
  ];
}
