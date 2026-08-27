{
  nixpkgs,
  stylix,
  weovim-flake,
  overlays,
  inputs,
  outputs,
}:
nixpkgs.lib.nixosSystem {
  specialArgs = {inherit inputs outputs;};
  modules = [
    ({
      config,
      pkgs,
      ...
    }: {
      nixpkgs.overlays = overlays;
    })
    stylix.nixosModules.stylix
    weovim-flake.nixosModules.default
    ./configuration.nix
  ];
}
