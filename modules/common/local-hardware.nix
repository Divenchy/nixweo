# Imports a machine-local hardware-configuration.nix that is gitignored.
# Generate it on the target machine with:
#   sudo nixos-generate-config --show-hardware-config > hosts/<host>/hardware-configuration.nix
# and build with a `path:` flake ref so the untracked file is visible to the flake:
#   sudo nixos-rebuild switch --flake path:.#<host>
hwConfig: {
  imports = [
    (
      if builtins.pathExists hwConfig
      then hwConfig
      else
        throw ''
          Missing hardware-configuration.nix for this host.
          Generate it with `sudo nixos-generate-config --show-hardware-config > hosts/<host>/hardware-configuration.nix`
          and rebuild with `--flake path:.#<host>` (git+file refs skip untracked files).
        ''
    )
  ];
}
