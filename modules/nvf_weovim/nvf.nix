{ configs, pkgs, inputs, lib,  ...}:

{
  imports = [
    inputs.nvf.nixosModules.default
  ];

  programs.nvf.enable = true;
  programs.nvf.settings.vim = {
    additionalRuntimePaths = [
      ./nvim
    ];

    luaConfigRC.config = ''
      -- Call module from ./nvim/lua/config
      require("config.lazy")
    '';
  };
}
