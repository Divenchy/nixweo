{
  description = "Nixos config flake for a weo.";

  # Inputs are pinned by tack: edit .tack/pins.toml or use `tack add/update`, never flake inputs.
  outputs = {self, ...}: let
    inputs = import ./.tack {} // {inherit self;};
  in
    inputs.flake-parts.lib.mkFlake {inherit inputs;} (inputs.import-tree ./modules);
}
