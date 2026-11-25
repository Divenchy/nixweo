# weovim: Neovim built with nvf, installed system-wide.
{inputs, ...}: {
  flake.modules.nixos.weovim = {
    pkgs,
    lib,
    ...
  }: {
    imports = [inputs.nvf.nixosModules.default];
    programs.nvf.enable = true;
    programs.nvf.settings.vim = lib.mkMerge [
      (import ./_nvim.nix {
        inherit pkgs lib;
        nvfLib = inputs.nvf.lib;
      })
      (import ./_plugins.nix {inherit pkgs;})
      (import ./_remaps.nix {inherit pkgs;})
    ];
  };
}
