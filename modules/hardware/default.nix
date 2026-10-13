# Opt-in hardware profiles. All are disabled by default; enable the ones that
# match the machine in its untracked hosts/<host>/local.nix.
{
  imports = [
    ./cpu-amd.nix
    ./nvidia-prime.nix
    ./asus-laptop.nix
  ];
}
