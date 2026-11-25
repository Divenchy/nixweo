# Luciole: Noctalia's native Wayland file manager.
{inputs, ...}: {
  flake.modules.homeManager.luciole = {
    imports = [inputs.luciole.homeModules.default];

    programs.luciole.enable = true;
  };
}
