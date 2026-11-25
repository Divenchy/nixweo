# Settings every host shares.
{
  flake.modules.nixos.base = {
    system.stateVersion = "26.05";
    nixpkgs.config.allowUnfree = true;
    # Enable flakes and new 'nix' command
    nix.settings.experimental-features = ["nix-command flakes"];
  };
}
