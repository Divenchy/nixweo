# Haskell shell: GHC + cabal + HLS, all from one haskellPackages set so HLS matches the GHC ABI.
# For a project, copy modules/development/devshells/haskell.envrc to the project root as .envrc and run `direnv allow`.
{pkgs}: let
  hp = pkgs.haskellPackages;
in
  pkgs.mkShell {
    packages = with hp; [
      ghc
      cabal-install
      haskell-language-server
      hlint
      fourmolu
      cabal-fmt
      ghcid
      hoogle
      pkgs.pkg-config
      pkgs.zlib # native dep of the zlib package, pulled in by most http/compression stacks
    ];
  }
