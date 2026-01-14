let
  # We pin to a specific nixpkgs commit for reproducibility.
  pkgs = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/61db79b0c6b838d9894923920b612048e1201926.tar.gz") { };
in pkgs.mkShell {
  packages = [
    (pkgs.python3.withPackages (
      python-pkgs: with python-pkgs; [
        # select Python packages here
        pandas
        numpy
        matplotlib
      ]
    ))
  ];

  shellHook = ''
    alias vi=nvim
    alias q=exit
  '';
  
}
