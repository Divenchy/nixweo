{inputs, ...}: {
  perSystem = {
    system,
    pkgs,
    ...
  }: {
    devShells = {
      zig-ray-lib = import ./_zig_raylib.nix {inherit pkgs;};
      graphics = import ./_graphics.nix {inherit pkgs inputs system;};
      elixir-phoenix = import ./_elixir-phoenix.nix {inherit pkgs;};
      spark = import ./_spark.nix {inherit pkgs;};
      haskell = import ./_haskell.nix {inherit pkgs;};
    };
  };
}
